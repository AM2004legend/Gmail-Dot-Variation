-- ================================
-- Gmail Dot Variation - Database Setup
-- ================================

-- Step 1: Create user_profiles table
CREATE TABLE IF NOT EXISTS user_profiles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  email VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id)
);

CREATE INDEX IF NOT EXISTS idx_user_profiles_user_id ON user_profiles(user_id);

-- Step 2: Create saved_emails table
CREATE TABLE IF NOT EXISTS saved_emails (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  email VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id, email)
);

CREATE INDEX IF NOT EXISTS idx_saved_emails_user_id ON saved_emails(user_id);

-- Step 3: Enable Row Level Security (RLS)
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE saved_emails ENABLE ROW LEVEL SECURITY;

-- Step 4: Create RLS policies for user_profiles table
-- Policy 1: Users can view their own profile
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_catalog.pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'user_profiles'
      AND policyname = 'Users can view their own profile'
  ) THEN
    CREATE POLICY "Users can view their own profile"
      ON user_profiles FOR SELECT
      USING (auth.uid() = user_id);
  END IF;
END $$;

-- Policy 2: Users can insert their own profile
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_catalog.pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'user_profiles'
      AND policyname = 'Users can insert their own profile'
  ) THEN
    CREATE POLICY "Users can insert their own profile"
      ON user_profiles FOR INSERT
      WITH CHECK (auth.uid() = user_id);
  END IF;
END $$;

-- Policy 3: Users can update their own profile
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_catalog.pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'user_profiles'
      AND policyname = 'Users can update their own profile'
  ) THEN
    CREATE POLICY "Users can update their own profile"
      ON user_profiles FOR UPDATE
      USING (auth.uid() = user_id);
  END IF;
END $$;

-- Step 5: Create RLS policies for saved_emails table
-- Policy 1: Users can view their own emails
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_catalog.pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'saved_emails'
      AND policyname = 'Users can view their own emails'
  ) THEN
    CREATE POLICY "Users can view their own emails"
      ON saved_emails FOR SELECT
      USING (auth.uid() = user_id);
  END IF;
END $$;

-- Policy 2: Users can insert their own emails
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_catalog.pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'saved_emails'
      AND policyname = 'Users can insert their own emails'
  ) THEN
    CREATE POLICY "Users can insert their own emails"
      ON saved_emails FOR INSERT
      WITH CHECK (auth.uid() = user_id);
  END IF;
END $$;

-- Policy 3: Users can delete their own emails
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_catalog.pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'saved_emails'
      AND policyname = 'Users can delete their own emails'
  ) THEN
    CREATE POLICY "Users can delete their own emails"
      ON saved_emails FOR DELETE
      USING (auth.uid() = user_id);
  END IF;
END $$;

-- ================================
-- Setup Complete!
-- ================================
