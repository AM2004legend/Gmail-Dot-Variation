# 🔧 Debugging: "Failed to Fetch" Error

## The Error

When you click on a generated email to copy it, you see: **"Failed to fetch"** error.

## What's Happening

The email is being copied to clipboard ✅, but saving to Supabase database ❌ is failing.

## New Error Messages ✅

Just improved the code! Now you'll see **specific error messages**:

### In Browser Console (F12 → Console tab)

**If database tables are missing:**
```
❌ Database tables not created. Run SQL from SETUP_DATABASE.md
```

**If RLS policies blocking:**
```
❌ RLS policy blocking save. Check Supabase RLS settings.
```

**If network problem:**
```
❌ Network error: Cannot reach database. Check internet connection.
```

**If auth invalid:**
```
❌ Authentication invalid. Try logging out and back in.
```

---

## Quick Fix (3 Minutes)

### Step 1: Open Console
- Press **F12**
- Click **Console** tab

### Step 2: Copy an Email
- Click on generated email
- Read the error message in console

### Step 3: Fix Based on Error

**If you see "Database tables not created":**
1. Open SETUP_DATABASE.md
2. Copy SQL
3. Go to Supabase SQL Editor
4. Run SQL
5. Try copying email again ✅

**If you see "RLS policy":**
1. Go to Supabase Table Editor
2. Click "saved_emails" → "Policies"
3. Enable any disabled policies
4. Try copying email again ✅

**If you see "Network error":**
1. Check internet connection
2. Check https://status.supabase.com
3. Refresh page
4. Try again ✅

**If you see "Authentication invalid":**
1. Click Logout
2. Login again
3. Try copying email again ✅

---

## Detailed Debugging

### Step 1: Open Browser Console
1. Press **F12** on your keyboard
2. Click **Console** tab
3. You should see detailed logs as you use the app

### Step 2: Test Email Saving

1. Login to the app (use test@test.com / test123)
2. Generate some email variations
3. **Copy an email** by clicking on it
4. Check the Console for messages

### Good Messages (Success) ✅
```
saveEmailVariation called with: user+123@gmail.com
userId: test_user_123
authToken exists: true
Inserting email into database...
Email saved successfully: [...]
✅ Email saved successfully! 💾
```

### Bad Messages (Errors) ❌
```
Error saving email: {code: "42P01", message: "relation \"saved_emails\" does not exist"}
❌ Database tables not created. Run SQL from SETUP_DATABASE.md

or

Error saving email: {code: "42501", message: "permission denied by policy"}
❌ RLS policy blocking save. Check Supabase RLS settings.
```

### Step 3: Check Saved Emails

1. Click **"Saved Emails"** button in header
2. You should see console messages like:
   ```
   Fetching saved emails...
   Fetched emails: [{id: '...', email: 'user+123@gmail.com', ...}]
   ```

---

## Common Issues & Solutions

### Issue 1: "Not authenticated, cannot save"
**Cause:** Not logged in
**Fix:** 
- Login with test@test.com / test123
- Or create your own account first

### Issue 2: "Database tables not created"
**Cause:** Tables don't exist in Supabase
**Fix:**
- Run SQL from SETUP_DATABASE.md
- Go to Supabase SQL Editor
- Paste and run the SQL

### Issue 3: "RLS policy blocking"
**Cause:** RLS policies disabled
**Fix:**
- Go to Supabase Table Editor
- Click "saved_emails" table
- Click "Policies" tab
- Enable missing policies

### Issue 4: "Network error: Cannot reach database"
**Cause:** Supabase unreachable
**Fix:**
- Check internet connection
- Check https://status.supabase.com
- Refresh page and try again

### Issue 5: "Authentication invalid"
**Cause:** Session expired
**Fix:**
- Click Logout button
- Login again
- Try copying email again

---

## Verify It's Working

### Test 1: Email Copies to Clipboard
```
1. Click on generated email
2. Paste it somewhere (notepad, textarea)
3. Text should appear
✅ If yes → Clipboard works!
```

### Test 2: Database Saves
```
1. Open console (F12)
2. Copy email
3. Look for "✅ Email saved successfully"
✅ If yes → Database works!
```

### Test 3: Saved Emails Appear
```
1. Copy email
2. Click "Saved Emails" button
3. Should see the email in list
✅ If yes → Everything works!
```

---

## If Still Not Working

1. **Check console output** - what specific error?
2. **Check Supabase** - do tables exist?
3. **Check RLS policies** - are they enabled?
4. **Check internet** - are you connected?
5. **Try test account** - test@test.com / test123

If error says "Database tables not created" → Run SETUP_DATABASE.md SQL  
If error says "RLS policy" → Enable policies in Supabase  
If error says "Network" → Check internet and Supabase status  
If error says "Authentication" → Logout and login again

