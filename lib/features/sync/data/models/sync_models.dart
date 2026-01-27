import '../../../exercise/domain/entities/exercise.dart';
import '../../../workout/domain/entities/workout.dart';
import '../../../workout/domain/entities/workout_exercise.dart';
import '../../../workout/domain/entities/exercise_set.dart';
import '../../../pr/domain/entities/personal_record.dart';

/// Request model for pushing local changes to server
class SyncPushRequest {
  final String deviceId;
  final DateTime? lastSyncAt;
  final List<SyncExercise> exercises;
  final List<SyncWorkout> workouts;
  final List<SyncPersonalRecord> personalRecords;

  const SyncPushRequest({
    required this.deviceId,
    this.lastSyncAt,
    this.exercises = const [],
    this.workouts = const [],
    this.personalRecords = const [],
  });

  Map<String, dynamic> toJson() => {
    'deviceId': deviceId,
    'lastSyncAt': lastSyncAt?.toIso8601String(),
    'exercises': exercises.map((e) => e.toJson()).toList(),
    'workouts': workouts.map((w) => w.toJson()).toList(),
    'personalRecords': personalRecords.map((pr) => pr.toJson()).toList(),
  };
}

/// Request model for pulling server changes
class SyncPullRequest {
  final String deviceId;
  final DateTime? lastSyncAt;

  const SyncPullRequest({required this.deviceId, this.lastSyncAt});

  Map<String, dynamic> toJson() => {
    'deviceId': deviceId,
    'lastSyncAt': lastSyncAt?.toIso8601String(),
  };
}

/// Response model for sync operations
class SyncPushResponse {
  final bool success;
  final int itemsPushed;
  final int conflicts;
  final DateTime syncedAt;

  const SyncPushResponse({
    required this.success,
    required this.itemsPushed,
    required this.conflicts,
    required this.syncedAt,
  });

  factory SyncPushResponse.fromJson(Map<String, dynamic> json) {
    return SyncPushResponse(
      success: json['success'] as bool,
      itemsPushed: json['itemsPushed'] as int,
      conflicts: json['conflicts'] as int,
      syncedAt: DateTime.parse(json['syncedAt'] as String),
    );
  }
}

/// Response model for pull operation
class SyncPullResponse {
  final List<SyncExercise> exercises;
  final List<SyncWorkout> workouts;
  final List<SyncPersonalRecord> personalRecords;
  final DateTime syncedAt;

  const SyncPullResponse({
    required this.exercises,
    required this.workouts,
    required this.personalRecords,
    required this.syncedAt,
  });

  factory SyncPullResponse.fromJson(Map<String, dynamic> json) {
    return SyncPullResponse(
      exercises: (json['exercises'] as List? ?? [])
          .map((e) => SyncExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      workouts: (json['workouts'] as List? ?? [])
          .map((w) => SyncWorkout.fromJson(w as Map<String, dynamic>))
          .toList(),
      personalRecords: (json['personalRecords'] as List? ?? [])
          .map((pr) => SyncPersonalRecord.fromJson(pr as Map<String, dynamic>))
          .toList(),
      syncedAt: DateTime.parse(json['syncedAt'] as String),
    );
  }
}

/// Exercise model for sync
class SyncExercise {
  final String id;
  final String name;
  final String? description;
  final String primaryMuscle;
  final List<String> secondaryMuscles;
  final bool isCompound;
  final bool isDeleted;
  final DateTime updatedAt;

  const SyncExercise({
    required this.id,
    required this.name,
    this.description,
    required this.primaryMuscle,
    required this.secondaryMuscles,
    required this.isCompound,
    required this.isDeleted,
    required this.updatedAt,
  });

