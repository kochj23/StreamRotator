# Google Home / Nest Camera Setup Guide

## For End Users

This guide shows you how to connect your Google Home or Nest cameras to Stream Rotator.

---

## What You Need

1. **Google Home or Nest cameras** already set up in the Google Home app
2. **A Google account** (the same one you use for Google Home)
3. **$5** for Google's one-time Device Access registration fee
4. **15-20 minutes** for the initial setup

---

## Step-by-Step Setup

### Part 1: Create Google Cloud Project (5-10 minutes)

1. **Open your web browser** and go to: https://console.cloud.google.com

2. **Sign in** with your Google account (the same one connected to your cameras)

3. **Create a new project:**
   - Click "Select a project" at the top
   - Click "NEW PROJECT"
   - Give it a name like "My Home Cameras"
   - Click "CREATE"
   - Wait a few seconds for it to be created

4. **Enable the Smart Device Management API:**
   - On the left menu, click "APIs & Services"
   - Click "Library"
   - In the search box, type: **Smart Device Management API**
   - Click on the result
   - Click the blue "ENABLE" button
   - Wait for it to enable

5. **Set up OAuth consent screen:**
   - On the left menu, click "APIs & Services" > "OAuth consent screen"
   - Choose "External" (the radio button)
   - Click "CREATE"

   **Fill out the form:**
   - App name: Type "Stream Rotator" (or any name you want)
   - User support email: Choose your email
   - Developer contact: Type your email
   - Click "SAVE AND CONTINUE"

   - On the next page (Scopes), just click "SAVE AND CONTINUE"
   - On the Test users page, click "+ ADD USERS", enter your email, click "ADD", then "SAVE AND CONTINUE"
   - On the Summary page, click "BACK TO DASHBOARD"

6. **Create OAuth credentials (the important part!):**
   - On the left menu, click "APIs & Services" > "Credentials"
   - Click "+ CREATE CREDENTIALS" at the top
   - Choose "OAuth client ID"
   - Application type: Choose "Desktop app"
   - Name: Type "Stream Rotator Client"
   - Click "CREATE"

   **A popup will appear with your credentials:**
   - You'll see a "Client ID" (looks like: 123456789-abc123.apps.googleusercontent.com)
   - You'll see a "Client secret" (looks like: GOCSPX-abc123xyz789)
   - **Copy both of these** - you'll need them soon!
   - You can also download them as a JSON file if you want a backup

---

### Part 2: Register for Device Access (5 minutes + $5)

1. **Go to the Device Access Console:**
   - Open: https://console.nest.google.com/device-access/
   - Sign in with your Google account

2. **Register and pay the fee:**
   - Click "Get Started" or "Go to registration"
   - Follow the prompts to **pay the $5 one-time registration fee**
   - This is required by Google (not us!)

3. **Create a Device Access project:**
   - After paying, click "Create project"
   - Give it a name (e.g., "My Home")
   - Click through the setup
   - **Copy the Project ID** that's shown
   - It looks like: `12345678-abcd-1234-abcd-123456789012`

---

### Part 3: Configure Stream Rotator (2 minutes)

1. **Open Stream Rotator**

2. **Go to Preferences:**
   - Press ⌘, (Command-comma)
   - Or click "Stream Rotator" menu > "Preferences"

3. **Scroll down to "Google Home / Nest Cameras" section**

4. **Enter your credentials:**
   - **OAuth Client ID:** Paste the Client ID from Part 1, Step 6
   - **OAuth Client Secret:** Paste the Client Secret from Part 1, Step 6
   - **Device Access Project ID:** Paste the Project ID from Part 2, Step 3

5. **Click "Save"**

---

### Part 4: Authenticate and Connect (2 minutes)

1. **In Stream Rotator, go to the "Google Home" menu**

2. **Click "Authenticate with Google"**

3. **A browser window will open:**
   - Sign in with your Google account (if not already signed in)
   - You may see a warning that the app is unverified - this is normal
   - Click "Advanced" > "Go to Stream Rotator (unsafe)"
   - Review the permissions
   - Click "Allow"

4. **Grant permissions:**
   - Allow Stream Rotator to access your Google devices
   - Click "Allow" or "Accept"

5. **You're done!**
   - Close the browser window
   - Return to Stream Rotator
   - Your cameras should appear in the Google Home section

---

## Discovering Your Cameras

After authentication:

1. Go to "Google Home" menu > "Discover Cameras"
2. Stream Rotator will find all your Google Home/Nest cameras
3. Select the cameras you want to add
4. Assign them to dashboards
5. Start viewing!

---

## Troubleshooting

### "Missing Google OAuth credentials" error

Make sure you entered all three values in Preferences:
- OAuth Client ID
- OAuth Client Secret
- Device Access Project ID

Click "Save" after entering them.

---

### "Access blocked: Authorization Error" when authenticating

This usually means:
1. The OAuth Client ID or Secret is incorrect - double-check them
2. The Smart Device Management API isn't enabled - go back to Part 1, Step 4
3. The OAuth consent screen isn't set up - go back to Part 1, Step 5

---

### "App is unverified" warning during authentication

This is normal! Google shows this warning for apps that haven't been verified. Just click:
- "Advanced" at the bottom
- "Go to Stream Rotator (unsafe)"
- Then proceed with authentication

---

### I lost my Client ID or Secret

1. Go back to https://console.cloud.google.com
2. Select your project
3. Go to "APIs & Services" > "Credentials"
4. You'll see your OAuth client listed
5. Click on it to view the Client ID and Secret

---

### No cameras are showing up after authentication

Make sure:
1. Your cameras are set up in the Google Home app
2. They're online and working
3. You're signed in with the same Google account
4. You clicked "Discover Cameras" in the Google Home menu
5. You granted all the permissions during authentication

---

## Important Notes

- **The $5 fee is one-time only** - You never have to pay it again
- **Your credentials are stored locally** - They never leave your computer
- **Setup is one-time** - Once configured, you won't need to do this again
- **Multiple devices:** If you want to use Stream Rotator on another computer, you'll need to enter the credentials again on that computer (but you won't need to pay the $5 again or create new projects)

---

## Security & Privacy

- Your OAuth credentials are stored securely on your Mac
- Stream Rotator only accesses your cameras when you explicitly authenticate
- No data is sent to any third parties
- You can revoke access anytime from your Google account settings

---

## Need More Help?

- Click "Setup Instructions" in Preferences for a quick reference
- Check the full documentation in the app's Help menu
- Make sure the Smart Device Management API is enabled
- Verify all three credentials are entered correctly

---

**Last Updated:** October 31, 2025
**App Version:** Stream Rotator 2.0