---

## Console Commands to Test

**Check if you're logged in:**
```javascript
sessionStorage.getItem('userId')
// Should return something like: test_user_123
```

**Check auth token exists:**
```javascript
sessionStorage.getItem('authToken')
// Should return a token
```

**Test save manually:**
```javascript
await saveEmailVariation('test.email@gmail.com')
// Should see success or specific error
```

**Check supabase is initialized:**
```javascript
console.log(supabase)
// Should show Supabase client object
```

---

## Last Resort: Nuclear Reset

If nothing else works:

1. Open DevTools (F12)
2. Go to "Application" tab
3. Click "Clear site data"
4. Refresh page
5. Login again
6. Try copying email

This clears all stored data and resets everything.

1. Check the error code in console
2. If it's `PGRST116` - this is OK! (means duplicate email)
3. If different error, check:
   - Are the tables created? (Run SQL from SUPABASE_SETUP.md)
   - Are RLS policies enabled?
   - Is your user_id valid?

#### Issue 3: Modal shows "No saved emails yet"
**Problem:** Nothing is appearing in the saved emails list
**Solution:**
1. Check console for `Fetched emails: []` (empty array)
2. Make sure you actually copied an email (check for "Email saved successfully" message)
3. Check Supabase:
   - Go to dashboard
   - Click "Table Editor"
   - Click "saved_emails" table
   - Look for your records

#### Issue 4: Supabase error messages in console
**Problem:** Database query fails with error message
**Solution:**
Look for the specific error:

**"relation does not exist"** - Tables not created
- Fix: Run SQL from SUPABASE_SETUP.md

**"relation \"saved_emails\" violates row level security policy"** - RLS blocking
- Fix: Enable policies from SUPABASE_SETUP.md

**"Invalid API Key"** - Wrong Supabase credentials
- Fix: Check SUPABASE_KEY and SUPABASE_URL in code

---

## Quick Debug Checklist

- [ ] Logged in successfully (see email in header)
- [ ] sessionStorage has userId (check F12 > Application > Storage > Session Storage)
- [ ] Console shows "Email saved successfully" after copying
- [ ] Click "Saved Emails" button opens modal
- [ ] Modal shows fetched emails (not empty)
- [ ] Can delete emails
- [ ] Supabase tables exist (check Table Editor)
- [ ] RLS policies enabled (check Policies tab)

---

## Console Commands for Manual Testing

Run these in browser console (F12 > Console):

```javascript
// Check if logged in
sessionStorage.getItem('userId')
sessionStorage.getItem('authToken')

// Manually save an email
await saveEmailVariation('test+debug@gmail.com')

// Fetch all saved emails
await fetchSavedEmails()

// Delete specific email (need the email ID)
await deleteSavedEmail('email-id-here')

// Check Supabase connection
console.log(supabase)
```

---

## Email Saving Flow (What Should Happen)

```
1. User copies email
   ↓
2. copyToClipboard() called
   ↓
3. saveEmailVariation(text) called
   ↓
4. Supabase .insert() executed
   ↓
5. Console: "Email saved successfully"
   ↓
6. User clicks "Saved Emails"
   ↓
7. openSavedEmailsModal() called
   ↓
8. fetchSavedEmails() returns array
   ↓
9. Modal renders list
```

If any step fails, console will show the error.

---

## Supabase Status Check

If you see errors about "Failed to fetch" or "Network error":

1. Go to https://supabase.com/
2. Login to your project
3. Check the "Status" indicator (green = good, red = down)
4. If down, wait for it to recover
5. If up but still failing, check:
   - Your internet connection
   - Browser developer tools Network tab
   - Look for CORS errors

---

## Still Not Working?

1. Open browser console (F12)
2. Copy the error message
3. Try these steps:
   - Logout and login again
   - Refresh the page (Ctrl+R)
   - Clear browser cache (Ctrl+Shift+Delete)
   - Try incognito/private mode

4. Check if database tables exist:
   - Supabase Dashboard → Table Editor
   - Should see "saved_emails" and "user_profiles"
   - If missing, run SQL from SUPABASE_SETUP.md

---

## Real-Time Testing

The console now logs every step, so you can:
1. Do an action (e.g., copy an email)
2. Watch console for the log messages
3. See exactly where it succeeds or fails

All logs start with the function name:
- `saveEmailVariation called with:`
- `Fetching saved emails...`
- `Email saved successfully:`
- etc.

---

## Contact Support

If you're stuck, check:
1. `IMPLEMENTATION_COMPLETE.md` - Full feature overview
2. `SUPABASE_SETUP.md` - Database setup guide
3. `QUICKSTART.md` - 15-minute setup guide
4. Browser console messages (most important!)
