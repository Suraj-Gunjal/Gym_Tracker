// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _muscleGroupMeta = const VerificationMeta(
    'muscleGroup',
  );
  @override
  late final GeneratedColumn<String> muscleGroup = GeneratedColumn<String>(
    'muscle_group',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPredefinedMeta = const VerificationMeta(
    'isPredefined',
  );
  @override
  late final GeneratedColumn<bool> isPredefined = GeneratedColumn<bool>(
    'is_predefined',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_predefined" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    muscleGroup,
    description,
    isPredefined,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('muscle_group')) {
      context.handle(
        _muscleGroupMeta,
        muscleGroup.isAcceptableOrUnknown(
          data['muscle_group']!,
          _muscleGroupMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_muscleGroupMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_predefined')) {
      context.handle(
        _isPredefinedMeta,
        isPredefined.isAcceptableOrUnknown(
          data['is_predefined']!,
          _isPredefinedMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      muscleGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}muscle_group'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isPredefined: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_predefined'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }
}

class Exercise extends DataClass implements Insertable<Exercise> {
  /// UUID primary key
  final String id;

  /// Exercise name
  final String name;

  /// Muscle group (stored as enum name string)
  final String muscleGroup;

  /// Optional description
  final String? description;

  /// Whether this is a predefined exercise
  final bool isPredefined;

  /// Last modification timestamp (for sync)
  final DateTime updatedAt;

  /// Soft delete flag (for sync)
  final bool deleted;
  const Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    this.description,
    required this.isPredefined,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['muscle_group'] = Variable<String>(muscleGroup);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_predefined'] = Variable<bool>(isPredefined);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      name: Value(name),
      muscleGroup: Value(muscleGroup),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isPredefined: Value(isPredefined),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory Exercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      muscleGroup: serializer.fromJson<String>(json['muscleGroup']),
      description: serializer.fromJson<String?>(json['description']),
      isPredefined: serializer.fromJson<bool>(json['isPredefined']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'muscleGroup': serializer.toJson<String>(muscleGroup),
      'description': serializer.toJson<String?>(description),
      'isPredefined': serializer.toJson<bool>(isPredefined),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  Exercise copyWith({
    String? id,
    String? name,
    String? muscleGroup,
    Value<String?> description = const Value.absent(),
    bool? isPredefined,
    DateTime? updatedAt,
    bool? deleted,
  }) => Exercise(
    id: id ?? this.id,
    name: name ?? this.name,
    muscleGroup: muscleGroup ?? this.muscleGroup,
    description: description.present ? description.value : this.description,
    isPredefined: isPredefined ?? this.isPredefined,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      muscleGroup: data.muscleGroup.present
          ? data.muscleGroup.value
          : this.muscleGroup,
      description: data.description.present
          ? data.description.value
          : this.description,
      isPredefined: data.isPredefined.present
          ? data.isPredefined.value
          : this.isPredefined,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('muscleGroup: $muscleGroup, ')
          ..write('description: $description, ')
          ..write('isPredefined: $isPredefined, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    muscleGroup,
    description,
    isPredefined,
    updatedAt,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.name == this.name &&
          other.muscleGroup == this.muscleGroup &&
          other.description == this.description &&
          other.isPredefined == this.isPredefined &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> muscleGroup;
  final Value<String?> description;
  final Value<bool> isPredefined;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<int> rowid;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.muscleGroup = const Value.absent(),
    this.description = const Value.absent(),
    this.isPredefined = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExercisesCompanion.insert({
    required String id,
    required String name,
    required String muscleGroup,
    this.description = const Value.absent(),
    this.isPredefined = const Value.absent(),
    required DateTime updatedAt,
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       muscleGroup = Value(muscleGroup),
       updatedAt = Value(updatedAt);
  static Insertable<Exercise> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? muscleGroup,
    Expression<String>? description,
    Expression<bool>? isPredefined,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (muscleGroup != null) 'muscle_group': muscleGroup,
      if (description != null) 'description': description,
      if (isPredefined != null) 'is_predefined': isPredefined,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? muscleGroup,
    Value<String?>? description,
    Value<bool>? isPredefined,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return ExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      description: description ?? this.description,
      isPredefined: isPredefined ?? this.isPredefined,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (muscleGroup.present) {
      map['muscle_group'] = Variable<String>(muscleGroup.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isPredefined.present) {
      map['is_predefined'] = Variable<bool>(isPredefined.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('muscleGroup: $muscleGroup, ')
          ..write('description: $description, ')
          ..write('isPredefined: $isPredefined, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutsTable extends Workouts with TableInfo<$WorkoutsTable, Workout> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    startedAt,
    completedAt,
    notes,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workouts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Workout> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Workout map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Workout(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $WorkoutsTable createAlias(String alias) {
    return $WorkoutsTable(attachedDatabase, alias);
  }
}

class Workout extends DataClass implements Insertable<Workout> {
  /// UUID primary key
  final String id;

  /// Optional workout name
  final String? name;

  /// When the workout was started
  final DateTime startedAt;

  /// When the workout was completed (null if in progress)
  final DateTime? completedAt;

  /// Optional notes
  final String? notes;

  /// Last modification timestamp (for sync)
  final DateTime updatedAt;

  /// Soft delete flag (for sync)
  final bool deleted;
  const Workout({
    required this.id,
    this.name,
    required this.startedAt,
    this.completedAt,
    this.notes,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  WorkoutsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutsCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory Workout.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Workout(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'notes': serializer.toJson<String?>(notes),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  Workout copyWith({
    String? id,
    Value<String?> name = const Value.absent(),
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? updatedAt,
    bool? deleted,
  }) => Workout(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    notes: notes.present ? notes.value : this.notes,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  Workout copyWithCompanion(WorkoutsCompanion data) {
    return Workout(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Workout(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, startedAt, completedAt, notes, updatedAt, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Workout &&
          other.id == this.id &&
          other.name == this.name &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.notes == this.notes &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class WorkoutsCompanion extends UpdateCompanion<Workout> {
  final Value<String> id;
  final Value<String?> name;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<String?> notes;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<int> rowid;
  const WorkoutsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutsCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime updatedAt,
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startedAt = Value(startedAt),
       updatedAt = Value(updatedAt);
  static Insertable<Workout> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<String>? notes,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (notes != null) 'notes': notes,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutsCompanion copyWith({
    Value<String>? id,
    Value<String?>? name,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<String?>? notes,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return WorkoutsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutExercisesTable extends WorkoutExercises
    with TableInfo<$WorkoutExercisesTable, WorkoutExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<String> workoutId = GeneratedColumn<String>(
    'workout_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workoutId,
    exerciseId,
    orderIndex,
    notes,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $WorkoutExercisesTable createAlias(String alias) {
    return $WorkoutExercisesTable(attachedDatabase, alias);
  }
}

class WorkoutExercise extends DataClass implements Insertable<WorkoutExercise> {
  /// UUID primary key
  final String id;

  /// Reference to parent workout
  final String workoutId;

  /// Reference to exercise definition
  final String exerciseId;

  /// Order within the workout
  final int orderIndex;

  /// Optional notes
  final String? notes;

  /// Last modification timestamp (for sync)
  final DateTime updatedAt;

  /// Soft delete flag (for sync)
  final bool deleted;
  const WorkoutExercise({
    required this.id,
    required this.workoutId,
    required this.exerciseId,
    required this.orderIndex,
    this.notes,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workout_id'] = Variable<String>(workoutId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['order_index'] = Variable<int>(orderIndex);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  WorkoutExercisesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutExercisesCompanion(
      id: Value(id),
      workoutId: Value(workoutId),
      exerciseId: Value(exerciseId),
      orderIndex: Value(orderIndex),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory WorkoutExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutExercise(
      id: serializer.fromJson<String>(json['id']),
      workoutId: serializer.fromJson<String>(json['workoutId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      notes: serializer.fromJson<String?>(json['notes']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workoutId': serializer.toJson<String>(workoutId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'notes': serializer.toJson<String?>(notes),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  WorkoutExercise copyWith({
    String? id,
    String? workoutId,
    String? exerciseId,
    int? orderIndex,
    Value<String?> notes = const Value.absent(),
    DateTime? updatedAt,
    bool? deleted,
  }) => WorkoutExercise(
    id: id ?? this.id,
    workoutId: workoutId ?? this.workoutId,
    exerciseId: exerciseId ?? this.exerciseId,
    orderIndex: orderIndex ?? this.orderIndex,
    notes: notes.present ? notes.value : this.notes,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  WorkoutExercise copyWithCompanion(WorkoutExercisesCompanion data) {
    return WorkoutExercise(
      id: data.id.present ? data.id.value : this.id,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      notes: data.notes.present ? data.notes.value : this.notes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExercise(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workoutId,
    exerciseId,
    orderIndex,
    notes,
    updatedAt,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutExercise &&
          other.id == this.id &&
          other.workoutId == this.workoutId &&
          other.exerciseId == this.exerciseId &&
          other.orderIndex == this.orderIndex &&
          other.notes == this.notes &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class WorkoutExercisesCompanion extends UpdateCompanion<WorkoutExercise> {
  final Value<String> id;
  final Value<String> workoutId;
  final Value<String> exerciseId;
  final Value<int> orderIndex;
  final Value<String?> notes;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<int> rowid;
  const WorkoutExercisesCompanion({
    this.id = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutExercisesCompanion.insert({
    required String id,
    required String workoutId,
    required String exerciseId,
    required int orderIndex,
    this.notes = const Value.absent(),
    required DateTime updatedAt,
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workoutId = Value(workoutId),
       exerciseId = Value(exerciseId),
       orderIndex = Value(orderIndex),
       updatedAt = Value(updatedAt);
  static Insertable<WorkoutExercise> custom({
    Expression<String>? id,
    Expression<String>? workoutId,
    Expression<String>? exerciseId,
    Expression<int>? orderIndex,
    Expression<String>? notes,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutId != null) 'workout_id': workoutId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (notes != null) 'notes': notes,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? workoutId,
    Value<String>? exerciseId,
    Value<int>? orderIndex,
    Value<String?>? notes,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return WorkoutExercisesCompanion(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      exerciseId: exerciseId ?? this.exerciseId,
      orderIndex: orderIndex ?? this.orderIndex,
      notes: notes ?? this.notes,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<String>(workoutId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExercisesCompanion(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExerciseSetsTable extends ExerciseSets
    with TableInfo<$ExerciseSetsTable, ExerciseSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workoutExerciseIdMeta = const VerificationMeta(
    'workoutExerciseId',
  );
  @override
  late final GeneratedColumn<String> workoutExerciseId =
      GeneratedColumn<String>(
        'workout_exercise_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _setNumberMeta = const VerificationMeta(
    'setNumber',
  );
  @override
  late final GeneratedColumn<int> setNumber = GeneratedColumn<int>(
    'set_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workoutExerciseId,
    setNumber,
    reps,
    weight,
    notes,
    completed,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseSet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workout_exercise_id')) {
      context.handle(
        _workoutExerciseIdMeta,
        workoutExerciseId.isAcceptableOrUnknown(
          data['workout_exercise_id']!,
          _workoutExerciseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workoutExerciseIdMeta);
    }
    if (data.containsKey('set_number')) {
      context.handle(
        _setNumberMeta,
        setNumber.isAcceptableOrUnknown(data['set_number']!, _setNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_setNumberMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseSet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workoutExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_exercise_id'],
      )!,
      setNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_number'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $ExerciseSetsTable createAlias(String alias) {
    return $ExerciseSetsTable(attachedDatabase, alias);
  }
}

class ExerciseSet extends DataClass implements Insertable<ExerciseSet> {
  /// UUID primary key
  final String id;

  /// Reference to parent workout exercise
  final String workoutExerciseId;

  /// Set number within the exercise (1, 2, 3...)
  final int setNumber;

  /// Number of reps performed
  final int reps;

  /// Weight used (in kg)
  final double weight;

  /// Optional notes
  final String? notes;

  /// Whether this set was completed
  final bool completed;

  /// Last modification timestamp (for sync)
  final DateTime updatedAt;

  /// Soft delete flag (for sync)
  final bool deleted;
  const ExerciseSet({
    required this.id,
    required this.workoutExerciseId,
    required this.setNumber,
    required this.reps,
    required this.weight,
    this.notes,
    required this.completed,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workout_exercise_id'] = Variable<String>(workoutExerciseId);
    map['set_number'] = Variable<int>(setNumber);
    map['reps'] = Variable<int>(reps);
    map['weight'] = Variable<double>(weight);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['completed'] = Variable<bool>(completed);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  ExerciseSetsCompanion toCompanion(bool nullToAbsent) {
    return ExerciseSetsCompanion(
      id: Value(id),
      workoutExerciseId: Value(workoutExerciseId),
      setNumber: Value(setNumber),
      reps: Value(reps),
      weight: Value(weight),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      completed: Value(completed),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory ExerciseSet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseSet(
      id: serializer.fromJson<String>(json['id']),
      workoutExerciseId: serializer.fromJson<String>(json['workoutExerciseId']),
      setNumber: serializer.fromJson<int>(json['setNumber']),
      reps: serializer.fromJson<int>(json['reps']),
      weight: serializer.fromJson<double>(json['weight']),
      notes: serializer.fromJson<String?>(json['notes']),
      completed: serializer.fromJson<bool>(json['completed']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workoutExerciseId': serializer.toJson<String>(workoutExerciseId),
      'setNumber': serializer.toJson<int>(setNumber),
      'reps': serializer.toJson<int>(reps),
      'weight': serializer.toJson<double>(weight),
      'notes': serializer.toJson<String?>(notes),
      'completed': serializer.toJson<bool>(completed),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  ExerciseSet copyWith({
    String? id,
    String? workoutExerciseId,
    int? setNumber,
    int? reps,
    double? weight,
    Value<String?> notes = const Value.absent(),
    bool? completed,
    DateTime? updatedAt,
    bool? deleted,
  }) => ExerciseSet(
    id: id ?? this.id,
    workoutExerciseId: workoutExerciseId ?? this.workoutExerciseId,
    setNumber: setNumber ?? this.setNumber,
    reps: reps ?? this.reps,
    weight: weight ?? this.weight,
    notes: notes.present ? notes.value : this.notes,
    completed: completed ?? this.completed,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  ExerciseSet copyWithCompanion(ExerciseSetsCompanion data) {
    return ExerciseSet(
      id: data.id.present ? data.id.value : this.id,
      workoutExerciseId: data.workoutExerciseId.present
          ? data.workoutExerciseId.value
          : this.workoutExerciseId,
      setNumber: data.setNumber.present ? data.setNumber.value : this.setNumber,
      reps: data.reps.present ? data.reps.value : this.reps,
      weight: data.weight.present ? data.weight.value : this.weight,
      notes: data.notes.present ? data.notes.value : this.notes,
      completed: data.completed.present ? data.completed.value : this.completed,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseSet(')
          ..write('id: $id, ')
          ..write('workoutExerciseId: $workoutExerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('reps: $reps, ')
          ..write('weight: $weight, ')
          ..write('notes: $notes, ')
          ..write('completed: $completed, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workoutExerciseId,
    setNumber,
    reps,
    weight,
    notes,
    completed,
    updatedAt,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseSet &&
          other.id == this.id &&
          other.workoutExerciseId == this.workoutExerciseId &&
          other.setNumber == this.setNumber &&
          other.reps == this.reps &&
          other.weight == this.weight &&
          other.notes == this.notes &&
          other.completed == this.completed &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class ExerciseSetsCompanion extends UpdateCompanion<ExerciseSet> {
  final Value<String> id;
  final Value<String> workoutExerciseId;
  final Value<int> setNumber;
  final Value<int> reps;
  final Value<double> weight;
  final Value<String?> notes;
  final Value<bool> completed;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<int> rowid;
  const ExerciseSetsCompanion({
    this.id = const Value.absent(),
    this.workoutExerciseId = const Value.absent(),
    this.setNumber = const Value.absent(),
    this.reps = const Value.absent(),
    this.weight = const Value.absent(),
    this.notes = const Value.absent(),
    this.completed = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExerciseSetsCompanion.insert({
    required String id,
    required String workoutExerciseId,
    required int setNumber,
    required int reps,
    required double weight,
    this.notes = const Value.absent(),
    this.completed = const Value.absent(),
    required DateTime updatedAt,
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workoutExerciseId = Value(workoutExerciseId),
       setNumber = Value(setNumber),
       reps = Value(reps),
       weight = Value(weight),
       updatedAt = Value(updatedAt);
  static Insertable<ExerciseSet> custom({
    Expression<String>? id,
    Expression<String>? workoutExerciseId,
    Expression<int>? setNumber,
    Expression<int>? reps,
    Expression<double>? weight,
    Expression<String>? notes,
    Expression<bool>? completed,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutExerciseId != null) 'workout_exercise_id': workoutExerciseId,
      if (setNumber != null) 'set_number': setNumber,
      if (reps != null) 'reps': reps,
      if (weight != null) 'weight': weight,
      if (notes != null) 'notes': notes,
      if (completed != null) 'completed': completed,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExerciseSetsCompanion copyWith({
    Value<String>? id,
    Value<String>? workoutExerciseId,
    Value<int>? setNumber,
    Value<int>? reps,
    Value<double>? weight,
    Value<String?>? notes,
    Value<bool>? completed,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return ExerciseSetsCompanion(
      id: id ?? this.id,
      workoutExerciseId: workoutExerciseId ?? this.workoutExerciseId,
      setNumber: setNumber ?? this.setNumber,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      notes: notes ?? this.notes,
      completed: completed ?? this.completed,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workoutExerciseId.present) {
      map['workout_exercise_id'] = Variable<String>(workoutExerciseId.value);
    }
    if (setNumber.present) {
      map['set_number'] = Variable<int>(setNumber.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseSetsCompanion(')
          ..write('id: $id, ')
          ..write('workoutExerciseId: $workoutExerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('reps: $reps, ')
          ..write('weight: $weight, ')
          ..write('notes: $notes, ')
          ..write('completed: $completed, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PersonalRecordsTable extends PersonalRecords
    with TableInfo<$PersonalRecordsTable, PersonalRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonalRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prTypeMeta = const VerificationMeta('prType');
  @override
  late final GeneratedColumn<String> prType = GeneratedColumn<String>(
    'pr_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _atWeightMeta = const VerificationMeta(
    'atWeight',
  );
  @override
  late final GeneratedColumn<double> atWeight = GeneratedColumn<double>(
    'at_weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<String> workoutId = GeneratedColumn<String>(
    'workout_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setIdMeta = const VerificationMeta('setId');
  @override
  late final GeneratedColumn<String> setId = GeneratedColumn<String>(
    'set_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _achievedAtMeta = const VerificationMeta(
    'achievedAt',
  );
  @override
  late final GeneratedColumn<DateTime> achievedAt = GeneratedColumn<DateTime>(
    'achieved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _previousValueMeta = const VerificationMeta(
    'previousValue',
  );
  @override
  late final GeneratedColumn<double> previousValue = GeneratedColumn<double>(
    'previous_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    exerciseId,
    prType,
    value,
    atWeight,
    workoutId,
    setId,
    achievedAt,
    previousValue,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personal_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonalRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('pr_type')) {
      context.handle(
        _prTypeMeta,
        prType.isAcceptableOrUnknown(data['pr_type']!, _prTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_prTypeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('at_weight')) {
      context.handle(
        _atWeightMeta,
        atWeight.isAcceptableOrUnknown(data['at_weight']!, _atWeightMeta),
      );
    }
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    if (data.containsKey('set_id')) {
      context.handle(
        _setIdMeta,
        setId.isAcceptableOrUnknown(data['set_id']!, _setIdMeta),
      );
    }
    if (data.containsKey('achieved_at')) {
      context.handle(
        _achievedAtMeta,
        achievedAt.isAcceptableOrUnknown(data['achieved_at']!, _achievedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_achievedAtMeta);
    }
    if (data.containsKey('previous_value')) {
      context.handle(
        _previousValueMeta,
        previousValue.isAcceptableOrUnknown(
          data['previous_value']!,
          _previousValueMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonalRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonalRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      prType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pr_type'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      atWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}at_weight'],
      ),
      workoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_id'],
      )!,
      setId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_id'],
      ),
      achievedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}achieved_at'],
      )!,
      previousValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}previous_value'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $PersonalRecordsTable createAlias(String alias) {
    return $PersonalRecordsTable(attachedDatabase, alias);
  }
}

class PersonalRecord extends DataClass implements Insertable<PersonalRecord> {
  /// UUID primary key
  final String id;

  /// Reference to exercise
  final String exerciseId;

  /// PR type (maxWeight, maxReps, maxVolume)
  final String prType;

  /// The record value
  final double value;

  /// For max reps: weight at which reps were performed
  final double? atWeight;

  /// Reference to workout where PR was achieved
  final String workoutId;

  /// Reference to specific set (optional)
  final String? setId;

  /// When the PR was achieved
  final DateTime achievedAt;

  /// Previous record value (for comparison)
  final double? previousValue;

  /// Last modification timestamp (for sync)
  final DateTime updatedAt;

  /// Soft delete flag (for sync)
  final bool deleted;
  const PersonalRecord({
    required this.id,
    required this.exerciseId,
    required this.prType,
    required this.value,
    this.atWeight,
    required this.workoutId,
    this.setId,
    required this.achievedAt,
    this.previousValue,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['pr_type'] = Variable<String>(prType);
    map['value'] = Variable<double>(value);
    if (!nullToAbsent || atWeight != null) {
      map['at_weight'] = Variable<double>(atWeight);
    }
    map['workout_id'] = Variable<String>(workoutId);
    if (!nullToAbsent || setId != null) {
      map['set_id'] = Variable<String>(setId);
    }
    map['achieved_at'] = Variable<DateTime>(achievedAt);
    if (!nullToAbsent || previousValue != null) {
      map['previous_value'] = Variable<double>(previousValue);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  PersonalRecordsCompanion toCompanion(bool nullToAbsent) {
    return PersonalRecordsCompanion(
      id: Value(id),
      exerciseId: Value(exerciseId),
      prType: Value(prType),
      value: Value(value),
      atWeight: atWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(atWeight),
      workoutId: Value(workoutId),
      setId: setId == null && nullToAbsent
          ? const Value.absent()
          : Value(setId),
      achievedAt: Value(achievedAt),
      previousValue: previousValue == null && nullToAbsent
          ? const Value.absent()
          : Value(previousValue),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory PersonalRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonalRecord(
      id: serializer.fromJson<String>(json['id']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      prType: serializer.fromJson<String>(json['prType']),
      value: serializer.fromJson<double>(json['value']),
      atWeight: serializer.fromJson<double?>(json['atWeight']),
      workoutId: serializer.fromJson<String>(json['workoutId']),
      setId: serializer.fromJson<String?>(json['setId']),
      achievedAt: serializer.fromJson<DateTime>(json['achievedAt']),
      previousValue: serializer.fromJson<double?>(json['previousValue']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'prType': serializer.toJson<String>(prType),
      'value': serializer.toJson<double>(value),
      'atWeight': serializer.toJson<double?>(atWeight),
      'workoutId': serializer.toJson<String>(workoutId),
      'setId': serializer.toJson<String?>(setId),
      'achievedAt': serializer.toJson<DateTime>(achievedAt),
      'previousValue': serializer.toJson<double?>(previousValue),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  PersonalRecord copyWith({
    String? id,
    String? exerciseId,
    String? prType,
    double? value,
    Value<double?> atWeight = const Value.absent(),
    String? workoutId,
    Value<String?> setId = const Value.absent(),
    DateTime? achievedAt,
    Value<double?> previousValue = const Value.absent(),
    DateTime? updatedAt,
    bool? deleted,
  }) => PersonalRecord(
    id: id ?? this.id,
    exerciseId: exerciseId ?? this.exerciseId,
    prType: prType ?? this.prType,
    value: value ?? this.value,
    atWeight: atWeight.present ? atWeight.value : this.atWeight,
    workoutId: workoutId ?? this.workoutId,
    setId: setId.present ? setId.value : this.setId,
    achievedAt: achievedAt ?? this.achievedAt,
    previousValue: previousValue.present
        ? previousValue.value
        : this.previousValue,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  PersonalRecord copyWithCompanion(PersonalRecordsCompanion data) {
    return PersonalRecord(
      id: data.id.present ? data.id.value : this.id,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      prType: data.prType.present ? data.prType.value : this.prType,
      value: data.value.present ? data.value.value : this.value,
      atWeight: data.atWeight.present ? data.atWeight.value : this.atWeight,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      setId: data.setId.present ? data.setId.value : this.setId,
      achievedAt: data.achievedAt.present
          ? data.achievedAt.value
          : this.achievedAt,
      previousValue: data.previousValue.present
          ? data.previousValue.value
          : this.previousValue,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonalRecord(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('prType: $prType, ')
          ..write('value: $value, ')
          ..write('atWeight: $atWeight, ')
          ..write('workoutId: $workoutId, ')
          ..write('setId: $setId, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('previousValue: $previousValue, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    exerciseId,
    prType,
    value,
    atWeight,
    workoutId,
    setId,
    achievedAt,
    previousValue,
    updatedAt,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonalRecord &&
          other.id == this.id &&
          other.exerciseId == this.exerciseId &&
          other.prType == this.prType &&
          other.value == this.value &&
          other.atWeight == this.atWeight &&
          other.workoutId == this.workoutId &&
          other.setId == this.setId &&
          other.achievedAt == this.achievedAt &&
          other.previousValue == this.previousValue &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class PersonalRecordsCompanion extends UpdateCompanion<PersonalRecord> {
  final Value<String> id;
  final Value<String> exerciseId;
  final Value<String> prType;
  final Value<double> value;
  final Value<double?> atWeight;
  final Value<String> workoutId;
  final Value<String?> setId;
  final Value<DateTime> achievedAt;
  final Value<double?> previousValue;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<int> rowid;
  const PersonalRecordsCompanion({
    this.id = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.prType = const Value.absent(),
    this.value = const Value.absent(),
    this.atWeight = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.setId = const Value.absent(),
    this.achievedAt = const Value.absent(),
    this.previousValue = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonalRecordsCompanion.insert({
    required String id,
    required String exerciseId,
    required String prType,
    required double value,
    this.atWeight = const Value.absent(),
    required String workoutId,
    this.setId = const Value.absent(),
    required DateTime achievedAt,
    this.previousValue = const Value.absent(),
    required DateTime updatedAt,
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       exerciseId = Value(exerciseId),
       prType = Value(prType),
       value = Value(value),
       workoutId = Value(workoutId),
       achievedAt = Value(achievedAt),
       updatedAt = Value(updatedAt);
  static Insertable<PersonalRecord> custom({
    Expression<String>? id,
    Expression<String>? exerciseId,
    Expression<String>? prType,
    Expression<double>? value,
    Expression<double>? atWeight,
    Expression<String>? workoutId,
    Expression<String>? setId,
    Expression<DateTime>? achievedAt,
    Expression<double>? previousValue,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (prType != null) 'pr_type': prType,
      if (value != null) 'value': value,
      if (atWeight != null) 'at_weight': atWeight,
      if (workoutId != null) 'workout_id': workoutId,
      if (setId != null) 'set_id': setId,
      if (achievedAt != null) 'achieved_at': achievedAt,
      if (previousValue != null) 'previous_value': previousValue,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonalRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? exerciseId,
    Value<String>? prType,
    Value<double>? value,
    Value<double?>? atWeight,
    Value<String>? workoutId,
    Value<String?>? setId,
    Value<DateTime>? achievedAt,
    Value<double?>? previousValue,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return PersonalRecordsCompanion(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      prType: prType ?? this.prType,
      value: value ?? this.value,
      atWeight: atWeight ?? this.atWeight,
      workoutId: workoutId ?? this.workoutId,
      setId: setId ?? this.setId,
      achievedAt: achievedAt ?? this.achievedAt,
      previousValue: previousValue ?? this.previousValue,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (prType.present) {
      map['pr_type'] = Variable<String>(prType.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (atWeight.present) {
      map['at_weight'] = Variable<double>(atWeight.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<String>(workoutId.value);
    }
    if (setId.present) {
      map['set_id'] = Variable<String>(setId.value);
    }
    if (achievedAt.present) {
      map['achieved_at'] = Variable<DateTime>(achievedAt.value);
    }
    if (previousValue.present) {
      map['previous_value'] = Variable<double>(previousValue.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonalRecordsCompanion(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('prType: $prType, ')
          ..write('value: $value, ')
          ..write('atWeight: $atWeight, ')
          ..write('workoutId: $workoutId, ')
          ..write('setId: $setId, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('previousValue: $previousValue, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accessTokenMeta = const VerificationMeta(
    'accessToken',
  );
  @override
  late final GeneratedColumn<String> accessToken = GeneratedColumn<String>(
    'access_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _refreshTokenMeta = const VerificationMeta(
    'refreshToken',
  );
  @override
  late final GeneratedColumn<String> refreshToken = GeneratedColumn<String>(
    'refresh_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    email,
    displayName,
    accessToken,
    refreshToken,
    createdAt,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('access_token')) {
      context.handle(
        _accessTokenMeta,
        accessToken.isAcceptableOrUnknown(
          data['access_token']!,
          _accessTokenMeta,
        ),
      );
    }
    if (data.containsKey('refresh_token')) {
      context.handle(
        _refreshTokenMeta,
        refreshToken.isAcceptableOrUnknown(
          data['refresh_token']!,
          _refreshTokenMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      accessToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}access_token'],
      ),
      refreshToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}refresh_token'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  /// UUID primary key
  final String id;

  /// User's email
  final String email;

  /// Display name
  final String? displayName;

  /// JWT access token
  final String? accessToken;

  /// JWT refresh token
  final String? refreshToken;

  /// Account creation date
  final DateTime createdAt;

  /// Last modification timestamp
  final DateTime updatedAt;

  /// Soft delete flag
  final bool deleted;
  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.accessToken,
    this.refreshToken,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || accessToken != null) {
      map['access_token'] = Variable<String>(accessToken);
    }
    if (!nullToAbsent || refreshToken != null) {
      map['refresh_token'] = Variable<String>(refreshToken);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      email: Value(email),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      accessToken: accessToken == null && nullToAbsent
          ? const Value.absent()
          : Value(accessToken),
      refreshToken: refreshToken == null && nullToAbsent
          ? const Value.absent()
          : Value(refreshToken),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      accessToken: serializer.fromJson<String?>(json['accessToken']),
      refreshToken: serializer.fromJson<String?>(json['refreshToken']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'displayName': serializer.toJson<String?>(displayName),
      'accessToken': serializer.toJson<String?>(accessToken),
      'refreshToken': serializer.toJson<String?>(refreshToken),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  User copyWith({
    String? id,
    String? email,
    Value<String?> displayName = const Value.absent(),
    Value<String?> accessToken = const Value.absent(),
    Value<String?> refreshToken = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? deleted,
  }) => User(
    id: id ?? this.id,
    email: email ?? this.email,
    displayName: displayName.present ? displayName.value : this.displayName,
    accessToken: accessToken.present ? accessToken.value : this.accessToken,
    refreshToken: refreshToken.present ? refreshToken.value : this.refreshToken,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      accessToken: data.accessToken.present
          ? data.accessToken.value
          : this.accessToken,
      refreshToken: data.refreshToken.present
          ? data.refreshToken.value
          : this.refreshToken,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    email,
    displayName,
    accessToken,
    refreshToken,
    createdAt,
    updatedAt,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.email == this.email &&
          other.displayName == this.displayName &&
          other.accessToken == this.accessToken &&
          other.refreshToken == this.refreshToken &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> email;
  final Value<String?> displayName;
  final Value<String?> accessToken;
  final Value<String?> refreshToken;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.displayName = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String email,
    this.displayName = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.refreshToken = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       email = Value(email),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? displayName,
    Expression<String>? accessToken,
    Expression<String>? refreshToken,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (displayName != null) 'display_name': displayName,
      if (accessToken != null) 'access_token': accessToken,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? email,
    Value<String?>? displayName,
    Value<String?>? accessToken,
    Value<String?>? refreshToken,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (accessToken.present) {
      map['access_token'] = Variable<String>(accessToken.value);
    }
    if (refreshToken.present) {
      map['refresh_token'] = Variable<String>(refreshToken.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutTemplatesTable extends WorkoutTemplates
    with TableInfo<$WorkoutTemplatesTable, WorkoutTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#6366F1'),
  );
  static const VerificationMeta _iconNameMeta = const VerificationMeta(
    'iconName',
  );
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
    'icon_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('fitness_center'),
  );
  static const VerificationMeta _estimatedMinutesMeta = const VerificationMeta(
    'estimatedMinutes',
  );
  @override
  late final GeneratedColumn<int> estimatedMinutes = GeneratedColumn<int>(
    'estimated_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usageCountMeta = const VerificationMeta(
    'usageCount',
  );
  @override
  late final GeneratedColumn<int> usageCount = GeneratedColumn<int>(
    'usage_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastUsedAtMeta = const VerificationMeta(
    'lastUsedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
    'last_used_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isPredefinedMeta = const VerificationMeta(
    'isPredefined',
  );
  @override
  late final GeneratedColumn<bool> isPredefined = GeneratedColumn<bool>(
    'is_predefined',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_predefined" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    color,
    iconName,
    estimatedMinutes,
    usageCount,
    lastUsedAt,
    sortOrder,
    isPredefined,
    createdAt,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutTemplate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('icon_name')) {
      context.handle(
        _iconNameMeta,
        iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta),
      );
    }
    if (data.containsKey('estimated_minutes')) {
      context.handle(
        _estimatedMinutesMeta,
        estimatedMinutes.isAcceptableOrUnknown(
          data['estimated_minutes']!,
          _estimatedMinutesMeta,
        ),
      );
    }
    if (data.containsKey('usage_count')) {
      context.handle(
        _usageCountMeta,
        usageCount.isAcceptableOrUnknown(data['usage_count']!, _usageCountMeta),
      );
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
        _lastUsedAtMeta,
        lastUsedAt.isAcceptableOrUnknown(
          data['last_used_at']!,
          _lastUsedAtMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_predefined')) {
      context.handle(
        _isPredefinedMeta,
        isPredefined.isAcceptableOrUnknown(
          data['is_predefined']!,
          _isPredefinedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutTemplate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      iconName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_name'],
      )!,
      estimatedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_minutes'],
      ),
      usageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usage_count'],
      )!,
      lastUsedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_used_at'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isPredefined: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_predefined'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $WorkoutTemplatesTable createAlias(String alias) {
    return $WorkoutTemplatesTable(attachedDatabase, alias);
  }
}

class WorkoutTemplate extends DataClass implements Insertable<WorkoutTemplate> {
  /// UUID primary key
  final String id;

  /// Template name (e.g., "Push Day", "Full Body")
  final String name;

  /// Optional description
  final String? description;

  /// Color for visual identification (hex string)
  final String color;

  /// Icon name for visual identification
  final String iconName;

  /// Estimated duration in minutes
  final int? estimatedMinutes;

  /// Number of times this template was used
  final int usageCount;

  /// Last time this template was used
  final DateTime? lastUsedAt;

  /// Sort order for custom ordering
  final int sortOrder;

  /// Whether this is a system/predefined template
  final bool isPredefined;

  /// Creation timestamp
  final DateTime createdAt;

  /// Last modification timestamp (for sync)
  final DateTime updatedAt;

  /// Soft delete flag (for sync)
  final bool deleted;
  const WorkoutTemplate({
    required this.id,
    required this.name,
    this.description,
    required this.color,
    required this.iconName,
    this.estimatedMinutes,
    required this.usageCount,
    this.lastUsedAt,
    required this.sortOrder,
    required this.isPredefined,
    required this.createdAt,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['color'] = Variable<String>(color);
    map['icon_name'] = Variable<String>(iconName);
    if (!nullToAbsent || estimatedMinutes != null) {
      map['estimated_minutes'] = Variable<int>(estimatedMinutes);
    }
    map['usage_count'] = Variable<int>(usageCount);
    if (!nullToAbsent || lastUsedAt != null) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_predefined'] = Variable<bool>(isPredefined);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  WorkoutTemplatesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      color: Value(color),
      iconName: Value(iconName),
      estimatedMinutes: estimatedMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedMinutes),
      usageCount: Value(usageCount),
      lastUsedAt: lastUsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAt),
      sortOrder: Value(sortOrder),
      isPredefined: Value(isPredefined),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory WorkoutTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutTemplate(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      color: serializer.fromJson<String>(json['color']),
      iconName: serializer.fromJson<String>(json['iconName']),
      estimatedMinutes: serializer.fromJson<int?>(json['estimatedMinutes']),
      usageCount: serializer.fromJson<int>(json['usageCount']),
      lastUsedAt: serializer.fromJson<DateTime?>(json['lastUsedAt']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isPredefined: serializer.fromJson<bool>(json['isPredefined']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'color': serializer.toJson<String>(color),
      'iconName': serializer.toJson<String>(iconName),
      'estimatedMinutes': serializer.toJson<int?>(estimatedMinutes),
      'usageCount': serializer.toJson<int>(usageCount),
      'lastUsedAt': serializer.toJson<DateTime?>(lastUsedAt),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isPredefined': serializer.toJson<bool>(isPredefined),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  WorkoutTemplate copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    String? color,
    String? iconName,
    Value<int?> estimatedMinutes = const Value.absent(),
    int? usageCount,
    Value<DateTime?> lastUsedAt = const Value.absent(),
    int? sortOrder,
    bool? isPredefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? deleted,
  }) => WorkoutTemplate(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    color: color ?? this.color,
    iconName: iconName ?? this.iconName,
    estimatedMinutes: estimatedMinutes.present
        ? estimatedMinutes.value
        : this.estimatedMinutes,
    usageCount: usageCount ?? this.usageCount,
    lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
    sortOrder: sortOrder ?? this.sortOrder,
    isPredefined: isPredefined ?? this.isPredefined,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  WorkoutTemplate copyWithCompanion(WorkoutTemplatesCompanion data) {
    return WorkoutTemplate(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      color: data.color.present ? data.color.value : this.color,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      estimatedMinutes: data.estimatedMinutes.present
          ? data.estimatedMinutes.value
          : this.estimatedMinutes,
      usageCount: data.usageCount.present
          ? data.usageCount.value
          : this.usageCount,
      lastUsedAt: data.lastUsedAt.present
          ? data.lastUsedAt.value
          : this.lastUsedAt,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isPredefined: data.isPredefined.present
          ? data.isPredefined.value
          : this.isPredefined,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutTemplate(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('color: $color, ')
          ..write('iconName: $iconName, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('usageCount: $usageCount, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isPredefined: $isPredefined, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    color,
    iconName,
    estimatedMinutes,
    usageCount,
    lastUsedAt,
    sortOrder,
    isPredefined,
    createdAt,
    updatedAt,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutTemplate &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.color == this.color &&
          other.iconName == this.iconName &&
          other.estimatedMinutes == this.estimatedMinutes &&
          other.usageCount == this.usageCount &&
          other.lastUsedAt == this.lastUsedAt &&
          other.sortOrder == this.sortOrder &&
          other.isPredefined == this.isPredefined &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class WorkoutTemplatesCompanion extends UpdateCompanion<WorkoutTemplate> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> color;
  final Value<String> iconName;
  final Value<int?> estimatedMinutes;
  final Value<int> usageCount;
  final Value<DateTime?> lastUsedAt;
  final Value<int> sortOrder;
  final Value<bool> isPredefined;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<int> rowid;
  const WorkoutTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.color = const Value.absent(),
    this.iconName = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isPredefined = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutTemplatesCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.color = const Value.absent(),
    this.iconName = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isPredefined = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<WorkoutTemplate> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? color,
    Expression<String>? iconName,
    Expression<int>? estimatedMinutes,
    Expression<int>? usageCount,
    Expression<DateTime>? lastUsedAt,
    Expression<int>? sortOrder,
    Expression<bool>? isPredefined,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (color != null) 'color': color,
      if (iconName != null) 'icon_name': iconName,
      if (estimatedMinutes != null) 'estimated_minutes': estimatedMinutes,
      if (usageCount != null) 'usage_count': usageCount,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isPredefined != null) 'is_predefined': isPredefined,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutTemplatesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? color,
    Value<String>? iconName,
    Value<int?>? estimatedMinutes,
    Value<int>? usageCount,
    Value<DateTime?>? lastUsedAt,
    Value<int>? sortOrder,
    Value<bool>? isPredefined,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return WorkoutTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      iconName: iconName ?? this.iconName,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      usageCount: usageCount ?? this.usageCount,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      sortOrder: sortOrder ?? this.sortOrder,
      isPredefined: isPredefined ?? this.isPredefined,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (estimatedMinutes.present) {
      map['estimated_minutes'] = Variable<int>(estimatedMinutes.value);
    }
    if (usageCount.present) {
      map['usage_count'] = Variable<int>(usageCount.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isPredefined.present) {
      map['is_predefined'] = Variable<bool>(isPredefined.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('color: $color, ')
          ..write('iconName: $iconName, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('usageCount: $usageCount, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isPredefined: $isPredefined, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TemplateExercisesTable extends TemplateExercises
    with TableInfo<$TemplateExercisesTable, TemplateExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TemplateExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_templates (id)',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultSetsMeta = const VerificationMeta(
    'defaultSets',
  );
  @override
  late final GeneratedColumn<int> defaultSets = GeneratedColumn<int>(
    'default_sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _defaultRepsMeta = const VerificationMeta(
    'defaultReps',
  );
  @override
  late final GeneratedColumn<int> defaultReps = GeneratedColumn<int>(
    'default_reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultWeightMeta = const VerificationMeta(
    'defaultWeight',
  );
  @override
  late final GeneratedColumn<double> defaultWeight = GeneratedColumn<double>(
    'default_weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultRestSecondsMeta =
      const VerificationMeta('defaultRestSeconds');
  @override
  late final GeneratedColumn<int> defaultRestSeconds = GeneratedColumn<int>(
    'default_rest_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(90),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supersetGroupMeta = const VerificationMeta(
    'supersetGroup',
  );
  @override
  late final GeneratedColumn<int> supersetGroup = GeneratedColumn<int>(
    'superset_group',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    templateId,
    exerciseId,
    sortOrder,
    defaultSets,
    defaultReps,
    defaultWeight,
    defaultRestSeconds,
    notes,
    supersetGroup,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'template_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<TemplateExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('default_sets')) {
      context.handle(
        _defaultSetsMeta,
        defaultSets.isAcceptableOrUnknown(
          data['default_sets']!,
          _defaultSetsMeta,
        ),
      );
    }
    if (data.containsKey('default_reps')) {
      context.handle(
        _defaultRepsMeta,
        defaultReps.isAcceptableOrUnknown(
          data['default_reps']!,
          _defaultRepsMeta,
        ),
      );
    }
    if (data.containsKey('default_weight')) {
      context.handle(
        _defaultWeightMeta,
        defaultWeight.isAcceptableOrUnknown(
          data['default_weight']!,
          _defaultWeightMeta,
        ),
      );
    }
    if (data.containsKey('default_rest_seconds')) {
      context.handle(
        _defaultRestSecondsMeta,
        defaultRestSeconds.isAcceptableOrUnknown(
          data['default_rest_seconds']!,
          _defaultRestSecondsMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('superset_group')) {
      context.handle(
        _supersetGroupMeta,
        supersetGroup.isAcceptableOrUnknown(
          data['superset_group']!,
          _supersetGroupMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TemplateExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TemplateExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      defaultSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_sets'],
      )!,
      defaultReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_reps'],
      ),
      defaultWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}default_weight'],
      ),
      defaultRestSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_rest_seconds'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      supersetGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}superset_group'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $TemplateExercisesTable createAlias(String alias) {
    return $TemplateExercisesTable(attachedDatabase, alias);
  }
}

class TemplateExercise extends DataClass
    implements Insertable<TemplateExercise> {
  /// UUID primary key
  final String id;

  /// Reference to the template
  final String templateId;

  /// Reference to the exercise
  final String exerciseId;

  /// Order of this exercise in the template
  final int sortOrder;

  /// Default number of sets
  final int defaultSets;

  /// Default reps (target)
  final int? defaultReps;

  /// Default weight
  final double? defaultWeight;

  /// Default rest time in seconds
  final int defaultRestSeconds;

  /// Notes for this exercise in the template
  final String? notes;

  /// Superset group (exercises with same group are supersetted)
  final int? supersetGroup;

  /// Last modification timestamp (for sync)
  final DateTime updatedAt;

  /// Soft delete flag (for sync)
  final bool deleted;
  const TemplateExercise({
    required this.id,
    required this.templateId,
    required this.exerciseId,
    required this.sortOrder,
    required this.defaultSets,
    this.defaultReps,
    this.defaultWeight,
    required this.defaultRestSeconds,
    this.notes,
    this.supersetGroup,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['template_id'] = Variable<String>(templateId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['sort_order'] = Variable<int>(sortOrder);
    map['default_sets'] = Variable<int>(defaultSets);
    if (!nullToAbsent || defaultReps != null) {
      map['default_reps'] = Variable<int>(defaultReps);
    }
    if (!nullToAbsent || defaultWeight != null) {
      map['default_weight'] = Variable<double>(defaultWeight);
    }
    map['default_rest_seconds'] = Variable<int>(defaultRestSeconds);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || supersetGroup != null) {
      map['superset_group'] = Variable<int>(supersetGroup);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  TemplateExercisesCompanion toCompanion(bool nullToAbsent) {
    return TemplateExercisesCompanion(
      id: Value(id),
      templateId: Value(templateId),
      exerciseId: Value(exerciseId),
      sortOrder: Value(sortOrder),
      defaultSets: Value(defaultSets),
      defaultReps: defaultReps == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultReps),
      defaultWeight: defaultWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultWeight),
      defaultRestSeconds: Value(defaultRestSeconds),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      supersetGroup: supersetGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(supersetGroup),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory TemplateExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TemplateExercise(
      id: serializer.fromJson<String>(json['id']),
      templateId: serializer.fromJson<String>(json['templateId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      defaultSets: serializer.fromJson<int>(json['defaultSets']),
      defaultReps: serializer.fromJson<int?>(json['defaultReps']),
      defaultWeight: serializer.fromJson<double?>(json['defaultWeight']),
      defaultRestSeconds: serializer.fromJson<int>(json['defaultRestSeconds']),
      notes: serializer.fromJson<String?>(json['notes']),
      supersetGroup: serializer.fromJson<int?>(json['supersetGroup']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'templateId': serializer.toJson<String>(templateId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'defaultSets': serializer.toJson<int>(defaultSets),
      'defaultReps': serializer.toJson<int?>(defaultReps),
      'defaultWeight': serializer.toJson<double?>(defaultWeight),
      'defaultRestSeconds': serializer.toJson<int>(defaultRestSeconds),
      'notes': serializer.toJson<String?>(notes),
      'supersetGroup': serializer.toJson<int?>(supersetGroup),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  TemplateExercise copyWith({
    String? id,
    String? templateId,
    String? exerciseId,
    int? sortOrder,
    int? defaultSets,
    Value<int?> defaultReps = const Value.absent(),
    Value<double?> defaultWeight = const Value.absent(),
    int? defaultRestSeconds,
    Value<String?> notes = const Value.absent(),
    Value<int?> supersetGroup = const Value.absent(),
    DateTime? updatedAt,
    bool? deleted,
  }) => TemplateExercise(
    id: id ?? this.id,
    templateId: templateId ?? this.templateId,
    exerciseId: exerciseId ?? this.exerciseId,
    sortOrder: sortOrder ?? this.sortOrder,
    defaultSets: defaultSets ?? this.defaultSets,
    defaultReps: defaultReps.present ? defaultReps.value : this.defaultReps,
    defaultWeight: defaultWeight.present
        ? defaultWeight.value
        : this.defaultWeight,
    defaultRestSeconds: defaultRestSeconds ?? this.defaultRestSeconds,
    notes: notes.present ? notes.value : this.notes,
    supersetGroup: supersetGroup.present
        ? supersetGroup.value
        : this.supersetGroup,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  TemplateExercise copyWithCompanion(TemplateExercisesCompanion data) {
    return TemplateExercise(
      id: data.id.present ? data.id.value : this.id,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      defaultSets: data.defaultSets.present
          ? data.defaultSets.value
          : this.defaultSets,
      defaultReps: data.defaultReps.present
          ? data.defaultReps.value
          : this.defaultReps,
      defaultWeight: data.defaultWeight.present
          ? data.defaultWeight.value
          : this.defaultWeight,
      defaultRestSeconds: data.defaultRestSeconds.present
          ? data.defaultRestSeconds.value
          : this.defaultRestSeconds,
      notes: data.notes.present ? data.notes.value : this.notes,
      supersetGroup: data.supersetGroup.present
          ? data.supersetGroup.value
          : this.supersetGroup,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TemplateExercise(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('defaultSets: $defaultSets, ')
          ..write('defaultReps: $defaultReps, ')
          ..write('defaultWeight: $defaultWeight, ')
          ..write('defaultRestSeconds: $defaultRestSeconds, ')
          ..write('notes: $notes, ')
          ..write('supersetGroup: $supersetGroup, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    templateId,
    exerciseId,
    sortOrder,
    defaultSets,
    defaultReps,
    defaultWeight,
    defaultRestSeconds,
    notes,
    supersetGroup,
    updatedAt,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TemplateExercise &&
          other.id == this.id &&
          other.templateId == this.templateId &&
          other.exerciseId == this.exerciseId &&
          other.sortOrder == this.sortOrder &&
          other.defaultSets == this.defaultSets &&
          other.defaultReps == this.defaultReps &&
          other.defaultWeight == this.defaultWeight &&
          other.defaultRestSeconds == this.defaultRestSeconds &&
          other.notes == this.notes &&
          other.supersetGroup == this.supersetGroup &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class TemplateExercisesCompanion extends UpdateCompanion<TemplateExercise> {
  final Value<String> id;
  final Value<String> templateId;
  final Value<String> exerciseId;
  final Value<int> sortOrder;
  final Value<int> defaultSets;
  final Value<int?> defaultReps;
  final Value<double?> defaultWeight;
  final Value<int> defaultRestSeconds;
  final Value<String?> notes;
  final Value<int?> supersetGroup;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<int> rowid;
  const TemplateExercisesCompanion({
    this.id = const Value.absent(),
    this.templateId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.defaultSets = const Value.absent(),
    this.defaultReps = const Value.absent(),
    this.defaultWeight = const Value.absent(),
    this.defaultRestSeconds = const Value.absent(),
    this.notes = const Value.absent(),
    this.supersetGroup = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TemplateExercisesCompanion.insert({
    required String id,
    required String templateId,
    required String exerciseId,
    required int sortOrder,
    this.defaultSets = const Value.absent(),
    this.defaultReps = const Value.absent(),
    this.defaultWeight = const Value.absent(),
    this.defaultRestSeconds = const Value.absent(),
    this.notes = const Value.absent(),
    this.supersetGroup = const Value.absent(),
    required DateTime updatedAt,
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       templateId = Value(templateId),
       exerciseId = Value(exerciseId),
       sortOrder = Value(sortOrder),
       updatedAt = Value(updatedAt);
  static Insertable<TemplateExercise> custom({
    Expression<String>? id,
    Expression<String>? templateId,
    Expression<String>? exerciseId,
    Expression<int>? sortOrder,
    Expression<int>? defaultSets,
    Expression<int>? defaultReps,
    Expression<double>? defaultWeight,
    Expression<int>? defaultRestSeconds,
    Expression<String>? notes,
    Expression<int>? supersetGroup,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateId != null) 'template_id': templateId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (defaultSets != null) 'default_sets': defaultSets,
      if (defaultReps != null) 'default_reps': defaultReps,
      if (defaultWeight != null) 'default_weight': defaultWeight,
      if (defaultRestSeconds != null)
        'default_rest_seconds': defaultRestSeconds,
      if (notes != null) 'notes': notes,
      if (supersetGroup != null) 'superset_group': supersetGroup,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TemplateExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? templateId,
    Value<String>? exerciseId,
    Value<int>? sortOrder,
    Value<int>? defaultSets,
    Value<int?>? defaultReps,
    Value<double?>? defaultWeight,
    Value<int>? defaultRestSeconds,
    Value<String?>? notes,
    Value<int?>? supersetGroup,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return TemplateExercisesCompanion(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      exerciseId: exerciseId ?? this.exerciseId,
      sortOrder: sortOrder ?? this.sortOrder,
      defaultSets: defaultSets ?? this.defaultSets,
      defaultReps: defaultReps ?? this.defaultReps,
      defaultWeight: defaultWeight ?? this.defaultWeight,
      defaultRestSeconds: defaultRestSeconds ?? this.defaultRestSeconds,
      notes: notes ?? this.notes,
      supersetGroup: supersetGroup ?? this.supersetGroup,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (defaultSets.present) {
      map['default_sets'] = Variable<int>(defaultSets.value);
    }
    if (defaultReps.present) {
      map['default_reps'] = Variable<int>(defaultReps.value);
    }
    if (defaultWeight.present) {
      map['default_weight'] = Variable<double>(defaultWeight.value);
    }
    if (defaultRestSeconds.present) {
      map['default_rest_seconds'] = Variable<int>(defaultRestSeconds.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (supersetGroup.present) {
      map['superset_group'] = Variable<int>(supersetGroup.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemplateExercisesCompanion(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('defaultSets: $defaultSets, ')
          ..write('defaultReps: $defaultReps, ')
          ..write('defaultWeight: $defaultWeight, ')
          ..write('defaultRestSeconds: $defaultRestSeconds, ')
          ..write('notes: $notes, ')
          ..write('supersetGroup: $supersetGroup, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BodyMeasurementsTable extends BodyMeasurements
    with TableInfo<$BodyMeasurementsTable, BodyMeasurement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BodyMeasurementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measuredAtMeta = const VerificationMeta(
    'measuredAt',
  );
  @override
  late final GeneratedColumn<DateTime> measuredAt = GeneratedColumn<DateTime>(
    'measured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyFatPercentMeta = const VerificationMeta(
    'bodyFatPercent',
  );
  @override
  late final GeneratedColumn<double> bodyFatPercent = GeneratedColumn<double>(
    'body_fat_percent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _muscleMassKgMeta = const VerificationMeta(
    'muscleMassKg',
  );
  @override
  late final GeneratedColumn<double> muscleMassKg = GeneratedColumn<double>(
    'muscle_mass_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _neckCmMeta = const VerificationMeta('neckCm');
  @override
  late final GeneratedColumn<double> neckCm = GeneratedColumn<double>(
    'neck_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shouldersCmMeta = const VerificationMeta(
    'shouldersCm',
  );
  @override
  late final GeneratedColumn<double> shouldersCm = GeneratedColumn<double>(
    'shoulders_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chestCmMeta = const VerificationMeta(
    'chestCm',
  );
  @override
  late final GeneratedColumn<double> chestCm = GeneratedColumn<double>(
    'chest_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _leftBicepCmMeta = const VerificationMeta(
    'leftBicepCm',
  );
  @override
  late final GeneratedColumn<double> leftBicepCm = GeneratedColumn<double>(
    'left_bicep_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rightBicepCmMeta = const VerificationMeta(
    'rightBicepCm',
  );
  @override
  late final GeneratedColumn<double> rightBicepCm = GeneratedColumn<double>(
    'right_bicep_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _leftForearmCmMeta = const VerificationMeta(
    'leftForearmCm',
  );
  @override
  late final GeneratedColumn<double> leftForearmCm = GeneratedColumn<double>(
    'left_forearm_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rightForearmCmMeta = const VerificationMeta(
    'rightForearmCm',
  );
  @override
  late final GeneratedColumn<double> rightForearmCm = GeneratedColumn<double>(
    'right_forearm_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _waistCmMeta = const VerificationMeta(
    'waistCm',
  );
  @override
  late final GeneratedColumn<double> waistCm = GeneratedColumn<double>(
    'waist_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hipsCmMeta = const VerificationMeta('hipsCm');
  @override
  late final GeneratedColumn<double> hipsCm = GeneratedColumn<double>(
    'hips_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _leftThighCmMeta = const VerificationMeta(
    'leftThighCm',
  );
  @override
  late final GeneratedColumn<double> leftThighCm = GeneratedColumn<double>(
    'left_thigh_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rightThighCmMeta = const VerificationMeta(
    'rightThighCm',
  );
  @override
  late final GeneratedColumn<double> rightThighCm = GeneratedColumn<double>(
    'right_thigh_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _leftCalfCmMeta = const VerificationMeta(
    'leftCalfCm',
  );
  @override
  late final GeneratedColumn<double> leftCalfCm = GeneratedColumn<double>(
    'left_calf_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rightCalfCmMeta = const VerificationMeta(
    'rightCalfCm',
  );
  @override
  late final GeneratedColumn<double> rightCalfCm = GeneratedColumn<double>(
    'right_calf_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    measuredAt,
    weightKg,
    bodyFatPercent,
    muscleMassKg,
    neckCm,
    shouldersCm,
    chestCm,
    leftBicepCm,
    rightBicepCm,
    leftForearmCm,
    rightForearmCm,
    waistCm,
    hipsCm,
    leftThighCm,
    rightThighCm,
    leftCalfCm,
    rightCalfCm,
    notes,
    photoPath,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'body_measurements';
  @override
  VerificationContext validateIntegrity(
    Insertable<BodyMeasurement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('measured_at')) {
      context.handle(
        _measuredAtMeta,
        measuredAt.isAcceptableOrUnknown(data['measured_at']!, _measuredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_measuredAtMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('body_fat_percent')) {
      context.handle(
        _bodyFatPercentMeta,
        bodyFatPercent.isAcceptableOrUnknown(
          data['body_fat_percent']!,
          _bodyFatPercentMeta,
        ),
      );
    }
    if (data.containsKey('muscle_mass_kg')) {
      context.handle(
        _muscleMassKgMeta,
        muscleMassKg.isAcceptableOrUnknown(
          data['muscle_mass_kg']!,
          _muscleMassKgMeta,
        ),
      );
    }
    if (data.containsKey('neck_cm')) {
      context.handle(
        _neckCmMeta,
        neckCm.isAcceptableOrUnknown(data['neck_cm']!, _neckCmMeta),
      );
    }
    if (data.containsKey('shoulders_cm')) {
      context.handle(
        _shouldersCmMeta,
        shouldersCm.isAcceptableOrUnknown(
          data['shoulders_cm']!,
          _shouldersCmMeta,
        ),
      );
    }
    if (data.containsKey('chest_cm')) {
      context.handle(
        _chestCmMeta,
        chestCm.isAcceptableOrUnknown(data['chest_cm']!, _chestCmMeta),
      );
    }
    if (data.containsKey('left_bicep_cm')) {
      context.handle(
        _leftBicepCmMeta,
        leftBicepCm.isAcceptableOrUnknown(
          data['left_bicep_cm']!,
          _leftBicepCmMeta,
        ),
      );
    }
    if (data.containsKey('right_bicep_cm')) {
      context.handle(
        _rightBicepCmMeta,
        rightBicepCm.isAcceptableOrUnknown(
          data['right_bicep_cm']!,
          _rightBicepCmMeta,
        ),
      );
    }
    if (data.containsKey('left_forearm_cm')) {
      context.handle(
        _leftForearmCmMeta,
        leftForearmCm.isAcceptableOrUnknown(
          data['left_forearm_cm']!,
          _leftForearmCmMeta,
        ),
      );
    }
    if (data.containsKey('right_forearm_cm')) {
      context.handle(
        _rightForearmCmMeta,
        rightForearmCm.isAcceptableOrUnknown(
          data['right_forearm_cm']!,
          _rightForearmCmMeta,
        ),
      );
    }
    if (data.containsKey('waist_cm')) {
      context.handle(
        _waistCmMeta,
        waistCm.isAcceptableOrUnknown(data['waist_cm']!, _waistCmMeta),
      );
    }
    if (data.containsKey('hips_cm')) {
      context.handle(
        _hipsCmMeta,
        hipsCm.isAcceptableOrUnknown(data['hips_cm']!, _hipsCmMeta),
      );
    }
    if (data.containsKey('left_thigh_cm')) {
      context.handle(
        _leftThighCmMeta,
        leftThighCm.isAcceptableOrUnknown(
          data['left_thigh_cm']!,
          _leftThighCmMeta,
        ),
      );
    }
    if (data.containsKey('right_thigh_cm')) {
      context.handle(
        _rightThighCmMeta,
        rightThighCm.isAcceptableOrUnknown(
          data['right_thigh_cm']!,
          _rightThighCmMeta,
        ),
      );
    }
    if (data.containsKey('left_calf_cm')) {
      context.handle(
        _leftCalfCmMeta,
        leftCalfCm.isAcceptableOrUnknown(
          data['left_calf_cm']!,
          _leftCalfCmMeta,
        ),
      );
    }
    if (data.containsKey('right_calf_cm')) {
      context.handle(
        _rightCalfCmMeta,
        rightCalfCm.isAcceptableOrUnknown(
          data['right_calf_cm']!,
          _rightCalfCmMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BodyMeasurement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BodyMeasurement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      measuredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}measured_at'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      bodyFatPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}body_fat_percent'],
      ),
      muscleMassKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}muscle_mass_kg'],
      ),
      neckCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}neck_cm'],
      ),
      shouldersCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}shoulders_cm'],
      ),
      chestCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}chest_cm'],
      ),
      leftBicepCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}left_bicep_cm'],
      ),
      rightBicepCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}right_bicep_cm'],
      ),
      leftForearmCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}left_forearm_cm'],
      ),
      rightForearmCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}right_forearm_cm'],
      ),
      waistCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}waist_cm'],
      ),
      hipsCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hips_cm'],
      ),
      leftThighCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}left_thigh_cm'],
      ),
      rightThighCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}right_thigh_cm'],
      ),
      leftCalfCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}left_calf_cm'],
      ),
      rightCalfCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}right_calf_cm'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $BodyMeasurementsTable createAlias(String alias) {
    return $BodyMeasurementsTable(attachedDatabase, alias);
  }
}

class BodyMeasurement extends DataClass implements Insertable<BodyMeasurement> {
  /// UUID primary key
  final String id;

  /// Date of the measurement
  final DateTime measuredAt;

  /// Body weight in kg
  final double? weightKg;

  /// Body fat percentage
  final double? bodyFatPercent;

  /// Muscle mass in kg
  final double? muscleMassKg;
  final double? neckCm;
  final double? shouldersCm;
  final double? chestCm;
  final double? leftBicepCm;
  final double? rightBicepCm;
  final double? leftForearmCm;
  final double? rightForearmCm;
  final double? waistCm;
  final double? hipsCm;
  final double? leftThighCm;
  final double? rightThighCm;
  final double? leftCalfCm;
  final double? rightCalfCm;

  /// Optional notes
  final String? notes;

  /// Optional photo path
  final String? photoPath;

  /// Last modification timestamp (for sync)
  final DateTime updatedAt;

  /// Soft delete flag (for sync)
  final bool deleted;
  const BodyMeasurement({
    required this.id,
    required this.measuredAt,
    this.weightKg,
    this.bodyFatPercent,
    this.muscleMassKg,
    this.neckCm,
    this.shouldersCm,
    this.chestCm,
    this.leftBicepCm,
    this.rightBicepCm,
    this.leftForearmCm,
    this.rightForearmCm,
    this.waistCm,
    this.hipsCm,
    this.leftThighCm,
    this.rightThighCm,
    this.leftCalfCm,
    this.rightCalfCm,
    this.notes,
    this.photoPath,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['measured_at'] = Variable<DateTime>(measuredAt);
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || bodyFatPercent != null) {
      map['body_fat_percent'] = Variable<double>(bodyFatPercent);
    }
    if (!nullToAbsent || muscleMassKg != null) {
      map['muscle_mass_kg'] = Variable<double>(muscleMassKg);
    }
    if (!nullToAbsent || neckCm != null) {
      map['neck_cm'] = Variable<double>(neckCm);
    }
    if (!nullToAbsent || shouldersCm != null) {
      map['shoulders_cm'] = Variable<double>(shouldersCm);
    }
    if (!nullToAbsent || chestCm != null) {
      map['chest_cm'] = Variable<double>(chestCm);
    }
    if (!nullToAbsent || leftBicepCm != null) {
      map['left_bicep_cm'] = Variable<double>(leftBicepCm);
    }
    if (!nullToAbsent || rightBicepCm != null) {
      map['right_bicep_cm'] = Variable<double>(rightBicepCm);
    }
    if (!nullToAbsent || leftForearmCm != null) {
      map['left_forearm_cm'] = Variable<double>(leftForearmCm);
    }
    if (!nullToAbsent || rightForearmCm != null) {
      map['right_forearm_cm'] = Variable<double>(rightForearmCm);
    }
    if (!nullToAbsent || waistCm != null) {
      map['waist_cm'] = Variable<double>(waistCm);
    }
    if (!nullToAbsent || hipsCm != null) {
      map['hips_cm'] = Variable<double>(hipsCm);
    }
    if (!nullToAbsent || leftThighCm != null) {
      map['left_thigh_cm'] = Variable<double>(leftThighCm);
    }
    if (!nullToAbsent || rightThighCm != null) {
      map['right_thigh_cm'] = Variable<double>(rightThighCm);
    }
    if (!nullToAbsent || leftCalfCm != null) {
      map['left_calf_cm'] = Variable<double>(leftCalfCm);
    }
    if (!nullToAbsent || rightCalfCm != null) {
      map['right_calf_cm'] = Variable<double>(rightCalfCm);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  BodyMeasurementsCompanion toCompanion(bool nullToAbsent) {
    return BodyMeasurementsCompanion(
      id: Value(id),
      measuredAt: Value(measuredAt),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      bodyFatPercent: bodyFatPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyFatPercent),
      muscleMassKg: muscleMassKg == null && nullToAbsent
          ? const Value.absent()
          : Value(muscleMassKg),
      neckCm: neckCm == null && nullToAbsent
          ? const Value.absent()
          : Value(neckCm),
      shouldersCm: shouldersCm == null && nullToAbsent
          ? const Value.absent()
          : Value(shouldersCm),
      chestCm: chestCm == null && nullToAbsent
          ? const Value.absent()
          : Value(chestCm),
      leftBicepCm: leftBicepCm == null && nullToAbsent
          ? const Value.absent()
          : Value(leftBicepCm),
      rightBicepCm: rightBicepCm == null && nullToAbsent
          ? const Value.absent()
          : Value(rightBicepCm),
      leftForearmCm: leftForearmCm == null && nullToAbsent
          ? const Value.absent()
          : Value(leftForearmCm),
      rightForearmCm: rightForearmCm == null && nullToAbsent
          ? const Value.absent()
          : Value(rightForearmCm),
      waistCm: waistCm == null && nullToAbsent
          ? const Value.absent()
          : Value(waistCm),
      hipsCm: hipsCm == null && nullToAbsent
          ? const Value.absent()
          : Value(hipsCm),
      leftThighCm: leftThighCm == null && nullToAbsent
          ? const Value.absent()
          : Value(leftThighCm),
      rightThighCm: rightThighCm == null && nullToAbsent
          ? const Value.absent()
          : Value(rightThighCm),
      leftCalfCm: leftCalfCm == null && nullToAbsent
          ? const Value.absent()
          : Value(leftCalfCm),
      rightCalfCm: rightCalfCm == null && nullToAbsent
          ? const Value.absent()
          : Value(rightCalfCm),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory BodyMeasurement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BodyMeasurement(
      id: serializer.fromJson<String>(json['id']),
      measuredAt: serializer.fromJson<DateTime>(json['measuredAt']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      bodyFatPercent: serializer.fromJson<double?>(json['bodyFatPercent']),
      muscleMassKg: serializer.fromJson<double?>(json['muscleMassKg']),
      neckCm: serializer.fromJson<double?>(json['neckCm']),
      shouldersCm: serializer.fromJson<double?>(json['shouldersCm']),
      chestCm: serializer.fromJson<double?>(json['chestCm']),
      leftBicepCm: serializer.fromJson<double?>(json['leftBicepCm']),
      rightBicepCm: serializer.fromJson<double?>(json['rightBicepCm']),
      leftForearmCm: serializer.fromJson<double?>(json['leftForearmCm']),
      rightForearmCm: serializer.fromJson<double?>(json['rightForearmCm']),
      waistCm: serializer.fromJson<double?>(json['waistCm']),
      hipsCm: serializer.fromJson<double?>(json['hipsCm']),
      leftThighCm: serializer.fromJson<double?>(json['leftThighCm']),
      rightThighCm: serializer.fromJson<double?>(json['rightThighCm']),
      leftCalfCm: serializer.fromJson<double?>(json['leftCalfCm']),
      rightCalfCm: serializer.fromJson<double?>(json['rightCalfCm']),
      notes: serializer.fromJson<String?>(json['notes']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'measuredAt': serializer.toJson<DateTime>(measuredAt),
      'weightKg': serializer.toJson<double?>(weightKg),
      'bodyFatPercent': serializer.toJson<double?>(bodyFatPercent),
      'muscleMassKg': serializer.toJson<double?>(muscleMassKg),
      'neckCm': serializer.toJson<double?>(neckCm),
      'shouldersCm': serializer.toJson<double?>(shouldersCm),
      'chestCm': serializer.toJson<double?>(chestCm),
      'leftBicepCm': serializer.toJson<double?>(leftBicepCm),
      'rightBicepCm': serializer.toJson<double?>(rightBicepCm),
      'leftForearmCm': serializer.toJson<double?>(leftForearmCm),
      'rightForearmCm': serializer.toJson<double?>(rightForearmCm),
      'waistCm': serializer.toJson<double?>(waistCm),
      'hipsCm': serializer.toJson<double?>(hipsCm),
      'leftThighCm': serializer.toJson<double?>(leftThighCm),
      'rightThighCm': serializer.toJson<double?>(rightThighCm),
      'leftCalfCm': serializer.toJson<double?>(leftCalfCm),
      'rightCalfCm': serializer.toJson<double?>(rightCalfCm),
      'notes': serializer.toJson<String?>(notes),
      'photoPath': serializer.toJson<String?>(photoPath),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  BodyMeasurement copyWith({
    String? id,
    DateTime? measuredAt,
    Value<double?> weightKg = const Value.absent(),
    Value<double?> bodyFatPercent = const Value.absent(),
    Value<double?> muscleMassKg = const Value.absent(),
    Value<double?> neckCm = const Value.absent(),
    Value<double?> shouldersCm = const Value.absent(),
    Value<double?> chestCm = const Value.absent(),
    Value<double?> leftBicepCm = const Value.absent(),
    Value<double?> rightBicepCm = const Value.absent(),
    Value<double?> leftForearmCm = const Value.absent(),
    Value<double?> rightForearmCm = const Value.absent(),
    Value<double?> waistCm = const Value.absent(),
    Value<double?> hipsCm = const Value.absent(),
    Value<double?> leftThighCm = const Value.absent(),
    Value<double?> rightThighCm = const Value.absent(),
    Value<double?> leftCalfCm = const Value.absent(),
    Value<double?> rightCalfCm = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    DateTime? updatedAt,
    bool? deleted,
  }) => BodyMeasurement(
    id: id ?? this.id,
    measuredAt: measuredAt ?? this.measuredAt,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    bodyFatPercent: bodyFatPercent.present
        ? bodyFatPercent.value
        : this.bodyFatPercent,
    muscleMassKg: muscleMassKg.present ? muscleMassKg.value : this.muscleMassKg,
    neckCm: neckCm.present ? neckCm.value : this.neckCm,
    shouldersCm: shouldersCm.present ? shouldersCm.value : this.shouldersCm,
    chestCm: chestCm.present ? chestCm.value : this.chestCm,
    leftBicepCm: leftBicepCm.present ? leftBicepCm.value : this.leftBicepCm,
    rightBicepCm: rightBicepCm.present ? rightBicepCm.value : this.rightBicepCm,
    leftForearmCm: leftForearmCm.present
        ? leftForearmCm.value
        : this.leftForearmCm,
    rightForearmCm: rightForearmCm.present
        ? rightForearmCm.value
        : this.rightForearmCm,
    waistCm: waistCm.present ? waistCm.value : this.waistCm,
    hipsCm: hipsCm.present ? hipsCm.value : this.hipsCm,
    leftThighCm: leftThighCm.present ? leftThighCm.value : this.leftThighCm,
    rightThighCm: rightThighCm.present ? rightThighCm.value : this.rightThighCm,
    leftCalfCm: leftCalfCm.present ? leftCalfCm.value : this.leftCalfCm,
    rightCalfCm: rightCalfCm.present ? rightCalfCm.value : this.rightCalfCm,
    notes: notes.present ? notes.value : this.notes,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  BodyMeasurement copyWithCompanion(BodyMeasurementsCompanion data) {
    return BodyMeasurement(
      id: data.id.present ? data.id.value : this.id,
      measuredAt: data.measuredAt.present
          ? data.measuredAt.value
          : this.measuredAt,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      bodyFatPercent: data.bodyFatPercent.present
          ? data.bodyFatPercent.value
          : this.bodyFatPercent,
      muscleMassKg: data.muscleMassKg.present
          ? data.muscleMassKg.value
          : this.muscleMassKg,
      neckCm: data.neckCm.present ? data.neckCm.value : this.neckCm,
      shouldersCm: data.shouldersCm.present
          ? data.shouldersCm.value
          : this.shouldersCm,
      chestCm: data.chestCm.present ? data.chestCm.value : this.chestCm,
      leftBicepCm: data.leftBicepCm.present
          ? data.leftBicepCm.value
          : this.leftBicepCm,
      rightBicepCm: data.rightBicepCm.present
          ? data.rightBicepCm.value
          : this.rightBicepCm,
      leftForearmCm: data.leftForearmCm.present
          ? data.leftForearmCm.value
          : this.leftForearmCm,
      rightForearmCm: data.rightForearmCm.present
          ? data.rightForearmCm.value
          : this.rightForearmCm,
      waistCm: data.waistCm.present ? data.waistCm.value : this.waistCm,
      hipsCm: data.hipsCm.present ? data.hipsCm.value : this.hipsCm,
      leftThighCm: data.leftThighCm.present
          ? data.leftThighCm.value
          : this.leftThighCm,
      rightThighCm: data.rightThighCm.present
          ? data.rightThighCm.value
          : this.rightThighCm,
      leftCalfCm: data.leftCalfCm.present
          ? data.leftCalfCm.value
          : this.leftCalfCm,
      rightCalfCm: data.rightCalfCm.present
          ? data.rightCalfCm.value
          : this.rightCalfCm,
      notes: data.notes.present ? data.notes.value : this.notes,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BodyMeasurement(')
          ..write('id: $id, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('weightKg: $weightKg, ')
          ..write('bodyFatPercent: $bodyFatPercent, ')
          ..write('muscleMassKg: $muscleMassKg, ')
          ..write('neckCm: $neckCm, ')
          ..write('shouldersCm: $shouldersCm, ')
          ..write('chestCm: $chestCm, ')
          ..write('leftBicepCm: $leftBicepCm, ')
          ..write('rightBicepCm: $rightBicepCm, ')
          ..write('leftForearmCm: $leftForearmCm, ')
          ..write('rightForearmCm: $rightForearmCm, ')
          ..write('waistCm: $waistCm, ')
          ..write('hipsCm: $hipsCm, ')
          ..write('leftThighCm: $leftThighCm, ')
          ..write('rightThighCm: $rightThighCm, ')
          ..write('leftCalfCm: $leftCalfCm, ')
          ..write('rightCalfCm: $rightCalfCm, ')
          ..write('notes: $notes, ')
          ..write('photoPath: $photoPath, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    measuredAt,
    weightKg,
    bodyFatPercent,
    muscleMassKg,
    neckCm,
    shouldersCm,
    chestCm,
    leftBicepCm,
    rightBicepCm,
    leftForearmCm,
    rightForearmCm,
    waistCm,
    hipsCm,
    leftThighCm,
    rightThighCm,
    leftCalfCm,
    rightCalfCm,
    notes,
    photoPath,
    updatedAt,
    deleted,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BodyMeasurement &&
          other.id == this.id &&
          other.measuredAt == this.measuredAt &&
          other.weightKg == this.weightKg &&
          other.bodyFatPercent == this.bodyFatPercent &&
          other.muscleMassKg == this.muscleMassKg &&
          other.neckCm == this.neckCm &&
          other.shouldersCm == this.shouldersCm &&
          other.chestCm == this.chestCm &&
          other.leftBicepCm == this.leftBicepCm &&
          other.rightBicepCm == this.rightBicepCm &&
          other.leftForearmCm == this.leftForearmCm &&
          other.rightForearmCm == this.rightForearmCm &&
          other.waistCm == this.waistCm &&
          other.hipsCm == this.hipsCm &&
          other.leftThighCm == this.leftThighCm &&
          other.rightThighCm == this.rightThighCm &&
          other.leftCalfCm == this.leftCalfCm &&
          other.rightCalfCm == this.rightCalfCm &&
          other.notes == this.notes &&
          other.photoPath == this.photoPath &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class BodyMeasurementsCompanion extends UpdateCompanion<BodyMeasurement> {
  final Value<String> id;
  final Value<DateTime> measuredAt;
  final Value<double?> weightKg;
  final Value<double?> bodyFatPercent;
  final Value<double?> muscleMassKg;
  final Value<double?> neckCm;
  final Value<double?> shouldersCm;
  final Value<double?> chestCm;
  final Value<double?> leftBicepCm;
  final Value<double?> rightBicepCm;
  final Value<double?> leftForearmCm;
  final Value<double?> rightForearmCm;
  final Value<double?> waistCm;
  final Value<double?> hipsCm;
  final Value<double?> leftThighCm;
  final Value<double?> rightThighCm;
  final Value<double?> leftCalfCm;
  final Value<double?> rightCalfCm;
  final Value<String?> notes;
  final Value<String?> photoPath;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<int> rowid;
  const BodyMeasurementsCompanion({
    this.id = const Value.absent(),
    this.measuredAt = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.bodyFatPercent = const Value.absent(),
    this.muscleMassKg = const Value.absent(),
    this.neckCm = const Value.absent(),
    this.shouldersCm = const Value.absent(),
    this.chestCm = const Value.absent(),
    this.leftBicepCm = const Value.absent(),
    this.rightBicepCm = const Value.absent(),
    this.leftForearmCm = const Value.absent(),
    this.rightForearmCm = const Value.absent(),
    this.waistCm = const Value.absent(),
    this.hipsCm = const Value.absent(),
    this.leftThighCm = const Value.absent(),
    this.rightThighCm = const Value.absent(),
    this.leftCalfCm = const Value.absent(),
    this.rightCalfCm = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BodyMeasurementsCompanion.insert({
    required String id,
    required DateTime measuredAt,
    this.weightKg = const Value.absent(),
    this.bodyFatPercent = const Value.absent(),
    this.muscleMassKg = const Value.absent(),
    this.neckCm = const Value.absent(),
    this.shouldersCm = const Value.absent(),
    this.chestCm = const Value.absent(),
    this.leftBicepCm = const Value.absent(),
    this.rightBicepCm = const Value.absent(),
    this.leftForearmCm = const Value.absent(),
    this.rightForearmCm = const Value.absent(),
    this.waistCm = const Value.absent(),
    this.hipsCm = const Value.absent(),
    this.leftThighCm = const Value.absent(),
    this.rightThighCm = const Value.absent(),
    this.leftCalfCm = const Value.absent(),
    this.rightCalfCm = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoPath = const Value.absent(),
    required DateTime updatedAt,
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       measuredAt = Value(measuredAt),
       updatedAt = Value(updatedAt);
  static Insertable<BodyMeasurement> custom({
    Expression<String>? id,
    Expression<DateTime>? measuredAt,
    Expression<double>? weightKg,
    Expression<double>? bodyFatPercent,
    Expression<double>? muscleMassKg,
    Expression<double>? neckCm,
    Expression<double>? shouldersCm,
    Expression<double>? chestCm,
    Expression<double>? leftBicepCm,
    Expression<double>? rightBicepCm,
    Expression<double>? leftForearmCm,
    Expression<double>? rightForearmCm,
    Expression<double>? waistCm,
    Expression<double>? hipsCm,
    Expression<double>? leftThighCm,
    Expression<double>? rightThighCm,
    Expression<double>? leftCalfCm,
    Expression<double>? rightCalfCm,
    Expression<String>? notes,
    Expression<String>? photoPath,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (measuredAt != null) 'measured_at': measuredAt,
      if (weightKg != null) 'weight_kg': weightKg,
      if (bodyFatPercent != null) 'body_fat_percent': bodyFatPercent,
      if (muscleMassKg != null) 'muscle_mass_kg': muscleMassKg,
      if (neckCm != null) 'neck_cm': neckCm,
      if (shouldersCm != null) 'shoulders_cm': shouldersCm,
      if (chestCm != null) 'chest_cm': chestCm,
      if (leftBicepCm != null) 'left_bicep_cm': leftBicepCm,
      if (rightBicepCm != null) 'right_bicep_cm': rightBicepCm,
      if (leftForearmCm != null) 'left_forearm_cm': leftForearmCm,
      if (rightForearmCm != null) 'right_forearm_cm': rightForearmCm,
      if (waistCm != null) 'waist_cm': waistCm,
      if (hipsCm != null) 'hips_cm': hipsCm,
      if (leftThighCm != null) 'left_thigh_cm': leftThighCm,
      if (rightThighCm != null) 'right_thigh_cm': rightThighCm,
      if (leftCalfCm != null) 'left_calf_cm': leftCalfCm,
      if (rightCalfCm != null) 'right_calf_cm': rightCalfCm,
      if (notes != null) 'notes': notes,
      if (photoPath != null) 'photo_path': photoPath,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BodyMeasurementsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? measuredAt,
    Value<double?>? weightKg,
    Value<double?>? bodyFatPercent,
    Value<double?>? muscleMassKg,
    Value<double?>? neckCm,
    Value<double?>? shouldersCm,
    Value<double?>? chestCm,
    Value<double?>? leftBicepCm,
    Value<double?>? rightBicepCm,
    Value<double?>? leftForearmCm,
    Value<double?>? rightForearmCm,
    Value<double?>? waistCm,
    Value<double?>? hipsCm,
    Value<double?>? leftThighCm,
    Value<double?>? rightThighCm,
    Value<double?>? leftCalfCm,
    Value<double?>? rightCalfCm,
    Value<String?>? notes,
    Value<String?>? photoPath,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return BodyMeasurementsCompanion(
      id: id ?? this.id,
      measuredAt: measuredAt ?? this.measuredAt,
      weightKg: weightKg ?? this.weightKg,
      bodyFatPercent: bodyFatPercent ?? this.bodyFatPercent,
      muscleMassKg: muscleMassKg ?? this.muscleMassKg,
      neckCm: neckCm ?? this.neckCm,
      shouldersCm: shouldersCm ?? this.shouldersCm,
      chestCm: chestCm ?? this.chestCm,
      leftBicepCm: leftBicepCm ?? this.leftBicepCm,
      rightBicepCm: rightBicepCm ?? this.rightBicepCm,
      leftForearmCm: leftForearmCm ?? this.leftForearmCm,
      rightForearmCm: rightForearmCm ?? this.rightForearmCm,
      waistCm: waistCm ?? this.waistCm,
      hipsCm: hipsCm ?? this.hipsCm,
      leftThighCm: leftThighCm ?? this.leftThighCm,
      rightThighCm: rightThighCm ?? this.rightThighCm,
      leftCalfCm: leftCalfCm ?? this.leftCalfCm,
      rightCalfCm: rightCalfCm ?? this.rightCalfCm,
      notes: notes ?? this.notes,
      photoPath: photoPath ?? this.photoPath,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (measuredAt.present) {
      map['measured_at'] = Variable<DateTime>(measuredAt.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (bodyFatPercent.present) {
      map['body_fat_percent'] = Variable<double>(bodyFatPercent.value);
    }
    if (muscleMassKg.present) {
      map['muscle_mass_kg'] = Variable<double>(muscleMassKg.value);
    }
    if (neckCm.present) {
      map['neck_cm'] = Variable<double>(neckCm.value);
    }
    if (shouldersCm.present) {
      map['shoulders_cm'] = Variable<double>(shouldersCm.value);
    }
    if (chestCm.present) {
      map['chest_cm'] = Variable<double>(chestCm.value);
    }
    if (leftBicepCm.present) {
      map['left_bicep_cm'] = Variable<double>(leftBicepCm.value);
    }
    if (rightBicepCm.present) {
      map['right_bicep_cm'] = Variable<double>(rightBicepCm.value);
    }
    if (leftForearmCm.present) {
      map['left_forearm_cm'] = Variable<double>(leftForearmCm.value);
    }
    if (rightForearmCm.present) {
      map['right_forearm_cm'] = Variable<double>(rightForearmCm.value);
    }
    if (waistCm.present) {
      map['waist_cm'] = Variable<double>(waistCm.value);
    }
    if (hipsCm.present) {
      map['hips_cm'] = Variable<double>(hipsCm.value);
    }
    if (leftThighCm.present) {
      map['left_thigh_cm'] = Variable<double>(leftThighCm.value);
    }
    if (rightThighCm.present) {
      map['right_thigh_cm'] = Variable<double>(rightThighCm.value);
    }
    if (leftCalfCm.present) {
      map['left_calf_cm'] = Variable<double>(leftCalfCm.value);
    }
    if (rightCalfCm.present) {
      map['right_calf_cm'] = Variable<double>(rightCalfCm.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BodyMeasurementsCompanion(')
          ..write('id: $id, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('weightKg: $weightKg, ')
          ..write('bodyFatPercent: $bodyFatPercent, ')
          ..write('muscleMassKg: $muscleMassKg, ')
          ..write('neckCm: $neckCm, ')
          ..write('shouldersCm: $shouldersCm, ')
          ..write('chestCm: $chestCm, ')
          ..write('leftBicepCm: $leftBicepCm, ')
          ..write('rightBicepCm: $rightBicepCm, ')
          ..write('leftForearmCm: $leftForearmCm, ')
          ..write('rightForearmCm: $rightForearmCm, ')
          ..write('waistCm: $waistCm, ')
          ..write('hipsCm: $hipsCm, ')
          ..write('leftThighCm: $leftThighCm, ')
          ..write('rightThighCm: $rightThighCm, ')
          ..write('leftCalfCm: $leftCalfCm, ')
          ..write('rightCalfCm: $rightCalfCm, ')
          ..write('notes: $notes, ')
          ..write('photoPath: $photoPath, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AchievementsTable extends Achievements
    with TableInfo<$AchievementsTable, Achievement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconNameMeta = const VerificationMeta(
    'iconName',
  );
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
    'icon_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tierMeta = const VerificationMeta('tier');
  @override
  late final GeneratedColumn<String> tier = GeneratedColumn<String>(
    'tier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requirementValueMeta = const VerificationMeta(
    'requirementValue',
  );
  @override
  late final GeneratedColumn<int> requirementValue = GeneratedColumn<int>(
    'requirement_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requirementTypeMeta = const VerificationMeta(
    'requirementType',
  );
  @override
  late final GeneratedColumn<String> requirementType = GeneratedColumn<String>(
    'requirement_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _xpRewardMeta = const VerificationMeta(
    'xpReward',
  );
  @override
  late final GeneratedColumn<int> xpReward = GeneratedColumn<int>(
    'xp_reward',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(100),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isPredefinedMeta = const VerificationMeta(
    'isPredefined',
  );
  @override
  late final GeneratedColumn<bool> isPredefined = GeneratedColumn<bool>(
    'is_predefined',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_predefined" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    iconName,
    color,
    category,
    tier,
    requirementValue,
    requirementType,
    xpReward,
    sortOrder,
    isPredefined,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Achievement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('icon_name')) {
      context.handle(
        _iconNameMeta,
        iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta),
      );
    } else if (isInserting) {
      context.missing(_iconNameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('tier')) {
      context.handle(
        _tierMeta,
        tier.isAcceptableOrUnknown(data['tier']!, _tierMeta),
      );
    } else if (isInserting) {
      context.missing(_tierMeta);
    }
    if (data.containsKey('requirement_value')) {
      context.handle(
        _requirementValueMeta,
        requirementValue.isAcceptableOrUnknown(
          data['requirement_value']!,
          _requirementValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requirementValueMeta);
    }
    if (data.containsKey('requirement_type')) {
      context.handle(
        _requirementTypeMeta,
        requirementType.isAcceptableOrUnknown(
          data['requirement_type']!,
          _requirementTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requirementTypeMeta);
    }
    if (data.containsKey('xp_reward')) {
      context.handle(
        _xpRewardMeta,
        xpReward.isAcceptableOrUnknown(data['xp_reward']!, _xpRewardMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_predefined')) {
      context.handle(
        _isPredefinedMeta,
        isPredefined.isAcceptableOrUnknown(
          data['is_predefined']!,
          _isPredefinedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Achievement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Achievement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      iconName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      tier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tier'],
      )!,
      requirementValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}requirement_value'],
      )!,
      requirementType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}requirement_type'],
      )!,
      xpReward: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp_reward'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isPredefined: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_predefined'],
      )!,
    );
  }

  @override
  $AchievementsTable createAlias(String alias) {
    return $AchievementsTable(attachedDatabase, alias);
  }
}

class Achievement extends DataClass implements Insertable<Achievement> {
  /// UUID primary key
  final String id;

  /// Achievement name
  final String name;

  /// Description of how to earn it
  final String description;

  /// Icon name
  final String iconName;

  /// Color (hex string)
  final String color;

  /// Category (workout, strength, consistency, etc.)
  final String category;

  /// Tier (bronze, silver, gold, platinum)
  final String tier;

  /// Requirement value (e.g., 100 for "100 workouts")
  final int requirementValue;

  /// Requirement type (workout_count, pr_count, streak_days, etc.)
  final String requirementType;

  /// XP points awarded
  final int xpReward;

  /// Sort order
  final int sortOrder;

  /// Whether this is a system achievement
  final bool isPredefined;
  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.color,
    required this.category,
    required this.tier,
    required this.requirementValue,
    required this.requirementType,
    required this.xpReward,
    required this.sortOrder,
    required this.isPredefined,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['icon_name'] = Variable<String>(iconName);
    map['color'] = Variable<String>(color);
    map['category'] = Variable<String>(category);
    map['tier'] = Variable<String>(tier);
    map['requirement_value'] = Variable<int>(requirementValue);
    map['requirement_type'] = Variable<String>(requirementType);
    map['xp_reward'] = Variable<int>(xpReward);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_predefined'] = Variable<bool>(isPredefined);
    return map;
  }

  AchievementsCompanion toCompanion(bool nullToAbsent) {
    return AchievementsCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      iconName: Value(iconName),
      color: Value(color),
      category: Value(category),
      tier: Value(tier),
      requirementValue: Value(requirementValue),
      requirementType: Value(requirementType),
      xpReward: Value(xpReward),
      sortOrder: Value(sortOrder),
      isPredefined: Value(isPredefined),
    );
  }

  factory Achievement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Achievement(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      iconName: serializer.fromJson<String>(json['iconName']),
      color: serializer.fromJson<String>(json['color']),
      category: serializer.fromJson<String>(json['category']),
      tier: serializer.fromJson<String>(json['tier']),
      requirementValue: serializer.fromJson<int>(json['requirementValue']),
      requirementType: serializer.fromJson<String>(json['requirementType']),
      xpReward: serializer.fromJson<int>(json['xpReward']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isPredefined: serializer.fromJson<bool>(json['isPredefined']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'iconName': serializer.toJson<String>(iconName),
      'color': serializer.toJson<String>(color),
      'category': serializer.toJson<String>(category),
      'tier': serializer.toJson<String>(tier),
      'requirementValue': serializer.toJson<int>(requirementValue),
      'requirementType': serializer.toJson<String>(requirementType),
      'xpReward': serializer.toJson<int>(xpReward),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isPredefined': serializer.toJson<bool>(isPredefined),
    };
  }

  Achievement copyWith({
    String? id,
    String? name,
    String? description,
    String? iconName,
    String? color,
    String? category,
    String? tier,
    int? requirementValue,
    String? requirementType,
    int? xpReward,
    int? sortOrder,
    bool? isPredefined,
  }) => Achievement(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    iconName: iconName ?? this.iconName,
    color: color ?? this.color,
    category: category ?? this.category,
    tier: tier ?? this.tier,
    requirementValue: requirementValue ?? this.requirementValue,
    requirementType: requirementType ?? this.requirementType,
    xpReward: xpReward ?? this.xpReward,
    sortOrder: sortOrder ?? this.sortOrder,
    isPredefined: isPredefined ?? this.isPredefined,
  );
  Achievement copyWithCompanion(AchievementsCompanion data) {
    return Achievement(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      color: data.color.present ? data.color.value : this.color,
      category: data.category.present ? data.category.value : this.category,
      tier: data.tier.present ? data.tier.value : this.tier,
      requirementValue: data.requirementValue.present
          ? data.requirementValue.value
          : this.requirementValue,
      requirementType: data.requirementType.present
          ? data.requirementType.value
          : this.requirementType,
      xpReward: data.xpReward.present ? data.xpReward.value : this.xpReward,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isPredefined: data.isPredefined.present
          ? data.isPredefined.value
          : this.isPredefined,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Achievement(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('iconName: $iconName, ')
          ..write('color: $color, ')
          ..write('category: $category, ')
          ..write('tier: $tier, ')
          ..write('requirementValue: $requirementValue, ')
          ..write('requirementType: $requirementType, ')
          ..write('xpReward: $xpReward, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isPredefined: $isPredefined')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    iconName,
    color,
    category,
    tier,
    requirementValue,
    requirementType,
    xpReward,
    sortOrder,
    isPredefined,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Achievement &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.iconName == this.iconName &&
          other.color == this.color &&
          other.category == this.category &&
          other.tier == this.tier &&
          other.requirementValue == this.requirementValue &&
          other.requirementType == this.requirementType &&
          other.xpReward == this.xpReward &&
          other.sortOrder == this.sortOrder &&
          other.isPredefined == this.isPredefined);
}

class AchievementsCompanion extends UpdateCompanion<Achievement> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> iconName;
  final Value<String> color;
  final Value<String> category;
  final Value<String> tier;
  final Value<int> requirementValue;
  final Value<String> requirementType;
  final Value<int> xpReward;
  final Value<int> sortOrder;
  final Value<bool> isPredefined;
  final Value<int> rowid;
  const AchievementsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.iconName = const Value.absent(),
    this.color = const Value.absent(),
    this.category = const Value.absent(),
    this.tier = const Value.absent(),
    this.requirementValue = const Value.absent(),
    this.requirementType = const Value.absent(),
    this.xpReward = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isPredefined = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AchievementsCompanion.insert({
    required String id,
    required String name,
    required String description,
    required String iconName,
    required String color,
    required String category,
    required String tier,
    required int requirementValue,
    required String requirementType,
    this.xpReward = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isPredefined = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       description = Value(description),
       iconName = Value(iconName),
       color = Value(color),
       category = Value(category),
       tier = Value(tier),
       requirementValue = Value(requirementValue),
       requirementType = Value(requirementType);
  static Insertable<Achievement> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? iconName,
    Expression<String>? color,
    Expression<String>? category,
    Expression<String>? tier,
    Expression<int>? requirementValue,
    Expression<String>? requirementType,
    Expression<int>? xpReward,
    Expression<int>? sortOrder,
    Expression<bool>? isPredefined,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (iconName != null) 'icon_name': iconName,
      if (color != null) 'color': color,
      if (category != null) 'category': category,
      if (tier != null) 'tier': tier,
      if (requirementValue != null) 'requirement_value': requirementValue,
      if (requirementType != null) 'requirement_type': requirementType,
      if (xpReward != null) 'xp_reward': xpReward,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isPredefined != null) 'is_predefined': isPredefined,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AchievementsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? description,
    Value<String>? iconName,
    Value<String>? color,
    Value<String>? category,
    Value<String>? tier,
    Value<int>? requirementValue,
    Value<String>? requirementType,
    Value<int>? xpReward,
    Value<int>? sortOrder,
    Value<bool>? isPredefined,
    Value<int>? rowid,
  }) {
    return AchievementsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      color: color ?? this.color,
      category: category ?? this.category,
      tier: tier ?? this.tier,
      requirementValue: requirementValue ?? this.requirementValue,
      requirementType: requirementType ?? this.requirementType,
      xpReward: xpReward ?? this.xpReward,
      sortOrder: sortOrder ?? this.sortOrder,
      isPredefined: isPredefined ?? this.isPredefined,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (tier.present) {
      map['tier'] = Variable<String>(tier.value);
    }
    if (requirementValue.present) {
      map['requirement_value'] = Variable<int>(requirementValue.value);
    }
    if (requirementType.present) {
      map['requirement_type'] = Variable<String>(requirementType.value);
    }
    if (xpReward.present) {
      map['xp_reward'] = Variable<int>(xpReward.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isPredefined.present) {
      map['is_predefined'] = Variable<bool>(isPredefined.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('iconName: $iconName, ')
          ..write('color: $color, ')
          ..write('category: $category, ')
          ..write('tier: $tier, ')
          ..write('requirementValue: $requirementValue, ')
          ..write('requirementType: $requirementType, ')
          ..write('xpReward: $xpReward, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isPredefined: $isPredefined, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserAchievementsTable extends UserAchievements
    with TableInfo<$UserAchievementsTable, UserAchievement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserAchievementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _achievementIdMeta = const VerificationMeta(
    'achievementId',
  );
  @override
  late final GeneratedColumn<String> achievementId = GeneratedColumn<String>(
    'achievement_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES achievements (id)',
    ),
  );
  static const VerificationMeta _currentProgressMeta = const VerificationMeta(
    'currentProgress',
  );
  @override
  late final GeneratedColumn<int> currentProgress = GeneratedColumn<int>(
    'current_progress',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isUnlockedMeta = const VerificationMeta(
    'isUnlocked',
  );
  @override
  late final GeneratedColumn<bool> isUnlocked = GeneratedColumn<bool>(
    'is_unlocked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_unlocked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _unlockedAtMeta = const VerificationMeta(
    'unlockedAt',
  );
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
    'unlocked_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSeenMeta = const VerificationMeta('isSeen');
  @override
  late final GeneratedColumn<bool> isSeen = GeneratedColumn<bool>(
    'is_seen',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_seen" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    achievementId,
    currentProgress,
    isUnlocked,
    unlockedAt,
    isSeen,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_achievements';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserAchievement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('achievement_id')) {
      context.handle(
        _achievementIdMeta,
        achievementId.isAcceptableOrUnknown(
          data['achievement_id']!,
          _achievementIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_achievementIdMeta);
    }
    if (data.containsKey('current_progress')) {
      context.handle(
        _currentProgressMeta,
        currentProgress.isAcceptableOrUnknown(
          data['current_progress']!,
          _currentProgressMeta,
        ),
      );
    }
    if (data.containsKey('is_unlocked')) {
      context.handle(
        _isUnlockedMeta,
        isUnlocked.isAcceptableOrUnknown(data['is_unlocked']!, _isUnlockedMeta),
      );
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
        _unlockedAtMeta,
        unlockedAt.isAcceptableOrUnknown(data['unlocked_at']!, _unlockedAtMeta),
      );
    }
    if (data.containsKey('is_seen')) {
      context.handle(
        _isSeenMeta,
        isSeen.isAcceptableOrUnknown(data['is_seen']!, _isSeenMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserAchievement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserAchievement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      achievementId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}achievement_id'],
      )!,
      currentProgress: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_progress'],
      )!,
      isUnlocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_unlocked'],
      )!,
      unlockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}unlocked_at'],
      ),
      isSeen: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_seen'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserAchievementsTable createAlias(String alias) {
    return $UserAchievementsTable(attachedDatabase, alias);
  }
}

class UserAchievement extends DataClass implements Insertable<UserAchievement> {
  /// UUID primary key
  final String id;

  /// Reference to achievement
  final String achievementId;

  /// Current progress value
  final int currentProgress;

  /// Whether the achievement is unlocked
  final bool isUnlocked;

  /// When the achievement was unlocked
  final DateTime? unlockedAt;

  /// Whether the user has seen/acknowledged this achievement
  final bool isSeen;

  /// Last modification timestamp (for sync)
  final DateTime updatedAt;
  const UserAchievement({
    required this.id,
    required this.achievementId,
    required this.currentProgress,
    required this.isUnlocked,
    this.unlockedAt,
    required this.isSeen,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['achievement_id'] = Variable<String>(achievementId);
    map['current_progress'] = Variable<int>(currentProgress);
    map['is_unlocked'] = Variable<bool>(isUnlocked);
    if (!nullToAbsent || unlockedAt != null) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    }
    map['is_seen'] = Variable<bool>(isSeen);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserAchievementsCompanion toCompanion(bool nullToAbsent) {
    return UserAchievementsCompanion(
      id: Value(id),
      achievementId: Value(achievementId),
      currentProgress: Value(currentProgress),
      isUnlocked: Value(isUnlocked),
      unlockedAt: unlockedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(unlockedAt),
      isSeen: Value(isSeen),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserAchievement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserAchievement(
      id: serializer.fromJson<String>(json['id']),
      achievementId: serializer.fromJson<String>(json['achievementId']),
      currentProgress: serializer.fromJson<int>(json['currentProgress']),
      isUnlocked: serializer.fromJson<bool>(json['isUnlocked']),
      unlockedAt: serializer.fromJson<DateTime?>(json['unlockedAt']),
      isSeen: serializer.fromJson<bool>(json['isSeen']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'achievementId': serializer.toJson<String>(achievementId),
      'currentProgress': serializer.toJson<int>(currentProgress),
      'isUnlocked': serializer.toJson<bool>(isUnlocked),
      'unlockedAt': serializer.toJson<DateTime?>(unlockedAt),
      'isSeen': serializer.toJson<bool>(isSeen),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserAchievement copyWith({
    String? id,
    String? achievementId,
    int? currentProgress,
    bool? isUnlocked,
    Value<DateTime?> unlockedAt = const Value.absent(),
    bool? isSeen,
    DateTime? updatedAt,
  }) => UserAchievement(
    id: id ?? this.id,
    achievementId: achievementId ?? this.achievementId,
    currentProgress: currentProgress ?? this.currentProgress,
    isUnlocked: isUnlocked ?? this.isUnlocked,
    unlockedAt: unlockedAt.present ? unlockedAt.value : this.unlockedAt,
    isSeen: isSeen ?? this.isSeen,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserAchievement copyWithCompanion(UserAchievementsCompanion data) {
    return UserAchievement(
      id: data.id.present ? data.id.value : this.id,
      achievementId: data.achievementId.present
          ? data.achievementId.value
          : this.achievementId,
      currentProgress: data.currentProgress.present
          ? data.currentProgress.value
          : this.currentProgress,
      isUnlocked: data.isUnlocked.present
          ? data.isUnlocked.value
          : this.isUnlocked,
      unlockedAt: data.unlockedAt.present
          ? data.unlockedAt.value
          : this.unlockedAt,
      isSeen: data.isSeen.present ? data.isSeen.value : this.isSeen,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserAchievement(')
          ..write('id: $id, ')
          ..write('achievementId: $achievementId, ')
          ..write('currentProgress: $currentProgress, ')
          ..write('isUnlocked: $isUnlocked, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('isSeen: $isSeen, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    achievementId,
    currentProgress,
    isUnlocked,
    unlockedAt,
    isSeen,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserAchievement &&
          other.id == this.id &&
          other.achievementId == this.achievementId &&
          other.currentProgress == this.currentProgress &&
          other.isUnlocked == this.isUnlocked &&
          other.unlockedAt == this.unlockedAt &&
          other.isSeen == this.isSeen &&
          other.updatedAt == this.updatedAt);
}

class UserAchievementsCompanion extends UpdateCompanion<UserAchievement> {
  final Value<String> id;
  final Value<String> achievementId;
  final Value<int> currentProgress;
  final Value<bool> isUnlocked;
  final Value<DateTime?> unlockedAt;
  final Value<bool> isSeen;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserAchievementsCompanion({
    this.id = const Value.absent(),
    this.achievementId = const Value.absent(),
    this.currentProgress = const Value.absent(),
    this.isUnlocked = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.isSeen = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserAchievementsCompanion.insert({
    required String id,
    required String achievementId,
    this.currentProgress = const Value.absent(),
    this.isUnlocked = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.isSeen = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       achievementId = Value(achievementId),
       updatedAt = Value(updatedAt);
  static Insertable<UserAchievement> custom({
    Expression<String>? id,
    Expression<String>? achievementId,
    Expression<int>? currentProgress,
    Expression<bool>? isUnlocked,
    Expression<DateTime>? unlockedAt,
    Expression<bool>? isSeen,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (achievementId != null) 'achievement_id': achievementId,
      if (currentProgress != null) 'current_progress': currentProgress,
      if (isUnlocked != null) 'is_unlocked': isUnlocked,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (isSeen != null) 'is_seen': isSeen,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserAchievementsCompanion copyWith({
    Value<String>? id,
    Value<String>? achievementId,
    Value<int>? currentProgress,
    Value<bool>? isUnlocked,
    Value<DateTime?>? unlockedAt,
    Value<bool>? isSeen,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserAchievementsCompanion(
      id: id ?? this.id,
      achievementId: achievementId ?? this.achievementId,
      currentProgress: currentProgress ?? this.currentProgress,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isSeen: isSeen ?? this.isSeen,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (achievementId.present) {
      map['achievement_id'] = Variable<String>(achievementId.value);
    }
    if (currentProgress.present) {
      map['current_progress'] = Variable<int>(currentProgress.value);
    }
    if (isUnlocked.present) {
      map['is_unlocked'] = Variable<bool>(isUnlocked.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (isSeen.present) {
      map['is_seen'] = Variable<bool>(isSeen.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserAchievementsCompanion(')
          ..write('id: $id, ')
          ..write('achievementId: $achievementId, ')
          ..write('currentProgress: $currentProgress, ')
          ..write('isUnlocked: $isUnlocked, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('isSeen: $isSeen, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserStatsTable extends UserStats
    with TableInfo<$UserStatsTable, UserStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalWorkoutsMeta = const VerificationMeta(
    'totalWorkouts',
  );
  @override
  late final GeneratedColumn<int> totalWorkouts = GeneratedColumn<int>(
    'total_workouts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalExercisesMeta = const VerificationMeta(
    'totalExercises',
  );
  @override
  late final GeneratedColumn<int> totalExercises = GeneratedColumn<int>(
    'total_exercises',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalSetsMeta = const VerificationMeta(
    'totalSets',
  );
  @override
  late final GeneratedColumn<int> totalSets = GeneratedColumn<int>(
    'total_sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalRepsMeta = const VerificationMeta(
    'totalReps',
  );
  @override
  late final GeneratedColumn<int> totalReps = GeneratedColumn<int>(
    'total_reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalWeightLiftedMeta = const VerificationMeta(
    'totalWeightLifted',
  );
  @override
  late final GeneratedColumn<double> totalWeightLifted =
      GeneratedColumn<double>(
        'total_weight_lifted',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _totalMinutesMeta = const VerificationMeta(
    'totalMinutes',
  );
  @override
  late final GeneratedColumn<int> totalMinutes = GeneratedColumn<int>(
    'total_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currentStreakMeta = const VerificationMeta(
    'currentStreak',
  );
  @override
  late final GeneratedColumn<int> currentStreak = GeneratedColumn<int>(
    'current_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _longestStreakMeta = const VerificationMeta(
    'longestStreak',
  );
  @override
  late final GeneratedColumn<int> longestStreak = GeneratedColumn<int>(
    'longest_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalPRsMeta = const VerificationMeta(
    'totalPRs',
  );
  @override
  late final GeneratedColumn<int> totalPRs = GeneratedColumn<int>(
    'total_p_rs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalXPMeta = const VerificationMeta(
    'totalXP',
  );
  @override
  late final GeneratedColumn<int> totalXP = GeneratedColumn<int>(
    'total_x_p',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _lastWorkoutAtMeta = const VerificationMeta(
    'lastWorkoutAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastWorkoutAt =
      GeneratedColumn<DateTime>(
        'last_workout_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    totalWorkouts,
    totalExercises,
    totalSets,
    totalReps,
    totalWeightLifted,
    totalMinutes,
    currentStreak,
    longestStreak,
    totalPRs,
    totalXP,
    level,
    lastWorkoutAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_stats';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserStat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('total_workouts')) {
      context.handle(
        _totalWorkoutsMeta,
        totalWorkouts.isAcceptableOrUnknown(
          data['total_workouts']!,
          _totalWorkoutsMeta,
        ),
      );
    }
    if (data.containsKey('total_exercises')) {
      context.handle(
        _totalExercisesMeta,
        totalExercises.isAcceptableOrUnknown(
          data['total_exercises']!,
          _totalExercisesMeta,
        ),
      );
    }
    if (data.containsKey('total_sets')) {
      context.handle(
        _totalSetsMeta,
        totalSets.isAcceptableOrUnknown(data['total_sets']!, _totalSetsMeta),
      );
    }
    if (data.containsKey('total_reps')) {
      context.handle(
        _totalRepsMeta,
        totalReps.isAcceptableOrUnknown(data['total_reps']!, _totalRepsMeta),
      );
    }
    if (data.containsKey('total_weight_lifted')) {
      context.handle(
        _totalWeightLiftedMeta,
        totalWeightLifted.isAcceptableOrUnknown(
          data['total_weight_lifted']!,
          _totalWeightLiftedMeta,
        ),
      );
    }
    if (data.containsKey('total_minutes')) {
      context.handle(
        _totalMinutesMeta,
        totalMinutes.isAcceptableOrUnknown(
          data['total_minutes']!,
          _totalMinutesMeta,
        ),
      );
    }
    if (data.containsKey('current_streak')) {
      context.handle(
        _currentStreakMeta,
        currentStreak.isAcceptableOrUnknown(
          data['current_streak']!,
          _currentStreakMeta,
        ),
      );
    }
    if (data.containsKey('longest_streak')) {
      context.handle(
        _longestStreakMeta,
        longestStreak.isAcceptableOrUnknown(
          data['longest_streak']!,
          _longestStreakMeta,
        ),
      );
    }
    if (data.containsKey('total_p_rs')) {
      context.handle(
        _totalPRsMeta,
        totalPRs.isAcceptableOrUnknown(data['total_p_rs']!, _totalPRsMeta),
      );
    }
    if (data.containsKey('total_x_p')) {
      context.handle(
        _totalXPMeta,
        totalXP.isAcceptableOrUnknown(data['total_x_p']!, _totalXPMeta),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('last_workout_at')) {
      context.handle(
        _lastWorkoutAtMeta,
        lastWorkoutAt.isAcceptableOrUnknown(
          data['last_workout_at']!,
          _lastWorkoutAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserStat(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      totalWorkouts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_workouts'],
      )!,
      totalExercises: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_exercises'],
      )!,
      totalSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_sets'],
      )!,
      totalReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_reps'],
      )!,
      totalWeightLifted: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_weight_lifted'],
      )!,
      totalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_minutes'],
      )!,
      currentStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_streak'],
      )!,
      longestStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}longest_streak'],
      )!,
      totalPRs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_p_rs'],
      )!,
      totalXP: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_x_p'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      lastWorkoutAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_workout_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserStatsTable createAlias(String alias) {
    return $UserStatsTable(attachedDatabase, alias);
  }
}

class UserStat extends DataClass implements Insertable<UserStat> {
  /// UUID primary key (single row per user)
  final String id;

  /// Total workouts completed
  final int totalWorkouts;

  /// Total exercises performed
  final int totalExercises;

  /// Total sets completed
  final int totalSets;

  /// Total reps performed
  final int totalReps;

  /// Total weight lifted (kg)
  final double totalWeightLifted;

  /// Total workout duration (minutes)
  final int totalMinutes;

  /// Current workout streak (consecutive days)
  final int currentStreak;

  /// Longest workout streak
  final int longestStreak;

  /// Total PRs achieved
  final int totalPRs;

  /// Total XP earned
  final int totalXP;

  /// Current level
  final int level;

  /// Last workout date (for streak calculation)
  final DateTime? lastWorkoutAt;

  /// Last modification timestamp
  final DateTime updatedAt;
  const UserStat({
    required this.id,
    required this.totalWorkouts,
    required this.totalExercises,
    required this.totalSets,
    required this.totalReps,
    required this.totalWeightLifted,
    required this.totalMinutes,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalPRs,
    required this.totalXP,
    required this.level,
    this.lastWorkoutAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['total_workouts'] = Variable<int>(totalWorkouts);
    map['total_exercises'] = Variable<int>(totalExercises);
    map['total_sets'] = Variable<int>(totalSets);
    map['total_reps'] = Variable<int>(totalReps);
    map['total_weight_lifted'] = Variable<double>(totalWeightLifted);
    map['total_minutes'] = Variable<int>(totalMinutes);
    map['current_streak'] = Variable<int>(currentStreak);
    map['longest_streak'] = Variable<int>(longestStreak);
    map['total_p_rs'] = Variable<int>(totalPRs);
    map['total_x_p'] = Variable<int>(totalXP);
    map['level'] = Variable<int>(level);
    if (!nullToAbsent || lastWorkoutAt != null) {
      map['last_workout_at'] = Variable<DateTime>(lastWorkoutAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserStatsCompanion toCompanion(bool nullToAbsent) {
    return UserStatsCompanion(
      id: Value(id),
      totalWorkouts: Value(totalWorkouts),
      totalExercises: Value(totalExercises),
      totalSets: Value(totalSets),
      totalReps: Value(totalReps),
      totalWeightLifted: Value(totalWeightLifted),
      totalMinutes: Value(totalMinutes),
      currentStreak: Value(currentStreak),
      longestStreak: Value(longestStreak),
      totalPRs: Value(totalPRs),
      totalXP: Value(totalXP),
      level: Value(level),
      lastWorkoutAt: lastWorkoutAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastWorkoutAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserStat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserStat(
      id: serializer.fromJson<String>(json['id']),
      totalWorkouts: serializer.fromJson<int>(json['totalWorkouts']),
      totalExercises: serializer.fromJson<int>(json['totalExercises']),
      totalSets: serializer.fromJson<int>(json['totalSets']),
      totalReps: serializer.fromJson<int>(json['totalReps']),
      totalWeightLifted: serializer.fromJson<double>(json['totalWeightLifted']),
      totalMinutes: serializer.fromJson<int>(json['totalMinutes']),
      currentStreak: serializer.fromJson<int>(json['currentStreak']),
      longestStreak: serializer.fromJson<int>(json['longestStreak']),
      totalPRs: serializer.fromJson<int>(json['totalPRs']),
      totalXP: serializer.fromJson<int>(json['totalXP']),
      level: serializer.fromJson<int>(json['level']),
      lastWorkoutAt: serializer.fromJson<DateTime?>(json['lastWorkoutAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'totalWorkouts': serializer.toJson<int>(totalWorkouts),
      'totalExercises': serializer.toJson<int>(totalExercises),
      'totalSets': serializer.toJson<int>(totalSets),
      'totalReps': serializer.toJson<int>(totalReps),
      'totalWeightLifted': serializer.toJson<double>(totalWeightLifted),
      'totalMinutes': serializer.toJson<int>(totalMinutes),
      'currentStreak': serializer.toJson<int>(currentStreak),
      'longestStreak': serializer.toJson<int>(longestStreak),
      'totalPRs': serializer.toJson<int>(totalPRs),
      'totalXP': serializer.toJson<int>(totalXP),
      'level': serializer.toJson<int>(level),
      'lastWorkoutAt': serializer.toJson<DateTime?>(lastWorkoutAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserStat copyWith({
    String? id,
    int? totalWorkouts,
    int? totalExercises,
    int? totalSets,
    int? totalReps,
    double? totalWeightLifted,
    int? totalMinutes,
    int? currentStreak,
    int? longestStreak,
    int? totalPRs,
    int? totalXP,
    int? level,
    Value<DateTime?> lastWorkoutAt = const Value.absent(),
    DateTime? updatedAt,
  }) => UserStat(
    id: id ?? this.id,
    totalWorkouts: totalWorkouts ?? this.totalWorkouts,
    totalExercises: totalExercises ?? this.totalExercises,
    totalSets: totalSets ?? this.totalSets,
    totalReps: totalReps ?? this.totalReps,
    totalWeightLifted: totalWeightLifted ?? this.totalWeightLifted,
    totalMinutes: totalMinutes ?? this.totalMinutes,
    currentStreak: currentStreak ?? this.currentStreak,
    longestStreak: longestStreak ?? this.longestStreak,
    totalPRs: totalPRs ?? this.totalPRs,
    totalXP: totalXP ?? this.totalXP,
    level: level ?? this.level,
    lastWorkoutAt: lastWorkoutAt.present
        ? lastWorkoutAt.value
        : this.lastWorkoutAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserStat copyWithCompanion(UserStatsCompanion data) {
    return UserStat(
      id: data.id.present ? data.id.value : this.id,
      totalWorkouts: data.totalWorkouts.present
          ? data.totalWorkouts.value
          : this.totalWorkouts,
      totalExercises: data.totalExercises.present
          ? data.totalExercises.value
          : this.totalExercises,
      totalSets: data.totalSets.present ? data.totalSets.value : this.totalSets,
      totalReps: data.totalReps.present ? data.totalReps.value : this.totalReps,
      totalWeightLifted: data.totalWeightLifted.present
          ? data.totalWeightLifted.value
          : this.totalWeightLifted,
      totalMinutes: data.totalMinutes.present
          ? data.totalMinutes.value
          : this.totalMinutes,
      currentStreak: data.currentStreak.present
          ? data.currentStreak.value
          : this.currentStreak,
      longestStreak: data.longestStreak.present
          ? data.longestStreak.value
          : this.longestStreak,
      totalPRs: data.totalPRs.present ? data.totalPRs.value : this.totalPRs,
      totalXP: data.totalXP.present ? data.totalXP.value : this.totalXP,
      level: data.level.present ? data.level.value : this.level,
      lastWorkoutAt: data.lastWorkoutAt.present
          ? data.lastWorkoutAt.value
          : this.lastWorkoutAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserStat(')
          ..write('id: $id, ')
          ..write('totalWorkouts: $totalWorkouts, ')
          ..write('totalExercises: $totalExercises, ')
          ..write('totalSets: $totalSets, ')
          ..write('totalReps: $totalReps, ')
          ..write('totalWeightLifted: $totalWeightLifted, ')
          ..write('totalMinutes: $totalMinutes, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('totalPRs: $totalPRs, ')
          ..write('totalXP: $totalXP, ')
          ..write('level: $level, ')
          ..write('lastWorkoutAt: $lastWorkoutAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    totalWorkouts,
    totalExercises,
    totalSets,
    totalReps,
    totalWeightLifted,
    totalMinutes,
    currentStreak,
    longestStreak,
    totalPRs,
    totalXP,
    level,
    lastWorkoutAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserStat &&
          other.id == this.id &&
          other.totalWorkouts == this.totalWorkouts &&
          other.totalExercises == this.totalExercises &&
          other.totalSets == this.totalSets &&
          other.totalReps == this.totalReps &&
          other.totalWeightLifted == this.totalWeightLifted &&
          other.totalMinutes == this.totalMinutes &&
          other.currentStreak == this.currentStreak &&
          other.longestStreak == this.longestStreak &&
          other.totalPRs == this.totalPRs &&
          other.totalXP == this.totalXP &&
          other.level == this.level &&
          other.lastWorkoutAt == this.lastWorkoutAt &&
          other.updatedAt == this.updatedAt);
}

class UserStatsCompanion extends UpdateCompanion<UserStat> {
  final Value<String> id;
  final Value<int> totalWorkouts;
  final Value<int> totalExercises;
  final Value<int> totalSets;
  final Value<int> totalReps;
  final Value<double> totalWeightLifted;
  final Value<int> totalMinutes;
  final Value<int> currentStreak;
  final Value<int> longestStreak;
  final Value<int> totalPRs;
  final Value<int> totalXP;
  final Value<int> level;
  final Value<DateTime?> lastWorkoutAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserStatsCompanion({
    this.id = const Value.absent(),
    this.totalWorkouts = const Value.absent(),
    this.totalExercises = const Value.absent(),
    this.totalSets = const Value.absent(),
    this.totalReps = const Value.absent(),
    this.totalWeightLifted = const Value.absent(),
    this.totalMinutes = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.totalPRs = const Value.absent(),
    this.totalXP = const Value.absent(),
    this.level = const Value.absent(),
    this.lastWorkoutAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserStatsCompanion.insert({
    required String id,
    this.totalWorkouts = const Value.absent(),
    this.totalExercises = const Value.absent(),
    this.totalSets = const Value.absent(),
    this.totalReps = const Value.absent(),
    this.totalWeightLifted = const Value.absent(),
    this.totalMinutes = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.totalPRs = const Value.absent(),
    this.totalXP = const Value.absent(),
    this.level = const Value.absent(),
    this.lastWorkoutAt = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt);
  static Insertable<UserStat> custom({
    Expression<String>? id,
    Expression<int>? totalWorkouts,
    Expression<int>? totalExercises,
    Expression<int>? totalSets,
    Expression<int>? totalReps,
    Expression<double>? totalWeightLifted,
    Expression<int>? totalMinutes,
    Expression<int>? currentStreak,
    Expression<int>? longestStreak,
    Expression<int>? totalPRs,
    Expression<int>? totalXP,
    Expression<int>? level,
    Expression<DateTime>? lastWorkoutAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (totalWorkouts != null) 'total_workouts': totalWorkouts,
      if (totalExercises != null) 'total_exercises': totalExercises,
      if (totalSets != null) 'total_sets': totalSets,
      if (totalReps != null) 'total_reps': totalReps,
      if (totalWeightLifted != null) 'total_weight_lifted': totalWeightLifted,
      if (totalMinutes != null) 'total_minutes': totalMinutes,
      if (currentStreak != null) 'current_streak': currentStreak,
      if (longestStreak != null) 'longest_streak': longestStreak,
      if (totalPRs != null) 'total_p_rs': totalPRs,
      if (totalXP != null) 'total_x_p': totalXP,
      if (level != null) 'level': level,
      if (lastWorkoutAt != null) 'last_workout_at': lastWorkoutAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserStatsCompanion copyWith({
    Value<String>? id,
    Value<int>? totalWorkouts,
    Value<int>? totalExercises,
    Value<int>? totalSets,
    Value<int>? totalReps,
    Value<double>? totalWeightLifted,
    Value<int>? totalMinutes,
    Value<int>? currentStreak,
    Value<int>? longestStreak,
    Value<int>? totalPRs,
    Value<int>? totalXP,
    Value<int>? level,
    Value<DateTime?>? lastWorkoutAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserStatsCompanion(
      id: id ?? this.id,
      totalWorkouts: totalWorkouts ?? this.totalWorkouts,
      totalExercises: totalExercises ?? this.totalExercises,
      totalSets: totalSets ?? this.totalSets,
      totalReps: totalReps ?? this.totalReps,
      totalWeightLifted: totalWeightLifted ?? this.totalWeightLifted,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalPRs: totalPRs ?? this.totalPRs,
      totalXP: totalXP ?? this.totalXP,
      level: level ?? this.level,
      lastWorkoutAt: lastWorkoutAt ?? this.lastWorkoutAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (totalWorkouts.present) {
      map['total_workouts'] = Variable<int>(totalWorkouts.value);
    }
    if (totalExercises.present) {
      map['total_exercises'] = Variable<int>(totalExercises.value);
    }
    if (totalSets.present) {
      map['total_sets'] = Variable<int>(totalSets.value);
    }
    if (totalReps.present) {
      map['total_reps'] = Variable<int>(totalReps.value);
    }
    if (totalWeightLifted.present) {
      map['total_weight_lifted'] = Variable<double>(totalWeightLifted.value);
    }
    if (totalMinutes.present) {
      map['total_minutes'] = Variable<int>(totalMinutes.value);
    }
    if (currentStreak.present) {
      map['current_streak'] = Variable<int>(currentStreak.value);
    }
    if (longestStreak.present) {
      map['longest_streak'] = Variable<int>(longestStreak.value);
    }
    if (totalPRs.present) {
      map['total_p_rs'] = Variable<int>(totalPRs.value);
    }
    if (totalXP.present) {
      map['total_x_p'] = Variable<int>(totalXP.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (lastWorkoutAt.present) {
      map['last_workout_at'] = Variable<DateTime>(lastWorkoutAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserStatsCompanion(')
          ..write('id: $id, ')
          ..write('totalWorkouts: $totalWorkouts, ')
          ..write('totalExercises: $totalExercises, ')
          ..write('totalSets: $totalSets, ')
          ..write('totalReps: $totalReps, ')
          ..write('totalWeightLifted: $totalWeightLifted, ')
          ..write('totalMinutes: $totalMinutes, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('totalPRs: $totalPRs, ')
          ..write('totalXP: $totalXP, ')
          ..write('level: $level, ')
          ..write('lastWorkoutAt: $lastWorkoutAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RestTimerSettingsTable extends RestTimerSettings
    with TableInfo<$RestTimerSettingsTable, RestTimerSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RestTimerSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultRestSecondsMeta =
      const VerificationMeta('defaultRestSeconds');
  @override
  late final GeneratedColumn<int> defaultRestSeconds = GeneratedColumn<int>(
    'default_rest_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(90),
  );
  static const VerificationMeta _compoundRestSecondsMeta =
      const VerificationMeta('compoundRestSeconds');
  @override
  late final GeneratedColumn<int> compoundRestSeconds = GeneratedColumn<int>(
    'compound_rest_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(180),
  );
  static const VerificationMeta _isolationRestSecondsMeta =
      const VerificationMeta('isolationRestSeconds');
  @override
  late final GeneratedColumn<int> isolationRestSeconds = GeneratedColumn<int>(
    'isolation_rest_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(60),
  );
  static const VerificationMeta _autoStartTimerMeta = const VerificationMeta(
    'autoStartTimer',
  );
  @override
  late final GeneratedColumn<bool> autoStartTimer = GeneratedColumn<bool>(
    'auto_start_timer',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_start_timer" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _vibrateOnCompleteMeta = const VerificationMeta(
    'vibrateOnComplete',
  );
  @override
  late final GeneratedColumn<bool> vibrateOnComplete = GeneratedColumn<bool>(
    'vibrate_on_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("vibrate_on_complete" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _soundOnCompleteMeta = const VerificationMeta(
    'soundOnComplete',
  );
  @override
  late final GeneratedColumn<bool> soundOnComplete = GeneratedColumn<bool>(
    'sound_on_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sound_on_complete" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _soundNameMeta = const VerificationMeta(
    'soundName',
  );
  @override
  late final GeneratedColumn<String> soundName = GeneratedColumn<String>(
    'sound_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('bell'),
  );
  static const VerificationMeta _showNotificationMeta = const VerificationMeta(
    'showNotification',
  );
  @override
  late final GeneratedColumn<bool> showNotification = GeneratedColumn<bool>(
    'show_notification',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_notification" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    defaultRestSeconds,
    compoundRestSeconds,
    isolationRestSeconds,
    autoStartTimer,
    vibrateOnComplete,
    soundOnComplete,
    soundName,
    showNotification,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rest_timer_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<RestTimerSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('default_rest_seconds')) {
      context.handle(
        _defaultRestSecondsMeta,
        defaultRestSeconds.isAcceptableOrUnknown(
          data['default_rest_seconds']!,
          _defaultRestSecondsMeta,
        ),
      );
    }
    if (data.containsKey('compound_rest_seconds')) {
      context.handle(
        _compoundRestSecondsMeta,
        compoundRestSeconds.isAcceptableOrUnknown(
          data['compound_rest_seconds']!,
          _compoundRestSecondsMeta,
        ),
      );
    }
    if (data.containsKey('isolation_rest_seconds')) {
      context.handle(
        _isolationRestSecondsMeta,
        isolationRestSeconds.isAcceptableOrUnknown(
          data['isolation_rest_seconds']!,
          _isolationRestSecondsMeta,
        ),
      );
    }
    if (data.containsKey('auto_start_timer')) {
      context.handle(
        _autoStartTimerMeta,
        autoStartTimer.isAcceptableOrUnknown(
          data['auto_start_timer']!,
          _autoStartTimerMeta,
        ),
      );
    }
    if (data.containsKey('vibrate_on_complete')) {
      context.handle(
        _vibrateOnCompleteMeta,
        vibrateOnComplete.isAcceptableOrUnknown(
          data['vibrate_on_complete']!,
          _vibrateOnCompleteMeta,
        ),
      );
    }
    if (data.containsKey('sound_on_complete')) {
      context.handle(
        _soundOnCompleteMeta,
        soundOnComplete.isAcceptableOrUnknown(
          data['sound_on_complete']!,
          _soundOnCompleteMeta,
        ),
      );
    }
    if (data.containsKey('sound_name')) {
      context.handle(
        _soundNameMeta,
        soundName.isAcceptableOrUnknown(data['sound_name']!, _soundNameMeta),
      );
    }
    if (data.containsKey('show_notification')) {
      context.handle(
        _showNotificationMeta,
        showNotification.isAcceptableOrUnknown(
          data['show_notification']!,
          _showNotificationMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RestTimerSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RestTimerSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      defaultRestSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_rest_seconds'],
      )!,
      compoundRestSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}compound_rest_seconds'],
      )!,
      isolationRestSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}isolation_rest_seconds'],
      )!,
      autoStartTimer: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_start_timer'],
      )!,
      vibrateOnComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}vibrate_on_complete'],
      )!,
      soundOnComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sound_on_complete'],
      )!,
      soundName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sound_name'],
      )!,
      showNotification: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_notification'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RestTimerSettingsTable createAlias(String alias) {
    return $RestTimerSettingsTable(attachedDatabase, alias);
  }
}

class RestTimerSetting extends DataClass
    implements Insertable<RestTimerSetting> {
  /// UUID primary key (single row per user)
  final String id;

  /// Default rest time in seconds
  final int defaultRestSeconds;

  /// Rest time for compound exercises (seconds)
  final int compoundRestSeconds;

  /// Rest time for isolation exercises (seconds)
  final int isolationRestSeconds;

  /// Whether to auto-start timer after logging a set
  final bool autoStartTimer;

  /// Whether to vibrate when timer completes
  final bool vibrateOnComplete;

  /// Whether to play sound when timer completes
  final bool soundOnComplete;

  /// Sound file name to play
  final String soundName;

  /// Whether to show timer as notification
  final bool showNotification;

  /// Last modification timestamp
  final DateTime updatedAt;
  const RestTimerSetting({
    required this.id,
    required this.defaultRestSeconds,
    required this.compoundRestSeconds,
    required this.isolationRestSeconds,
    required this.autoStartTimer,
    required this.vibrateOnComplete,
    required this.soundOnComplete,
    required this.soundName,
    required this.showNotification,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['default_rest_seconds'] = Variable<int>(defaultRestSeconds);
    map['compound_rest_seconds'] = Variable<int>(compoundRestSeconds);
    map['isolation_rest_seconds'] = Variable<int>(isolationRestSeconds);
    map['auto_start_timer'] = Variable<bool>(autoStartTimer);
    map['vibrate_on_complete'] = Variable<bool>(vibrateOnComplete);
    map['sound_on_complete'] = Variable<bool>(soundOnComplete);
    map['sound_name'] = Variable<String>(soundName);
    map['show_notification'] = Variable<bool>(showNotification);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RestTimerSettingsCompanion toCompanion(bool nullToAbsent) {
    return RestTimerSettingsCompanion(
      id: Value(id),
      defaultRestSeconds: Value(defaultRestSeconds),
      compoundRestSeconds: Value(compoundRestSeconds),
      isolationRestSeconds: Value(isolationRestSeconds),
      autoStartTimer: Value(autoStartTimer),
      vibrateOnComplete: Value(vibrateOnComplete),
      soundOnComplete: Value(soundOnComplete),
      soundName: Value(soundName),
      showNotification: Value(showNotification),
      updatedAt: Value(updatedAt),
    );
  }

  factory RestTimerSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RestTimerSetting(
      id: serializer.fromJson<String>(json['id']),
      defaultRestSeconds: serializer.fromJson<int>(json['defaultRestSeconds']),
      compoundRestSeconds: serializer.fromJson<int>(
        json['compoundRestSeconds'],
      ),
      isolationRestSeconds: serializer.fromJson<int>(
        json['isolationRestSeconds'],
      ),
      autoStartTimer: serializer.fromJson<bool>(json['autoStartTimer']),
      vibrateOnComplete: serializer.fromJson<bool>(json['vibrateOnComplete']),
      soundOnComplete: serializer.fromJson<bool>(json['soundOnComplete']),
      soundName: serializer.fromJson<String>(json['soundName']),
      showNotification: serializer.fromJson<bool>(json['showNotification']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'defaultRestSeconds': serializer.toJson<int>(defaultRestSeconds),
      'compoundRestSeconds': serializer.toJson<int>(compoundRestSeconds),
      'isolationRestSeconds': serializer.toJson<int>(isolationRestSeconds),
      'autoStartTimer': serializer.toJson<bool>(autoStartTimer),
      'vibrateOnComplete': serializer.toJson<bool>(vibrateOnComplete),
      'soundOnComplete': serializer.toJson<bool>(soundOnComplete),
      'soundName': serializer.toJson<String>(soundName),
      'showNotification': serializer.toJson<bool>(showNotification),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RestTimerSetting copyWith({
    String? id,
    int? defaultRestSeconds,
    int? compoundRestSeconds,
    int? isolationRestSeconds,
    bool? autoStartTimer,
    bool? vibrateOnComplete,
    bool? soundOnComplete,
    String? soundName,
    bool? showNotification,
    DateTime? updatedAt,
  }) => RestTimerSetting(
    id: id ?? this.id,
    defaultRestSeconds: defaultRestSeconds ?? this.defaultRestSeconds,
    compoundRestSeconds: compoundRestSeconds ?? this.compoundRestSeconds,
    isolationRestSeconds: isolationRestSeconds ?? this.isolationRestSeconds,
    autoStartTimer: autoStartTimer ?? this.autoStartTimer,
    vibrateOnComplete: vibrateOnComplete ?? this.vibrateOnComplete,
    soundOnComplete: soundOnComplete ?? this.soundOnComplete,
    soundName: soundName ?? this.soundName,
    showNotification: showNotification ?? this.showNotification,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RestTimerSetting copyWithCompanion(RestTimerSettingsCompanion data) {
    return RestTimerSetting(
      id: data.id.present ? data.id.value : this.id,
      defaultRestSeconds: data.defaultRestSeconds.present
          ? data.defaultRestSeconds.value
          : this.defaultRestSeconds,
      compoundRestSeconds: data.compoundRestSeconds.present
          ? data.compoundRestSeconds.value
          : this.compoundRestSeconds,
      isolationRestSeconds: data.isolationRestSeconds.present
          ? data.isolationRestSeconds.value
          : this.isolationRestSeconds,
      autoStartTimer: data.autoStartTimer.present
          ? data.autoStartTimer.value
          : this.autoStartTimer,
      vibrateOnComplete: data.vibrateOnComplete.present
          ? data.vibrateOnComplete.value
          : this.vibrateOnComplete,
      soundOnComplete: data.soundOnComplete.present
          ? data.soundOnComplete.value
          : this.soundOnComplete,
      soundName: data.soundName.present ? data.soundName.value : this.soundName,
      showNotification: data.showNotification.present
          ? data.showNotification.value
          : this.showNotification,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RestTimerSetting(')
          ..write('id: $id, ')
          ..write('defaultRestSeconds: $defaultRestSeconds, ')
          ..write('compoundRestSeconds: $compoundRestSeconds, ')
          ..write('isolationRestSeconds: $isolationRestSeconds, ')
          ..write('autoStartTimer: $autoStartTimer, ')
          ..write('vibrateOnComplete: $vibrateOnComplete, ')
          ..write('soundOnComplete: $soundOnComplete, ')
          ..write('soundName: $soundName, ')
          ..write('showNotification: $showNotification, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    defaultRestSeconds,
    compoundRestSeconds,
    isolationRestSeconds,
    autoStartTimer,
    vibrateOnComplete,
    soundOnComplete,
    soundName,
    showNotification,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RestTimerSetting &&
          other.id == this.id &&
          other.defaultRestSeconds == this.defaultRestSeconds &&
          other.compoundRestSeconds == this.compoundRestSeconds &&
          other.isolationRestSeconds == this.isolationRestSeconds &&
          other.autoStartTimer == this.autoStartTimer &&
          other.vibrateOnComplete == this.vibrateOnComplete &&
          other.soundOnComplete == this.soundOnComplete &&
          other.soundName == this.soundName &&
          other.showNotification == this.showNotification &&
          other.updatedAt == this.updatedAt);
}

class RestTimerSettingsCompanion extends UpdateCompanion<RestTimerSetting> {
  final Value<String> id;
  final Value<int> defaultRestSeconds;
  final Value<int> compoundRestSeconds;
  final Value<int> isolationRestSeconds;
  final Value<bool> autoStartTimer;
  final Value<bool> vibrateOnComplete;
  final Value<bool> soundOnComplete;
  final Value<String> soundName;
  final Value<bool> showNotification;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RestTimerSettingsCompanion({
    this.id = const Value.absent(),
    this.defaultRestSeconds = const Value.absent(),
    this.compoundRestSeconds = const Value.absent(),
    this.isolationRestSeconds = const Value.absent(),
    this.autoStartTimer = const Value.absent(),
    this.vibrateOnComplete = const Value.absent(),
    this.soundOnComplete = const Value.absent(),
    this.soundName = const Value.absent(),
    this.showNotification = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RestTimerSettingsCompanion.insert({
    required String id,
    this.defaultRestSeconds = const Value.absent(),
    this.compoundRestSeconds = const Value.absent(),
    this.isolationRestSeconds = const Value.absent(),
    this.autoStartTimer = const Value.absent(),
    this.vibrateOnComplete = const Value.absent(),
    this.soundOnComplete = const Value.absent(),
    this.soundName = const Value.absent(),
    this.showNotification = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt);
  static Insertable<RestTimerSetting> custom({
    Expression<String>? id,
    Expression<int>? defaultRestSeconds,
    Expression<int>? compoundRestSeconds,
    Expression<int>? isolationRestSeconds,
    Expression<bool>? autoStartTimer,
    Expression<bool>? vibrateOnComplete,
    Expression<bool>? soundOnComplete,
    Expression<String>? soundName,
    Expression<bool>? showNotification,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (defaultRestSeconds != null)
        'default_rest_seconds': defaultRestSeconds,
      if (compoundRestSeconds != null)
        'compound_rest_seconds': compoundRestSeconds,
      if (isolationRestSeconds != null)
        'isolation_rest_seconds': isolationRestSeconds,
      if (autoStartTimer != null) 'auto_start_timer': autoStartTimer,
      if (vibrateOnComplete != null) 'vibrate_on_complete': vibrateOnComplete,
      if (soundOnComplete != null) 'sound_on_complete': soundOnComplete,
      if (soundName != null) 'sound_name': soundName,
      if (showNotification != null) 'show_notification': showNotification,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RestTimerSettingsCompanion copyWith({
    Value<String>? id,
    Value<int>? defaultRestSeconds,
    Value<int>? compoundRestSeconds,
    Value<int>? isolationRestSeconds,
    Value<bool>? autoStartTimer,
    Value<bool>? vibrateOnComplete,
    Value<bool>? soundOnComplete,
    Value<String>? soundName,
    Value<bool>? showNotification,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RestTimerSettingsCompanion(
      id: id ?? this.id,
      defaultRestSeconds: defaultRestSeconds ?? this.defaultRestSeconds,
      compoundRestSeconds: compoundRestSeconds ?? this.compoundRestSeconds,
      isolationRestSeconds: isolationRestSeconds ?? this.isolationRestSeconds,
      autoStartTimer: autoStartTimer ?? this.autoStartTimer,
      vibrateOnComplete: vibrateOnComplete ?? this.vibrateOnComplete,
      soundOnComplete: soundOnComplete ?? this.soundOnComplete,
      soundName: soundName ?? this.soundName,
      showNotification: showNotification ?? this.showNotification,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (defaultRestSeconds.present) {
      map['default_rest_seconds'] = Variable<int>(defaultRestSeconds.value);
    }
    if (compoundRestSeconds.present) {
      map['compound_rest_seconds'] = Variable<int>(compoundRestSeconds.value);
    }
    if (isolationRestSeconds.present) {
      map['isolation_rest_seconds'] = Variable<int>(isolationRestSeconds.value);
    }
    if (autoStartTimer.present) {
      map['auto_start_timer'] = Variable<bool>(autoStartTimer.value);
    }
    if (vibrateOnComplete.present) {
      map['vibrate_on_complete'] = Variable<bool>(vibrateOnComplete.value);
    }
    if (soundOnComplete.present) {
      map['sound_on_complete'] = Variable<bool>(soundOnComplete.value);
    }
    if (soundName.present) {
      map['sound_name'] = Variable<String>(soundName.value);
    }
    if (showNotification.present) {
      map['show_notification'] = Variable<bool>(showNotification.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RestTimerSettingsCompanion(')
          ..write('id: $id, ')
          ..write('defaultRestSeconds: $defaultRestSeconds, ')
          ..write('compoundRestSeconds: $compoundRestSeconds, ')
          ..write('isolationRestSeconds: $isolationRestSeconds, ')
          ..write('autoStartTimer: $autoStartTimer, ')
          ..write('vibrateOnComplete: $vibrateOnComplete, ')
          ..write('soundOnComplete: $soundOnComplete, ')
          ..write('soundName: $soundName, ')
          ..write('showNotification: $showNotification, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExerciseRestTimesTable extends ExerciseRestTimes
    with TableInfo<$ExerciseRestTimesTable, ExerciseRestTime> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseRestTimesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _restSecondsMeta = const VerificationMeta(
    'restSeconds',
  );
  @override
  late final GeneratedColumn<int> restSeconds = GeneratedColumn<int>(
    'rest_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    exerciseId,
    restSeconds,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_rest_times';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseRestTime> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('rest_seconds')) {
      context.handle(
        _restSecondsMeta,
        restSeconds.isAcceptableOrUnknown(
          data['rest_seconds']!,
          _restSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_restSecondsMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseRestTime map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseRestTime(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      restSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_seconds'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ExerciseRestTimesTable createAlias(String alias) {
    return $ExerciseRestTimesTable(attachedDatabase, alias);
  }
}

class ExerciseRestTime extends DataClass
    implements Insertable<ExerciseRestTime> {
  /// UUID primary key
  final String id;

  /// Reference to the exercise
  final String exerciseId;

  /// Custom rest time in seconds
  final int restSeconds;

  /// Last modification timestamp
  final DateTime updatedAt;
  const ExerciseRestTime({
    required this.id,
    required this.exerciseId,
    required this.restSeconds,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['rest_seconds'] = Variable<int>(restSeconds);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ExerciseRestTimesCompanion toCompanion(bool nullToAbsent) {
    return ExerciseRestTimesCompanion(
      id: Value(id),
      exerciseId: Value(exerciseId),
      restSeconds: Value(restSeconds),
      updatedAt: Value(updatedAt),
    );
  }

  factory ExerciseRestTime.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseRestTime(
      id: serializer.fromJson<String>(json['id']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      restSeconds: serializer.fromJson<int>(json['restSeconds']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'restSeconds': serializer.toJson<int>(restSeconds),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ExerciseRestTime copyWith({
    String? id,
    String? exerciseId,
    int? restSeconds,
    DateTime? updatedAt,
  }) => ExerciseRestTime(
    id: id ?? this.id,
    exerciseId: exerciseId ?? this.exerciseId,
    restSeconds: restSeconds ?? this.restSeconds,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ExerciseRestTime copyWithCompanion(ExerciseRestTimesCompanion data) {
    return ExerciseRestTime(
      id: data.id.present ? data.id.value : this.id,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      restSeconds: data.restSeconds.present
          ? data.restSeconds.value
          : this.restSeconds,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseRestTime(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, exerciseId, restSeconds, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseRestTime &&
          other.id == this.id &&
          other.exerciseId == this.exerciseId &&
          other.restSeconds == this.restSeconds &&
          other.updatedAt == this.updatedAt);
}

class ExerciseRestTimesCompanion extends UpdateCompanion<ExerciseRestTime> {
  final Value<String> id;
  final Value<String> exerciseId;
  final Value<int> restSeconds;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ExerciseRestTimesCompanion({
    this.id = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExerciseRestTimesCompanion.insert({
    required String id,
    required String exerciseId,
    required int restSeconds,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       exerciseId = Value(exerciseId),
       restSeconds = Value(restSeconds),
       updatedAt = Value(updatedAt);
  static Insertable<ExerciseRestTime> custom({
    Expression<String>? id,
    Expression<String>? exerciseId,
    Expression<int>? restSeconds,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (restSeconds != null) 'rest_seconds': restSeconds,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExerciseRestTimesCompanion copyWith({
    Value<String>? id,
    Value<String>? exerciseId,
    Value<int>? restSeconds,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ExerciseRestTimesCompanion(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      restSeconds: restSeconds ?? this.restSeconds,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (restSeconds.present) {
      map['rest_seconds'] = Variable<int>(restSeconds.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseRestTimesCompanion(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $WorkoutsTable workouts = $WorkoutsTable(this);
  late final $WorkoutExercisesTable workoutExercises = $WorkoutExercisesTable(
    this,
  );
  late final $ExerciseSetsTable exerciseSets = $ExerciseSetsTable(this);
  late final $PersonalRecordsTable personalRecords = $PersonalRecordsTable(
    this,
  );
  late final $UsersTable users = $UsersTable(this);
  late final $WorkoutTemplatesTable workoutTemplates = $WorkoutTemplatesTable(
    this,
  );
  late final $TemplateExercisesTable templateExercises =
      $TemplateExercisesTable(this);
  late final $BodyMeasurementsTable bodyMeasurements = $BodyMeasurementsTable(
    this,
  );
  late final $AchievementsTable achievements = $AchievementsTable(this);
  late final $UserAchievementsTable userAchievements = $UserAchievementsTable(
    this,
  );
  late final $UserStatsTable userStats = $UserStatsTable(this);
  late final $RestTimerSettingsTable restTimerSettings =
      $RestTimerSettingsTable(this);
  late final $ExerciseRestTimesTable exerciseRestTimes =
      $ExerciseRestTimesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    exercises,
    workouts,
    workoutExercises,
    exerciseSets,
    personalRecords,
    users,
    workoutTemplates,
    templateExercises,
    bodyMeasurements,
    achievements,
    userAchievements,
    userStats,
    restTimerSettings,
    exerciseRestTimes,
  ];
}

typedef $$ExercisesTableCreateCompanionBuilder =
    ExercisesCompanion Function({
      required String id,
      required String name,
      required String muscleGroup,
      Value<String?> description,
      Value<bool> isPredefined,
      required DateTime updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });
typedef $$ExercisesTableUpdateCompanionBuilder =
    ExercisesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> muscleGroup,
      Value<String?> description,
      Value<bool> isPredefined,
      Value<DateTime> updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPredefined => $composableBuilder(
    column: $table.isPredefined,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPredefined => $composableBuilder(
    column: $table.isPredefined,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPredefined => $composableBuilder(
    column: $table.isPredefined,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$ExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExercisesTable,
          Exercise,
          $$ExercisesTableFilterComposer,
          $$ExercisesTableOrderingComposer,
          $$ExercisesTableAnnotationComposer,
          $$ExercisesTableCreateCompanionBuilder,
          $$ExercisesTableUpdateCompanionBuilder,
          (Exercise, BaseReferences<_$AppDatabase, $ExercisesTable, Exercise>),
          Exercise,
          PrefetchHooks Function()
        > {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> muscleGroup = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isPredefined = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisesCompanion(
                id: id,
                name: name,
                muscleGroup: muscleGroup,
                description: description,
                isPredefined: isPredefined,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String muscleGroup,
                Value<String?> description = const Value.absent(),
                Value<bool> isPredefined = const Value.absent(),
                required DateTime updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisesCompanion.insert(
                id: id,
                name: name,
                muscleGroup: muscleGroup,
                description: description,
                isPredefined: isPredefined,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExercisesTable,
      Exercise,
      $$ExercisesTableFilterComposer,
      $$ExercisesTableOrderingComposer,
      $$ExercisesTableAnnotationComposer,
      $$ExercisesTableCreateCompanionBuilder,
      $$ExercisesTableUpdateCompanionBuilder,
      (Exercise, BaseReferences<_$AppDatabase, $ExercisesTable, Exercise>),
      Exercise,
      PrefetchHooks Function()
    >;
typedef $$WorkoutsTableCreateCompanionBuilder =
    WorkoutsCompanion Function({
      required String id,
      Value<String?> name,
      required DateTime startedAt,
      Value<DateTime?> completedAt,
      Value<String?> notes,
      required DateTime updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });
typedef $$WorkoutsTableUpdateCompanionBuilder =
    WorkoutsCompanion Function({
      Value<String> id,
      Value<String?> name,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
      Value<String?> notes,
      Value<DateTime> updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });

class $$WorkoutsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkoutsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$WorkoutsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutsTable,
          Workout,
          $$WorkoutsTableFilterComposer,
          $$WorkoutsTableOrderingComposer,
          $$WorkoutsTableAnnotationComposer,
          $$WorkoutsTableCreateCompanionBuilder,
          $$WorkoutsTableUpdateCompanionBuilder,
          (Workout, BaseReferences<_$AppDatabase, $WorkoutsTable, Workout>),
          Workout,
          PrefetchHooks Function()
        > {
  $$WorkoutsTableTableManager(_$AppDatabase db, $WorkoutsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutsCompanion(
                id: id,
                name: name,
                startedAt: startedAt,
                completedAt: completedAt,
                notes: notes,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> name = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutsCompanion.insert(
                id: id,
                name: name,
                startedAt: startedAt,
                completedAt: completedAt,
                notes: notes,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkoutsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutsTable,
      Workout,
      $$WorkoutsTableFilterComposer,
      $$WorkoutsTableOrderingComposer,
      $$WorkoutsTableAnnotationComposer,
      $$WorkoutsTableCreateCompanionBuilder,
      $$WorkoutsTableUpdateCompanionBuilder,
      (Workout, BaseReferences<_$AppDatabase, $WorkoutsTable, Workout>),
      Workout,
      PrefetchHooks Function()
    >;
typedef $$WorkoutExercisesTableCreateCompanionBuilder =
    WorkoutExercisesCompanion Function({
      required String id,
      required String workoutId,
      required String exerciseId,
      required int orderIndex,
      Value<String?> notes,
      required DateTime updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });
typedef $$WorkoutExercisesTableUpdateCompanionBuilder =
    WorkoutExercisesCompanion Function({
      Value<String> id,
      Value<String> workoutId,
      Value<String> exerciseId,
      Value<int> orderIndex,
      Value<String?> notes,
      Value<DateTime> updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });

class $$WorkoutExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workoutId => $composableBuilder(
    column: $table.workoutId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkoutExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workoutId => $composableBuilder(
    column: $table.workoutId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workoutId =>
      $composableBuilder(column: $table.workoutId, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$WorkoutExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutExercisesTable,
          WorkoutExercise,
          $$WorkoutExercisesTableFilterComposer,
          $$WorkoutExercisesTableOrderingComposer,
          $$WorkoutExercisesTableAnnotationComposer,
          $$WorkoutExercisesTableCreateCompanionBuilder,
          $$WorkoutExercisesTableUpdateCompanionBuilder,
          (
            WorkoutExercise,
            BaseReferences<
              _$AppDatabase,
              $WorkoutExercisesTable,
              WorkoutExercise
            >,
          ),
          WorkoutExercise,
          PrefetchHooks Function()
        > {
  $$WorkoutExercisesTableTableManager(
    _$AppDatabase db,
    $WorkoutExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workoutId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutExercisesCompanion(
                id: id,
                workoutId: workoutId,
                exerciseId: exerciseId,
                orderIndex: orderIndex,
                notes: notes,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workoutId,
                required String exerciseId,
                required int orderIndex,
                Value<String?> notes = const Value.absent(),
                required DateTime updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutExercisesCompanion.insert(
                id: id,
                workoutId: workoutId,
                exerciseId: exerciseId,
                orderIndex: orderIndex,
                notes: notes,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkoutExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutExercisesTable,
      WorkoutExercise,
      $$WorkoutExercisesTableFilterComposer,
      $$WorkoutExercisesTableOrderingComposer,
      $$WorkoutExercisesTableAnnotationComposer,
      $$WorkoutExercisesTableCreateCompanionBuilder,
      $$WorkoutExercisesTableUpdateCompanionBuilder,
      (
        WorkoutExercise,
        BaseReferences<_$AppDatabase, $WorkoutExercisesTable, WorkoutExercise>,
      ),
      WorkoutExercise,
      PrefetchHooks Function()
    >;
typedef $$ExerciseSetsTableCreateCompanionBuilder =
    ExerciseSetsCompanion Function({
      required String id,
      required String workoutExerciseId,
      required int setNumber,
      required int reps,
      required double weight,
      Value<String?> notes,
      Value<bool> completed,
      required DateTime updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });
typedef $$ExerciseSetsTableUpdateCompanionBuilder =
    ExerciseSetsCompanion Function({
      Value<String> id,
      Value<String> workoutExerciseId,
      Value<int> setNumber,
      Value<int> reps,
      Value<double> weight,
      Value<String?> notes,
      Value<bool> completed,
      Value<DateTime> updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });

class $$ExerciseSetsTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseSetsTable> {
  $$ExerciseSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workoutExerciseId => $composableBuilder(
    column: $table.workoutExerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExerciseSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseSetsTable> {
  $$ExerciseSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workoutExerciseId => $composableBuilder(
    column: $table.workoutExerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExerciseSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseSetsTable> {
  $$ExerciseSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workoutExerciseId => $composableBuilder(
    column: $table.workoutExerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get setNumber =>
      $composableBuilder(column: $table.setNumber, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$ExerciseSetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExerciseSetsTable,
          ExerciseSet,
          $$ExerciseSetsTableFilterComposer,
          $$ExerciseSetsTableOrderingComposer,
          $$ExerciseSetsTableAnnotationComposer,
          $$ExerciseSetsTableCreateCompanionBuilder,
          $$ExerciseSetsTableUpdateCompanionBuilder,
          (
            ExerciseSet,
            BaseReferences<_$AppDatabase, $ExerciseSetsTable, ExerciseSet>,
          ),
          ExerciseSet,
          PrefetchHooks Function()
        > {
  $$ExerciseSetsTableTableManager(_$AppDatabase db, $ExerciseSetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workoutExerciseId = const Value.absent(),
                Value<int> setNumber = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciseSetsCompanion(
                id: id,
                workoutExerciseId: workoutExerciseId,
                setNumber: setNumber,
                reps: reps,
                weight: weight,
                notes: notes,
                completed: completed,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workoutExerciseId,
                required int setNumber,
                required int reps,
                required double weight,
                Value<String?> notes = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                required DateTime updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciseSetsCompanion.insert(
                id: id,
                workoutExerciseId: workoutExerciseId,
                setNumber: setNumber,
                reps: reps,
                weight: weight,
                notes: notes,
                completed: completed,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExerciseSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExerciseSetsTable,
      ExerciseSet,
      $$ExerciseSetsTableFilterComposer,
      $$ExerciseSetsTableOrderingComposer,
      $$ExerciseSetsTableAnnotationComposer,
      $$ExerciseSetsTableCreateCompanionBuilder,
      $$ExerciseSetsTableUpdateCompanionBuilder,
      (
        ExerciseSet,
        BaseReferences<_$AppDatabase, $ExerciseSetsTable, ExerciseSet>,
      ),
      ExerciseSet,
      PrefetchHooks Function()
    >;
typedef $$PersonalRecordsTableCreateCompanionBuilder =
    PersonalRecordsCompanion Function({
      required String id,
      required String exerciseId,
      required String prType,
      required double value,
      Value<double?> atWeight,
      required String workoutId,
      Value<String?> setId,
      required DateTime achievedAt,
      Value<double?> previousValue,
      required DateTime updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });
typedef $$PersonalRecordsTableUpdateCompanionBuilder =
    PersonalRecordsCompanion Function({
      Value<String> id,
      Value<String> exerciseId,
      Value<String> prType,
      Value<double> value,
      Value<double?> atWeight,
      Value<String> workoutId,
      Value<String?> setId,
      Value<DateTime> achievedAt,
      Value<double?> previousValue,
      Value<DateTime> updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });

class $$PersonalRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $PersonalRecordsTable> {
  $$PersonalRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prType => $composableBuilder(
    column: $table.prType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get atWeight => $composableBuilder(
    column: $table.atWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workoutId => $composableBuilder(
    column: $table.workoutId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setId => $composableBuilder(
    column: $table.setId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get previousValue => $composableBuilder(
    column: $table.previousValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PersonalRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonalRecordsTable> {
  $$PersonalRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prType => $composableBuilder(
    column: $table.prType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get atWeight => $composableBuilder(
    column: $table.atWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workoutId => $composableBuilder(
    column: $table.workoutId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setId => $composableBuilder(
    column: $table.setId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get previousValue => $composableBuilder(
    column: $table.previousValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PersonalRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonalRecordsTable> {
  $$PersonalRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get prType =>
      $composableBuilder(column: $table.prType, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<double> get atWeight =>
      $composableBuilder(column: $table.atWeight, builder: (column) => column);

  GeneratedColumn<String> get workoutId =>
      $composableBuilder(column: $table.workoutId, builder: (column) => column);

  GeneratedColumn<String> get setId =>
      $composableBuilder(column: $table.setId, builder: (column) => column);

  GeneratedColumn<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get previousValue => $composableBuilder(
    column: $table.previousValue,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$PersonalRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersonalRecordsTable,
          PersonalRecord,
          $$PersonalRecordsTableFilterComposer,
          $$PersonalRecordsTableOrderingComposer,
          $$PersonalRecordsTableAnnotationComposer,
          $$PersonalRecordsTableCreateCompanionBuilder,
          $$PersonalRecordsTableUpdateCompanionBuilder,
          (
            PersonalRecord,
            BaseReferences<
              _$AppDatabase,
              $PersonalRecordsTable,
              PersonalRecord
            >,
          ),
          PersonalRecord,
          PrefetchHooks Function()
        > {
  $$PersonalRecordsTableTableManager(
    _$AppDatabase db,
    $PersonalRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonalRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonalRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonalRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<String> prType = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<double?> atWeight = const Value.absent(),
                Value<String> workoutId = const Value.absent(),
                Value<String?> setId = const Value.absent(),
                Value<DateTime> achievedAt = const Value.absent(),
                Value<double?> previousValue = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PersonalRecordsCompanion(
                id: id,
                exerciseId: exerciseId,
                prType: prType,
                value: value,
                atWeight: atWeight,
                workoutId: workoutId,
                setId: setId,
                achievedAt: achievedAt,
                previousValue: previousValue,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String exerciseId,
                required String prType,
                required double value,
                Value<double?> atWeight = const Value.absent(),
                required String workoutId,
                Value<String?> setId = const Value.absent(),
                required DateTime achievedAt,
                Value<double?> previousValue = const Value.absent(),
                required DateTime updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PersonalRecordsCompanion.insert(
                id: id,
                exerciseId: exerciseId,
                prType: prType,
                value: value,
                atWeight: atWeight,
                workoutId: workoutId,
                setId: setId,
                achievedAt: achievedAt,
                previousValue: previousValue,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PersonalRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersonalRecordsTable,
      PersonalRecord,
      $$PersonalRecordsTableFilterComposer,
      $$PersonalRecordsTableOrderingComposer,
      $$PersonalRecordsTableAnnotationComposer,
      $$PersonalRecordsTableCreateCompanionBuilder,
      $$PersonalRecordsTableUpdateCompanionBuilder,
      (
        PersonalRecord,
        BaseReferences<_$AppDatabase, $PersonalRecordsTable, PersonalRecord>,
      ),
      PersonalRecord,
      PrefetchHooks Function()
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      required String email,
      Value<String?> displayName,
      Value<String?> accessToken,
      Value<String?> refreshToken,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String> email,
      Value<String?> displayName,
      Value<String?> accessToken,
      Value<String?> refreshToken,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accessToken => $composableBuilder(
    column: $table.accessToken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get refreshToken => $composableBuilder(
    column: $table.refreshToken,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> accessToken = const Value.absent(),
                Value<String?> refreshToken = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                email: email,
                displayName: displayName,
                accessToken: accessToken,
                refreshToken: refreshToken,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String email,
                Value<String?> displayName = const Value.absent(),
                Value<String?> accessToken = const Value.absent(),
                Value<String?> refreshToken = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                email: email,
                displayName: displayName,
                accessToken: accessToken,
                refreshToken: refreshToken,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$WorkoutTemplatesTableCreateCompanionBuilder =
    WorkoutTemplatesCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      Value<String> color,
      Value<String> iconName,
      Value<int?> estimatedMinutes,
      Value<int> usageCount,
      Value<DateTime?> lastUsedAt,
      Value<int> sortOrder,
      Value<bool> isPredefined,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });
typedef $$WorkoutTemplatesTableUpdateCompanionBuilder =
    WorkoutTemplatesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<String> color,
      Value<String> iconName,
      Value<int?> estimatedMinutes,
      Value<int> usageCount,
      Value<DateTime?> lastUsedAt,
      Value<int> sortOrder,
      Value<bool> isPredefined,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });

final class $$WorkoutTemplatesTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkoutTemplatesTable, WorkoutTemplate> {
  $$WorkoutTemplatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$TemplateExercisesTable, List<TemplateExercise>>
  _templateExercisesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.templateExercises,
        aliasName: $_aliasNameGenerator(
          db.workoutTemplates.id,
          db.templateExercises.templateId,
        ),
      );

  $$TemplateExercisesTableProcessedTableManager get templateExercisesRefs {
    final manager = $$TemplateExercisesTableTableManager(
      $_db,
      $_db.templateExercises,
    ).filter((f) => f.templateId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _templateExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutTemplatesTable> {
  $$WorkoutTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPredefined => $composableBuilder(
    column: $table.isPredefined,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> templateExercisesRefs(
    Expression<bool> Function($$TemplateExercisesTableFilterComposer f) f,
  ) {
    final $$TemplateExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.templateExercises,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplateExercisesTableFilterComposer(
            $db: $db,
            $table: $db.templateExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutTemplatesTable> {
  $$WorkoutTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPredefined => $composableBuilder(
    column: $table.isPredefined,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutTemplatesTable> {
  $$WorkoutTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isPredefined => $composableBuilder(
    column: $table.isPredefined,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  Expression<T> templateExercisesRefs<T extends Object>(
    Expression<T> Function($$TemplateExercisesTableAnnotationComposer a) f,
  ) {
    final $$TemplateExercisesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.templateExercises,
          getReferencedColumn: (t) => t.templateId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TemplateExercisesTableAnnotationComposer(
                $db: $db,
                $table: $db.templateExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutTemplatesTable,
          WorkoutTemplate,
          $$WorkoutTemplatesTableFilterComposer,
          $$WorkoutTemplatesTableOrderingComposer,
          $$WorkoutTemplatesTableAnnotationComposer,
          $$WorkoutTemplatesTableCreateCompanionBuilder,
          $$WorkoutTemplatesTableUpdateCompanionBuilder,
          (WorkoutTemplate, $$WorkoutTemplatesTableReferences),
          WorkoutTemplate,
          PrefetchHooks Function({bool templateExercisesRefs})
        > {
  $$WorkoutTemplatesTableTableManager(
    _$AppDatabase db,
    $WorkoutTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String> iconName = const Value.absent(),
                Value<int?> estimatedMinutes = const Value.absent(),
                Value<int> usageCount = const Value.absent(),
                Value<DateTime?> lastUsedAt = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isPredefined = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutTemplatesCompanion(
                id: id,
                name: name,
                description: description,
                color: color,
                iconName: iconName,
                estimatedMinutes: estimatedMinutes,
                usageCount: usageCount,
                lastUsedAt: lastUsedAt,
                sortOrder: sortOrder,
                isPredefined: isPredefined,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String> iconName = const Value.absent(),
                Value<int?> estimatedMinutes = const Value.absent(),
                Value<int> usageCount = const Value.absent(),
                Value<DateTime?> lastUsedAt = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isPredefined = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutTemplatesCompanion.insert(
                id: id,
                name: name,
                description: description,
                color: color,
                iconName: iconName,
                estimatedMinutes: estimatedMinutes,
                usageCount: usageCount,
                lastUsedAt: lastUsedAt,
                sortOrder: sortOrder,
                isPredefined: isPredefined,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutTemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({templateExercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (templateExercisesRefs) db.templateExercises,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (templateExercisesRefs)
                    await $_getPrefetchedData<
                      WorkoutTemplate,
                      $WorkoutTemplatesTable,
                      TemplateExercise
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutTemplatesTableReferences
                          ._templateExercisesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WorkoutTemplatesTableReferences(
                            db,
                            table,
                            p0,
                          ).templateExercisesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.templateId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutTemplatesTable,
      WorkoutTemplate,
      $$WorkoutTemplatesTableFilterComposer,
      $$WorkoutTemplatesTableOrderingComposer,
      $$WorkoutTemplatesTableAnnotationComposer,
      $$WorkoutTemplatesTableCreateCompanionBuilder,
      $$WorkoutTemplatesTableUpdateCompanionBuilder,
      (WorkoutTemplate, $$WorkoutTemplatesTableReferences),
      WorkoutTemplate,
      PrefetchHooks Function({bool templateExercisesRefs})
    >;
typedef $$TemplateExercisesTableCreateCompanionBuilder =
    TemplateExercisesCompanion Function({
      required String id,
      required String templateId,
      required String exerciseId,
      required int sortOrder,
      Value<int> defaultSets,
      Value<int?> defaultReps,
      Value<double?> defaultWeight,
      Value<int> defaultRestSeconds,
      Value<String?> notes,
      Value<int?> supersetGroup,
      required DateTime updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });
typedef $$TemplateExercisesTableUpdateCompanionBuilder =
    TemplateExercisesCompanion Function({
      Value<String> id,
      Value<String> templateId,
      Value<String> exerciseId,
      Value<int> sortOrder,
      Value<int> defaultSets,
      Value<int?> defaultReps,
      Value<double?> defaultWeight,
      Value<int> defaultRestSeconds,
      Value<String?> notes,
      Value<int?> supersetGroup,
      Value<DateTime> updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });

final class $$TemplateExercisesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TemplateExercisesTable,
          TemplateExercise
        > {
  $$TemplateExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutTemplatesTable _templateIdTable(_$AppDatabase db) =>
      db.workoutTemplates.createAlias(
        $_aliasNameGenerator(
          db.templateExercises.templateId,
          db.workoutTemplates.id,
        ),
      );

  $$WorkoutTemplatesTableProcessedTableManager get templateId {
    final $_column = $_itemColumn<String>('template_id')!;

    final manager = $$WorkoutTemplatesTableTableManager(
      $_db,
      $_db.workoutTemplates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TemplateExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $TemplateExercisesTable> {
  $$TemplateExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultSets => $composableBuilder(
    column: $table.defaultSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultReps => $composableBuilder(
    column: $table.defaultReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get defaultWeight => $composableBuilder(
    column: $table.defaultWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultRestSeconds => $composableBuilder(
    column: $table.defaultRestSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get supersetGroup => $composableBuilder(
    column: $table.supersetGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutTemplatesTableFilterComposer get templateId {
    final $$WorkoutTemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.workoutTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutTemplatesTableFilterComposer(
            $db: $db,
            $table: $db.workoutTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TemplateExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $TemplateExercisesTable> {
  $$TemplateExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultSets => $composableBuilder(
    column: $table.defaultSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultReps => $composableBuilder(
    column: $table.defaultReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get defaultWeight => $composableBuilder(
    column: $table.defaultWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultRestSeconds => $composableBuilder(
    column: $table.defaultRestSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get supersetGroup => $composableBuilder(
    column: $table.supersetGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutTemplatesTableOrderingComposer get templateId {
    final $$WorkoutTemplatesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.workoutTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutTemplatesTableOrderingComposer(
            $db: $db,
            $table: $db.workoutTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TemplateExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TemplateExercisesTable> {
  $$TemplateExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get defaultSets => $composableBuilder(
    column: $table.defaultSets,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultReps => $composableBuilder(
    column: $table.defaultReps,
    builder: (column) => column,
  );

  GeneratedColumn<double> get defaultWeight => $composableBuilder(
    column: $table.defaultWeight,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultRestSeconds => $composableBuilder(
    column: $table.defaultRestSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get supersetGroup => $composableBuilder(
    column: $table.supersetGroup,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  $$WorkoutTemplatesTableAnnotationComposer get templateId {
    final $$WorkoutTemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.workoutTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutTemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TemplateExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TemplateExercisesTable,
          TemplateExercise,
          $$TemplateExercisesTableFilterComposer,
          $$TemplateExercisesTableOrderingComposer,
          $$TemplateExercisesTableAnnotationComposer,
          $$TemplateExercisesTableCreateCompanionBuilder,
          $$TemplateExercisesTableUpdateCompanionBuilder,
          (TemplateExercise, $$TemplateExercisesTableReferences),
          TemplateExercise,
          PrefetchHooks Function({bool templateId})
        > {
  $$TemplateExercisesTableTableManager(
    _$AppDatabase db,
    $TemplateExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TemplateExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TemplateExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TemplateExercisesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> templateId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> defaultSets = const Value.absent(),
                Value<int?> defaultReps = const Value.absent(),
                Value<double?> defaultWeight = const Value.absent(),
                Value<int> defaultRestSeconds = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> supersetGroup = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TemplateExercisesCompanion(
                id: id,
                templateId: templateId,
                exerciseId: exerciseId,
                sortOrder: sortOrder,
                defaultSets: defaultSets,
                defaultReps: defaultReps,
                defaultWeight: defaultWeight,
                defaultRestSeconds: defaultRestSeconds,
                notes: notes,
                supersetGroup: supersetGroup,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String templateId,
                required String exerciseId,
                required int sortOrder,
                Value<int> defaultSets = const Value.absent(),
                Value<int?> defaultReps = const Value.absent(),
                Value<double?> defaultWeight = const Value.absent(),
                Value<int> defaultRestSeconds = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> supersetGroup = const Value.absent(),
                required DateTime updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TemplateExercisesCompanion.insert(
                id: id,
                templateId: templateId,
                exerciseId: exerciseId,
                sortOrder: sortOrder,
                defaultSets: defaultSets,
                defaultReps: defaultReps,
                defaultWeight: defaultWeight,
                defaultRestSeconds: defaultRestSeconds,
                notes: notes,
                supersetGroup: supersetGroup,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TemplateExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({templateId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (templateId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.templateId,
                                referencedTable:
                                    $$TemplateExercisesTableReferences
                                        ._templateIdTable(db),
                                referencedColumn:
                                    $$TemplateExercisesTableReferences
                                        ._templateIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TemplateExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TemplateExercisesTable,
      TemplateExercise,
      $$TemplateExercisesTableFilterComposer,
      $$TemplateExercisesTableOrderingComposer,
      $$TemplateExercisesTableAnnotationComposer,
      $$TemplateExercisesTableCreateCompanionBuilder,
      $$TemplateExercisesTableUpdateCompanionBuilder,
      (TemplateExercise, $$TemplateExercisesTableReferences),
      TemplateExercise,
      PrefetchHooks Function({bool templateId})
    >;
typedef $$BodyMeasurementsTableCreateCompanionBuilder =
    BodyMeasurementsCompanion Function({
      required String id,
      required DateTime measuredAt,
      Value<double?> weightKg,
      Value<double?> bodyFatPercent,
      Value<double?> muscleMassKg,
      Value<double?> neckCm,
      Value<double?> shouldersCm,
      Value<double?> chestCm,
      Value<double?> leftBicepCm,
      Value<double?> rightBicepCm,
      Value<double?> leftForearmCm,
      Value<double?> rightForearmCm,
      Value<double?> waistCm,
      Value<double?> hipsCm,
      Value<double?> leftThighCm,
      Value<double?> rightThighCm,
      Value<double?> leftCalfCm,
      Value<double?> rightCalfCm,
      Value<String?> notes,
      Value<String?> photoPath,
      required DateTime updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });
typedef $$BodyMeasurementsTableUpdateCompanionBuilder =
    BodyMeasurementsCompanion Function({
      Value<String> id,
      Value<DateTime> measuredAt,
      Value<double?> weightKg,
      Value<double?> bodyFatPercent,
      Value<double?> muscleMassKg,
      Value<double?> neckCm,
      Value<double?> shouldersCm,
      Value<double?> chestCm,
      Value<double?> leftBicepCm,
      Value<double?> rightBicepCm,
      Value<double?> leftForearmCm,
      Value<double?> rightForearmCm,
      Value<double?> waistCm,
      Value<double?> hipsCm,
      Value<double?> leftThighCm,
      Value<double?> rightThighCm,
      Value<double?> leftCalfCm,
      Value<double?> rightCalfCm,
      Value<String?> notes,
      Value<String?> photoPath,
      Value<DateTime> updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });

class $$BodyMeasurementsTableFilterComposer
    extends Composer<_$AppDatabase, $BodyMeasurementsTable> {
  $$BodyMeasurementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bodyFatPercent => $composableBuilder(
    column: $table.bodyFatPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get muscleMassKg => $composableBuilder(
    column: $table.muscleMassKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get neckCm => $composableBuilder(
    column: $table.neckCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get shouldersCm => $composableBuilder(
    column: $table.shouldersCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get chestCm => $composableBuilder(
    column: $table.chestCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get leftBicepCm => $composableBuilder(
    column: $table.leftBicepCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rightBicepCm => $composableBuilder(
    column: $table.rightBicepCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get leftForearmCm => $composableBuilder(
    column: $table.leftForearmCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rightForearmCm => $composableBuilder(
    column: $table.rightForearmCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get waistCm => $composableBuilder(
    column: $table.waistCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hipsCm => $composableBuilder(
    column: $table.hipsCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get leftThighCm => $composableBuilder(
    column: $table.leftThighCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rightThighCm => $composableBuilder(
    column: $table.rightThighCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get leftCalfCm => $composableBuilder(
    column: $table.leftCalfCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rightCalfCm => $composableBuilder(
    column: $table.rightCalfCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BodyMeasurementsTableOrderingComposer
    extends Composer<_$AppDatabase, $BodyMeasurementsTable> {
  $$BodyMeasurementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bodyFatPercent => $composableBuilder(
    column: $table.bodyFatPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get muscleMassKg => $composableBuilder(
    column: $table.muscleMassKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get neckCm => $composableBuilder(
    column: $table.neckCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get shouldersCm => $composableBuilder(
    column: $table.shouldersCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get chestCm => $composableBuilder(
    column: $table.chestCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get leftBicepCm => $composableBuilder(
    column: $table.leftBicepCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rightBicepCm => $composableBuilder(
    column: $table.rightBicepCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get leftForearmCm => $composableBuilder(
    column: $table.leftForearmCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rightForearmCm => $composableBuilder(
    column: $table.rightForearmCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get waistCm => $composableBuilder(
    column: $table.waistCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hipsCm => $composableBuilder(
    column: $table.hipsCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get leftThighCm => $composableBuilder(
    column: $table.leftThighCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rightThighCm => $composableBuilder(
    column: $table.rightThighCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get leftCalfCm => $composableBuilder(
    column: $table.leftCalfCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rightCalfCm => $composableBuilder(
    column: $table.rightCalfCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BodyMeasurementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BodyMeasurementsTable> {
  $$BodyMeasurementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get bodyFatPercent => $composableBuilder(
    column: $table.bodyFatPercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get muscleMassKg => $composableBuilder(
    column: $table.muscleMassKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get neckCm =>
      $composableBuilder(column: $table.neckCm, builder: (column) => column);

  GeneratedColumn<double> get shouldersCm => $composableBuilder(
    column: $table.shouldersCm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get chestCm =>
      $composableBuilder(column: $table.chestCm, builder: (column) => column);

  GeneratedColumn<double> get leftBicepCm => $composableBuilder(
    column: $table.leftBicepCm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rightBicepCm => $composableBuilder(
    column: $table.rightBicepCm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get leftForearmCm => $composableBuilder(
    column: $table.leftForearmCm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rightForearmCm => $composableBuilder(
    column: $table.rightForearmCm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get waistCm =>
      $composableBuilder(column: $table.waistCm, builder: (column) => column);

  GeneratedColumn<double> get hipsCm =>
      $composableBuilder(column: $table.hipsCm, builder: (column) => column);

  GeneratedColumn<double> get leftThighCm => $composableBuilder(
    column: $table.leftThighCm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rightThighCm => $composableBuilder(
    column: $table.rightThighCm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get leftCalfCm => $composableBuilder(
    column: $table.leftCalfCm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rightCalfCm => $composableBuilder(
    column: $table.rightCalfCm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$BodyMeasurementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BodyMeasurementsTable,
          BodyMeasurement,
          $$BodyMeasurementsTableFilterComposer,
          $$BodyMeasurementsTableOrderingComposer,
          $$BodyMeasurementsTableAnnotationComposer,
          $$BodyMeasurementsTableCreateCompanionBuilder,
          $$BodyMeasurementsTableUpdateCompanionBuilder,
          (
            BodyMeasurement,
            BaseReferences<
              _$AppDatabase,
              $BodyMeasurementsTable,
              BodyMeasurement
            >,
          ),
          BodyMeasurement,
          PrefetchHooks Function()
        > {
  $$BodyMeasurementsTableTableManager(
    _$AppDatabase db,
    $BodyMeasurementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BodyMeasurementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BodyMeasurementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BodyMeasurementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> measuredAt = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<double?> bodyFatPercent = const Value.absent(),
                Value<double?> muscleMassKg = const Value.absent(),
                Value<double?> neckCm = const Value.absent(),
                Value<double?> shouldersCm = const Value.absent(),
                Value<double?> chestCm = const Value.absent(),
                Value<double?> leftBicepCm = const Value.absent(),
                Value<double?> rightBicepCm = const Value.absent(),
                Value<double?> leftForearmCm = const Value.absent(),
                Value<double?> rightForearmCm = const Value.absent(),
                Value<double?> waistCm = const Value.absent(),
                Value<double?> hipsCm = const Value.absent(),
                Value<double?> leftThighCm = const Value.absent(),
                Value<double?> rightThighCm = const Value.absent(),
                Value<double?> leftCalfCm = const Value.absent(),
                Value<double?> rightCalfCm = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BodyMeasurementsCompanion(
                id: id,
                measuredAt: measuredAt,
                weightKg: weightKg,
                bodyFatPercent: bodyFatPercent,
                muscleMassKg: muscleMassKg,
                neckCm: neckCm,
                shouldersCm: shouldersCm,
                chestCm: chestCm,
                leftBicepCm: leftBicepCm,
                rightBicepCm: rightBicepCm,
                leftForearmCm: leftForearmCm,
                rightForearmCm: rightForearmCm,
                waistCm: waistCm,
                hipsCm: hipsCm,
                leftThighCm: leftThighCm,
                rightThighCm: rightThighCm,
                leftCalfCm: leftCalfCm,
                rightCalfCm: rightCalfCm,
                notes: notes,
                photoPath: photoPath,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime measuredAt,
                Value<double?> weightKg = const Value.absent(),
                Value<double?> bodyFatPercent = const Value.absent(),
                Value<double?> muscleMassKg = const Value.absent(),
                Value<double?> neckCm = const Value.absent(),
                Value<double?> shouldersCm = const Value.absent(),
                Value<double?> chestCm = const Value.absent(),
                Value<double?> leftBicepCm = const Value.absent(),
                Value<double?> rightBicepCm = const Value.absent(),
                Value<double?> leftForearmCm = const Value.absent(),
                Value<double?> rightForearmCm = const Value.absent(),
                Value<double?> waistCm = const Value.absent(),
                Value<double?> hipsCm = const Value.absent(),
                Value<double?> leftThighCm = const Value.absent(),
                Value<double?> rightThighCm = const Value.absent(),
                Value<double?> leftCalfCm = const Value.absent(),
                Value<double?> rightCalfCm = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                required DateTime updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BodyMeasurementsCompanion.insert(
                id: id,
                measuredAt: measuredAt,
                weightKg: weightKg,
                bodyFatPercent: bodyFatPercent,
                muscleMassKg: muscleMassKg,
                neckCm: neckCm,
                shouldersCm: shouldersCm,
                chestCm: chestCm,
                leftBicepCm: leftBicepCm,
                rightBicepCm: rightBicepCm,
                leftForearmCm: leftForearmCm,
                rightForearmCm: rightForearmCm,
                waistCm: waistCm,
                hipsCm: hipsCm,
                leftThighCm: leftThighCm,
                rightThighCm: rightThighCm,
                leftCalfCm: leftCalfCm,
                rightCalfCm: rightCalfCm,
                notes: notes,
                photoPath: photoPath,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BodyMeasurementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BodyMeasurementsTable,
      BodyMeasurement,
      $$BodyMeasurementsTableFilterComposer,
      $$BodyMeasurementsTableOrderingComposer,
      $$BodyMeasurementsTableAnnotationComposer,
      $$BodyMeasurementsTableCreateCompanionBuilder,
      $$BodyMeasurementsTableUpdateCompanionBuilder,
      (
        BodyMeasurement,
        BaseReferences<_$AppDatabase, $BodyMeasurementsTable, BodyMeasurement>,
      ),
      BodyMeasurement,
      PrefetchHooks Function()
    >;
typedef $$AchievementsTableCreateCompanionBuilder =
    AchievementsCompanion Function({
      required String id,
      required String name,
      required String description,
      required String iconName,
      required String color,
      required String category,
      required String tier,
      required int requirementValue,
      required String requirementType,
      Value<int> xpReward,
      Value<int> sortOrder,
      Value<bool> isPredefined,
      Value<int> rowid,
    });
typedef $$AchievementsTableUpdateCompanionBuilder =
    AchievementsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> description,
      Value<String> iconName,
      Value<String> color,
      Value<String> category,
      Value<String> tier,
      Value<int> requirementValue,
      Value<String> requirementType,
      Value<int> xpReward,
      Value<int> sortOrder,
      Value<bool> isPredefined,
      Value<int> rowid,
    });

final class $$AchievementsTableReferences
    extends BaseReferences<_$AppDatabase, $AchievementsTable, Achievement> {
  $$AchievementsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UserAchievementsTable, List<UserAchievement>>
  _userAchievementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userAchievements,
    aliasName: $_aliasNameGenerator(
      db.achievements.id,
      db.userAchievements.achievementId,
    ),
  );

  $$UserAchievementsTableProcessedTableManager get userAchievementsRefs {
    final manager = $$UserAchievementsTableTableManager(
      $_db,
      $_db.userAchievements,
    ).filter((f) => f.achievementId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _userAchievementsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AchievementsTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get requirementValue => $composableBuilder(
    column: $table.requirementValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requirementType => $composableBuilder(
    column: $table.requirementType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xpReward => $composableBuilder(
    column: $table.xpReward,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPredefined => $composableBuilder(
    column: $table.isPredefined,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> userAchievementsRefs(
    Expression<bool> Function($$UserAchievementsTableFilterComposer f) f,
  ) {
    final $$UserAchievementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userAchievements,
      getReferencedColumn: (t) => t.achievementId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserAchievementsTableFilterComposer(
            $db: $db,
            $table: $db.userAchievements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AchievementsTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get requirementValue => $composableBuilder(
    column: $table.requirementValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requirementType => $composableBuilder(
    column: $table.requirementType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xpReward => $composableBuilder(
    column: $table.xpReward,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPredefined => $composableBuilder(
    column: $table.isPredefined,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AchievementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get tier =>
      $composableBuilder(column: $table.tier, builder: (column) => column);

  GeneratedColumn<int> get requirementValue => $composableBuilder(
    column: $table.requirementValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get requirementType => $composableBuilder(
    column: $table.requirementType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get xpReward =>
      $composableBuilder(column: $table.xpReward, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isPredefined => $composableBuilder(
    column: $table.isPredefined,
    builder: (column) => column,
  );

  Expression<T> userAchievementsRefs<T extends Object>(
    Expression<T> Function($$UserAchievementsTableAnnotationComposer a) f,
  ) {
    final $$UserAchievementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userAchievements,
      getReferencedColumn: (t) => t.achievementId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserAchievementsTableAnnotationComposer(
            $db: $db,
            $table: $db.userAchievements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AchievementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AchievementsTable,
          Achievement,
          $$AchievementsTableFilterComposer,
          $$AchievementsTableOrderingComposer,
          $$AchievementsTableAnnotationComposer,
          $$AchievementsTableCreateCompanionBuilder,
          $$AchievementsTableUpdateCompanionBuilder,
          (Achievement, $$AchievementsTableReferences),
          Achievement,
          PrefetchHooks Function({bool userAchievementsRefs})
        > {
  $$AchievementsTableTableManager(_$AppDatabase db, $AchievementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> iconName = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> tier = const Value.absent(),
                Value<int> requirementValue = const Value.absent(),
                Value<String> requirementType = const Value.absent(),
                Value<int> xpReward = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isPredefined = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AchievementsCompanion(
                id: id,
                name: name,
                description: description,
                iconName: iconName,
                color: color,
                category: category,
                tier: tier,
                requirementValue: requirementValue,
                requirementType: requirementType,
                xpReward: xpReward,
                sortOrder: sortOrder,
                isPredefined: isPredefined,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String description,
                required String iconName,
                required String color,
                required String category,
                required String tier,
                required int requirementValue,
                required String requirementType,
                Value<int> xpReward = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isPredefined = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AchievementsCompanion.insert(
                id: id,
                name: name,
                description: description,
                iconName: iconName,
                color: color,
                category: category,
                tier: tier,
                requirementValue: requirementValue,
                requirementType: requirementType,
                xpReward: xpReward,
                sortOrder: sortOrder,
                isPredefined: isPredefined,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AchievementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userAchievementsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (userAchievementsRefs) db.userAchievements,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (userAchievementsRefs)
                    await $_getPrefetchedData<
                      Achievement,
                      $AchievementsTable,
                      UserAchievement
                    >(
                      currentTable: table,
                      referencedTable: $$AchievementsTableReferences
                          ._userAchievementsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$AchievementsTableReferences(
                            db,
                            table,
                            p0,
                          ).userAchievementsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.achievementId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AchievementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AchievementsTable,
      Achievement,
      $$AchievementsTableFilterComposer,
      $$AchievementsTableOrderingComposer,
      $$AchievementsTableAnnotationComposer,
      $$AchievementsTableCreateCompanionBuilder,
      $$AchievementsTableUpdateCompanionBuilder,
      (Achievement, $$AchievementsTableReferences),
      Achievement,
      PrefetchHooks Function({bool userAchievementsRefs})
    >;
typedef $$UserAchievementsTableCreateCompanionBuilder =
    UserAchievementsCompanion Function({
      required String id,
      required String achievementId,
      Value<int> currentProgress,
      Value<bool> isUnlocked,
      Value<DateTime?> unlockedAt,
      Value<bool> isSeen,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$UserAchievementsTableUpdateCompanionBuilder =
    UserAchievementsCompanion Function({
      Value<String> id,
      Value<String> achievementId,
      Value<int> currentProgress,
      Value<bool> isUnlocked,
      Value<DateTime?> unlockedAt,
      Value<bool> isSeen,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$UserAchievementsTableReferences
    extends
        BaseReferences<_$AppDatabase, $UserAchievementsTable, UserAchievement> {
  $$UserAchievementsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AchievementsTable _achievementIdTable(_$AppDatabase db) =>
      db.achievements.createAlias(
        $_aliasNameGenerator(
          db.userAchievements.achievementId,
          db.achievements.id,
        ),
      );

  $$AchievementsTableProcessedTableManager get achievementId {
    final $_column = $_itemColumn<String>('achievement_id')!;

    final manager = $$AchievementsTableTableManager(
      $_db,
      $_db.achievements,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_achievementIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UserAchievementsTableFilterComposer
    extends Composer<_$AppDatabase, $UserAchievementsTable> {
  $$UserAchievementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentProgress => $composableBuilder(
    column: $table.currentProgress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isUnlocked => $composableBuilder(
    column: $table.isUnlocked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSeen => $composableBuilder(
    column: $table.isSeen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AchievementsTableFilterComposer get achievementId {
    final $$AchievementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.achievementId,
      referencedTable: $db.achievements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AchievementsTableFilterComposer(
            $db: $db,
            $table: $db.achievements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserAchievementsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserAchievementsTable> {
  $$UserAchievementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentProgress => $composableBuilder(
    column: $table.currentProgress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isUnlocked => $composableBuilder(
    column: $table.isUnlocked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSeen => $composableBuilder(
    column: $table.isSeen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AchievementsTableOrderingComposer get achievementId {
    final $$AchievementsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.achievementId,
      referencedTable: $db.achievements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AchievementsTableOrderingComposer(
            $db: $db,
            $table: $db.achievements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserAchievementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserAchievementsTable> {
  $$UserAchievementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get currentProgress => $composableBuilder(
    column: $table.currentProgress,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isUnlocked => $composableBuilder(
    column: $table.isUnlocked,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSeen =>
      $composableBuilder(column: $table.isSeen, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$AchievementsTableAnnotationComposer get achievementId {
    final $$AchievementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.achievementId,
      referencedTable: $db.achievements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AchievementsTableAnnotationComposer(
            $db: $db,
            $table: $db.achievements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserAchievementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserAchievementsTable,
          UserAchievement,
          $$UserAchievementsTableFilterComposer,
          $$UserAchievementsTableOrderingComposer,
          $$UserAchievementsTableAnnotationComposer,
          $$UserAchievementsTableCreateCompanionBuilder,
          $$UserAchievementsTableUpdateCompanionBuilder,
          (UserAchievement, $$UserAchievementsTableReferences),
          UserAchievement,
          PrefetchHooks Function({bool achievementId})
        > {
  $$UserAchievementsTableTableManager(
    _$AppDatabase db,
    $UserAchievementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserAchievementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserAchievementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserAchievementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> achievementId = const Value.absent(),
                Value<int> currentProgress = const Value.absent(),
                Value<bool> isUnlocked = const Value.absent(),
                Value<DateTime?> unlockedAt = const Value.absent(),
                Value<bool> isSeen = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserAchievementsCompanion(
                id: id,
                achievementId: achievementId,
                currentProgress: currentProgress,
                isUnlocked: isUnlocked,
                unlockedAt: unlockedAt,
                isSeen: isSeen,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String achievementId,
                Value<int> currentProgress = const Value.absent(),
                Value<bool> isUnlocked = const Value.absent(),
                Value<DateTime?> unlockedAt = const Value.absent(),
                Value<bool> isSeen = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserAchievementsCompanion.insert(
                id: id,
                achievementId: achievementId,
                currentProgress: currentProgress,
                isUnlocked: isUnlocked,
                unlockedAt: unlockedAt,
                isSeen: isSeen,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserAchievementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({achievementId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (achievementId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.achievementId,
                                referencedTable:
                                    $$UserAchievementsTableReferences
                                        ._achievementIdTable(db),
                                referencedColumn:
                                    $$UserAchievementsTableReferences
                                        ._achievementIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UserAchievementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserAchievementsTable,
      UserAchievement,
      $$UserAchievementsTableFilterComposer,
      $$UserAchievementsTableOrderingComposer,
      $$UserAchievementsTableAnnotationComposer,
      $$UserAchievementsTableCreateCompanionBuilder,
      $$UserAchievementsTableUpdateCompanionBuilder,
      (UserAchievement, $$UserAchievementsTableReferences),
      UserAchievement,
      PrefetchHooks Function({bool achievementId})
    >;
typedef $$UserStatsTableCreateCompanionBuilder =
    UserStatsCompanion Function({
      required String id,
      Value<int> totalWorkouts,
      Value<int> totalExercises,
      Value<int> totalSets,
      Value<int> totalReps,
      Value<double> totalWeightLifted,
      Value<int> totalMinutes,
      Value<int> currentStreak,
      Value<int> longestStreak,
      Value<int> totalPRs,
      Value<int> totalXP,
      Value<int> level,
      Value<DateTime?> lastWorkoutAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$UserStatsTableUpdateCompanionBuilder =
    UserStatsCompanion Function({
      Value<String> id,
      Value<int> totalWorkouts,
      Value<int> totalExercises,
      Value<int> totalSets,
      Value<int> totalReps,
      Value<double> totalWeightLifted,
      Value<int> totalMinutes,
      Value<int> currentStreak,
      Value<int> longestStreak,
      Value<int> totalPRs,
      Value<int> totalXP,
      Value<int> level,
      Value<DateTime?> lastWorkoutAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UserStatsTableFilterComposer
    extends Composer<_$AppDatabase, $UserStatsTable> {
  $$UserStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalWorkouts => $composableBuilder(
    column: $table.totalWorkouts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalExercises => $composableBuilder(
    column: $table.totalExercises,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalSets => $composableBuilder(
    column: $table.totalSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalReps => $composableBuilder(
    column: $table.totalReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalWeightLifted => $composableBuilder(
    column: $table.totalWeightLifted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalMinutes => $composableBuilder(
    column: $table.totalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPRs => $composableBuilder(
    column: $table.totalPRs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalXP => $composableBuilder(
    column: $table.totalXP,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastWorkoutAt => $composableBuilder(
    column: $table.lastWorkoutAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserStatsTable> {
  $$UserStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalWorkouts => $composableBuilder(
    column: $table.totalWorkouts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalExercises => $composableBuilder(
    column: $table.totalExercises,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalSets => $composableBuilder(
    column: $table.totalSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalReps => $composableBuilder(
    column: $table.totalReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalWeightLifted => $composableBuilder(
    column: $table.totalWeightLifted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalMinutes => $composableBuilder(
    column: $table.totalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPRs => $composableBuilder(
    column: $table.totalPRs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalXP => $composableBuilder(
    column: $table.totalXP,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastWorkoutAt => $composableBuilder(
    column: $table.lastWorkoutAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserStatsTable> {
  $$UserStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get totalWorkouts => $composableBuilder(
    column: $table.totalWorkouts,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalExercises => $composableBuilder(
    column: $table.totalExercises,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalSets =>
      $composableBuilder(column: $table.totalSets, builder: (column) => column);

  GeneratedColumn<int> get totalReps =>
      $composableBuilder(column: $table.totalReps, builder: (column) => column);

  GeneratedColumn<double> get totalWeightLifted => $composableBuilder(
    column: $table.totalWeightLifted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalMinutes => $composableBuilder(
    column: $table.totalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalPRs =>
      $composableBuilder(column: $table.totalPRs, builder: (column) => column);

  GeneratedColumn<int> get totalXP =>
      $composableBuilder(column: $table.totalXP, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<DateTime> get lastWorkoutAt => $composableBuilder(
    column: $table.lastWorkoutAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserStatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserStatsTable,
          UserStat,
          $$UserStatsTableFilterComposer,
          $$UserStatsTableOrderingComposer,
          $$UserStatsTableAnnotationComposer,
          $$UserStatsTableCreateCompanionBuilder,
          $$UserStatsTableUpdateCompanionBuilder,
          (UserStat, BaseReferences<_$AppDatabase, $UserStatsTable, UserStat>),
          UserStat,
          PrefetchHooks Function()
        > {
  $$UserStatsTableTableManager(_$AppDatabase db, $UserStatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> totalWorkouts = const Value.absent(),
                Value<int> totalExercises = const Value.absent(),
                Value<int> totalSets = const Value.absent(),
                Value<int> totalReps = const Value.absent(),
                Value<double> totalWeightLifted = const Value.absent(),
                Value<int> totalMinutes = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<int> longestStreak = const Value.absent(),
                Value<int> totalPRs = const Value.absent(),
                Value<int> totalXP = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<DateTime?> lastWorkoutAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserStatsCompanion(
                id: id,
                totalWorkouts: totalWorkouts,
                totalExercises: totalExercises,
                totalSets: totalSets,
                totalReps: totalReps,
                totalWeightLifted: totalWeightLifted,
                totalMinutes: totalMinutes,
                currentStreak: currentStreak,
                longestStreak: longestStreak,
                totalPRs: totalPRs,
                totalXP: totalXP,
                level: level,
                lastWorkoutAt: lastWorkoutAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<int> totalWorkouts = const Value.absent(),
                Value<int> totalExercises = const Value.absent(),
                Value<int> totalSets = const Value.absent(),
                Value<int> totalReps = const Value.absent(),
                Value<double> totalWeightLifted = const Value.absent(),
                Value<int> totalMinutes = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<int> longestStreak = const Value.absent(),
                Value<int> totalPRs = const Value.absent(),
                Value<int> totalXP = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<DateTime?> lastWorkoutAt = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserStatsCompanion.insert(
                id: id,
                totalWorkouts: totalWorkouts,
                totalExercises: totalExercises,
                totalSets: totalSets,
                totalReps: totalReps,
                totalWeightLifted: totalWeightLifted,
                totalMinutes: totalMinutes,
                currentStreak: currentStreak,
                longestStreak: longestStreak,
                totalPRs: totalPRs,
                totalXP: totalXP,
                level: level,
                lastWorkoutAt: lastWorkoutAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserStatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserStatsTable,
      UserStat,
      $$UserStatsTableFilterComposer,
      $$UserStatsTableOrderingComposer,
      $$UserStatsTableAnnotationComposer,
      $$UserStatsTableCreateCompanionBuilder,
      $$UserStatsTableUpdateCompanionBuilder,
      (UserStat, BaseReferences<_$AppDatabase, $UserStatsTable, UserStat>),
      UserStat,
      PrefetchHooks Function()
    >;
typedef $$RestTimerSettingsTableCreateCompanionBuilder =
    RestTimerSettingsCompanion Function({
      required String id,
      Value<int> defaultRestSeconds,
      Value<int> compoundRestSeconds,
      Value<int> isolationRestSeconds,
      Value<bool> autoStartTimer,
      Value<bool> vibrateOnComplete,
      Value<bool> soundOnComplete,
      Value<String> soundName,
      Value<bool> showNotification,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RestTimerSettingsTableUpdateCompanionBuilder =
    RestTimerSettingsCompanion Function({
      Value<String> id,
      Value<int> defaultRestSeconds,
      Value<int> compoundRestSeconds,
      Value<int> isolationRestSeconds,
      Value<bool> autoStartTimer,
      Value<bool> vibrateOnComplete,
      Value<bool> soundOnComplete,
      Value<String> soundName,
      Value<bool> showNotification,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$RestTimerSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $RestTimerSettingsTable> {
  $$RestTimerSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultRestSeconds => $composableBuilder(
    column: $table.defaultRestSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get compoundRestSeconds => $composableBuilder(
    column: $table.compoundRestSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isolationRestSeconds => $composableBuilder(
    column: $table.isolationRestSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoStartTimer => $composableBuilder(
    column: $table.autoStartTimer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get vibrateOnComplete => $composableBuilder(
    column: $table.vibrateOnComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get soundOnComplete => $composableBuilder(
    column: $table.soundOnComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get soundName => $composableBuilder(
    column: $table.soundName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showNotification => $composableBuilder(
    column: $table.showNotification,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RestTimerSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $RestTimerSettingsTable> {
  $$RestTimerSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultRestSeconds => $composableBuilder(
    column: $table.defaultRestSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get compoundRestSeconds => $composableBuilder(
    column: $table.compoundRestSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isolationRestSeconds => $composableBuilder(
    column: $table.isolationRestSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoStartTimer => $composableBuilder(
    column: $table.autoStartTimer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get vibrateOnComplete => $composableBuilder(
    column: $table.vibrateOnComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get soundOnComplete => $composableBuilder(
    column: $table.soundOnComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get soundName => $composableBuilder(
    column: $table.soundName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showNotification => $composableBuilder(
    column: $table.showNotification,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RestTimerSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RestTimerSettingsTable> {
  $$RestTimerSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get defaultRestSeconds => $composableBuilder(
    column: $table.defaultRestSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get compoundRestSeconds => $composableBuilder(
    column: $table.compoundRestSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isolationRestSeconds => $composableBuilder(
    column: $table.isolationRestSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoStartTimer => $composableBuilder(
    column: $table.autoStartTimer,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get vibrateOnComplete => $composableBuilder(
    column: $table.vibrateOnComplete,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get soundOnComplete => $composableBuilder(
    column: $table.soundOnComplete,
    builder: (column) => column,
  );

  GeneratedColumn<String> get soundName =>
      $composableBuilder(column: $table.soundName, builder: (column) => column);

  GeneratedColumn<bool> get showNotification => $composableBuilder(
    column: $table.showNotification,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RestTimerSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RestTimerSettingsTable,
          RestTimerSetting,
          $$RestTimerSettingsTableFilterComposer,
          $$RestTimerSettingsTableOrderingComposer,
          $$RestTimerSettingsTableAnnotationComposer,
          $$RestTimerSettingsTableCreateCompanionBuilder,
          $$RestTimerSettingsTableUpdateCompanionBuilder,
          (
            RestTimerSetting,
            BaseReferences<
              _$AppDatabase,
              $RestTimerSettingsTable,
              RestTimerSetting
            >,
          ),
          RestTimerSetting,
          PrefetchHooks Function()
        > {
  $$RestTimerSettingsTableTableManager(
    _$AppDatabase db,
    $RestTimerSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RestTimerSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RestTimerSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RestTimerSettingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> defaultRestSeconds = const Value.absent(),
                Value<int> compoundRestSeconds = const Value.absent(),
                Value<int> isolationRestSeconds = const Value.absent(),
                Value<bool> autoStartTimer = const Value.absent(),
                Value<bool> vibrateOnComplete = const Value.absent(),
                Value<bool> soundOnComplete = const Value.absent(),
                Value<String> soundName = const Value.absent(),
                Value<bool> showNotification = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RestTimerSettingsCompanion(
                id: id,
                defaultRestSeconds: defaultRestSeconds,
                compoundRestSeconds: compoundRestSeconds,
                isolationRestSeconds: isolationRestSeconds,
                autoStartTimer: autoStartTimer,
                vibrateOnComplete: vibrateOnComplete,
                soundOnComplete: soundOnComplete,
                soundName: soundName,
                showNotification: showNotification,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<int> defaultRestSeconds = const Value.absent(),
                Value<int> compoundRestSeconds = const Value.absent(),
                Value<int> isolationRestSeconds = const Value.absent(),
                Value<bool> autoStartTimer = const Value.absent(),
                Value<bool> vibrateOnComplete = const Value.absent(),
                Value<bool> soundOnComplete = const Value.absent(),
                Value<String> soundName = const Value.absent(),
                Value<bool> showNotification = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RestTimerSettingsCompanion.insert(
                id: id,
                defaultRestSeconds: defaultRestSeconds,
                compoundRestSeconds: compoundRestSeconds,
                isolationRestSeconds: isolationRestSeconds,
                autoStartTimer: autoStartTimer,
                vibrateOnComplete: vibrateOnComplete,
                soundOnComplete: soundOnComplete,
                soundName: soundName,
                showNotification: showNotification,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RestTimerSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RestTimerSettingsTable,
      RestTimerSetting,
      $$RestTimerSettingsTableFilterComposer,
      $$RestTimerSettingsTableOrderingComposer,
      $$RestTimerSettingsTableAnnotationComposer,
      $$RestTimerSettingsTableCreateCompanionBuilder,
      $$RestTimerSettingsTableUpdateCompanionBuilder,
      (
        RestTimerSetting,
        BaseReferences<
          _$AppDatabase,
          $RestTimerSettingsTable,
          RestTimerSetting
        >,
      ),
      RestTimerSetting,
      PrefetchHooks Function()
    >;
typedef $$ExerciseRestTimesTableCreateCompanionBuilder =
    ExerciseRestTimesCompanion Function({
      required String id,
      required String exerciseId,
      required int restSeconds,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ExerciseRestTimesTableUpdateCompanionBuilder =
    ExerciseRestTimesCompanion Function({
      Value<String> id,
      Value<String> exerciseId,
      Value<int> restSeconds,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ExerciseRestTimesTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseRestTimesTable> {
  $$ExerciseRestTimesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExerciseRestTimesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseRestTimesTable> {
  $$ExerciseRestTimesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExerciseRestTimesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseRestTimesTable> {
  $$ExerciseRestTimesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ExerciseRestTimesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExerciseRestTimesTable,
          ExerciseRestTime,
          $$ExerciseRestTimesTableFilterComposer,
          $$ExerciseRestTimesTableOrderingComposer,
          $$ExerciseRestTimesTableAnnotationComposer,
          $$ExerciseRestTimesTableCreateCompanionBuilder,
          $$ExerciseRestTimesTableUpdateCompanionBuilder,
          (
            ExerciseRestTime,
            BaseReferences<
              _$AppDatabase,
              $ExerciseRestTimesTable,
              ExerciseRestTime
            >,
          ),
          ExerciseRestTime,
          PrefetchHooks Function()
        > {
  $$ExerciseRestTimesTableTableManager(
    _$AppDatabase db,
    $ExerciseRestTimesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseRestTimesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseRestTimesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseRestTimesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> restSeconds = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciseRestTimesCompanion(
                id: id,
                exerciseId: exerciseId,
                restSeconds: restSeconds,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String exerciseId,
                required int restSeconds,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ExerciseRestTimesCompanion.insert(
                id: id,
                exerciseId: exerciseId,
                restSeconds: restSeconds,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExerciseRestTimesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExerciseRestTimesTable,
      ExerciseRestTime,
      $$ExerciseRestTimesTableFilterComposer,
      $$ExerciseRestTimesTableOrderingComposer,
      $$ExerciseRestTimesTableAnnotationComposer,
      $$ExerciseRestTimesTableCreateCompanionBuilder,
      $$ExerciseRestTimesTableUpdateCompanionBuilder,
      (
        ExerciseRestTime,
        BaseReferences<
          _$AppDatabase,
          $ExerciseRestTimesTable,
          ExerciseRestTime
        >,
      ),
      ExerciseRestTime,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$WorkoutsTableTableManager get workouts =>
      $$WorkoutsTableTableManager(_db, _db.workouts);
  $$WorkoutExercisesTableTableManager get workoutExercises =>
      $$WorkoutExercisesTableTableManager(_db, _db.workoutExercises);
  $$ExerciseSetsTableTableManager get exerciseSets =>
      $$ExerciseSetsTableTableManager(_db, _db.exerciseSets);
  $$PersonalRecordsTableTableManager get personalRecords =>
      $$PersonalRecordsTableTableManager(_db, _db.personalRecords);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$WorkoutTemplatesTableTableManager get workoutTemplates =>
      $$WorkoutTemplatesTableTableManager(_db, _db.workoutTemplates);
  $$TemplateExercisesTableTableManager get templateExercises =>
      $$TemplateExercisesTableTableManager(_db, _db.templateExercises);
  $$BodyMeasurementsTableTableManager get bodyMeasurements =>
      $$BodyMeasurementsTableTableManager(_db, _db.bodyMeasurements);
  $$AchievementsTableTableManager get achievements =>
      $$AchievementsTableTableManager(_db, _db.achievements);
  $$UserAchievementsTableTableManager get userAchievements =>
      $$UserAchievementsTableTableManager(_db, _db.userAchievements);
  $$UserStatsTableTableManager get userStats =>
      $$UserStatsTableTableManager(_db, _db.userStats);
  $$RestTimerSettingsTableTableManager get restTimerSettings =>
      $$RestTimerSettingsTableTableManager(_db, _db.restTimerSettings);
  $$ExerciseRestTimesTableTableManager get exerciseRestTimes =>
      $$ExerciseRestTimesTableTableManager(_db, _db.exerciseRestTimes);
}
