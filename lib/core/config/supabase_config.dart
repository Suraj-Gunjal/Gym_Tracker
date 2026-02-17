/// Supabase configuration for Gym Tracker.
///
/// Supabase is a free, open-source Firebase alternative that provides:
/// - PostgreSQL database (500MB free)
/// - Authentication (50K monthly active users free)
/// - Realtime subscriptions
/// - Storage (1GB free)
/// - Edge Functions
///
/// Setup Instructions:
/// 1. Go to https://supabase.com and create a free account
/// 2. Create a new project
/// 3. Copy your project URL and anon key from Settings > API
/// 4. Update the values below or use environment variables
///
/// Alternative Free Database Options:
/// - Neon (https://neon.tech) - Serverless Postgres, great with Prisma
/// - PlanetScale (https://planetscale.com) - MySQL with branching
/// - Firebase (https://firebase.google.com) - NoSQL Firestore
/// - Turso (https://turso.tech) - SQLite at the edge
library;

class SupabaseConfig {
  // Replace with your Supabase project URL
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );

  // Replace with your Supabase anon/public key
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key',
  );

  // Whether Supabase is configured and ready to use
  static bool get isConfigured =>
      supabaseUrl != 'https://your-project.supabase.co' &&
      supabaseAnonKey != 'your-anon-key';

  // Storage bucket names
  static const String avatarsBucket = 'avatars';
  static const String workoutPhotosBucket = 'workout-photos';
  static const String progressPhotosBucket = 'progress-photos';

  // Table names (matching Prisma schema)
  static const String usersTable = 'users';
  static const String workoutsTable = 'workouts';
  static const String exercisesTable = 'exercises';
  static const String personalRecordsTable = 'personal_records';
  static const String workoutExercisesTable = 'workout_exercises';
  static const String exerciseSetsTable = 'exercise_sets';
  static const String achievementsTable = 'achievements';
  static const String userAchievementsTable = 'user_achievements';
  static const String challengesTable = 'challenges';
  static const String bodyMeasurementsTable = 'body_measurements';

  // Realtime channels
  static const String workoutsChannel = 'workouts-changes';
  static const String prsChannel = 'prs-changes';
  static const String achievementsChannel = 'achievements-changes';
}

/// SQL to create Supabase tables (run in Supabase SQL Editor).
/// This mirrors the Prisma schema for seamless sync.
const String supabaseSetupSQL = '''
-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table (extends Supabase auth.users)
CREATE TABLE IF NOT EXISTS public.user_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  display_name TEXT,
  avatar_url TEXT,
  total_workouts INTEGER DEFAULT 0,
  total_xp INTEGER DEFAULT 0,
  level INTEGER DEFAULT 1,
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Exercises table
CREATE TABLE IF NOT EXISTS public.exercises (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  primary_muscle TEXT NOT NULL,
  secondary_muscles TEXT[] DEFAULT '{}',
  is_custom BOOLEAN DEFAULT false,
  is_compound BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Workouts table
CREATE TABLE IF NOT EXISTS public.workouts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
  name TEXT,
  notes TEXT,
  started_at TIMESTAMPTZ NOT NULL,
  completed_at TIMESTAMPTZ,
  duration_minutes INTEGER,
  total_volume REAL DEFAULT 0,
  total_sets INTEGER DEFAULT 0,
  is_completed BOOLEAN DEFAULT false,
  sync_status TEXT DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Workout exercises table
CREATE TABLE IF NOT EXISTS public.workout_exercises (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  workout_id UUID NOT NULL REFERENCES public.workouts(id) ON DELETE CASCADE,
  exercise_id UUID NOT NULL REFERENCES public.exercises(id),
  order_index INTEGER NOT NULL,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Exercise sets table
CREATE TABLE IF NOT EXISTS public.exercise_sets (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  workout_exercise_id UUID NOT NULL REFERENCES public.workout_exercises(id) ON DELETE CASCADE,
  set_number INTEGER NOT NULL,
  weight REAL,
  reps INTEGER,
  rpe REAL,
  is_warmup BOOLEAN DEFAULT false,
  is_dropset BOOLEAN DEFAULT false,
  is_failure BOOLEAN DEFAULT false,
  is_completed BOOLEAN DEFAULT false,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Personal records table
CREATE TABLE IF NOT EXISTS public.personal_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
  exercise_id UUID NOT NULL REFERENCES public.exercises(id),
  weight REAL NOT NULL,
  reps INTEGER NOT NULL,
  one_rm REAL NOT NULL,
  workout_id UUID REFERENCES public.workouts(id),
  achieved_at TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Achievements table
CREATE TABLE IF NOT EXISTS public.achievements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  category TEXT NOT NULL,
  tier TEXT NOT NULL,
  xp_reward INTEGER DEFAULT 100,
  icon_name TEXT,
  requirement_type TEXT NOT NULL,
  requirement_value REAL NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- User achievements table
CREATE TABLE IF NOT EXISTS public.user_achievements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
  achievement_id UUID NOT NULL REFERENCES public.achievements(id),
  progress REAL DEFAULT 0,
  is_unlocked BOOLEAN DEFAULT false,
  unlocked_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Body measurements table
CREATE TABLE IF NOT EXISTS public.body_measurements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  weight_kg REAL,
  body_fat_percentage REAL,
  chest_cm REAL,
  waist_cm REAL,
  hips_cm REAL,
  left_bicep_cm REAL,
  right_bicep_cm REAL,
  left_thigh_cm REAL,
  right_thigh_cm REAL,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Challenges table
CREATE TABLE IF NOT EXISTS public.challenges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  challenge_type TEXT NOT NULL,
  target_value REAL NOT NULL,
  unit TEXT NOT NULL,
  duration_days INTEGER NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  xp_reward INTEGER DEFAULT 100,
  difficulty INTEGER DEFAULT 3,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- User challenge progress table
CREATE TABLE IF NOT EXISTS public.user_challenge_progress (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
  challenge_id UUID NOT NULL REFERENCES public.challenges(id),
  current_value REAL DEFAULT 0,
  is_completed BOOLEAN DEFAULT false,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workout_exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exercise_sets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.personal_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.body_measurements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_challenge_progress ENABLE ROW LEVEL SECURITY;

-- RLS Policies (users can only access their own data)
CREATE POLICY "Users can view own profile" ON public.user_profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.user_profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can view own workouts" ON public.workouts
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users can view own exercises" ON public.exercises
  FOR ALL USING (auth.uid() = user_id OR user_id IS NULL);

CREATE POLICY "Users can view own PRs" ON public.personal_records
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users can view own measurements" ON public.body_measurements
  FOR ALL USING (auth.uid() = user_id);

-- Enable realtime for key tables
ALTER PUBLICATION supabase_realtime ADD TABLE public.workouts;
ALTER PUBLICATION supabase_realtime ADD TABLE public.personal_records;
ALTER PUBLICATION supabase_realtime ADD TABLE public.user_achievements;

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_workouts_user_id ON public.workouts(user_id);
CREATE INDEX IF NOT EXISTS idx_workouts_started_at ON public.workouts(started_at);
CREATE INDEX IF NOT EXISTS idx_prs_user_exercise ON public.personal_records(user_id, exercise_id);
CREATE INDEX IF NOT EXISTS idx_measurements_user_date ON public.body_measurements(user_id, date);
''';
