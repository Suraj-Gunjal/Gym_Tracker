/// RPE (Rate of Perceived Exertion) scale values.
enum RPE {
  rpe6(6, 'Very Easy', '4+ reps in reserve', 0.65),
  rpe7(7, 'Easy', '3 reps in reserve', 0.72),
  rpe75(7.5, 'Moderate-Easy', '2-3 reps in reserve', 0.76),
  rpe8(8, 'Moderate', '2 reps in reserve', 0.80),
  rpe85(8.5, 'Moderate-Hard', '1-2 reps in reserve', 0.84),
  rpe9(9, 'Hard', '1 rep in reserve', 0.88),
  rpe95(9.5, 'Very Hard', 'Maybe 1 rep left', 0.92),
  rpe10(10, 'Maximum', 'No reps in reserve', 1.0);

  final double value;
  final String label;
  final String description;
  final double percentageOf1RM;

  const RPE(this.value, this.label, this.description, this.percentageOf1RM);

  /// Get RIR (Reps in Reserve) from RPE.
  int get rir => (10 - value).round();

  /// Get color for this RPE level.
  String get colorHex {
    if (value <= 7) return '22C55E'; // Green
    if (value <= 8) return 'F59E0B'; // Yellow
    if (value <= 9) return 'F97316'; // Orange
    return 'EF4444'; // Red
  }
}

/// Tempo notation (eccentric-pause-concentric-pause).
class Tempo {
  final int eccentric; // Lowering phase
  final int pauseBottom; // Pause at bottom
  final int concentric; // Lifting phase
  final int pauseTop; // Pause at top

  const Tempo({
    required this.eccentric,
    required this.pauseBottom,
    required this.concentric,
    required this.pauseTop,
  });

  /// Parse tempo from string notation (e.g., "3-1-2-0").
  factory Tempo.fromString(String notation) {
    final parts = notation.split('-').map((p) => int.tryParse(p) ?? 0).toList();
    return Tempo(
      eccentric: parts.isNotEmpty ? parts[0] : 2,
      pauseBottom: parts.length > 1 ? parts[1] : 0,
      concentric: parts.length > 2 ? parts[2] : 1,
      pauseTop: parts.length > 3 ? parts[3] : 0,
    );
  }

  /// Get total time under tension per rep (seconds).
  int get tutPerRep => eccentric + pauseBottom + concentric + pauseTop;

  /// Get notation string.
  String get notation => '$eccentric-$pauseBottom-$concentric-$pauseTop';

  /// Get display label.
  String get label {
    if (this == Tempo.standard) return 'Standard';
    if (this == Tempo.slow) return 'Slow Eccentric';
    if (this == Tempo.explosive) return 'Explosive';
    if (this == Tempo.pause) return 'Pause Rep';
    return 'Custom ($notation)';
  }

  /// Predefined tempos.
  static const standard = Tempo(
    eccentric: 2,
    pauseBottom: 0,
    concentric: 1,
    pauseTop: 0,
  );

  static const slow = Tempo(
    eccentric: 4,
    pauseBottom: 1,
    concentric: 2,
    pauseTop: 0,
  );

  static const explosive = Tempo(
    eccentric: 2,
    pauseBottom: 0,
    concentric: 1, // 'X' explosive
    pauseTop: 0,
  );

  static const pause = Tempo(
    eccentric: 2,
    pauseBottom: 2,
    concentric: 1,
    pauseTop: 1,
  );

  Tempo copyWith({
    int? eccentric,
    int? pauseBottom,
    int? concentric,
    int? pauseTop,
  }) {
    return Tempo(
      eccentric: eccentric ?? this.eccentric,
      pauseBottom: pauseBottom ?? this.pauseBottom,
      concentric: concentric ?? this.concentric,
      pauseTop: pauseTop ?? this.pauseTop,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Tempo &&
      eccentric == other.eccentric &&
      pauseBottom == other.pauseBottom &&
      concentric == other.concentric &&
      pauseTop == other.pauseTop;

  @override
  int get hashCode => Object.hash(eccentric, pauseBottom, concentric, pauseTop);
}

/// Extended set data with RPE and tempo.
class ExtendedSetData {
  final String setId;
  final RPE? rpe;
  final Tempo? tempo;
  final int? rir; // Reps in Reserve (alternative to RPE)
  final String? notes;
  final DateTime recordedAt;

  const ExtendedSetData({
    required this.setId,
    this.rpe,
    this.tempo,
    this.rir,
    this.notes,
    required this.recordedAt,
  });

  /// Calculate time under tension for the set.
  int calculateTUT(int reps) {
    if (tempo == null) return reps * 3; // Default 3 seconds per rep
    return reps * tempo!.tutPerRep;
  }

  ExtendedSetData copyWith({
    String? setId,
    RPE? rpe,
    Tempo? tempo,
    int? rir,
    String? notes,
    DateTime? recordedAt,
  }) {
    return ExtendedSetData(
      setId: setId ?? this.setId,
      rpe: rpe ?? this.rpe,
      tempo: tempo ?? this.tempo,
      rir: rir ?? this.rir,
      notes: notes ?? this.notes,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }
}

/// RPE/RIR statistics for analysis.
class RPEStats {
  final double averageRPE;
  final double totalTUT;
  final int setsAtMaxEffort;
  final int setsAtModerate;
  final int setsAtEasy;
  final List<RPE> rpeDistribution;

  const RPEStats({
    required this.averageRPE,
    required this.totalTUT,
    required this.setsAtMaxEffort,
    required this.setsAtModerate,
    required this.setsAtEasy,
    required this.rpeDistribution,
  });

  String get effortLevel {
    if (averageRPE >= 9) return 'Maximum Effort';
    if (averageRPE >= 8) return 'High Effort';
    if (averageRPE >= 7) return 'Moderate Effort';
    return 'Low Effort';
  }

  String get recoveryEstimate {
    if (averageRPE >= 9.5) return '72+ hours';
    if (averageRPE >= 9) return '48-72 hours';
    if (averageRPE >= 8) return '24-48 hours';
    return '12-24 hours';
  }
}
