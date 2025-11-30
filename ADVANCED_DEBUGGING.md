# Advanced Debugging Guide

For users who want to understand what's happening under the hood.

## Browser Console Debugging

### Access the Console

1. **Windows:** Press `F12` or `Ctrl+Shift+I`
2. **Mac:** Press `Cmd+Option+I`
3. Look for "Console" tab (usually 2nd tab)
4. You'll see all logs, warnings, and errors here

### Reading Console Messages

**Blue messages:** Informational logs (what the app is doing)
```
fetchSavedEmails - userId: 123abc authToken exists: true
Querying saved_emails for user: 123abc
Fetched emails: Array(3)
```

**Red messages:** Errors that happened
```
Error saving email: {code: "PGRST116", message: "...duplicate..."}
Error deleting email: {code: "42P01", message: "relation "saved_emails" does not exist"}
```

**Yellow messages:** Warnings
```
[Warning] Something might be wrong
```

---

## Common Error Codes

### PGRST116 - Duplicate Key
**Meaning:** Email already saved  
**Action:** Automatically handled - shows "Email already saved!" notification

### 42P01 - Relation Does Not Exist
**Meaning:** Table doesn't exist in database  
**What to do:** Run SQL from SETUP_DATABASE.md to create tables

### 42501 - Permission Denied
**Meaning:** RLS policy is blocking the operation  
**What to do:** 
1. Go to Supabase
2. Table Editor → Select table
3. Policies tab → Check all 3 policies are enabled
4. Try again

### 401 - Unauthorized (JWT)
**Meaning:** Auth token invalid or expired  
**What to do:** Logout → Login again

---

## Step-by-Step: Debugging Email Save

When you click "Copy Email" and it doesn't save:

### 1. Check Authentication
**In Console:**
```javascript
console.log(sessionStorage.getItem('userId'))
console.log(sessionStorage.getItem('authToken'))
```

**Expected output:**
- userId: A string like `"f47ac10b-58cc-4372-a567-0e02b2c3d479"`
- authToken: A long JWT token starting with `eyJ`

**If missing:** User isn't logged in. Login first.

### 2. Check Database Connection
**In Console:**
```javascript
// Verify Supabase is initialized
console.log(window.supabase)
```

**Expected output:** Supabase client object with methods like `from()`, `auth()`, etc.

**If undefined:** JavaScript failed to load Supabase library.

### 3. Try Manual Save Test
**In Console:**
```javascript
// Manually test save function
saveEmailVariation('test.variation@gmail.com')
```

**Expected output:** 
- Green success notification appears
- Console shows: `Email saved successfully: [object Object]`
- Email appears in "Saved Emails" modal

**If error:** Check error message for specific issue (see Error Codes above).

---

## Step-by-Step: Debugging Email Load

When "Saved Emails" button doesn't show your emails:

### 1. Check You're Logged In
```javascript
console.log(sessionStorage.getItem('userId'))
```

**Should show a user ID**, not `null` or `undefined`.

### 2. Check Table Exists
Go to: https://lwmidjhyrlswpfjnyxrqs.supabase.co
- Table Editor on left
- Look for `saved_emails` table
- If it doesn't exist → Run SQL from SETUP_DATABASE.md

### 3. Manually Query Your Emails
**In Console:**
```javascript
// Get your user ID first
const userId = sessionStorage.getItem('userId')
console.log('My user ID:', userId)

// Query emails for this user
const { data, error } = await supabase
  .from('saved_emails')
  .select('*')
  .eq('user_id', userId)

console.log('Query result:', data)
console.log('Query error:', error)
```

**Expected output:**
- `data`: Array like `[{id: "123", email: "test.variation@gmail.com", created_at: "2025-01-15T10:30:00Z"}, ...]`
- `error`: `null` or `undefined`

**If error:**
- `"relation does not exist"` → Create tables with SQL
- `"permission denied"` → Enable RLS policies
- Other → Check error message below

### 4. Check RLS Policies
Go to: https://lwmidjhyrlswpfjnyxrqs.supabase.co
- Table Editor → saved_emails
- Click "Policies" tab
- Should see 3 policies with green checkmarks:
  - SELECT - Enabled
  - INSERT - Enabled
  - DELETE - Enabled

If any show "Disabled", click to enable them.

---

## Step-by-Step: Debugging Email Delete

When you can't delete a saved email:

### 1. Get Email ID
**In Console:**
```javascript
// Fetch your emails first
const userId = sessionStorage.getItem('userId')
const { data } = await supabase
  .from('saved_emails')
  .select('*')
  .eq('user_id', userId)

console.log('Emails:', data)
// Look for the email you want to delete
// Copy its ID value
```

### 2. Try Manual Delete
**In Console:**
```javascript
// Replace "email-id-here" with actual ID
const { data, error } = await supabase
  .from('saved_emails')
  .delete()
  .eq('id', 'email-id-here')

console.log('Delete result:', data)
console.log('Delete error:', error)
```

**Expected output:**
- `data`: Object `{}`
- `error`: `null` or `undefined`

**If error:**
- `"relation does not exist"` → Tables not created
- `"permission denied"` → DELETE policy not enabled
- Other → See error codes section

---

## Network Debugging

### Check API Calls

1. Open DevTools: F12
2. Go to "Network" tab
3. Try an action (save, load, delete)
4. Look for requests to `lwmidjhyrlswpfjnyxrqs.supabase.co`

