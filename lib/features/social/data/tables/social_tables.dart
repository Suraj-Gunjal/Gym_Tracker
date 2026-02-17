import 'package:drift/drift.dart';

/// Users table for social profiles.
class SocialProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().unique()();
  TextColumn get displayName => text()();
  TextColumn get username => text().unique()();
  TextColumn get bio => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  IntColumn get totalWorkouts => integer().withDefault(const Constant(0))();
  IntColumn get totalPRs => integer().withDefault(const Constant(0))();
  IntColumn get followersCount => integer().withDefault(const Constant(0))();
  IntColumn get followingCount => integer().withDefault(const Constant(0))();
  BoolColumn get isPublic => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Followers table for social connections.
class Followers extends Table {
  TextColumn get id => text()();
  TextColumn get followerId => text()();
  TextColumn get followingId => text()();
  TextColumn get status =>
      text().withDefault(const Constant('pending'))(); // pending, accepted
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Shared workouts table.
class SharedWorkouts extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get workoutId => text()();
  TextColumn get caption => text().nullable()();
  IntColumn get likesCount => integer().withDefault(const Constant(0))();
  IntColumn get commentsCount => integer().withDefault(const Constant(0))();
  TextColumn get visibility => text().withDefault(
    const Constant('public'),
  )(); // public, followers, private
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Workout likes table.
class WorkoutLikes extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get sharedWorkoutId => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Workout comments table.
class WorkoutComments extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get sharedWorkoutId => text()();
  TextColumn get content => text()();
  TextColumn get parentCommentId => text().nullable()();
  IntColumn get likesCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Activity feed table for notifications.
class ActivityFeed extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get actorId => text()();
  TextColumn get type => text()(); // like, comment, follow, pr_beat, badge
  TextColumn get referenceId => text().nullable()();
  TextColumn get referenceType =>
      text().nullable()(); // workout, comment, user, pr
  TextColumn get message => text()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
