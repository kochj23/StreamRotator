# Google Home Camera Discovery - Debugging Guide

## What I've Done

I've added detailed debug logging to the camera discovery code. This will help us see exactly what's happening when you try to discover cameras.

---

## How to See the Debug Logs

### **Method 1: Using Console.app (Easiest)**

1. **Open Console.app:**
   - Press **⌘+Space** to open Spotlight
   - Type **"Console"**
   - Press Enter

2. **Filter for Stream Rotator logs:**
   - In the search box at the top right, type: **GoogleHome**
   - Or type: **Stream Rotator**

3. **Keep Console.app open**

4. **Go back to Stream Rotator and try discovering cameras:**
   - Click **"Google Home"** menu > **"Discover Cameras"**

5. **Watch the Console.app window** - you'll see log messages appear in real-time

---

### **Method 2: Using Terminal**

1. **Open Terminal**

2. **Run this command:**
   ```bash
   log stream --predicate 'processImagePath contains "Stream Rotator"' --level debug
   ```

3. **Keep Terminal open**

4. **Go back to Stream Rotator and try discovering cameras**

5. **Watch Terminal** - you'll see all the log messages

---

## What to Look For in the Logs

When you click "Discover Cameras", you should see messages like:

```
[GoogleHome] Discovering cameras...
[GoogleHome] Using Project ID: 12345678-abcd-1234-abcd-123456789012
[GoogleHome] API Endpoint: https://smartdevicemanagement.googleapis.com/v1/enterprises/12345678-abcd-1234-abcd-123456789012/devices
[GoogleHome] Access Token: ya29.a0AfH6SMBd...
[GoogleHome] API Response Status: 200
[GoogleHome] API Response: {...}
[GoogleHome] Devices array from API: (...)
[GoogleHome] Discovered X cameras
```

---

## Common Issues and What the Logs Will Show

### **Issue 1: Wrong Project ID Format**

**Logs might show:**
```
[GoogleHome] API Response Status: 404
[GoogleHome] API Error: Project not found
```

**Solution:**
- Your Project ID might be wrong
- It should look like: `12345678-abcd-1234-abcd-123456789012`
- NOT the project NAME, but the project ID (UUID format)

---

### **Issue 2: No Devices Linked to Project**

**Logs might show:**
```
[GoogleHome] API Response Status: 200
[GoogleHome] API Response: {}
[GoogleHome] Devices array from API: (null)
[GoogleHome] Discovered 0 cameras
```

**Solution:**
You need to **authorize your cameras** with your Device Access project:

1. Go to: https://nestservices.google.com/partnerconnections
2. You should see your Device Access project listed
3. Click on it and authorize your cameras
4. Select which cameras to share with the project

---

### **Issue 3: Wrong OAuth Scopes**

**Logs might show:**
```
[GoogleHome] API Response Status: 403
[GoogleHome] API Error: Insufficient permissions
```

**Solution:**
- The OAuth scope might be wrong
- Make sure during authentication you granted ALL permissions
- Try authenticating again and accept all permission requests

---

### **Issue 4: Invalid/Expired Access Token**

**Logs might show:**
```
[GoogleHome] API Response Status: 401
[GoogleHome] API Error: Invalid credentials
```

**Solution:**
- Your access token might have expired
- Try authenticating again:
  - "Google Home" > "Authenticate with Google..."

---

### **Issue 5: API Not Enabled**

**Logs might show:**
```
[GoogleHome] API Response Status: 403
[GoogleHome] API Error: Smart Device Management API has not been enabled
```

**Solution:**
- Go to Google Cloud Console
- Make sure "Smart Device Management API" is enabled
- Wait a few minutes and try again

---

## Quick Test Steps

1. **Open Console.app** (or Terminal with the log command)

2. **Filter for "GoogleHome"**

3. **In Stream Rotator:**
   - Go to "Google Home" menu
   - Click "Discover Cameras"

4. **Look at the logs** and copy them

5. **Send me the logs** so I can see exactly what's happening

---

## Most Likely Issue: Devices Not Linked to Project

The most common reason for "0 cameras found" is that you haven't authorized your cameras with your Device Access project.

### **How to Fix:**

1. **Go to Partner Connections:**
   - Visit: https://nestservices.google.com/partnerconnections
   - Sign in with your Google account

2. **You should see your Device Access project listed:**
   - Project name: Whatever you named it
   - Click on it

3. **Authorize devices:**
   - You'll see a list of your Google Home structures (homes)
   - Select your home
   - Click "Allow" or "Authorize"
   - Select which cameras you want to share

4. **Wait a few minutes** for the authorization to propagate

5. **Try discovering cameras again in Stream Rotator**

---

## What I Need From You

Please run the camera discovery with Console.app or Terminal open, and send me:

1. **The exact log output** - copy/paste everything with `[GoogleHome]` in it

2. **Specifically these lines:**
   - `[GoogleHome] API Response Status: XXX`
   - `[GoogleHome] API Response: {...}`
   - `[GoogleHome] Discovered X cameras`

This will tell me exactly what Google's API is returning and why it's finding zero cameras.

---

## Alternative: Check Directly in Device Access Console

You can also verify your setup:

1. **Go to:** https://console.nest.google.com/device-access/

2. **Click on your project**

3. **Look for:**
   - Are any devices listed?
   - Is the OAuth Client ID correct?
   - Is the project status "Active"?

4. **Check the "Devices" tab:**
   - Does it show your cameras?
   - If not, you need to authorize them via Partner Connections

---

## Quick Checklist

- [ ] Smart Device Management API is enabled in Google Cloud Console
- [ ] OAuth Client ID matches between Google Cloud and Device Access projects
- [ ] You've authorized your devices at https://nestservices.google.com/partnerconnections
- [ ] Your cameras are online and working in the Google Home app
- [ ] You've waited a few minutes after authorization for changes to propagate
- [ ] You're using the Project ID (UUID format), not the project name

---

**Once you run the discovery and check the logs, send me the output and I can tell you exactly what's wrong!** 🔍
