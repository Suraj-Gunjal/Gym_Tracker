# Supabase Cloud Sync Setup Guide

This guide explains how to set up Supabase for cloud sync in the Gym Tracker app.

## Step 1: Create a Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign up for a free account
2. Click "New Project" and fill in:
   - **Name**: gym-tracker (or your preferred name)
   - **Database Password**: Generate a strong password (save this!)
   - **Region**: Choose the closest region to you
3. Wait for the project to be created (takes ~2 minutes)

## Step 2: Set Up the Database

1. In your Supabase dashboard, go to **SQL Editor**
2. Click "New Query"
3. Copy and paste the contents of `supabase/migrations/001_initial_schema.sql`
4. Click "Run" to execute the migration
5. Verify tables were created by going to **Table Editor**

You should see these tables:

- `profiles`
- `exercises`
- `workouts`
- `workout_exercises`
- `exercise_sets`
- `personal_records`
- `workout_templates`
- `body_measurements`
- `sync_metadata`

## Step 3: Configure Authentication

1. Go to **Authentication** > **Providers**
2. **Email** is enabled by default
3. (Optional) Enable **Google** OAuth:
   - Click Google
   - Add your OAuth credentials from Google Cloud Console
4. (Optional) Enable **Apple** OAuth:
   - Click Apple
   - Add your Apple Sign-In credentials

## Step 4: Set Up Storage (Optional)

For storing profile pictures and workout photos:

1. Go to **Storage** in the sidebar
2. Click "Create bucket" and create:
   - `avatars` (public)
   - `workout-photos` (private)
   - `progress-photos` (private)

Then run these policies in SQL Editor:

```sql
-- Avatar storage policies
CREATE POLICY "Avatar images are publicly accessible"
ON storage.objects FOR SELECT
USING (bucket_id = 'avatars');

CREATE POLICY "Users can upload their own avatar"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can update their own avatar"
ON storage.objects FOR UPDATE
USING (bucket_id = 'avatars' AND auth.uid()::text = (storage.foldername(name))[1]);
```

## Step 5: Get Your API Credentials

1. Go to **Settings** > **API**
2. Copy:
   - **Project URL** (e.g., `https://xxxxx.supabase.co`)
   - **anon/public** key (the one labeled "anon key")

## Step 6: Configure the Flutter App

### Option A: Environment Variables (Recommended for Production)

Build with environment variables:

```bash
flutter build apk --release \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

### Option B: Direct Configuration (Development Only)

Edit `lib/core/config/supabase_config.dart`:

```dart
static const String supabaseUrl = 'https://your-project.supabase.co';
static const String supabaseAnonKey = 'your-anon-key';
```

⚠️ **Warning**: Don't commit real credentials to version control!

## Step 7: Test the Connection

1. Run the app: `flutter run`
2. Go to Settings > Backup & Sync
3. Sign up or sign in
4. Try syncing your data

## Features

### Automatic Sync

- Data syncs automatically every 5 minutes when signed in
- Toggle auto-sync in Settings > Backup & Sync

### Manual Sync

- Tap the sync icon in the app bar
- Pull to refresh on most screens

### Force Backup

- Uploads ALL local data to cloud
- Overwrites cloud data with local data

### Force Restore

- Downloads ALL cloud data to device
- Overwrites local data with cloud data

## Troubleshooting

### "Cloud Not Configured" Error

- Verify SUPABASE_URL and SUPABASE_ANON_KEY are set correctly
- Check that the URL starts with `https://`

### "Not Authenticated" Error

- Sign in through Settings > Backup & Sync

### Sync Fails

- Check your internet connection
- Verify Row Level Security (RLS) policies are set up correctly
- Check the Supabase dashboard for any error logs

### Data Not Appearing

- Make sure you're signed in with the same account on all devices
- Wait for sync to complete (check the status indicator)

## Security Notes

1. **Row Level Security (RLS)** is enabled on all tables
   - Users can only access their own data
   - Policies are defined in the migration

2. **API Keys**
   - The `anon` key is safe to include in the app
   - It only allows access to data the user owns
   - Never expose the `service_role` key

3. **Authentication**
   - Passwords are hashed using bcrypt
   - Sessions are managed by Supabase Auth
   - Tokens expire and refresh automatically

## Cost Considerations

### Free Tier Includes:

- 500 MB database storage
- 1 GB file storage
- 2 GB bandwidth/month
- 50,000 monthly active users
- 500,000 Edge Function invocations

This is more than enough for personal use and small user bases!

### When to Upgrade:

- More than 500 MB of workout data
- Heavy file storage usage (many photos)
- High traffic (many concurrent users)

## Support

For issues with:

- **Supabase setup**: Check [supabase.com/docs](https://supabase.com/docs)
- **App integration**: Open an issue on GitHub
- **Account issues**: Contact Supabase support
