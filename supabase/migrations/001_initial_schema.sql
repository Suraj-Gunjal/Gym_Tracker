-- Gym Tracker Supabase Schema
-- Run this in your Supabase SQL Editor

-- Note: JWT secret is automatically managed by Supabase - no need to set it manually

-- ============================================
-- PROFILES TABLE (extends auth.users)
-- ============================================
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT,
    display_name TEXT,
    avatar_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Users can view their own profile"
    ON public.profiles FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile"
    ON public.profiles FOR UPDATE
    USING (auth.uid() = id);

CREATE POLICY "Users can insert their own profile"
    ON public.profiles FOR INSERT
    WITH CHECK (auth.uid() = id);

-- ============================================
-- EXERCISES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.exercises (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    muscle_group TEXT NOT NULL,
    description TEXT,
    is_predefined BOOLEAN DEFAULT FALSE,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted BOOLEAN DEFAULT FALSE
);

-- Enable RLS
ALTER TABLE public.exercises ENABLE ROW LEVEL SECURITY;

-- Exercises policies
CREATE POLICY "Users can view their own exercises"
    ON public.exercises FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own exercises"
    ON public.exercises FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own exercises"
    ON public.exercises FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own exercises"
    ON public.exercises FOR DELETE
    USING (auth.uid() = user_id);

-- Index for sync queries
CREATE INDEX idx_exercises_user_updated ON public.exercises(user_id, updated_at);

-- ============================================
-- WORKOUTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.workouts (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT,
    started_at TIMESTAMPTZ NOT NULL,
    completed_at TIMESTAMPTZ,
    notes TEXT,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted BOOLEAN DEFAULT FALSE
);

-- Enable RLS
ALTER TABLE public.workouts ENABLE ROW LEVEL SECURITY;

-- Workouts policies
CREATE POLICY "Users can view their own workouts"
    ON public.workouts FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own workouts"
    ON public.workouts FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own workouts"
    ON public.workouts FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own workouts"
    ON public.workouts FOR DELETE
    USING (auth.uid() = user_id);

-- Index for sync queries
CREATE INDEX idx_workouts_user_updated ON public.workouts(user_id, updated_at);

-- ============================================
-- WORKOUT_EXERCISES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.workout_exercises (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    workout_id TEXT NOT NULL REFERENCES public.workouts(id) ON DELETE CASCADE,
    exercise_id TEXT NOT NULL,
    order_index INTEGER NOT NULL,
    notes TEXT,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted BOOLEAN DEFAULT FALSE
);

-- Enable RLS
ALTER TABLE public.workout_exercises ENABLE ROW LEVEL SECURITY;

-- Workout exercises policies
CREATE POLICY "Users can view their own workout_exercises"
    ON public.workout_exercises FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own workout_exercises"
    ON public.workout_exercises FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own workout_exercises"
    ON public.workout_exercises FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own workout_exercises"
    ON public.workout_exercises FOR DELETE
    USING (auth.uid() = user_id);

-- Index for sync queries
CREATE INDEX idx_workout_exercises_user_updated ON public.workout_exercises(user_id, updated_at);

-- ============================================
-- EXERCISE_SETS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.exercise_sets (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    workout_exercise_id TEXT NOT NULL REFERENCES public.workout_exercises(id) ON DELETE CASCADE,
    set_number INTEGER NOT NULL,
    reps INTEGER NOT NULL,
    weight REAL NOT NULL,
    notes TEXT,
    completed BOOLEAN DEFAULT TRUE,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted BOOLEAN DEFAULT FALSE
);

-- Enable RLS
ALTER TABLE public.exercise_sets ENABLE ROW LEVEL SECURITY;

-- Exercise sets policies
CREATE POLICY "Users can view their own exercise_sets"
    ON public.exercise_sets FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own exercise_sets"
    ON public.exercise_sets FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own exercise_sets"
    ON public.exercise_sets FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own exercise_sets"
    ON public.exercise_sets FOR DELETE
    USING (auth.uid() = user_id);

-- Index for sync queries
CREATE INDEX idx_exercise_sets_user_updated ON public.exercise_sets(user_id, updated_at);

-- ============================================
-- PERSONAL_RECORDS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.personal_records (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    exercise_id TEXT NOT NULL,
    pr_type TEXT NOT NULL,
    value REAL NOT NULL,
    at_weight REAL,
    workout_id TEXT,
    set_id TEXT,
    achieved_at TIMESTAMPTZ NOT NULL,
    previous_value REAL,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted BOOLEAN DEFAULT FALSE
);