  factory SyncExercise.fromJson(Map<String, dynamic> json) {
    return SyncExercise(
      id: json['clientId'] as String? ?? json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      primaryMuscle: json['primaryMuscle'] as String,
      secondaryMuscles: (json['secondaryMuscles'] as List? ?? [])
          .map((e) => e as String)
          .toList(),
      isCompound: json['isCompound'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  factory SyncExercise.fromEntity(Exercise exercise) {
    return SyncExercise(
      id: exercise.id,
      name: exercise.name,
      description: exercise.description,
      primaryMuscle: exercise.muscleGroup.name.toUpperCase(),
      secondaryMuscles: [],
      isCompound: false,
      isDeleted: exercise.deleted,
      updatedAt: exercise.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'primaryMuscle': primaryMuscle,
    'secondaryMuscles': secondaryMuscles,
    'isCompound': isCompound,
    'isDeleted': isDeleted,
    'updatedAt': updatedAt.toIso8601String(),
  };
}

/// Workout model for sync
class SyncWorkout {
  final String id;
  final String? name;
  final String? notes;
  final DateTime startTime;
  final DateTime? endTime;
  final int? durationMs;
  final bool isDeleted;
  final DateTime updatedAt;
  final List<SyncWorkoutExercise> exercises;

  const SyncWorkout({
    required this.id,
    this.name,
    this.notes,
    required this.startTime,
    this.endTime,
    this.durationMs,
    required this.isDeleted,
    required this.updatedAt,
    this.exercises = const [],
  });

  factory SyncWorkout.fromJson(Map<String, dynamic> json) {
    return SyncWorkout(
      id: json['clientId'] as String? ?? json['id'] as String,
      name: json['name'] as String?,
      notes: json['notes'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      durationMs: json['durationMs'] as int?,
      isDeleted: json['isDeleted'] as bool? ?? false,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      exercises: (json['exercises'] as List? ?? [])
          .map((e) => SyncWorkoutExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  factory SyncWorkout.fromEntity(Workout workout) {
    return SyncWorkout(
      id: workout.id,
      name: workout.name,
      notes: workout.notes,
      startTime: workout.startedAt,
      endTime: workout.completedAt,
      durationMs: workout.duration?.inMilliseconds,
      isDeleted: workout.deleted,
      updatedAt: workout.updatedAt,
      exercises: workout.exercises
          .map((e) => SyncWorkoutExercise.fromEntity(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'notes': notes,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'durationMs': durationMs,
    'isDeleted': isDeleted,
    'updatedAt': updatedAt.toIso8601String(),
    'exercises': exercises.map((e) => e.toJson()).toList(),
  };
}

/// Workout exercise for sync
class SyncWorkoutExercise {
  final String id;
  final String exerciseId;
  final int orderIndex;
  final String? notes;
  final int? restSeconds;
  final List<SyncExerciseSet> sets;

  const SyncWorkoutExercise({
    required this.id,
    required this.exerciseId,
    required this.orderIndex,
    this.notes,
    this.restSeconds,
    this.sets = const [],
  });

  factory SyncWorkoutExercise.fromJson(Map<String, dynamic> json) {
    return SyncWorkoutExercise(
      id: json['clientId'] as String? ?? json['id'] as String,
      exerciseId: json['exerciseId'] as String,
      orderIndex: json['orderIndex'] as int,
      notes: json['notes'] as String?,
      restSeconds: json['restSeconds'] as int?,
      sets: (json['sets'] as List? ?? [])
          .map((s) => SyncExerciseSet.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  factory SyncWorkoutExercise.fromEntity(WorkoutExercise we) {
    return SyncWorkoutExercise(
      id: we.id,
      exerciseId: we.exerciseId,
      orderIndex: we.orderIndex,
      notes: we.notes,
      restSeconds: null,
      sets: we.sets.map((s) => SyncExerciseSet.fromEntity(s)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'exerciseId': exerciseId,
    'orderIndex': orderIndex,
    'notes': notes,
    'restSeconds': restSeconds,
    'sets': sets.map((s) => s.toJson()).toList(),
  };
}

/// Exercise set for sync
class SyncExerciseSet {
  final String id;
  final int setNumber;
  final double? weight;
  final int? reps;
  final int? durationSeconds;
  final double? distance;
  final double? rpe;
  final bool isWarmup;
  final bool isDropset;
  final bool isFailure;
  final bool isCompleted;
  final DateTime? completedAt;

  const SyncExerciseSet({
    required this.id,
    required this.setNumber,
    this.weight,
    this.reps,
    this.durationSeconds,
    this.distance,
    this.rpe,
    this.isWarmup = false,
    this.isDropset = false,
    this.isFailure = false,
    this.isCompleted = false,
    this.completedAt,
  });

  factory SyncExerciseSet.fromJson(Map<String, dynamic> json) {
    return SyncExerciseSet(
      id: json['clientId'] as String? ?? json['id'] as String,
      setNumber: json['setNumber'] as int,
      weight: (json['weight'] as num?)?.toDouble(),
      reps: json['reps'] as int?,
      durationSeconds: json['durationSeconds'] as int?,
      distance: (json['distance'] as num?)?.toDouble(),
      rpe: (json['rpe'] as num?)?.toDouble(),
      isWarmup: json['isWarmup'] as bool? ?? false,
      isDropset: json['isDropset'] as bool? ?? false,
      isFailure: json['isFailure'] as bool? ?? false,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  factory SyncExerciseSet.fromEntity(ExerciseSet set) {
    return SyncExerciseSet(
      id: set.id,
      setNumber: set.setNumber,
      weight: set.weight,
      reps: set.reps,
      durationSeconds: null,
      distance: null,
      rpe: null,
      isWarmup: false,
      isDropset: false,
      isFailure: false,
      isCompleted: set.completed,
      completedAt: null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'setNumber': setNumber,
    'weight': weight,
    'reps': reps,
    'durationSeconds': durationSeconds,
    'distance': distance,
    'rpe': rpe,
    'isWarmup': isWarmup,
    'isDropset': isDropset,
    'isFailure': isFailure,
    'isCompleted': isCompleted,
    'completedAt': completedAt?.toIso8601String(),
  };
}

/// Personal record for sync
class SyncPersonalRecord {
  final String id;
  final String exerciseId;
  final String prType;
  final double value;
  final double? weight;
  final int? reps;
  final DateTime achievedAt;
  final DateTime updatedAt;

  const SyncPersonalRecord({
    required this.id,
    required this.exerciseId,
    required this.prType,
    required this.value,
    this.weight,
    this.reps,
    required this.achievedAt,
    required this.updatedAt,
  });

  factory SyncPersonalRecord.fromJson(Map<String, dynamic> json) {
    return SyncPersonalRecord(
      id: json['clientId'] as String? ?? json['id'] as String,
      exerciseId: json['exerciseId'] as String,
      prType: json['prType'] as String,
      value: (json['value'] as num).toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      reps: json['reps'] as int?,
      achievedAt: DateTime.parse(json['achievedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  factory SyncPersonalRecord.fromEntity(PersonalRecord pr) {
    return SyncPersonalRecord(
      id: pr.id,
      exerciseId: pr.exerciseId,
      prType: pr.prType.name.toUpperCase(),
      value: pr.value,
      weight: pr.atWeight,
      reps: null,
      achievedAt: pr.achievedAt,
      updatedAt: pr.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'exerciseId': exerciseId,
    'prType': prType,
    'value': value,
    'weight': weight,
    'reps': reps,
    'achievedAt': achievedAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
