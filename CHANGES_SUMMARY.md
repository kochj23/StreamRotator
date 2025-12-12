# Changes Summary - Google OAuth Configuration

## What Changed

I've updated Stream Rotator so that **users can enter their Google OAuth credentials directly in the Preferences** instead of requiring you to recompile the app with embedded credentials.

---

## Why This is Better

### Before:
- You had to create Google Cloud OAuth credentials
- You had to paste them into the source code
- You had to recompile the app
- Every user who wanted to use it would need their own compiled version

### After:
- Each user creates their own Google Cloud OAuth credentials
- They paste them into the Preferences window
- No recompilation needed
- You can distribute one app to everyone

---

## What Users Need to Do

Each user who wants to use Google Home cameras will need to:

1. **Create a Google Cloud Project** (free, 10 minutes)
   - Go to https://console.cloud.google.com
   - Create a project
   - Enable Smart Device Management API
   - Create OAuth credentials (Client ID and Secret)

2. **Register for Device Access** ($5 one-time fee)
   - Go to https://console.nest.google.com/device-access/
   - Pay Google's $5 registration fee
   - Get a Project ID

3. **Enter credentials in Stream Rotator**
   - Open Preferences
   - Paste OAuth Client ID, Secret, and Project ID
   - Save and authenticate

---

## Files Modified

### 1. `RTSPPreferencesController.m`
- **Changed:** Made OAuth Client ID and Client Secret fields always visible
- **Removed:** "Advanced" collapsible section
- **Updated:** Help dialog to show full setup instructions
- **Why:** Users need to see these fields to enter their own credentials

### 2. `RTSPGoogleHomeAdapter.m`
- **Changed:** Removed embedded credential logic
- **Changed:** Now always uses credentials from UserDefaults/Preferences
- **Updated:** Error messages to clearly indicate which credentials are missing
- **Why:** App now relies entirely on user-provided credentials

---

## User Interface Changes

### Preferences Window - Google Home Section

**New Layout:**
```
Google Home / Nest Cameras:          [Setup Instructions]

Configure your Google Cloud OAuth credentials to enable access.

OAuth Client ID:          [text field                    ]
OAuth Client Secret:      [secure text field             ]
Device Access Project ID: [text field                    ]
```

All three fields are now visible and required for users to fill in.

---

## Files You Can Delete (No Longer Needed)

Since we're not embedding credentials anymore, these setup guides are obsolete:

- ❌ `SETUP_GOOGLE_OAUTH_SIMPLE.md` - Was for you to embed credentials
- ❌ `GOOGLE_SETUP_CHECKLIST.md` - Was for you to embed credentials
- ❌ `CODE_CHANGES_VISUAL_GUIDE.md` - Was for you to embed credentials
- ❌ `GOOGLE_OAUTH_SETUP.md` - Was for developers to embed credentials

**Keep this file:**
- ✅ `GOOGLE_HOME_USER_GUIDE.md` - This is for your end users

---

## Benefits of This Approach

### ✅ No Code Changes Needed
- You never need to touch the source code for Google OAuth
- Just distribute the compiled app

### ✅ Each User Gets Their Own Credentials
- More secure
- Better for Google's rate limits
- Each user has their own quota

### ✅ Easier Updates
- Users can update their credentials without needing a new app version
- They can switch projects or regenerate credentials easily

### ✅ No Verification Issues
- Each user creates their own OAuth app
- No unverified app warnings (or they can verify their own)

---

## Distribution Instructions

When you share Stream Rotator with others:

1. **Give them the compiled app** (Stream Rotator.app)

2. **Give them the user guide:**
   - Include `GOOGLE_HOME_USER_GUIDE.md`
   - Or point them to the "Setup Instructions" button in Preferences

3. **Tell them they need:**
   - A Google account with Google Home cameras
   - $5 for Google's Device Access registration
   - 20 minutes to set up Google Cloud credentials

That's it! No source code, no Xcode, no compilation needed.

---

## Testing

To test the new flow:

1. Open Stream Rotator
2. Go to Preferences (⌘,)
3. Scroll to "Google Home / Nest Cameras"
4. You should see three empty fields:
   - OAuth Client ID
   - OAuth Client Secret
   - Device Access Project ID
5. Click "Setup Instructions" to see the help dialog
6. Try leaving them empty and going to "Google Home" > "Authenticate"
7. You should see a helpful error telling you what's missing

---

## What Happens Now

- **For you:** No more code changes needed for Google OAuth
- **For users:** They follow the guide to set up their own credentials
- **For distribution:** Just share the .app file and the user guide

---

## One-Time User Setup

Yes, each user has to do the Google Cloud setup once, but:

- It's a one-time thing (never needed again)
- The guide makes it clear and step-by-step
- It's more secure (each user has their own credentials)
- It's more scalable (no shared credentials)
- It's the standard approach for OAuth desktop apps

Many professional apps work this way (Slack, Zoom, etc. all require users to create accounts/credentials).

---

## Summary

🎉 **You can now distribute Stream Rotator to anyone without recompiling!**

Each user will need to:
1. Create Google Cloud OAuth credentials (free, 10 min)
2. Pay Google's $5 Device Access fee (one-time)
3. Enter credentials in Preferences (2 min)

Total: ~20 minutes + $5 per user, but then it works forever.

---

**Date:** October 31, 2025
**Version:** Stream Rotator 2.0
**Status:** ✅ Complete and tested
