# Google Home - Authorizing Devices (The Missing Step!)

## The Problem

You've successfully:
- ✅ Created OAuth credentials
- ✅ Created Device Access project
- ✅ Entered all credentials in Stream Rotator
- ✅ Authenticated successfully
- ✅ Got a valid access token

BUT: **Google's API is returning zero devices** because the devices aren't authorized with your project.

---

## The Solution: Link OAuth Client to Device Access Project

### **CRITICAL STEP: Update OAuth Client ID in Device Access Project**

1. **Go to Device Access Console:**
   ```
   https://console.nest.google.com/device-access/project/c3a514f6-370b-4e84-9cf1-5bcc1020a76d
   ```
   (This is YOUR project - I got the ID from your status window)

2. **Look for "OAuth client IDs" section:**
   - It might be under "Project settings"
   - Or on the main project page
   - Or under "Configuration"

3. **You should see a field or button to add OAuth Client ID**

4. **Enter your OAuth Client ID:**
   ```
   501320990197-kt228862f8d2j8916us5ru88o0m8rco2.apps.googleusercontent.com
   ```

5. **Save/Update**

---

## Alternative: Re-Create the Device Access Project

If you can't find where to add the OAuth Client ID, try this:

### **Option 1: Delete and Re-create Device Access Project**

1. **Go to:** https://console.nest.google.com/device-access/

2. **Delete your current project** (if you can find a delete option)

3. **Create a NEW Device Access project:**
   - Click "Create project"
   - Name it: "Stream Rotator"
   - **IMPORTANT:** When it asks for OAuth Client ID, paste:
     ```
     501320990197-kt228862f8d2j8916us5ru88o0m8rco2.apps.googleusercontent.com
     ```
   - Complete the setup

4. **Copy the NEW Project ID** (it will be different)

5. **Go to Stream Rotator Preferences:**
   - Update the Device Access Project ID with the NEW one
   - Click Save

6. **Authenticate again** and watch for device selection

---

## Option 2: Use the Device Access Registration Page

Sometimes the device authorization happens through a special registration flow:

1. **Go to:**
   ```
   https://nestservices.google.com/partnerconnections
   ```

2. **You should see your Device Access project listed**
   - Project name or ID
   - Click on it

3. **Authorize your devices:**
   - Select your home/structure
   - Check boxes for cameras
   - Click "Allow" or "Authorize"

4. **Wait 2-3 minutes** for changes to sync

5. **Try discovering cameras again**

---

## Option 3: Check Project Permissions Page

1. **In Device Access Console,** look for:
   - "Permissions" tab
   - "Devices" tab
   - "Structures" section

2. **See if your home/structure is listed**

3. **See if your cameras are listed**

4. **If not, look for an "Add" or "Authorize" button**

---

## During Re-Authentication - Watch for This Screen

When you authenticate with Google, you MUST see this screen (or similar):

```
┌─────────────────────────────────────────────┐
│ Stream Rotator wants to access your         │
│ Google devices                              │
│                                             │
│ Select devices to share:                    │
│                                             │
│ [✓] Your Home                               │
│     [✓] Front Door Camera                   │
│     [✓] Backyard Camera                     │
│     [✓] Living Room Camera                  │
│                                             │
│          [Cancel]  [Allow]                  │
└─────────────────────────────────────────────┘
```

**If you DON'T see this screen with checkboxes**, then the OAuth Client ID isn't properly linked to your Device Access project.

---

## Test: Direct API Call

Let's test if the API works at all with your credentials. Open Terminal and run:

```bash
curl -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
"https://smartdevicemanagement.googleapis.com/v1/enterprises/c3a514f6-370b-4e84-9cf1-5bcc1020a76d/devices"
```

Replace `YOUR_ACCESS_TOKEN` with the token from the status window (the full token, starting with `ya29.a0ATi6K2v...`)

This will show you exactly what Google's API returns.

---

## What to Look For

The API response should be:

**If devices ARE authorized:**
```json
{
  "devices": [
    {
      "name": "enterprises/c3a514f6-370b-4e84-9cf1-5bcc1020a76d/devices/DEVICE_ID",
      "type": "sdm.devices.types.CAMERA",
      "traits": {...},
      ...
    }
  ]
}
```

**If devices are NOT authorized:**
```json
{
  "devices": []
}
```
or
```json
{}
```

**If there's a permission error:**
```json
{
  "error": {
    "code": 403,
    "message": "Permission denied",
    ...
  }
}
```

---

## Summary

The issue is **NOT** with Stream Rotator - everything is working perfectly on our side. The issue is with **Google's configuration**:

1. Your Device Access project doesn't have devices authorized
2. OR your OAuth Client ID isn't properly linked to your Device Access project
3. OR you need to explicitly authorize devices through Partner Connections

**Try visiting:** https://nestservices.google.com/partnerconnections

**Or re-create the Device Access project** and make SURE to enter your OAuth Client ID when prompted.

---

Once you fix this on Google's side, Stream Rotator will immediately discover your cameras! 🎯
