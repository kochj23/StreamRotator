# Google OAuth Setup - Quick Checklist

Print this and check off each step as you complete it!

---

## 🎯 Goal
Get two codes from Google (Client ID and Client Secret) and put them in your app.

---

## 📋 Checklist

### STEP 1: Create Google Cloud Project
- [ ] Go to https://console.cloud.google.com
- [ ] Sign in with your Google account
- [ ] Click the project dropdown at the top
- [ ] Click "NEW PROJECT"
- [ ] Name it: `Stream Rotator`
- [ ] Click "CREATE"
- [ ] Wait for project to be created

---

### STEP 2: Enable Smart Device Management API
- [ ] Click "APIs & Services" on the left menu
- [ ] Click "Library"
- [ ] Search for: `Smart Device Management API`
- [ ] Click on the API result
- [ ] Click "ENABLE"
- [ ] Wait for it to enable

---

### STEP 3: Set Up OAuth Consent Screen
- [ ] Click "APIs & Services" > "OAuth consent screen"
- [ ] Choose "External"
- [ ] Click "CREATE"

**Page 1:**
- [ ] App name: `Stream Rotator`
- [ ] User support email: (your email)
- [ ] Developer contact: (your email)
- [ ] Click "SAVE AND CONTINUE"

**Page 2:**
- [ ] Click "SAVE AND CONTINUE" (don't add anything)

**Page 3:**
- [ ] Click "+ ADD USERS"
- [ ] Enter your email
- [ ] Click "ADD"
- [ ] Click "SAVE AND CONTINUE"

**Page 4:**
- [ ] Click "BACK TO DASHBOARD"

---

### STEP 4: Create OAuth Credentials
- [ ] Click "APIs & Services" > "Credentials"
- [ ] Click "+ CREATE CREDENTIALS"
- [ ] Choose "OAuth client ID"
- [ ] Application type: "Desktop app"
- [ ] Name: `Stream Rotator Client`
- [ ] Click "CREATE"

**IMPORTANT - Copy These:**
- [ ] Copy the Client ID (ends with .apps.googleusercontent.com)
- [ ] Copy the Client Secret (starts with GOCSPX-)

📝 **Write them here temporarily:**
```
Client ID: _______________________________________________

Client Secret: ___________________________________________
```

---

### STEP 5: Put Credentials in Your App
- [ ] Open Xcode
- [ ] Open Stream Rotator project
- [ ] Find file: `RTSPGoogleHomeAdapter.m`
- [ ] Press ⌘F, search for: `YOUR_CLIENT_ID`
- [ ] Replace `YOUR_CLIENT_ID.apps.googleusercontent.com` with your real Client ID
- [ ] Keep the `@"` and `"` around it
- [ ] Press ⌘F, search for: `YOUR_CLIENT_SECRET`
- [ ] Replace `YOUR_CLIENT_SECRET` with your real Client Secret
- [ ] Keep the `@"` and `"` around it
- [ ] Press ⌘S to save

---

### STEP 6: Rebuild App
- [ ] Press ⌘B in Xcode (or Product > Build)
- [ ] Wait for "Build Succeeded"

---

### STEP 7: Test It
- [ ] Quit Stream Rotator (⌘Q)
- [ ] Reopen Stream Rotator
- [ ] Go to Preferences (⌘,)
- [ ] Look for "Google Home / Nest Cameras" section
- [ ] Verify you see the simplified interface

---

## ✅ Done!

You've successfully set up Google OAuth credentials in your app!

Your users will now only need to:
1. Get their Device Access Project ID from Google ($5)
2. Paste it in Preferences
3. Click "Authenticate"

---

## 🆘 Emergency Info

**If you need to find your credentials again:**
1. Go to https://console.cloud.google.com
2. Select your "Stream Rotator" project
3. Go to "APIs & Services" > "Credentials"
4. Click on "Stream Rotator Client"
5. Your Client ID and Secret are shown there

**Files you modified:**
- `/Users/kochj/Desktop/xcode/Stream Rotator/Stream Rotator/RTSPGoogleHomeAdapter.m`

**Lines you changed:**
- Around line 118: Client ID
- Around line 123: Client Secret

---

**Setup Date:** ________________

**Status:** [ ] Complete
