# Setting Up Google Home Cameras - Simple Guide

## What You're Going to Do

You're going to get two special codes from Google that will let your app connect to Google Home cameras. Think of these like keys that unlock a door. You only have to do this once, and then anyone who uses your app won't have to do it.

**Time needed:** About 10-15 minutes
**Cost:** Free (but your users will pay Google $5 later to use their cameras)

---

## Step 1: Open Google Cloud Console

1. Open your web browser (Safari, Chrome, etc.)
2. Go to this website: **https://console.cloud.google.com**
3. Sign in with your Google account (any Gmail account works)
4. You should see a page that says "Google Cloud Console" at the top

**What you're looking at:** This is Google's website where developers set up apps that work with Google services.

---

## Step 2: Create a New Project

1. Look at the top of the page - you'll see "Select a project" or a project name
2. Click on that dropdown menu (it's near the Google Cloud logo)
3. A window will pop up - click the button that says **"NEW PROJECT"** (top right of that window)
4. You'll see a form asking for details:
   - **Project name:** Type `Stream Rotator` (or whatever you want to call it)
   - **Location:** Leave as-is (probably says "No organization")
5. Click the blue **"CREATE"** button
6. Wait a few seconds - a notification will appear saying your project was created

**What you just did:** You created a "container" that will hold your app's settings.

---

## Step 3: Enable the Smart Device Management API

1. Look at the left side of the screen - there's a menu with lots of options
2. Click on **"APIs & Services"** (it has a gear/plug icon)
3. Click on **"Library"** (it should be near the top of the menu)
4. You'll see a search box that says "Search for APIs and Services"
5. Type: **Smart Device Management API**
6. Click on the result that says "Smart Device Management API"
7. You'll see a page about this API - click the blue **"ENABLE"** button
8. Wait a few seconds - the page will change to show it's enabled

**What you just did:** You turned on the feature that lets apps talk to Google Home cameras.

---

## Step 4: Set Up OAuth Consent Screen

This is important - it creates the screen users see when they sign in.

1. On the left menu, click **"APIs & Services"** again
2. Click **"OAuth consent screen"**
3. You'll see two options: "Internal" and "External"
   - Choose **"External"** (click the radio button next to it)
   - Click the blue **"CREATE"** button

4. **Fill out the form:**

   **Page 1 - App information:**
   - **App name:** Type `Stream Rotator`
   - **User support email:** Choose your email from the dropdown
   - **App logo:** Skip this (not required)
   - **Application home page:** Skip this
   - **Application privacy policy link:** Skip this
   - **Application terms of service link:** Skip this
   - **Authorized domains:** Skip this
   - **Developer contact information:** Type your email address

   Click the blue **"SAVE AND CONTINUE"** button at the bottom

   **Page 2 - Scopes:**
   - Don't add anything here - just click **"SAVE AND CONTINUE"**

   **Page 3 - Test users:**
   - Click **"+ ADD USERS"**
   - Type your email address
   - Click **"ADD"**
   - Click **"SAVE AND CONTINUE"**

   **Page 4 - Summary:**
   - Just review and click **"BACK TO DASHBOARD"**

**What you just did:** You told Google what your app is called and who's allowed to test it.

---

## Step 5: Create OAuth Credentials (The Important Part!)

This is where you get the two "keys" you need.

1. On the left menu, click **"APIs & Services"** again
2. Click **"Credentials"**
3. At the top of the page, click **"+ CREATE CREDENTIALS"**
4. From the dropdown, choose **"OAuth client ID"**
5. You'll see a form:
   - **Application type:** Choose **"Desktop app"** from the dropdown
   - **Name:** Type `Stream Rotator Client`
6. Click the blue **"CREATE"** button

7. **IMPORTANT:** A popup will appear with your credentials!
   - You'll see "OAuth client created" at the top
   - There are two important things here:
     - **Your Client ID** - a long text ending in `.apps.googleusercontent.com`
     - **Your Client Secret** - starts with `GOCSPX-`

8. **Keep this window open or copy these somewhere safe!** You'll need them in the next step.

**What you just got:** The two "keys" that your app needs to connect to Google.

---

## Step 6: Put the Keys in Your App

Now you need to copy those keys into your app's code.

1. Open **Xcode** (if it's not already open)
2. In Xcode, make sure you have the Stream Rotator project open
3. On the left side, find and click on: **Stream Rotator** folder (with the blue icon)
4. Look for a file called **RTSPGoogleHomeAdapter.m**
5. Click on it to open it
6. Press **⌘F** (Command-F) to open the Find box
7. Type: `YOUR_CLIENT_ID` and press Enter
8. You should see a line that looks like:
   ```
   clientID = @"YOUR_CLIENT_ID.apps.googleusercontent.com";
   ```
9. **Replace everything between the quotes** with your actual Client ID from Google
   - Delete `YOUR_CLIENT_ID.apps.googleusercontent.com`
   - Paste your real Client ID (the long one from Google)
   - Keep the `@"` at the beginning and `"` at the end
   - It should look like:
   ```
   clientID = @"123456789-abc123def456.apps.googleusercontent.com";
   ```

10. Now do the same for the Client Secret:
    - Press **⌘F** again
    - Type: `YOUR_CLIENT_SECRET` and press Enter
    - You should see:
    ```
    clientSecret = @"YOUR_CLIENT_SECRET";
    ```
    - Replace `YOUR_CLIENT_SECRET` with your actual Client Secret from Google
    - Keep the `@"` and `"` around it
    - It should look like:
    ```
    clientSecret = @"GOCSPX-a1b2c3d4e5f6g7h8i9j0";
    ```

11. Press **⌘S** (Command-S) to save the file

**What you just did:** You put the two keys into your app so it can connect to Google.

---

## Step 7: Rebuild Your App

Now you need to rebuild the app with the new keys.

1. In Xcode, press **⌘B** (Command-B) or go to **Product** menu > **Build**
2. Wait for the build to finish - you'll see "Build Succeeded" in Xcode
3. Or, if you prefer the command line, open Terminal and run:
   ```bash
   cd "/Users/kochj/Desktop/xcode/Stream Rotator"
   xcodebuild -project "Stream Rotator.xcodeproj" -scheme "Stream Rotator" -configuration Release clean build
   ```

**What you just did:** You rebuilt the app with your new keys inside it.

---

## Step 8: Test It!

Let's make sure it works:

1. Quit Stream Rotator if it's running (⌘Q)
2. Open it again from Xcode or from the Applications folder
3. Go to **Preferences** (⌘,) or click the menu **Stream Rotator** > **Preferences**
4. Scroll down to **"Google Home / Nest Cameras"** section
5. You should see:
   - A field for "Device Access Project ID"
   - A "Setup Instructions" button
   - An "Advanced" section (collapsed)

**You're done with your part!**

The OAuth credentials are now built into your app. You won't see them in the UI because they're hidden inside the code.

---

## What Your Users Will Do (Much Simpler!)

Now that YOU'VE done the hard part, your users will have a much easier time:

1. They go to https://console.nest.google.com/device-access/
2. They pay Google $5 (one-time fee)
3. They create a project and get a "Project ID"
4. They open Stream Rotator preferences
5. They paste the Project ID
6. They click "Authenticate" and sign in with Google
7. Done! Their cameras appear automatically

---

## Troubleshooting

### "I can't find the file RTSPGoogleHomeAdapter.m"

1. In Xcode, on the left sidebar, make sure you're looking at the file navigator (folder icon)
2. Look for the "Stream Rotator" folder (blue icon)
3. Click the triangle next to it to expand
4. Scroll through the files - they're in alphabetical order
5. Look for files starting with "RTSP"

### "The build failed"

1. Make sure you saved the file (⌘S)
2. Make sure you didn't accidentally delete the `@"` or `"` characters
3. Make sure there are no extra spaces or line breaks in your Client ID or Secret
4. The line should look exactly like this (but with your values):
   ```objc
   clientID = @"123-abc.apps.googleusercontent.com";
   ```

### "I lost the Client ID and Secret popup"

1. Go back to https://console.cloud.google.com
2. Click on "APIs & Services" > "Credentials"
3. You'll see your OAuth client listed under "OAuth 2.0 Client IDs"
4. Click on it (the name "Stream Rotator Client")
5. Your Client ID and Secret are shown there

### "When I test, I get 'Missing required parameter: client_id'"

This means the keys weren't properly inserted. Double-check:
1. You replaced `YOUR_CLIENT_ID` with your actual Client ID
2. You replaced `YOUR_CLIENT_SECRET` with your actual Client Secret
3. You saved the file (⌘S)
4. You rebuilt the app (⌘B)

---

## Summary - What You Did

✅ Created a Google Cloud Project
✅ Enabled Smart Device Management API
✅ Set up OAuth consent screen
✅ Created OAuth credentials (Client ID & Secret)
✅ Put those credentials in your app's code
✅ Rebuilt the app

Your app can now connect to Google Home cameras! Your users will have a much easier setup process because you did the hard part for them.

---

## Questions?

If you get stuck:
1. Check the Google Cloud Console to make sure your project exists
2. Check that the API is enabled
3. Check that your credentials are correct in the code
4. Try rebuilding the app
5. Check the app's console log for error messages

---

**Last Updated:** October 31, 2025
**App Version:** Stream Rotator 2.0
