class Sector {
  final String sector;
  final double score;
  final int rank;
  final double return1d;
  final double return5d;
  final double return10d;
  final double return20d;
  final double volumeRatio;
  final double turnoverRatio20;
  final double volumeSurgeRatio;
  final double flowAcceleration;
  final double breadth;
  final double aboveMa25;
  final double aboveMa75;
  final double rs5d;
  final double acceleration;
  final String state;

  const Sector({
    required this.sector, required this.score, required this.rank,
    required this.return1d, required this.return5d, required this.return10d,
    required this.return20d, required this.volumeRatio, required this.turnoverRatio20, required this.volumeSurgeRatio, required this.flowAcceleration, required this.breadth,
    required this.aboveMa25, required this.aboveMa75,
    required this.rs5d, required this.acceleration, required this.state,
  });

  factory Sector.fromJson(Map<String, dynamic> j) => Sector(
    sector: j['sector'] as String,
    score: (j['score'] as num?)?.toDouble() ?? 0,
    rank: (j['rank'] as num?)?.toInt() ?? 0,
    return1d: (j['return_1d'] as num?)?.toDouble() ?? 0,
    return5d: (j['return_5d'] as num?)?.toDouble() ?? 0,
    return10d: (j['return_10d'] as num?)?.toDouble() ?? 0,
    return20d: (j['return_20d'] as num?)?.toDouble() ?? 0,
    volumeRatio: (j['volume_ratio'] as num?)?.toDouble() ?? 0,
    turnoverRatio20: (j['turnover_ratio20'] as num?)?.toDouble() ?? 1,
    volumeSurgeRatio: (j['volume_surge_ratio'] as num?)?.toDouble() ?? 0,
    flowAcceleration: (j['flow_acceleration'] as num?)?.toDouble() ?? 0,
    breadth: (j['breadth'] as num?)?.toDouble() ?? 0,
    aboveMa25: (j['above_ma25_ratio'] as num?)?.toDouble() ?? 0,
    aboveMa75: (j['above_ma75_ratio'] as num?)?.toDouble() ?? 0,
    rs5d: (j['rs_5d'] as num?)?.toDouble() ?? 0,
    acceleration: (j['acceleration'] as num?)?.toDouble() ?? 0,
    state: j['state'] as String? ?? 'Unknown',
  );
}

class RotationPoint {
  final String sector;
  final double score;
  final double rs5d;
  final double acceleration;
  final String state;
  final int rank;
  const RotationPoint({required this.sector, required this.score, required this.rs5d, required this.acceleration, required this.state, required this.rank});
  factory RotationPoint.fromJson(Map<String, dynamic> j) => RotationPoint(
    sector: j['sector'] as String,
    score: (j['score'] as num?)?.toDouble() ?? 0,
    rs5d: (j['rs_5d'] as num?)?.toDouble() ?? 0,
    acceleration: (j['acceleration'] as num?)?.toDouble() ?? 0,
    state: j['state'] as String? ?? 'Unknown',
    rank: (j['rank'] as num?)?.toInt() ?? 0,
  );
}

class FocusSector {
  final String sector;
  final int rank;
  final double score;
  final String state;
  final double return5d;
  final double volumeRatio;
  final double turnoverRatio20;
  final double volumeSurgeRatio;
  final double flowAcceleration;
  final double breadth;
  final double scoreDelta;
  final int rankChange;
  final String reason;

  const FocusSector({required this.sector, required this.rank, required this.score, required this.state, required this.return5d, required this.volumeRatio, required this.turnoverRatio20, required this.volumeSurgeRatio, required this.flowAcceleration, required this.breadth, required this.scoreDelta, required this.rankChange, required this.reason});
  factory FocusSector.fromJson(Map<String, dynamic> j) => FocusSector(
    sector: j['sector'] as String,
    rank: (j['rank'] as num?)?.toInt() ?? 0,
    score: (j['score'] as num?)?.toDouble() ?? 0,
    state: j['state'] as String? ?? 'Unknown',
    return5d: (j['return_5d'] as num?)?.toDouble() ?? 0,
    volumeRatio: (j['volume_ratio'] as num?)?.toDouble() ?? 0,
    turnoverRatio20: (j['turnover_ratio20'] as num?)?.toDouble() ?? 1,
    volumeSurgeRatio: (j['volume_surge_ratio'] as num?)?.toDouble() ?? 0,
    flowAcceleration: (j['flow_acceleration'] as num?)?.toDouble() ?? 0,
    breadth: (j['breadth'] as num?)?.toDouble() ?? 0,
    scoreDelta: (j['score_delta_5s'] as num?)?.toDouble() ?? 0,
    rankChange: (j['rank_change_5s'] as num?)?.toInt() ?? 0,
    reason: j['reason'] as String? ?? '',
  );
}

class HistoryPoint {
  final String date;
  final String sector;
  final double score;
  final int rank;
  final double rs5d;
  final double acceleration;
  final String state;
  const HistoryPoint({required this.date, required this.sector, required this.score, required this.rank, required this.rs5d, required this.acceleration, required this.state});
  factory HistoryPoint.fromJson(Map<String, dynamic> j) => HistoryPoint(
    date: j['date'] as String,
    sector: j['sector'] as String,
    score: (j['score'] as num?)?.toDouble() ?? 0,
    rank: (j['rank'] as num?)?.toInt() ?? 0,
    rs5d: (j['rs_5d'] as num?)?.toDouble() ?? 0,
    acceleration: (j['acceleration'] as num?)?.toDouble() ?? 0,
    state: j['state'] as String? ?? 'Unknown',
  );
}
