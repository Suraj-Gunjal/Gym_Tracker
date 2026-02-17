import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/rpe_tempo.dart';

part 'rpe_provider.g.dart';

/// Provider for RPE/Tempo data per set.
@riverpod
class ExtendedSetDataNotifier extends _$ExtendedSetDataNotifier {
  @override
  Map<String, ExtendedSetData> build() => {};

  void updateRPE(String setId, RPE rpe) {
    final existing = state[setId];
    state = {
      ...state,
      setId: ExtendedSetData(
        setId: setId,
        rpe: rpe,
        tempo: existing?.tempo,
        rir: rpe.rir,
        notes: existing?.notes,
        recordedAt: DateTime.now(),
      ),
    };
  }

  void updateTempo(String setId, Tempo tempo) {
    final existing = state[setId];
    state = {
      ...state,
      setId: ExtendedSetData(
        setId: setId,
        rpe: existing?.rpe,
        tempo: tempo,
        rir: existing?.rir,
        notes: existing?.notes,
        recordedAt: DateTime.now(),
      ),
    };
  }

  void updateRIR(String setId, int rir) {
    final existing = state[setId];
    // Convert RIR to RPE
    final rpe = RPE.values.firstWhere(
      (r) => r.rir == rir,
      orElse: () => RPE.rpe8,
    );
    state = {
      ...state,
      setId: ExtendedSetData(
        setId: setId,
        rpe: rpe,
        tempo: existing?.tempo,
        rir: rir,
        notes: existing?.notes,
        recordedAt: DateTime.now(),
      ),
    };
  }

  void addNote(String setId, String note) {
    final existing = state[setId];
    if (existing != null) {
      state = {...state, setId: existing.copyWith(notes: note)};
    }
  }

  ExtendedSetData? getSetData(String setId) => state[setId];
}

/// Provider for RPE statistics.
@riverpod
RPEStats rpeStats(RpeStatsRef ref) {
  final setData = ref.watch(extendedSetDataNotifierProvider);

  if (setData.isEmpty) {
    return const RPEStats(
      averageRPE: 0,
      totalTUT: 0,
      setsAtMaxEffort: 0,
      setsAtModerate: 0,
      setsAtEasy: 0,
      rpeDistribution: [],
    );
  }

  final rpes = setData.values
      .where((d) => d.rpe != null)
      .map((d) => d.rpe!)
      .toList();

  if (rpes.isEmpty) {
    return const RPEStats(
      averageRPE: 0,
      totalTUT: 0,
      setsAtMaxEffort: 0,
      setsAtModerate: 0,
      setsAtEasy: 0,
      rpeDistribution: [],
    );
  }

  final avgRPE = rpes.map((r) => r.value).reduce((a, b) => a + b) / rpes.length;

  // Calculate total TUT (assuming 8 reps per set as default)
  final totalTUT = setData.values
      .map((d) => d.calculateTUT(8))
      .fold(0, (sum, tut) => sum + tut);

  return RPEStats(
    averageRPE: avgRPE,
    totalTUT: totalTUT.toDouble(),
    setsAtMaxEffort: rpes.where((r) => r.value >= 9.5).length,
    setsAtModerate: rpes.where((r) => r.value >= 8 && r.value < 9.5).length,
    setsAtEasy: rpes.where((r) => r.value < 8).length,
    rpeDistribution: rpes,
  );
}

/// Provider for default tempo setting.
@riverpod
class DefaultTempoNotifier extends _$DefaultTempoNotifier {
  @override
  Tempo build() => Tempo.standard;

  void setTempo(Tempo tempo) {
    state = tempo;
  }

  void setFromString(String notation) {
    state = Tempo.fromString(notation);
  }
}

/// Provider for TUT calculations.
@riverpod
int calculateTotalTUT(
  CalculateTotalTUTRef ref,
  List<(int reps, Tempo? tempo)> sets,
) {
  return sets
      .map((set) {
        final tempo = set.$2 ?? Tempo.standard;
        return set.$1 * tempo.tutPerRep;
      })
      .fold(0, (sum, tut) => sum + tut);
}
