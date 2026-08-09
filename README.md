# JP Sector Momentum — Stage 4

東証プライムの **33業種モメンタム / 出来高 / Breadth / Relative Strength / Breakout / 加速度** を、引け後の日次データで可視化するAndroid向けアプリです。

Stage 4では、Stage 3の分析機能に加えて **GitHub Pagesへの実運用デプロイ** と **GitHub ActionsでのAndroid APK自動ビルド** を追加しています。

## Stage 4の主要機能

- JPX Prime銘柄・33業種マスター
- 英字入り東証コード対応
- Stooq EOD best-effort provider
- 差分更新 + 新規上場bootstrap
- 90%以上の銘柄が揃った最新営業日だけ採用
- OHLC/重複/カバレッジ品質ゲート
- Sector Score 6要素
- Rotation 4象限
- Focus sector抽出
- 個別銘柄ランキング
- Home / Sectors / Rotation / Stocks / History
- GitHub Pages静的JSON API
- Pagesキャッシュ対策
- API生成時刻・ソース表示
- GitHub Actions平日更新
- GitHub Actions release APK build

## 自動運用

- `daily-pages.yml`: 平日17:45 JST相当のEOD更新 + Pages deploy
- `build-android.yml`: release APK build + Artifact upload

APKはPages URLをGitHub repository情報から自動生成して埋め込みます。

## Sector Score

```text
25% Momentum
20% Volume
20% Breadth
15% Relative Strength
10% Breakout
10% Acceleration
```

各成分は33業種内percentileで0–100化します。

## 注意

このアプリは市場情報を整理・可視化するための分析ツールです。無料データには遅延・欠損・仕様変更の可能性があります。
