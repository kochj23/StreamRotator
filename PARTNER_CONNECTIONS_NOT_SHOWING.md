# Partner Connections Not Showing - Deep Troubleshooting

## Your Situation

You've done everything correctly:
- ✅ Created Device Access project with OAuth Client ID
- ✅ It's been 20+ minutes
- ✅ Authentication works (valid token)
- ❌ Still doesn't show in Partner Connections
- ❌ Zero devices discovered

---

## Root Cause Analysis

There are only a few reasons why a Device Access project wouldn't show in Partner Connections:

1. **OAuth Consent Screen is in Testing mode** and you're not a test user
2. **OAuth Client ID doesn't match** between Google Cloud and Device Access
3. **Different Google accounts** used somewhere
4. **Google's backend hasn't synced** (rare, but possible)
5. **The Device Access project wasn't actually created successfully**

---

## Systematic Checklist

Let's verify EVERYTHING:

### **1. Verify OAuth Consent Screen**

**Go to:** https://console.cloud.google.com

**Steps:**
1. Select your "Stream Rotator" Google Cloud project
2. Go to "APIs & Services" > "OAuth consent screen"

**Check these:**
- [ ] Publishing status: Is it "Testing" or "In production"?
- [ ] If "Testing": Is kochj23@gmail.com in the "Test users" list?
- [ ] User type: Is it "External"?

**If it's in Testing mode without you as a test user:**
- Click "ADD USERS"
- Add: kochj23@gmail.com
- Click "SAVE"
- Wait 5 minutes
- Check Partner Connections again

**Try publishing to production:**
- Look for "PUBLISH APP" button
- Click it and confirm
- This removes test user restrictions

---

### **2. Verify OAuth Client ID Exactly Matches**

**In Google Cloud Console:**
- Go to "APIs & Services" > "Credentials"
- Click on your OAuth Client
- Copy the Client ID

**It should be EXACTLY:**
```
501320990197-kt228862f8d2j8916us5ru88o0m8rco2.apps.googleusercontent.com
```

**In Device Access Console:**
- Go to: https://console.nest.google.com/device-access/
- Click on your project
- Look at "Project Info"
- **Is the OAuth Client ID shown there?**
- **Does it EXACTLY match the one above?**

If they don't match or the Device Access console doesn't show the OAuth Client ID at all, that's your problem.

---

### **3. Check if Device Access Project Actually Exists**

**Go to:** https://console.nest.google.com/device-access/

**Do you see:**
- [ ] Your project listed (new one you just created)?
- [ ] Project ID matches what's in Stream Rotator?
- [ ] Project status is "Active" or similar?

**If you DON'T see your project:**
- The creation might have failed silently
- Try creating it again

---

### **4. Direct API Test - Check What Google Says**

Let's see what Google's API actually returns.

**Open Terminal and run:**

```bash
# Replace YOUR_TOKEN with your actual token from Status window
curl -v -H "Authorization: Bearer YOUR_TOKEN" \
"https://smartdevicemanagement.googleapis.com/v1/enterprises/c3a514f6-370b-4e84-9cf1-5bcc1020a76d/structures"
```

**Also test devices:**
```bash
curl -v -H "Authorization: Bearer YOUR_TOKEN" \
"https://smartdevicemanagement.googleapis.com/v1/enterprises/c3a514f6-370b-4e84-9cf1-5bcc1020a76d/devices"
```

**What to look for:**
- HTTP status code (200, 403, 404, etc.)
- Response body
- Any error messages

**Possible responses:**

**If Project ID is wrong:**
```json
{
  "error": {
    "code": 404,
    "message": "Requested entity was not found."
  }
}
```

**If no devices authorized:**
```json
{
  "structures": [],
  "devices": []
}
```

**If permission issue:**
```json
{
  "error": {
    "code": 403,
    "message": "The caller does not have permission"
  }
}
```

---

### **5. Try Console.app Logs**

**Open Console.app**, search for "GoogleHome", and try discovering cameras.

**Look for these specific lines:**
```
[GoogleHome] Structures API Response: {...}
[GoogleHome] API Response: {...}
[GoogleHome] API Response Status: XXX
```

**Send me these responses!** They'll tell us exactly what Google is saying.

---

## **Alternative Theory: Google Changed Their API**

It's possible Google changed how Device Access works. Let me check if we need to use a different registration process:

### **Check Google's Current Documentation:**

1. **Go to:**
   ```
   https://developers.google.com/nest/device-access/get-started
   ```

2. **Read the "Register for Device Access" section**

3. **Check if there are new requirements or steps**

4. **See if the registration flow changed**

---

## **Nuclear Option: Start Completely Fresh**

If nothing above works, let's start from scratch:

### **Delete Everything:**
1. Delete Device Access project
2. Delete OAuth Client ID in Google Cloud
3. Delete OAuth Consent Screen settings

### **Start Over:**
1. Create Google Cloud project (fresh)
2. Enable Smart Device Management API
3. Set up OAuth consent screen (External, add yourself as test user)
4. Create OAuth Client ID (Desktop app)
5. Create Device Access project (with OAuth Client ID)
6. Update Stream Rotator with new credentials

---

## **What I Need From You:**

Please check and tell me:

1. **OAuth Consent Screen status:**
   - Testing or Production?
   - Are you listed as a test user (if Testing)?

2. **Device Access Console:**
   - When you click on your project, does it show the OAuth Client ID anywhere?
   - Any fields or settings you can click?

3. **Console.app logs:**
   - What does `[GoogleHome] API Response:` show?
   - What does `[GoogleHome] Structures API Response:` show?

4. **Direct curl test:**
   - What does the structures endpoint return?
   - What does the devices endpoint return?

With this information, I can tell you exactly what's misconfigured! 🔍
