# 📚 Complete Documentation Hub

> **All documentation in one place.** Choose your path based on your needs.

---

## 🚀 **START HERE** - Choose Your Path

### **⚡ I just want to use it** (5 minutes)
Start with the app immediately:
1. Open `index.html` in browser
2. Test with: `test@test.com` / `test123`
3. Generate emails and explore
4. **Done!** You can use it right now.

---

### **🔧 I need to set up the database** (10 minutes)
1. Read: [Supabase Setup Steps](#supabase-setup-steps) (below)
2. Run the SQL code in Supabase
3. Create your own account
4. Start saving emails

---

### **🐛 Something's broken, help me fix it!** (2-5 minutes)
1. Look at your error message
2. Find it in: [Common Errors](#common-errors) (below)
3. Follow the fix steps
4. Test to verify it works

---

### **📖 Teach me everything** (30 minutes)
Read these in order:
1. [How the app works](#how-the-app-works)
2. [Email generation](#email-generation)
3. [Database system](#database-system)
4. [Security](#security)

---

## ⚡ Quick Reference

| Task | How | Time |
|------|-----|------|
| Use test account | `test@test.com` / `test123` | 0 min |
| See generated emails | Click "Generate Magic Variations" | 1 min |
| Copy an email | Click the email text | 1 min |
| Save an email | Click "💾 Save" button | 1 min |
| View saved emails | Click "Saved Emails" button | 1 min |
| Logout | Click "Logout" button | 0 min |
| Create your account | Sign up with your email | 2 min |
| Set up Supabase | Follow SQL steps below | 10 min |

---

## 🔧 **Supabase Setup Steps**

### **Step 1: Open Supabase**
```
URL: https://supabase.com/dashboard/project/lwmidjhyrlswpfjnyrqs
Log in with your account
```

### **Step 2: Open SQL Editor**
```
Left sidebar → SQL Editor → New Query
```

### **Step 3: Create Tables & RLS**
Copy and run this SQL:

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

-- Enable Row Level Security
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE saved_emails ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for user_profiles
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_policies WHERE schemaname = 'public' AND tablename = 'user_profiles' AND policyname = 'Users can view their own profile') THEN
    CREATE POLICY "Users can view their own profile" ON user_profiles FOR SELECT USING (auth.uid() = user_id);
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_policies WHERE schemaname = 'public' AND tablename = 'user_profiles' AND policyname = 'Users can insert their own profile') THEN
    CREATE POLICY "Users can insert their own profile" ON user_profiles FOR INSERT WITH CHECK (auth.uid() = user_id);
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_policies WHERE schemaname = 'public' AND tablename = 'user_profiles' AND policyname = 'Users can update their own profile') THEN
    CREATE POLICY "Users can update their own profile" ON user_profiles FOR UPDATE USING (auth.uid() = user_id);
  END IF;
END $$;

-- Create RLS policies for saved_emails
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_policies WHERE schemaname = 'public' AND tablename = 'saved_emails' AND policyname = 'Users can view their own emails') THEN
    CREATE POLICY "Users can view their own emails" ON saved_emails FOR SELECT USING (auth.uid() = user_id);
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_policies WHERE schemaname = 'public' AND tablename = 'saved_emails' AND policyname = 'Users can insert their own emails') THEN
    CREATE POLICY "Users can insert their own emails" ON saved_emails FOR INSERT WITH CHECK (auth.uid() = user_id);
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_catalog.pg_policies WHERE schemaname = 'public' AND tablename = 'saved_emails' AND policyname = 'Users can delete their own emails') THEN
    CREATE POLICY "Users can delete their own emails" ON saved_emails FOR DELETE USING (auth.uid() = user_id);
  END IF;
END $$;
```

### **Step 4: Verify Success**
```
Click "Run" button
Wait for "Success" message
Go to Table Editor
Verify both tables exist: ✅ user_profiles ✅ saved_emails
```

### **Step 5: Test the App**
```
Refresh index.html
Sign up with your email
Generate and save an email
Check Supabase Table Editor → saved_emails
You should see your email!
```

---

## 📊 How the App Works

### **The Email Generator**
1. You enter your email (e.g., `john@gmail.com`)
2. App generates 64 variations using Gmail's dot feature
3. Shows: current variations, all possible, and saved count

### **The Variations**
Gmail treats dots (.) as nothing, so:
- `john@gmail.com` = `j.o.h.n@gmail.com` = `jo.hn@gmail.com` = etc.
- All 64 variations work with your real Gmail account
- Use different variations for different websites
- Perfect for tracking which sites leaked your email

### **The Saving Feature**
1. Click any email to copy to clipboard
2. Click "💾 Save" button to save to database
3. Button turns gray ✅ "Saved"
4. Click "Saved Emails" to view all saved ones
5. Delete any saved email you don't need

### **The Authentication**
- Supabase handles user accounts
- Email/password signup and login
- Passwords never stored (encrypted by Supabase)
- Test account: `test@test.com` / `test123`

---

## 🔐 Security

### **Your Data is Safe Because:**
- ✅ Row Level Security (RLS) - Users can only see their own data
- ✅ Encrypted passwords - Never stored in plain text
- ✅ HTTPS - All communication is encrypted
- ✅ No third-party tracking - Only Supabase backend
- ✅ No email selling - Your emails are never shared

### **How It Works:**
```
User A can only see:
  - Their own user profile
  - Their own saved emails

