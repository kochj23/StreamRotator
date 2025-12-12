# Add Google Home Status Window Files to Xcode

## Quick Steps

You need to add two new files to your Xcode project:

1. **RTSPGoogleHomeStatusWindow.h**
2. **RTSPGoogleHomeStatusWindow.m**

Both files are already created in: `/Users/kochj/Desktop/xcode/Stream Rotator/Stream Rotator/`

---

## How to Add Them to Xcode

### Method 1: Drag and Drop (Easiest)

1. **Open Xcode** with your Stream Rotator project

2. **In the left sidebar (Project Navigator):**
   - Find the "Stream Rotator" folder (the blue one with files)
   - Scroll to find where other similar files are (like `RTSPGoogleHomeAdapter.h`)

3. **Open Finder:**
   - Navigate to: `/Users/kochj/Desktop/xcode/Stream Rotator/Stream Rotator/`
   - Find these two files:
     - `RTSPGoogleHomeStatusWindow.h`
     - `RTSPGoogleHomeStatusWindow.m`

4. **Drag both files from Finder into Xcode's Project Navigator**
   - Drop them near the other RTSP files
   - A dialog will appear

5. **In the dialog, make sure:**
   - ✅ "Copy items if needed" is UNCHECKED (files are already in the right place)
   - ✅ "Create groups" is selected
   - ✅ "Stream Rotator" target is checked
   - Click "Finish"

---

### Method 2: Add Files Menu

1. **Open Xcode** with your Stream Rotator project

2. **Right-click on the "Stream Rotator" folder** in the left sidebar

3. **Choose "Add Files to 'Stream Rotator'..."**

4. **Navigate to:** `/Users/kochj/Desktop/xcode/Stream Rotator/Stream Rotator/`

5. **Select both files:**
   - Hold ⌘ (Command) and click both:
     - `RTSPGoogleHomeStatusWindow.h`
     - `RTSPGoogleHomeStatusWindow.m`

6. **Make sure:**
   - ✅ "Copy items if needed" is UNCHECKED
   - ✅ "Create groups" is selected
   - ✅ "Add to targets: Stream Rotator" is checked

7. **Click "Add"**

---

## Then Build

After adding the files:

1. **Press ⌘B** to build
2. Or go to **Product** menu > **Build**

The build should succeed and you'll have the new status window available!

---

## To Access the Status Window

After rebuilding:

1. **Run Stream Rotator**
2. **Click "Google Home" menu** (in the menu bar)
3. **Click "Show Status..."**

You'll see a comprehensive status window showing:
- OAuth configuration
- Authentication status
- Token validity and expiration
- Cameras discovered
- Diagnostic information
- Troubleshooting hints

This will help us figure out exactly why cameras aren't being discovered!
