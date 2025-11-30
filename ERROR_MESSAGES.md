# 🔧 Database Error Messages - What They Mean

When you try to save an email, you might see these error messages. Here's what each one means and how to fix it:

---

## ❌ "Database tables not created. Run SQL from SETUP_DATABASE.md"

### What it means:
The `saved_emails` table doesn't exist in Supabase.

### How to fix:
1. Open `SETUP_DATABASE.md` in your project folder
2. Copy all the SQL code
3. Go to Supabase Dashboard → SQL Editor → New Query
4. Paste the SQL
5. Click "Run"
6. Try saving an email again

---

## ❌ "RLS policy blocking save. Check Supabase RLS settings."

### What it means:
The tables exist, but Row Level Security (RLS) policies are preventing the insert.

### How to fix:
1. Go to Supabase Dashboard
2. Click "Table Editor" in left sidebar
3. Click on `saved_emails` table
4. Click "Policies" tab at bottom
5. You should see 3 policies:
   - "Users can view their own emails"
   - "Users can insert their own emails"
   - "Users can delete their own emails"

If you don't see them, run the RLS part of SETUP_DATABASE.md SQL again.

---

## ❌ "Authentication invalid. Try logging out and back in."

### What it means:
Your session token is invalid or expired.

### How to fix:
1. Click **Logout** button in dashboard header
2. Log back in with test@test.com / test123
3. Try saving an email again

---

## ❌ Other errors

If you see a different error, it will show the exact Supabase error message. Here are common ones:

### "relation \"saved_emails\" does not exist"
**Solution:** Tables not created. Run SQL from SETUP_DATABASE.md

### "permission denied for schema public"
**Solution:** RLS policy not set up correctly. Run SQL from SETUP_DATABASE.md

### "violates row level security policy"
**Solution:** RLS is working but your user doesn't match the policy. Try logout/login again.

### "JSON web token is invalid or expired"
**Solution:** Auth token expired. Logout and login again.

---

## Quick Checklist

If you see ANY error, check these in order:

1. **Tables created?**
   - Go to Supabase → Table Editor
   - See `saved_emails` table? ✅ Good
   - No? Run SQL from SETUP_DATABASE.md

2. **RLS policies enabled?**
   - Click on `saved_emails` table
   - Click "Policies" tab
   - See 3 policies listed? ✅ Good
   - No? Run SQL from SETUP_DATABASE.md

3. **Logged in?**
   - See your email in dashboard header? ✅ Good
   - No? Log in again

4. **Using test account?**
   - Using test@test.com / test123? ✅ Good
   - Different email? That might be the issue if not using Supabase auth

---

## How to Verify Tables & Policies

### Step 1: Check Tables Exist
1. Supabase Dashboard
2. Left sidebar → "Table Editor"
3. You should see:
   - ✅ `saved_emails` table
   - ✅ `user_profiles` table

### Step 2: Check RLS Policies
1. Click on `saved_emails` table
2. Scroll down to "Policies" section
3. You should see 3 rows:
   - ✅ "Users can insert their own emails"
   - ✅ "Users can view their own emails"
   - ✅ "Users can delete their own emails"

If you see this, database is correctly set up!

---

## Test Database Connection

After setting up, test it:

1. Log in with test@test.com / test123
2. Generate email variations
3. **Copy an email**
4. You should see in top-right: **"✅ Email saved successfully!"**

If you see that, everything is working!

---

## Still Having Issues?

Try these steps:

1. **Logout completely**
   - Click Logout button
   - Close browser tab
   - Open new tab and go to app again

2. **Run SQL again**
   - Go to SETUP_DATABASE.md
   - Copy ALL the SQL
   - Paste into Supabase SQL Editor
   - Click "Run"

3. **Create new account**
   - Try signing up with a NEW email address
   - See if saving works with fresh account

4. **Check Supabase status**
   - Go to https://status.supabase.com/
   - Is it showing any issues? (Red status = problems)

---

## Error Messages You'll See

| Error | Cause | Fix |
|-------|-------|-----|
| "Database tables not created" | Tables don't exist | Run SQL |
| "RLS policy blocking save" | RLS policies wrong | Run SQL |
| "Authentication invalid" | Session expired | Logout/Login |
| "permission denied" | RLS not enabled | Run SQL |
| "violates row level security policy" | User ID mismatch | Logout/Login |

---

## Most Common Fix

**99% of the time:** Just run the SQL from SETUP_DATABASE.md again!

It's safe to run multiple times - it will skip existing tables and just create what's missing.
