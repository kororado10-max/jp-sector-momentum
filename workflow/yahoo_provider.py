"""Yahoo Finance chart EOD provider with the legacy Stooq module interface.

The application originally used Stooq and its tests still validate the CSV parser.
Keep ``parse_stooq_csv`` for backward compatibility while live EOD retrieval uses
Yahoo Finance chart JSON for Tokyo symbols (e.g. 7203.T).
"""
from __future__ import annotations

import asyncio
from datetime import datetime, timedelta, timezone
from io import StringIO

import httpx
import pandas as pd

from ..code_utils import canonical_code

BASE_URL = "https://query1.finance.yahoo.com/v8/finance/chart/"


class StooqError(RuntimeError):
    pass


def parse_stooq_csv(text: str, code: str) -> pd.DataFrame:
    """Legacy parser retained for regression tests and cached Stooq payloads."""
    normalized = canonical_code(code)
    if not normalized:
        raise StooqError(f"Invalid TSE code: {code}")
    text = text.strip()
    if not text or "Date" not in text[:120]:
        raise StooqError(f"Unexpected Stooq response for {normalized}")
    df = pd.read_csv(StringIO(text))
    df.columns = [str(c).lower() for c in df.columns]
    required = {"date", "open", "high", "low", "close", "volume"}
    if df.empty or not required.issubset(df.columns):
        raise StooqError(f"No usable OHLCV data for {normalized}")
    df["date"] = pd.to_datetime(df["date"], errors="coerce")
    for column in ["open", "high", "low", "close", "volume"]:
        df[column] = pd.to_numeric(df[column], errors="coerce")
    df["code"] = normalized
    df = df.dropna(subset=["date", "open", "high", "low", "close", "volume"]).copy()
    df = df[(df["close"] > 0) & (df["volume"] >= 0)].copy()
    return df[["date", "code", "open", "high", "low", "close", "volume"]]


def _epoch(day: str, plus_days: int = 0) -> int:
    dt = datetime.strptime(day, "%Y-%m-%d").replace(tzinfo=timezone.utc) + timedelta(days=plus_days)
    return int(dt.timestamp())


def parse_yahoo_json(payload: dict, code: str) -> pd.DataFrame:
    normalized = canonical_code(code)
    if not normalized:
        raise StooqError(f"Invalid TSE code: {code}")

    chart = payload.get("chart") or {}
    if chart.get("error"):
        raise StooqError(str(chart["error"]))
    results = chart.get("result") or []
    if not results:
        raise StooqError(f"No Yahoo chart result for {normalized}")

    result = results[0]
    timestamps = result.get("timestamp") or []
    indicators = result.get("indicators") or {}
    quotes = indicators.get("quote") or []
    if not timestamps or not quotes:
        raise StooqError(f"No Yahoo OHLCV data for {normalized}")

    quote = quotes[0]
    adj_blocks = indicators.get("adjclose") or []
    adjusted = (adj_blocks[0].get("adjclose") if adj_blocks else None) or []
    rows: list[dict] = []

    for i, ts in enumerate(timestamps):
        values = {
            key: (quote.get(key) or [None] * len(timestamps))[i]
            for key in ["open", "high", "low", "close", "volume"]
        }
        if any(values[key] is None for key in ["open", "high", "low", "close", "volume"]):
            continue

        raw_close = float(values["close"])
        adj_close = adjusted[i] if i < len(adjusted) else None
        factor = (float(adj_close) / raw_close) if adj_close not in (None, 0) and raw_close else 1.0
        rows.append(
            {
                "date": pd.to_datetime(int(ts), unit="s", utc=True)
                .tz_convert("Asia/Tokyo")
                .tz_localize(None)
                .normalize(),
                "code": normalized,
                "open": float(values["open"]) * factor,
                "high": float(values["high"]) * factor,
                "low": float(values["low"]) * factor,
                "close": raw_close * factor,
                "volume": float(values["volume"]),
            }
        )

    if not rows:
        raise StooqError(f"No usable Yahoo rows for {normalized}")
    return pd.DataFrame(rows)[["date", "code", "open", "high", "low", "close", "volume"]]


async def fetch_symbol(
    code: str,
    start: str,
    end: str,
    client: httpx.AsyncClient | None = None,
) -> pd.DataFrame:
    normalized = canonical_code(code)
    if not normalized:
        raise StooqError(f"Invalid TSE code: {code}")

    symbol = f"{normalized}.T"
    params = {
        "period1": _epoch(start),
        "period2": _epoch(end, 1),
        "interval": "1d",
        "events": "history",
        "includeAdjustedClose": "true",
    }
    owns_client = client is None
    if client is None:
        client = httpx.AsyncClient(
            timeout=20,
            follow_redirects=True,
            headers={"User-Agent": "Mozilla/5.0 JP-Sector-Momentum/0.4"},
        )

    try:
        last_exc: Exception | None = None
        for attempt in range(4):
            try:
                response = await client.get(BASE_URL + symbol, params=params)
                if response.status_code == 429:
                    raise StooqError("Yahoo rate limited request")
                response.raise_for_status()
                return parse_yahoo_json(response.json(), normalized)
            except Exception as exc:
                last_exc = exc
                if attempt < 3:
                    await asyncio.sleep(1.2 * (attempt + 1))
        raise StooqError(f"Failed Yahoo fetch for {normalized}: {last_exc}")
    finally:
        if owns_client:
            await client.aclose()


async def fetch_many(
    codes: list[str],
    start: str,
    end: str,
    concurrency: int = 6,
) -> tuple[pd.DataFrame, list[str]]:
    semaphore = asyncio.Semaphore(max(1, concurrency))
    failures: list[str] = []
    frames: list[pd.DataFrame] = []
    limits = httpx.Limits(
        max_connections=max(8, concurrency * 2),
        max_keepalive_connections=max(4, concurrency),
    )

    async with httpx.AsyncClient(
        timeout=20,
        follow_redirects=True,
        limits=limits,
        headers={"User-Agent": "Mozilla/5.0 JP-Sector-Momentum/0.4"},
    ) as client:

        async def one(code: str) -> None:
            normalized = canonical_code(code)
            if not normalized:
                failures.append(str(code))
                return
            async with semaphore:
                try:
                    frame = await fetch_symbol(normalized, start, end, client)
                    if frame.empty:
                        failures.append(normalized)
                    else:
                        frames.append(frame)
                except Exception:
                    failures.append(normalized)

        await asyncio.gather(*(one(code) for code in codes))

    if frames:
        out = pd.concat(frames, ignore_index=True)
    else:
        out = pd.DataFrame(columns=["date", "code", "open", "high", "low", "close", "volume"])
    return out, sorted(set(failures))
