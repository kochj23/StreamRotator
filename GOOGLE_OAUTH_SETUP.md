# Google OAuth Credentials Setup for Developers

## Overview

Stream Rotator now has **embedded OAuth credentials** to simplify the setup process for end users. Instead of requiring each user to create their own Google Cloud Project and OAuth credentials, the app provides pre-configured credentials.

Users only need to:
1. Pay Google's $5 Device Access registration fee (one-time)
2. Create a Device Access project and get their Project ID
3. Enter the Project ID in Stream Rotator
4. Click "Authenticate" and sign in with Google

## Developer Setup: Creating OAuth Credentials

As the developer, you need to create OAuth credentials that will be embedded in the app:

### Step 1: Create Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Click the project dropdown at the top
3. Click "New Project"
4. Name it "Stream Rotator" (or your preferred name)
5. Click "Create"

### Step 2: Enable Smart Device Management API

1. In the Cloud Console, go to "APIs & Services" > "Library"
2. Search for "Smart Device Management API"
3. Click on it and click "Enable"

### Step 3: Configure OAuth Consent Screen

1. Go to "APIs & Services" > "OAuth consent screen"
2. Choose "External" (unless you have a Google Workspace)
3. Click "Create"
4. Fill in the required information:
   - App name: "Stream Rotator"
   - User support email: Your email
   - Developer contact email: Your email
5. Click "Save and Continue"
6. On the Scopes page, click "Save and Continue" (default scopes are fine)
7. On the Test users page, add yourself as a test user
8. Click "Save and Continue"

### Step 4: Create OAuth Client ID

1. Go to "APIs & Services" > "Credentials"
2. Click "+ CREATE CREDENTIALS" > "OAuth client ID"
3. Choose "Desktop app" as the application type
4. Name it "Stream Rotator Desktop Client"
5. Click "Create"
6. **IMPORTANT**: Copy the Client ID and Client Secret that are displayed

### Step 5: Update the Code

Open `Stream Rotator/RTSPGoogleHomeAdapter.m` and replace the placeholder values:

```objc
// Around line 118-123
if (!clientID || clientID.length == 0) {
    // Replace with your actual Client ID
    clientID = @"123456789012-abcdefghijklmnopqrstuvwxyz1234.apps.googleusercontent.com";
}

if (!clientSecret || clientSecret.length == 0) {
    // Replace with your actual Client Secret
    clientSecret = @"GOCSPX-AbCdEfGhIjKlMnOpQrStUvWxYz";
}
```

### Step 6: Rebuild the App

```bash
cd "/Users/kochj/Desktop/xcode/Stream Rotator"
xcodebuild -project "Stream Rotator.xcodeproj" -scheme "Stream Rotator" -configuration Release clean build
```

## User Setup (After You've Embedded Credentials)

Once you've embedded the OAuth credentials in the app, your users will have a much simpler setup process:

1. **Register for Device Access** (one-time $5 fee):
   - Go to https://console.nest.google.com/device-access/
   - Click "Get Started"
   - Pay the $5 registration fee

2. **Create a Device Access Project**:
   - Click "Create project"
   - Name it (e.g., "My Home")
   - Copy the Project ID (looks like: `12345678-abcd-1234-abcd-123456789012`)

3. **Configure Stream Rotator**:
   - Open Stream Rotator
   - Go to Preferences (⌘,)
   - Scroll to "Google Home / Nest Cameras"
   - Paste the Project ID
   - Click "Save"

4. **Authenticate**:
   - Go to Google Home menu > "Authenticate with Google"
   - Sign in with your Google account
   - Grant the requested permissions
   - Your cameras will be automatically discovered!

## Security Considerations

### Embedded Credentials

- **OAuth Client ID and Secret are not highly sensitive** for desktop apps since they're already visible in network traffic
- Google's OAuth flow requires user consent, so embedded credentials can't be misused without user permission
- This is a common pattern for desktop applications (e.g., VS Code, many email clients)

### Best Practices

1. **Don't commit credentials to public repositories** if you plan to open-source this
2. Consider using environment variables or build-time configuration for credentials
3. The Device Access Project ID is user-specific and never shared

### Alternative: User-Provided Credentials

If you prefer not to embed credentials, users can still provide their own:
1. Open Preferences
2. Expand "Advanced: Use Custom OAuth Credentials"
3. Enter their own Client ID and Client Secret
4. Enter their Device Access Project ID
5. Save and authenticate

## Troubleshooting

### "Missing required parameter: client_id" Error

This means the embedded credentials haven't been set yet. Update lines 118-123 in `RTSPGoogleHomeAdapter.m` with your actual credentials.

### "Missing Device Access Project ID" Error

The user needs to:
1. Visit https://console.nest.google.com/device-access/
2. Register and pay the $5 fee
3. Create a project and copy the Project ID
4. Enter it in Stream Rotator preferences

### OAuth Verification Error

If Google shows a warning about an unverified app:
1. This is normal for apps in testing mode
2. Users can click "Advanced" > "Go to Stream Rotator (unsafe)"
3. To remove this warning, you need to submit your app for OAuth verification (requires Google review)

## Rate Limits and Quotas

- Smart Device Management API has rate limits
- Default quota: 300 requests per minute
- If you have many users, you may need to request a quota increase from Google

## Resources

- [Google Smart Device Management API](https://developers.google.com/nest/device-access)
- [OAuth 2.0 for Desktop Apps](https://developers.google.com/identity/protocols/oauth2/native-app)
- [Device Access Console](https://console.nest.google.com/device-access/)

## Summary

The new simplified flow:
- ✅ No Google Cloud Console for users
- ✅ No OAuth credential creation for users
- ✅ Simple 3-step setup process
- ✅ Just needs Device Access Project ID
- ✅ One-click authentication

Users will save significant time and frustration with this approach!
