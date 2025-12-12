# Visual Guide - Where to Paste Your Credentials

## 📍 Location
**File:** `Stream Rotator/RTSPGoogleHomeAdapter.m`
**Lines:** Around 115-125

---

## 🔍 How to Find It

1. Open Xcode
2. Press **⌘F** (opens Find box)
3. Type: `YOUR_CLIENT_ID`
4. Press Enter
5. You'll jump to the exact spot!

---

## 👀 What You'll See

### BEFORE (What's there now):

```objc
// If not customized, use embedded credentials
if (!clientID || clientID.length == 0) {
    // Embedded OAuth Client ID for Stream Rotator
    // Users can override this in preferences if they want to use their own
    clientID = @"YOUR_CLIENT_ID.apps.googleusercontent.com"; // TODO: Replace with actual credentials
}

if (!clientSecret || clientSecret.length == 0) {
    // Embedded OAuth Client Secret for Stream Rotator
    clientSecret = @"YOUR_CLIENT_SECRET"; // TODO: Replace with actual credentials
}
```

---

## ✏️ What to Change

### EXAMPLE: After You Paste Your Real Credentials

Let's say Google gave you:
- **Client ID:** `123456789-abc123xyz789.apps.googleusercontent.com`
- **Client Secret:** `GOCSPX-AbCd1234EfGh5678IjKl`

### AFTER (How it should look):

```objc
// If not customized, use embedded credentials
if (!clientID || clientID.length == 0) {
    // Embedded OAuth Client ID for Stream Rotator
    // Users can override this in preferences if they want to use their own
    clientID = @"123456789-abc123xyz789.apps.googleusercontent.com";
}

if (!clientSecret || clientSecret.length == 0) {
    // Embedded OAuth Client Secret for Stream Rotator
    clientSecret = @"GOCSPX-AbCd1234EfGh5678IjKl";
}
```

---

## ⚠️ Important Rules

### ✅ DO:
- Replace **ONLY** the text between the quotes
- Keep the `@"` at the start
- Keep the `"` at the end
- Keep the `;` at the very end
- Save the file (⌘S) after making changes

### ❌ DON'T:
- Delete the `@"` or `"`
- Delete the `;` at the end
- Add extra spaces before or after
- Change anything else in the file
- Add line breaks inside the quotes

---

## 🎯 Exact Steps

### Step 1: Replace Client ID

1. Find this line:
   ```objc
   clientID = @"YOUR_CLIENT_ID.apps.googleusercontent.com";
   ```

2. Click between the quotes (after `@"` and before `"`)

3. Select everything between the quotes:
   - Double-click on `YOUR_CLIENT_ID` to select it
   - Or: Click and drag to select `YOUR_CLIENT_ID.apps.googleusercontent.com`

4. Paste your real Client ID (⌘V)

5. Make sure it looks like:
   ```objc
   clientID = @"your-actual-client-id.apps.googleusercontent.com";
   ```

### Step 2: Replace Client Secret

1. Find this line:
   ```objc
   clientSecret = @"YOUR_CLIENT_SECRET";
   ```

2. Click between the quotes

3. Select `YOUR_CLIENT_SECRET`

4. Paste your real Client Secret (⌘V)

5. Make sure it looks like:
   ```objc
   clientSecret = @"GOCSPX-YourActualSecret";
   ```

### Step 3: Save

1. Press **⌘S** to save
2. You should see the black dot on the file tab disappear (this means it's saved)

---

## 🧪 Double-Check

After you paste, verify:

**Client ID should:**
- Start with a number
- End with `.apps.googleusercontent.com`
- Look something like: `123456789-abc123xyz.apps.googleusercontent.com`
- Be surrounded by `@"` and `";`

**Client Secret should:**
- Start with `GOCSPX-`
- Be followed by random letters and numbers
- Look something like: `GOCSPX-a1b2c3d4e5f6g7h8`
- Be surrounded by `@"` and `";`

---

## 📸 Screenshot Reference

When you're done, the code block should look like this:

```
Line 115:     if (!clientID || clientID.length == 0) {
Line 116:         // Embedded OAuth Client ID for Stream Rotator
Line 117:         // Users can override this in preferences if they want to use their own
Line 118:         clientID = @"YOUR-REAL-CLIENT-ID-HERE.apps.googleusercontent.com";
Line 119:     }
Line 120:
Line 121:     if (!clientSecret || clientSecret.length == 0) {
Line 122:         // Embedded OAuth Client Secret for Stream Rotator
Line 123:         clientSecret = @"GOCSPX-YourRealSecretHere";
Line 124:     }
```

(But with YOUR actual credentials from Google, not these example ones!)

---

## 🔧 Common Mistakes

### ❌ Wrong - Missing @":
```objc
clientID = "123456789-abc.apps.googleusercontent.com";  // Missing @
```

### ✅ Correct:
```objc
clientID = @"123456789-abc.apps.googleusercontent.com";
```

---

### ❌ Wrong - Missing semicolon:
```objc
clientID = @"123456789-abc.apps.googleusercontent.com"  // Missing ;
```

### ✅ Correct:
```objc
clientID = @"123456789-abc.apps.googleusercontent.com";
```

---

### ❌ Wrong - Extra spaces:
```objc
clientID = @" 123456789-abc.apps.googleusercontent.com ";  // Spaces inside quotes
```

### ✅ Correct:
```objc
clientID = @"123456789-abc.apps.googleusercontent.com";
```

---

### ❌ Wrong - Line break:
```objc
clientID = @"123456789-abc
.apps.googleusercontent.com";  // Split across lines
```

### ✅ Correct:
```objc
clientID = @"123456789-abc.apps.googleusercontent.com";
```

---

## ✅ Final Checklist

Before rebuilding:
- [ ] I found the file `RTSPGoogleHomeAdapter.m`
- [ ] I replaced `YOUR_CLIENT_ID.apps.googleusercontent.com` with my real Client ID
- [ ] I kept the `@"` and `";` around it
- [ ] I replaced `YOUR_CLIENT_SECRET` with my real Client Secret
- [ ] I kept the `@"` and `";` around it
- [ ] I pressed ⌘S to save the file
- [ ] The file tab has no black dot (meaning it's saved)
- [ ] I'm ready to rebuild (⌘B)

---

**You've got this! It's just a simple copy-paste into two specific spots.** 🎉
