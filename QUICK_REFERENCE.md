# Quick Reference Card

## Getting Started (First Time)

### Step 1: Setup Database Tables
1. Copy **all SQL** from `SETUP_DATABASE.md`
2. Go to: https://lwmidjhyrlswpfjnyxrqs.supabase.co
3. Click **SQL Editor** → **New query**
4. Paste SQL → Click **Run**
5. ✅ Done!

### Step 2: Create Account or Login
- **New account:** Click "Sign Up" → Enter email/password
- **Test account:** `test@test.com` / `test123`
- **Returning:** Click "Login" → Use your email/password

### Step 3: Use the App
1. Generate email variations
2. Click "Copy Email" → Auto-saves
3. Click "Saved Emails" → View your collection
4. Click delete icon → Remove from collection

---

## Error Messages Quick Fixes

| Error | Fix |
|-------|-----|
| "Database tables not created" | Run SQL from SETUP_DATABASE.md |
| "RLS policy blocking" | Check Supabase → Tables → Policies (enable if disabled) |
| "Authentication invalid" | Click Logout → Click Login → Try again |
| "Error saving/loading emails" | Check browser console (F12) for details |

---

## Can't Fix It?

1. **Try test account first:** `test@test.com` / `test123`
2. **Clear everything:** F12 → Application → Clear site data → Refresh
3. **Check database:** Log into Supabase → Table Editor → Verify tables exist
4. **Read full guide:** See `TROUBLESHOOTING.md` for detailed help

---

## Browser Shortcuts

- **Open DevTools:** `F12` (Windows) or `Cmd+Option+I` (Mac)
- **Check Console:** DevTools → Console tab → Look for red errors
- **Clear Cache:** DevTools → Application → Clear site data

---

## Supabase Project Link

https://lwmidjhyrlswpfjnyxrqs.supabase.co

**Login credentials:** Use your email (same as for this app)

---

## Files You Need

| Must Read | Nice to Have |
|-----------|--------------|
| `SETUP_DATABASE.md` | QUICKSTART.md |
| `TROUBLESHOOTING.md` | ERROR_MESSAGES.md |
| | NOTIFICATIONS.md |

---

## Status Indicators

✅ = Success (green notification)  
❌ = Error (red notification)  
⏳ = Loading (blue notification)

---

**Most Common Issue:** Forgot to run SQL from SETUP_DATABASE.md  
**Easiest Test:** Log in with `test@test.com` / `test123`  
**Nuclear Reset:** F12 → Application → Clear site data
