# Troubleshooting Guide

## Quick Diagnosis

When you see an error message while saving or managing emails, this guide will help you fix it.

## Error Messages & Solutions

### ❌ "Database tables not created. Run SQL from SETUP_DATABASE.md"

**What this means:** The `saved_emails` or `user_profiles` tables don't exist in your Supabase database.

**How to fix:**
1. Open `SETUP_DATABASE.md` in this folder
2. Copy ALL the SQL code
3. Go to https://lwmidjhyrlswpfjnyxrqs.supabase.co
4. Click "SQL Editor" in the left menu
5. Click "New query"
6. Paste the SQL code
7. Click "Run" (green button)
8. You should see "✅ Success" messages
9. Check "Table Editor" to verify both tables exist

**Verification:**
- In Supabase, go to "Table Editor"
- You should see `user_profiles` and `saved_emails` tables
- If you don't, the SQL didn't run - try again

---

### ❌ "RLS policy blocking save/deletion. Check Supabase RLS settings"

**What this means:** The tables exist but are protected by "Row Level Security" policies that aren't allowing you to save/delete emails.

**How to fix:**
1. Go to https://lwmidjhyrlswpfjnyxrqs.supabase.co
2. Click "Table Editor" in left menu
3. Click on `saved_emails` table
4. Click the "Policies" tab
5. You should see 3 policies:
   - SELECT policy
   - INSERT policy  
   - DELETE policy
6. If these are missing, run the SQL from `SETUP_DATABASE.md` again
7. If they exist but say "No Access", make sure they're enabled

**Verification:**
- Each policy should show a green checkmark
- Status should say "Allow" not "Deny"

---

### ❌ "Authentication invalid. Try logging out and back in"

**What this means:** Your login session expired or token became invalid.

**How to fix:**
1. Click the "Logout" button in the top right
2. Log back in with your email and password
3. Try saving again

**Why this happens:**
- Session tokens expire after a while
- Browser session was cleared
- Multiple logins in different windows

---

### ❌ "Error loading emails" or "Error deleting email"

**What this means:** Something went wrong but the error is more specific than above.

**How to debug:**
1. Open your browser's **Developer Tools**:
   - Windows: Press `F12` or `Ctrl+Shift+I`
   - Mac: Press `Cmd+Option+I`
2. Look at the "Console" tab
3. Copy the full error message
4. Search for it in the table below

---

## Common Issues & Fixes

### Issue: Login works, but saving emails fails

**Most likely:** Database tables aren't created

**Steps:**
1. Check if you can see `saved_emails` table in Supabase Table Editor
2. If not, run SQL from `SETUP_DATABASE.md`
3. Try saving again

---

### Issue: Can login with test account but not own email

**Most likely:** Account not created in database

**Steps:**
1. Your account info is saved locally on this device
2. Sign up again with your email/password
3. The app will remember you next time you visit

---

### Issue: Saved emails don't show up

**Most likely:** Database queries failing silently

**Steps:**
1. Press F12 to open Developer Tools
2. Click "Console" tab
3. Try the "Saved Emails" button
4. Look for error messages in red
5. Share the error text with support

---

### Issue: On-screen notifications aren't showing

**Most likely:** Notification container hidden

**Workaround:**
1. Press F12 to open Developer Tools
2. Click "Console" tab
3. You'll see all messages there instead
4. Check for errors

---

## Step-by-Step: First Time Setup

### Part 1: Create Database Tables (One Time)

```
1. Copy SQL from SETUP_DATABASE.md file
2. Go to https://lwmidjhyrlswpfjnyxrqs.supabase.co
3. Click "SQL Editor" → "New query"
4. Paste the SQL
5. Click "Run"
6. See "Success" message
```

### Part 2: Create Your Account

```
1. Click "Sign Up" on login page
2. Enter email and password (e.g., test@test.com / password123)
3. Wait for success notification
4. You're logged in!
```

### Part 3: Test Saving

```
1. Go to main dashboard
2. Generate an email variation (or use the default)
3. Click "Copy Email"
4. Should see "✅ Email saved successfully!"
5. Click "Saved Emails" button
6. Should see your saved email in the list
```

---

## Debugging Checklist

When something isn't working:

- [ ] Is the login page showing? If no → File missing or browser issue
- [ ] Can you log in? If no → Check email/password or try test account
- [ ] Can you copy emails? If no → Basic app works but database connection missing
- [ ] Can you save emails? If no → Database tables not created or RLS issue
- [ ] Can you see saved emails? If no → Check database has tables
- [ ] Can you delete emails? If no → RLS policy blocking DELETE

---

## Getting Help

### With Database Issues:

1. Check `ERROR_MESSAGES.md` for your specific error
2. Follow `SETUP_DATABASE.md` exactly as written
3. Verify both tables exist in Supabase Table Editor
4. Verify RLS policies are enabled (green checkmarks)

### With Login Issues:

1. Use test account: `test@test.com` / `test123`
2. Or create new local account (works without Supabase)
3. Check browser console (F12) for errors

### With Saving Issues:

1. Make sure you're logged in
2. Make sure database tables exist
3. Try logging out and back in
4. Check browser console (F12) for error details

---

## Files in This Folder

| File | Purpose |
|------|---------|
| `index.html` | Main dashboard - email generator and saved emails |
| `login.html` | Login/signup page |
| `SETUP_DATABASE.md` | SQL to create database tables - run this FIRST |
| `QUICKSTART.md` | Quick start guide (5 min setup) |
| `ERROR_MESSAGES.md` | Complete error reference |
| `TROUBLESHOOTING.md` | This file - debugging help |
| `NOTIFICATIONS.md` | How the notification system works |

---

## Test Account (Always Works)

**Email:** `test@test.com`  
**Password:** `test123`

This account works even if your database isn't set up yet. Use it to test the app while you're configuring Supabase.

---

## When All Else Fails

### Nuclear Option: Clear Everything

1. Close all browser tabs with this app
2. Open browser DevTools: F12
3. Go to "Application" tab
4. Click "Clear site data"
5. Refresh page
6. Try again from scratch

This clears:
- Login session
- Saved preferences  
- Local accounts
- Browser cache

---

Last Updated: 2025  
For detailed error codes, see `ERROR_MESSAGES.md`