-- Enable RLS
ALTER TABLE public.personal_records ENABLE ROW LEVEL SECURITY;

-- Personal records policies
CREATE POLICY "Users can view their own personal_records"
    ON public.personal_records FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own personal_records"
    ON public.personal_records FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own personal_records"
    ON public.personal_records FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own personal_records"
    ON public.personal_records FOR DELETE
    USING (auth.uid() = user_id);

-- Index for sync queries
CREATE INDEX idx_personal_records_user_updated ON public.personal_records(user_id, updated_at);

-- ============================================
-- WORKOUT_TEMPLATES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.workout_templates (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    is_public BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted BOOLEAN DEFAULT FALSE
);

-- Enable RLS
ALTER TABLE public.workout_templates ENABLE ROW LEVEL SECURITY;

-- Templates policies
CREATE POLICY "Users can view their own templates"
    ON public.workout_templates FOR SELECT
    USING (auth.uid() = user_id OR is_public = TRUE);

CREATE POLICY "Users can insert their own templates"
    ON public.workout_templates FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own templates"
    ON public.workout_templates FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own templates"
    ON public.workout_templates FOR DELETE
    USING (auth.uid() = user_id);

-- Index for sync queries
CREATE INDEX idx_workout_templates_user_updated ON public.workout_templates(user_id, updated_at);

-- ============================================
-- BODY_MEASUREMENTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.body_measurements (
    id TEXT PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    measurement_type TEXT NOT NULL,
    value REAL NOT NULL,
    unit TEXT NOT NULL,
    measured_at TIMESTAMPTZ NOT NULL,
    notes TEXT,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted BOOLEAN DEFAULT FALSE
);

-- Enable RLS
ALTER TABLE public.body_measurements ENABLE ROW LEVEL SECURITY;

-- Body measurements policies
CREATE POLICY "Users can view their own body_measurements"
    ON public.body_measurements FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own body_measurements"
    ON public.body_measurements FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own body_measurements"
    ON public.body_measurements FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own body_measurements"
    ON public.body_measurements FOR DELETE
    USING (auth.uid() = user_id);

-- Index for sync queries
CREATE INDEX idx_body_measurements_user_updated ON public.body_measurements(user_id, updated_at);

-- ============================================
-- SYNC_METADATA TABLE (tracks last sync per device)
-- ============================================
CREATE TABLE IF NOT EXISTS public.sync_metadata (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    device_id TEXT NOT NULL,
    last_sync_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, device_id)
);

-- Enable RLS
ALTER TABLE public.sync_metadata ENABLE ROW LEVEL SECURITY;

-- Sync metadata policies
CREATE POLICY "Users can manage their own sync_metadata"
    ON public.sync_metadata FOR ALL
    USING (auth.uid() = user_id);

-- ============================================
-- FUNCTIONS
-- ============================================

-- Function to automatically create profile on user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, email, display_name)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'display_name', split_part(NEW.email, '@', 1))
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create profile on signup
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply updated_at triggers to all tables
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON public.profiles
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_exercises_updated_at BEFORE UPDATE ON public.exercises
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_workouts_updated_at BEFORE UPDATE ON public.workouts
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_workout_exercises_updated_at BEFORE UPDATE ON public.workout_exercises
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_exercise_sets_updated_at BEFORE UPDATE ON public.exercise_sets
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_personal_records_updated_at BEFORE UPDATE ON public.personal_records
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_workout_templates_updated_at BEFORE UPDATE ON public.workout_templates
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER update_body_measurements_updated_at BEFORE UPDATE ON public.body_measurements
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

-- ============================================
-- STORAGE BUCKETS
-- ============================================
-- Run these in the Supabase Dashboard under Storage

-- INSERT INTO storage.buckets (id, name, public) VALUES ('avatars', 'avatars', true);
-- INSERT INTO storage.buckets (id, name, public) VALUES ('workout-photos', 'workout-photos', false);
-- INSERT INTO storage.buckets (id, name, public) VALUES ('progress-photos', 'progress-photos', false);

-- Storage policies (run in SQL editor)
-- CREATE POLICY "Avatar images are publicly accessible" ON storage.objects FOR SELECT USING (bucket_id = 'avatars');
-- CREATE POLICY "Users can upload their own avatar" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);
-- CREATE POLICY "Users can update their own avatar" ON storage.objects FOR UPDATE USING (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);
-- CREATE POLICY "Users can delete their own avatar" ON storage.objects FOR DELETE USING (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);