User B can only see:
  - Their own user profile
  - Their own saved emails

No mixing of data
No privacy leaks
```

---

## 🎓 Email Generation Details

### **The Gmail Dot Trick**
Gmail doesn't count dots in the username part:
```
john.smith@gmail.com
johnsmith@gmail.com  ← Same inbox!
j.o.h.n.s.m.i.t.h@gmail.com ← Still the same!
```

### **How We Generate 64 Variations**
For email `john.smith@gmail.com`, we:
1. Remove the `@gmail.com` part
2. Keep: `john.smith` (10 characters)
3. Insert dots in different positions
4. Create all possible combinations
5. Add back `@gmail.com`

### **Why 64?**
With 10 characters, there are 2^10 = 1024 possible positions for dots, but we show only 64 of the most useful ones.

---

## 💾 Database System

### **Two Tables:**

**user_profiles** - Stores account info
```
id (UUID)         → Unique identifier
user_id (UUID)    → Links to auth user
email (string)    → Your email address
created_at        → When you signed up
```

**saved_emails** - Stores your saved variations
```
id (UUID)         → Unique identifier
user_id (UUID)    → Links to you
email (string)    → The saved variation
created_at        → When you saved it
```

### **How It Works:**
1. You sign up → user_profiles row created
2. You save an email → saved_emails row created
3. You view saved → Fetches all your saved_emails
4. You delete one → Deletes that saved_emails row

---

## 🐛 Common Errors

### **"Cannot reach database"**
**Cause:** Internet connection or Supabase down
**Fix:**
1. Check internet connection
2. Try again
3. If still fails: Supabase might be down (check status.supabase.com)

### **"Table not found"**
**Cause:** You haven't run the SQL setup yet
**Fix:**
1. Follow "Supabase Setup Steps" above
2. Run the SQL code
3. Refresh the app

### **"Permission denied"**
**Cause:** RLS policy blocking the operation
**Fix:**
1. Go to Supabase → Table Editor
2. Click each table → Policies tab
3. Verify all 3 policies exist for each table
4. If missing: Run the SQL again

### **"Email already saved"**
**Cause:** You already saved this email
**Fix:**
1. This is normal! It prevents duplicates
2. Click "Saved Emails" to see all your saved ones

### **Cannot login after signup**
**Cause:** Account created but email not confirmed
**Fix:**
1. Wait a moment and try again
2. If still fails: Check spam folder for confirmation email
3. Or use test account: `test@test.com` / `test123`

---

## ✅ Verification Checklist

### **Tables Created?**
```
Go to Supabase → Table Editor
You should see:
  ✅ user_profiles
  ✅ saved_emails
```

### **RLS Enabled?**
```
Click each table
Click "Policies" tab
You should see 3 policies per table
```

### **Can Sign Up?**
```
Try signing up with new email
Should see success message
Check Supabase → Authentication → Users
You should see your user
```

### **Can Save Emails?**
```
Log in
Generate emails
Click "💾 Save" on an email
Should see green notification: ✅ "Email saved successfully! 💾"
Check Supabase → Table Editor → saved_emails
You should see your email
```

---

## 📞 Support by Issue

| Issue | Solution | Time |
|-------|----------|------|
| Can't generate emails | Refresh page | 1 min |
| Can't save emails | Check database setup | 10 min |
| Can't login | Try test account first | 2 min |
| Database error | Run SQL code | 5 min |
| Permission denied | Check RLS policies | 5 min |

---

## 🎯 File Reference

| File | Purpose |
|------|---------|
| **index.html** | Main application |
| **login.html** | Authentication |
| **signup.html** | Signup page |
| **shared-functions.js** | Database functions |
| **SUPABASE_COMPLETE.md** | Database setup details |
| **This file** | Everything documented here |

---

## 🚀 Next Steps

1. **Try the app** - Use test account: `test@test.com` / `test123`
2. **Set up your account** - Follow "Supabase Setup Steps" above
3. **Create your account** - Sign up with your email
4. **Save some emails** - Generate, then save favorites
5. **Explore features** - Check "Saved Emails" button

---

**Last Updated:** November 30, 2025  
**Status:** Complete & Ready to Use ✅
