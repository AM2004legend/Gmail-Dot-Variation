# 🗄️ Supabase Setup & Configuration Guide

Complete one-stop guide for setting up and configuring Supabase for Gmail Dot Variation.

---

## 📋 Table of Contents

1. [Project Information](#project-information)
2. [5-Minute Quick Setup](#5-minute-quick-setup)
3. [Complete Setup with RLS](#complete-setup-with-rls)
4. [Configuration Settings](#configuration-settings)
5. [Verification Checklist](#verification-checklist)
6. [Troubleshooting](#troubleshooting)
7. [API Reference](#api-reference)

---

## 📌 Project Information

**Supabase Project URL:** https://lwmidjhyrlswpfjnyrqs.supabase.co

**Anon Key:** `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx3bWlkamh5cmxzd3Bmam55cnFzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ0NjU2MDEsImV4cCI6MjA4MDA0MTYwMX0.hSg6XR2L19Z9gcarXvjUSpQoZaHWmtNf7eBhmYKV5fw`

**Tables Required:**
- `user_profiles` - Stores user information
- `saved_emails` - Stores user's saved email variations

**Authentication:** Email/Password via Supabase Auth

---

## ⚡ 5-Minute Quick Setup

### What You'll Do
1. Copy SQL code
2. Paste into Supabase SQL Editor
3. Run it
4. Test your app
5. Done! ✅

### Step-by-Step

#### Step 1: Go to Supabase Dashboard
```
URL: https://lwmidjhyrlswpfjnyxrqs.supabase.co
Login with your account
```

#### Step 2: Open SQL Editor
```
Left sidebar → "SQL Editor"
Click "New Query" button
```

#### Step 3: Copy This SQL Code

```sql
-- Create user_profiles table
CREATE TABLE IF NOT EXISTS user_profiles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  email VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id)
);

CREATE INDEX IF NOT EXISTS idx_user_profiles_user_id ON user_profiles(user_id);

-- Create saved_emails table
CREATE TABLE IF NOT EXISTS saved_emails (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  email VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id, email)
);

CREATE INDEX IF NOT EXISTS idx_saved_emails_user_id ON saved_emails(user_id);

-- Enable Row Level Security (RLS)
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE saved_emails ENABLE ROW LEVEL SECURITY;

-- user_profiles policies
CREATE POLICY IF NOT EXISTS "Users can view their own profile"
  ON user_profiles FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "Users can insert their own profile"
  ON user_profiles FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "Users can update their own profile"
  ON user_profiles FOR UPDATE
  USING (auth.uid() = user_id);

-- saved_emails policies
CREATE POLICY IF NOT EXISTS "Users can view their own emails"
  ON saved_emails FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "Users can insert their own emails"
  ON saved_emails FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "Users can delete their own emails"
  ON saved_emails FOR DELETE
  USING (auth.uid() = user_id);
```

#### Step 4: Run the SQL
```
Click "Run" button (green) or press Ctrl+Enter
Wait for "Success" message
```

#### Step 5: Verify
```
Click "Table Editor" in left sidebar
You should see both tables:
  ✅ user_profiles
  ✅ saved_emails
```

#### Step 6: Test Your App
```
Open index.html
Sign up or login
Copy an email
Should see: "✅ Email saved successfully! 💾"
Click "Saved Emails" → Should see your emails
```

---

## 🔐 Complete Setup with RLS Details

### Table Definitions

#### user_profiles Table
```sql
CREATE TABLE user_profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  email VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id)
);

CREATE INDEX idx_user_profiles_user_id ON user_profiles(user_id);
```

**Columns:**
- `id` - Primary key, auto-generated
- `user_id` - Foreign key to auth.users (auto-deletes on user delete)
- `email` - User's email address
- `created_at` - Account creation timestamp
- `updated_at` - Last update timestamp

#### saved_emails Table
```sql
CREATE TABLE saved_emails (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  email VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id, email)
);

CREATE INDEX idx_saved_emails_user_id ON saved_emails(user_id);
```

**Columns:**
- `id` - Primary key, auto-generated
- `user_id` - Foreign key to auth.users (auto-deletes on user delete)
- `email` - Saved email variation
- `created_at` - When it was saved
- Unique constraint: Same email can't be saved twice per user

### Row Level Security (RLS) Policies

#### user_profiles Policies

**SELECT Policy - Users can view their own profile**
```sql
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own profile"
  ON user_profiles FOR SELECT
  USING (auth.uid() = user_id);
```
Allows users to read only their own profile row.

**INSERT Policy - Users can create their own profile**
```sql
CREATE POLICY "Users can insert their own profile"
  ON user_profiles FOR INSERT
  WITH CHECK (auth.uid() = user_id);
```
Allows users to create profile only for themselves.

**UPDATE Policy - Users can update their own profile**
```sql
CREATE POLICY "Users can update their own profile"
  ON user_profiles FOR UPDATE
  USING (auth.uid() = user_id);
```
Allows users to update only their own profile.

#### saved_emails Policies

**SELECT Policy - Users can view their own emails**
```sql
ALTER TABLE saved_emails ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own emails"
  ON saved_emails FOR SELECT
  USING (auth.uid() = user_id);
```
Allows users to read only their own saved emails.

**INSERT Policy - Users can save their own emails**
```sql
CREATE POLICY "Users can insert their own emails"
  ON saved_emails FOR INSERT
  WITH CHECK (auth.uid() = user_id);
```
Allows users to save emails only for themselves.

**DELETE Policy - Users can delete their own emails**
```sql
CREATE POLICY "Users can delete their own emails"
  ON saved_emails FOR DELETE
  USING (auth.uid() = user_id);
```
Allows users to delete only their own saved emails.

---

## ⚙️ Configuration Settings

### Authentication Setup

Go to: **Authentication → Providers → Email**

**Required Settings:**
```
✅ Enable Email Signup = ON
✅ Confirm email (Require confirmation) = OFF (for immediate login)
✅ Send magic link for email = OFF
```

### Redirect URLs

Go to: **Authentication → URL Configuration**

**Add these redirect URLs:**
```
http://localhost:3000
http://localhost:5500
file://
https://yourdomain.com (your production domain)
```

### API Configuration

The app is already configured with:
- **Project URL:** `https://lwmidjhyrlswpfjnyxrqs.supabase.co`
- **Anon Key:** [See Project Information section]

These are set in both `login.html` and `index.html` files.

---

## ✅ Verification Checklist

After setup, verify everything works:

### In Supabase Dashboard

- [ ] Tables created
  - [ ] user_profiles table exists
  - [ ] saved_emails table exists

- [ ] RLS enabled
  - [ ] user_profiles has RLS enabled (lock icon)
  - [ ] saved_emails has RLS enabled (lock icon)

- [ ] Policies created
  - [ ] user_profiles has 3 policies (SELECT, INSERT, UPDATE)
  - [ ] saved_emails has 3 policies (SELECT, INSERT, DELETE)

- [ ] Authentication configured
  - [ ] Email provider enabled
  - [ ] Email confirmation = OFF
  - [ ] Redirect URLs added

### In Your App

- [ ] Can signup with new email
  - [ ] Signup form shows success message
  - [ ] Redirects to login

- [ ] Can login with created account
  - [ ] Login succeeds
  - [ ] Redirected to dashboard
  - [ ] Email shows in header

- [ ] Can test account works
  - [ ] test@test.com / test123 logs in
  - [ ] Email shows in header

- [ ] Can save emails
  - [ ] Copy email → see green notification
  - [ ] "✅ Email saved successfully! 💾"

- [ ] Can view saved emails
  - [ ] Click "Saved Emails" button
  - [ ] Modal shows your saved emails
  - [ ] Can see email from step above

- [ ] Can delete emails
  - [ ] Click delete icon on email
  - [ ] Email disappears from list
  - [ ] Notification shows success

### In Supabase Table Editor

- [ ] user_profiles has rows
  - [ ] One row per user account
  - [ ] user_id matches auth.users
  - [ ] email is correct

- [ ] saved_emails has rows
  - [ ] One row per saved email
  - [ ] user_id matches your user ID
  - [ ] email shows your saved variations

---

## 🔧 Troubleshooting

### Issue 0: "Users not appearing in user_profiles table"

**This is the most common issue. Follow these steps:**

#### Step 1: Check if tables exist
```
Go to Supabase Dashboard
Click "Table Editor" (left sidebar)
Look for these tables:
  ✅ user_profiles - should exist
  ✅ saved_emails - should exist
```

If tables are MISSING → Go to Issue 1 (run SQL)

If tables exist → Continue to Step 2

#### Step 2: Check RLS Policies
```
Click "user_profiles" table
Click "Policies" tab
You should see 3 policies:
  ✅ Users can view their own profile (SELECT)
  ✅ Users can insert their own profile (INSERT)
  ✅ Users can update their own profile (UPDATE)
```

If policies are MISSING → Go to Issue 2 (re-enable RLS)

If policies exist → Continue to Step 3

#### Step 3: Check browser console for errors
```
Open your app (index.html or login.html)
Press F12 (or right-click → Inspect)
Click "Console" tab
Try to signup or login
Look for messages like:
  ✅ "USER PROFILE CREATED SUCCESSFULLY"
  ❌ "PROFILE CREATION FAILED"
  ❌ "TABLE MISSING"
  ❌ "RLS POLICY BLOCKING"
```

Copy the exact error message and match it below:

**If you see "USER PROFILE CREATED SUCCESSFULLY":**
- Your app is working correctly
- Check Table Editor → user_profiles → should see your user row

**If you see "TABLE MISSING":**
- Go to Issue 1 (create tables)

**If you see "RLS POLICY BLOCKING":**
- Go to Issue 2 (fix RLS policies)

**If you see "NETWORK ERROR":**
- Go to Issue 3 (check connection)

#### Step 4: Manually verify in Table Editor
```
Go to Supabase → Table Editor
Click "user_profiles" table
At the top, you should see rows like:
  ID | user_id | email | created_at
  [UUID] | [UUID] | [user@email.com] | [timestamp]
```

If you see NO ROWS:
- Either profile creation is failing (check Step 3 console)
- Or RLS policy is preventing you from seeing them (Issue 2)

#### Step 5: Test with a new signup
```
Open your app
Sign up with a NEW email (never used before)
Check browser console (F12 → Console)
Look for profile creation message
Then check Supabase Table Editor again
```

---

### Issue 1: "relation user_profiles does not exist"

**Cause:** Tables weren't created

**Fix:**
1. Copy the SQL from this guide
2. Paste into SQL Editor
3. Run it
4. Wait for "Success" message
5. Try app again

### Issue 2: "permission denied by policy"

**Cause:** RLS policies not properly set up

**Fix:**
1. Go to Table Editor
2. Click each table
3. Click "Policies" tab
4. Verify all 3-6 policies exist
5. If any missing, re-run SQL
6. Try app again

### Issue 3: Tables show "relation already exists"

**Cause:** Tables already created (this is fine!)

**Fix:**
1. Click "Table Editor"
2. Verify both tables exist
3. Verify RLS policies exist
4. Try app - should work!

### Issue 4: Cannot login or signup

**Cause:** Email provider not enabled or incorrect settings

**Fix:**
1. Go to Authentication → Providers
2. Check Email is enabled
3. Check email confirmation is OFF
4. Go to URL Configuration
5. Verify redirect URLs include `file://`
6. Try again

### Issue 5: Saved emails don't persist

**Cause:** RLS policies may be blocking inserts

**Fix:**
1. Open browser console (F12)
2. Copy an email
3. Look for error message
4. If error mentions "permission" or "policy":
   - Go to Supabase
   - Check saved_emails table Policies
   - Verify INSERT policy exists
   - Try again

### Issue 6: App works but no data saves

**Cause:** Could be multiple issues

**Debug Steps:**
1. Press F12 to open console
2. Copy an email
3. Watch console for error messages
4. Note exact error
5. Match to issue above
6. Follow fix

---

## 📡 API Reference

### Database Functions (in JavaScript)

All these functions are available in `index.html` and `login.html`:

#### saveEmailVariation(email)
Saves an email to the saved_emails table.

```javascript
const result = await saveEmailVariation('user.variation@gmail.com');
// Returns: true if success, false if error
```

**Error Handling:**
- Checks authentication
- Detects missing tables
- Detects RLS blocks
- Provides specific error messages

#### fetchSavedEmails()
Retrieves all saved emails for current user.

```javascript
const emails = await fetchSavedEmails();
// Returns: Array of {id, email, created_at}
```

#### deleteSavedEmail(emailId)
Deletes a saved email by ID.

```javascript
const result = await deleteSavedEmail('email-id-uuid');
// Returns: true if success, false if error
```

#### updateUserProfile(updates)
Updates user profile data.

```javascript
const result = await updateUserProfile({
  email: 'newemail@example.com'
});
// Returns: true if success, false if error
```

#### initUserProfile(userId, email)
Initializes a new user profile (called automatically on signup/login).

```javascript
await initUserProfile('user-uuid', 'user@example.com');
```

---

## 🚀 Next Steps

After setup is complete:

1. **Test with your own account**
   - Sign up with your email
   - Copy some emails
   - Verify they appear in "Saved Emails"

2. **Share with others**
   - They can sign up independently
   - Each user's data is private (RLS ensures this)

3. **Monitor usage**
   - Go to Supabase Dashboard
   - Check Authentication → Users count
   - Check Table Editor → Row counts

4. **Make backup**
   - Supabase has built-in backups
   - Available in Project Settings

---

## 📞 Support

### Common Tasks

**Create a test user:**
```
Email: test@test.com
Password: test123
(Or use any credentials - they work locally)
```

**Delete a user:**
```
Go to Authentication → Users
Find user email
Click the user
Click "Delete user"
```

**Clear all data:**
```
Go to Table Editor
Click table name
Select all rows
Click Delete
```

**Check table structure:**
```
Go to Table Editor
Click table name
"Structure" tab shows all columns
```

---

## 📝 Summary

**What was set up:**
- ✅ Two database tables (user_profiles, saved_emails)
- ✅ Row Level Security (RLS) with 6 policies
- ✅ Email/password authentication
- ✅ Automatic user profile creation
- ✅ Email variation persistence
- ✅ Secure data isolation (users can't see others' data)

**What you can do now:**
- ✅ Sign up with email/password
- ✅ Save email variations permanently
- ✅ View your saved emails
- ✅ Delete emails you don't want
- ✅ Data persists across sessions
- ✅ Multiple users work independently

**Total setup time:** ~5 minutes for quick setup, ~15 minutes for full configuration.

---

**Last Updated:** 2025  
**Status:** Complete - Ready for production use