**Each request should show:**
- Status: 200 (success) or 4xx/5xx (error)
- Response: JSON with data or error details

### If Requests Fail

**Status 401:** Authentication issue
- Token expired → Logout/login
- Wrong API key → Check SUPABASE_SETUP.md

**Status 403:** Permission denied
- RLS policies blocking → Check Supabase policies tab
- User doesn't have access → Check user_id matches

**Status 404:** Resource not found
- Table doesn't exist → Run SQL from SETUP_DATABASE.md
- Wrong table name → Check spelling

---

## Inspecting Saved Data

### View All Your Emails in Database

Go to: https://lwmidjhyrlswpfjnyxrqs.supabase.co
1. Click "Table Editor"
2. Click "saved_emails"
3. See all emails there
4. Can manually delete or edit

### View Your User Profile

Go to: https://lwmidjhyrlswpfjnyxrqs.supabase.co
1. Click "Table Editor"
2. Click "user_profiles"
3. Find your user_id
4. See your profile data

---

## Testing Without Database

### Test Locally (No Supabase Needed)

The app has built-in test modes:

**Test Account (Always Works):**
- Email: `test@test.com`
- Password: `test123`
- Uses localStorage (browser storage)
- Emails persist on this device
- No database required

**Local Account:**
1. Click "Sign Up"
2. Create any email/password
3. Uses localStorage instead of Supabase
4. Works without database setup

### Test Features Separately

**Just test email generation:**
- No login needed
- Just click "Generate variation"
- Copy email to clipboard
- Works fine

**Test login:**
- Click "Login"
- Try test account
- Should succeed

**Test saving:**
- Login with test account
- Copy an email
- Click "Saved Emails"
- Should show email (after database is set up)

---

## Performance Monitoring

### Check Request Times

1. Open Console (F12)
2. Look for messages like:
   - `saveEmailVariation took 0.5s`
   - `fetchSavedEmails took 1.2s`
3. Times > 3 seconds usually mean network issues

### Check Storage Usage

**In Console:**
```javascript
// Check sessionStorage (login data)
console.log('Session storage:', sessionStorage)

// Check localStorage (saved accounts)
console.log('Local storage:', localStorage)
```

**SessionStorage should contain:**
- `userId`: Your user ID
- `authToken`: Your JWT token
- `userEmail`: Your email

---

## Clearing Diagnostic Data

### Clear Everything and Start Fresh

**Option 1 - Using DevTools:**
1. Open DevTools (F12)
2. Go to "Application" tab
3. Click "Clear site data"
4. Refresh page

**Option 2 - Using Console:**
```javascript
// Clear session
sessionStorage.clear()

// Clear local storage
localStorage.clear()

// Reload
location.reload()
```

This clears:
- Login session (userId, authToken)
- Saved local accounts
- Browser cache
- All cookies

---

## Reporting Issues

When something doesn't work, gather this info:

1. **Error message visible on screen** (screenshot)
2. **Console logs** (F12 → Console → Copy all text)
3. **What you were trying to do**
4. **What you expected to happen**
5. **What actually happened**

**Include console output:**
- Right-click console
- Select "Save as..."
- Share the file

---

## Common Debugging Patterns

### Pattern: "Nothing happens when I click"
- Check browser console (F12)
- Look for red error messages
- If none → Button might be disabled or JavaScript didn't load

### Pattern: "I see a notification but data isn't saved"
- Check browser console
- Look for "Error:" messages
- Note the specific error text
- Compare to error codes section above

### Pattern: "Works in one browser but not another"
- Might be browser storage issue
- Try clearing cache (Ctrl+Shift+Delete)
- Check browser cookies/storage enabled
- Try private/incognito window

### Pattern: "Works for test@test.com but not my account"
- Check user_id exists in database
- Check RLS policies reference correct field
- Try logout → login

---

## Advanced: Network Request Details

### Supabase API Format

Each request to Supabase looks like:
```
POST https://lwmidjhyrlswpfjnyxrqs.supabase.co/rest/v1/saved_emails
Headers:
  - Authorization: Bearer [JWT_TOKEN]
  - apikey: [ANON_KEY]
Body: {
  "user_id": "123abc",
  "email": "variation@gmail.com",
  "created_at": "2025-01-15T10:30:00Z"
}
Response:
  - Success: {id: "456def", ...}
  - Error: {code: "PGRST116", message: "..."}
```

### Verify API Key is Loaded

**In Console:**
```javascript
// Check if Supabase is initialized with correct key
console.log(window.supabase.supabaseUrl)
console.log(window.supabase.supabaseKey)
```

**Should show:**
- URL: `https://lwmidjhyrlswpfjnyxrqs.supabase.co`
- Key: Starting with `eyJ` (JWT format)

---

## When You're Stuck

1. **Try test account:** `test@test.com` / `test123`
2. **Clear everything:** F12 → Application → Clear site data
3. **Check basic stuff:**
   - Database tables created? (Supabase Table Editor)
   - RLS policies enabled? (Supabase Policies tab)
   - Are you logged in? (Console check)
   - Is error specific or generic? (Compare to error codes)
4. **Read full guides:** TROUBLESHOOTING.md and ERROR_MESSAGES.md
5. **Check DevTools:** Console, Network, and Application tabs for clues

---

Last Updated: 2025  
For simpler help, see TROUBLESHOOTING.md or ERROR_MESSAGES.md
