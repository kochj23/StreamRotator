# Fix OAuth "Invalid Request" Error

## What I Fixed

I updated Stream Rotator to use the modern OAuth redirect URI. Google deprecated the old method (`urn:ietf:wg:oauth:2.0:oob`) which was causing the "invalid request" error.

**New redirect URI:** `http://127.0.0.1:8080/oauth2callback`

---

## What YOU Need to Do (2 Minutes)

You need to add this redirect URI to your OAuth Client in Google Cloud Console.

---

## STEP-BY-STEP INSTRUCTIONS

### **Step 1: Go to Google Cloud Console**

1. **Open your browser and go to:**
   ```
   https://console.cloud.google.com
   ```

2. **Sign in with kochj23@gmail.com** (if not already signed in)

3. **Select your "Stream Rotator" project** (click the project dropdown at top)

---

### **Step 2: Open OAuth Client Settings**

1. **On the left menu, click:**
   ```
   APIs & Services > Credentials
   ```

2. **You'll see your OAuth 2.0 Client ID listed**
   - Name: "Stream Rotator Client" (or whatever you named it)
   - Type: Desktop app
   - Client ID: 501320990197-kt228862f8d2j8916us5ru88o0m8rco2.apps.googleusercontent.com

3. **Click on it** (click on the name)

---

### **Step 3: Add Redirect URI**

1. **You should see the OAuth client details page**

2. **Look for a section called "Authorized redirect URIs"**
   - It might be empty
   - Or it might already have some URIs

3. **Click "+ ADD URI" or "ADD URI"** (there's a button)

4. **A text field will appear**

5. **Type THIS EXACT URI:**
   ```
   http://127.0.0.1:8080/oauth2callback
   ```

   **⚠️ IMPORTANT:**
   - Use `http://` NOT `https://`
   - Use `127.0.0.1` NOT `localhost`
   - Use port `8080`
   - Use `/oauth2callback` as the path
   - No spaces before or after!

6. **Click "SAVE"** at the bottom of the page

7. **Wait for the "OAuth client updated" success message**

---

### **Step 4: Wait and Test**

1. **Wait 2-3 minutes** for Google to update

2. **Go back to Stream Rotator**

3. **Try "Google Home" > "Authenticate with Google..."**

4. **The authentication should work now!**

---

## Visual Reference

After adding the redirect URI, your OAuth Client should show:

```
┌────────────────────────────────────────────────────┐
│ OAuth client details                               │
├────────────────────────────────────────────────────┤
│ Client ID:                                         │
│ 501320990197-kt228862f8d2j8916us5ru88o0m8rco2...  │
│                                                    │
│ Client secret:                                     │
│ GOCSPX-Pd7...                                      │
│                                                    │
│ Application type:                                  │
│ Desktop app                                        │
│                                                    │
│ Authorized redirect URIs:                          │
│ • http://127.0.0.1:8080/oauth2callback             │  ← Must have this!
│                                                    │
└────────────────────────────────────────────────────┘
```

---

## Why This Fix Works

**Old way (deprecated):**
- Used `urn:ietf:wg:oauth:2.0:oob`
- Google deprecated this in 2022
- Causes "invalid request" error

**New way (modern):**
- Uses `http://127.0.0.1:8080/oauth2callback`
- Google opens browser, redirects to localhost
- Stream Rotator captures the authorization code from the callback
- This is the current standard for desktop apps

---

## After You Add the Redirect URI

Once you've added the redirect URI and waited 2-3 minutes:

1. **Try authenticating in Stream Rotator**
2. **You should now see the device selection screen during OAuth!**
3. **Select your cameras** (check the boxes)
4. **Complete authentication**
5. **Try "Discover Cameras"**
6. **Your cameras should appear!**

---

## If You Still Don't See Device Selection

Even after fixing the OAuth flow, if you don't see a device selection screen with checkboxes, it means:

- The OAuth Client ID still isn't properly linked to your Device Access project
- You may need to wait longer for Google to sync
- Or the Device Access project needs to be re-created one more time

But fix the redirect URI first - that's definitely causing the "invalid request" error!

---

**TL;DR:**
1. Go to Google Cloud Console
2. Click on your OAuth Client
3. Add redirect URI: `http://127.0.0.1:8080/oauth2callback`
4. Click Save
5. Wait 2-3 minutes
6. Try authenticating again in Stream Rotator

🔧 **This should fix the "invalid request" error!**
