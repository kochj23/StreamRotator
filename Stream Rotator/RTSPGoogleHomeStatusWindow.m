//
//  RTSPGoogleHomeStatusWindow.m
//  Stream Rotator
//

#import "RTSPGoogleHomeStatusWindow.h"
#import "RTSPGoogleHomeAdapter.h"

@interface RTSPGoogleHomeStatusWindow ()
@property (nonatomic, strong) NSTextView *textView;
@property (nonatomic, strong) NSScrollView *scrollView;
@end

@implementation RTSPGoogleHomeStatusWindow

+ (instancetype)sharedWindow {
    static RTSPGoogleHomeStatusWindow *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[RTSPGoogleHomeStatusWindow alloc] init];
    });
    return shared;
}

- (instancetype)init {
    self = [super initWithContentRect:NSMakeRect(0, 0, 700, 600)
                            styleMask:(NSWindowStyleMaskTitled |
                                      NSWindowStyleMaskClosable |
                                      NSWindowStyleMaskResizable)
                              backing:NSBackingStoreBuffered
                                defer:NO];

    if (self) {
        self.title = @"Google Home Status";
        [self center];
        self.minSize = NSMakeSize(600, 400);

        [self setupUI];
    }

    return self;
}

- (void)setupUI {
    // Create scroll view
    self.scrollView = [[NSScrollView alloc] initWithFrame:self.contentView.bounds];
    self.scrollView.hasVerticalScroller = YES;
    self.scrollView.hasHorizontalScroller = NO;
    self.scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    self.scrollView.borderType = NSNoBorder;

    // Create text view
    NSSize contentSize = self.scrollView.contentSize;
    self.textView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, contentSize.width, contentSize.height)];
    self.textView.minSize = NSMakeSize(0, contentSize.height);
    self.textView.maxSize = NSMakeSize(FLT_MAX, FLT_MAX);
    self.textView.verticallyResizable = YES;
    self.textView.horizontallyResizable = NO;
    self.textView.autoresizingMask = NSViewWidthSizable;
    self.textView.textContainer.containerSize = NSMakeSize(contentSize.width, FLT_MAX);
    self.textView.textContainer.widthTracksTextView = YES;
    self.textView.editable = NO;
    self.textView.selectable = YES;
    self.textView.font = [NSFont fontWithName:@"Menlo" size:11];

    self.scrollView.documentView = self.textView;

    // Create button bar at bottom
    NSView *buttonBar = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, self.contentView.bounds.size.width, 50)];
    buttonBar.autoresizingMask = NSViewWidthSizable;

    NSButton *refreshButton = [[NSButton alloc] initWithFrame:NSMakeRect(20, 13, 120, 24)];
    refreshButton.title = @"Refresh Status";
    refreshButton.bezelStyle = NSBezelStyleRounded;
    refreshButton.target = self;
    refreshButton.action = @selector(refresh);
    [buttonBar addSubview:refreshButton];

    NSButton *copyButton = [[NSButton alloc] initWithFrame:NSMakeRect(150, 13, 100, 24)];
    copyButton.title = @"Copy All";
    copyButton.bezelStyle = NSBezelStyleRounded;
    copyButton.target = self;
    copyButton.action = @selector(copyAll:);
    [buttonBar addSubview:copyButton];

    NSButton *closeButton = [[NSButton alloc] initWithFrame:NSMakeRect(self.contentView.bounds.size.width - 100, 13, 80, 24)];
    closeButton.title = @"Close";
    closeButton.bezelStyle = NSBezelStyleRounded;
    closeButton.target = self;
    closeButton.action = @selector(close);
    closeButton.keyEquivalent = @"\e";
    closeButton.autoresizingMask = NSViewMinXMargin;
    [buttonBar addSubview:closeButton];

    // Adjust scroll view frame to make room for button bar
    NSRect scrollFrame = self.contentView.bounds;
    scrollFrame.size.height -= 50;
    scrollFrame.origin.y = 50;
    self.scrollView.frame = scrollFrame;

    [self.contentView addSubview:self.scrollView];
    [self.contentView addSubview:buttonBar];
}

- (void)show {
    [self refresh];
    [self makeKeyAndOrderFront:nil];
}

- (void)refresh {
    RTSPGoogleHomeAdapter *adapter = [RTSPGoogleHomeAdapter sharedAdapter];
    RTSPGoogleHomeAuth *auth = adapter.authentication;

    NSMutableString *status = [NSMutableString string];

    [status appendString:@"═══════════════════════════════════════════════════════════════════\n"];
    [status appendString:@"              GOOGLE HOME / NEST CAMERA STATUS\n"];
    [status appendString:@"═══════════════════════════════════════════════════════════════════\n\n"];

    // Current Time
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterMediumStyle;
    [status appendFormat:@"Current Time: %@\n\n", [formatter stringFromDate:[NSDate date]]];

    // OAuth Configuration
    [status appendString:@"───────────────────────────────────────────────────────────────────\n"];
    [status appendString:@"OAUTH CONFIGURATION\n"];
    [status appendString:@"───────────────────────────────────────────────────────────────────\n"];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *clientID = [defaults stringForKey:@"GoogleHome_ClientID"];
    NSString *clientSecret = [defaults stringForKey:@"GoogleHome_ClientSecret"];
    NSString *projectID = [defaults stringForKey:@"GoogleHome_ProjectID"];

    if (clientID && clientID.length > 0) {
        [status appendFormat:@"✓ OAuth Client ID: %@\n", clientID];
    } else {
        [status appendString:@"✗ OAuth Client ID: NOT CONFIGURED\n"];
    }

    if (clientSecret && clientSecret.length > 0) {
        [status appendFormat:@"✓ OAuth Client Secret: %@\n", [self maskString:clientSecret]];
    } else {
        [status appendString:@"✗ OAuth Client Secret: NOT CONFIGURED\n"];
    }

    if (projectID && projectID.length > 0) {
        [status appendFormat:@"✓ Device Access Project ID: %@\n", projectID];
    } else {
        [status appendString:@"✗ Device Access Project ID: NOT CONFIGURED\n"];
    }

    [status appendString:@"\n"];

    // Authentication Object Status
    [status appendString:@"───────────────────────────────────────────────────────────────────\n"];
    [status appendString:@"AUTHENTICATION OBJECT\n"];
    [status appendString:@"───────────────────────────────────────────────────────────────────\n"];

    if (auth) {
        [status appendString:@"✓ Authentication object exists\n"];

        if (auth.clientID) {
            [status appendFormat:@"  Client ID in auth: %@\n", auth.clientID];
        } else {
            [status appendString:@"  Client ID in auth: MISSING ❌\n"];
        }

        if (auth.clientSecret) {
            [status appendFormat:@"  Client Secret in auth: %@\n", [self maskString:auth.clientSecret]];
        } else {
            [status appendString:@"  Client Secret in auth: MISSING ❌\n"];
        }

        if (auth.projectID) {
            [status appendFormat:@"  Project ID in auth: %@\n", auth.projectID];
        } else {
            [status appendString:@"  Project ID in auth: MISSING ❌\n"];
        }
    } else {
        [status appendString:@"✗ Authentication object is NULL ❌\n"];
    }

    [status appendString:@"\n"];

    // Token Status
    [status appendString:@"───────────────────────────────────────────────────────────────────\n"];
    [status appendString:@"TOKEN STATUS\n"];
    [status appendString:@"───────────────────────────────────────────────────────────────────\n"];

    if (auth && auth.accessToken) {
        [status appendFormat:@"✓ Access Token: %@...%@\n",
         [auth.accessToken substringToIndex:MIN(20, auth.accessToken.length)],
         [auth.accessToken substringFromIndex:MAX(0, auth.accessToken.length - 10)]];

        if (auth.tokenExpiration) {
            NSTimeInterval timeUntilExpiration = [auth.tokenExpiration timeIntervalSinceNow];
            [status appendFormat:@"  Expiration: %@\n", [formatter stringFromDate:auth.tokenExpiration]];

            if (timeUntilExpiration > 0) {
                int hours = (int)timeUntilExpiration / 3600;
                int minutes = ((int)timeUntilExpiration % 3600) / 60;
                [status appendFormat:@"  Time until expiration: %d hours, %d minutes ✓\n", hours, minutes];
            } else {
                [status appendString:@"  Token is EXPIRED ❌\n"];
            }
        } else {
            [status appendString:@"  Expiration: Unknown\n"];
        }

        if ([auth isValid]) {
            [status appendString:@"  Status: VALID ✓\n"];
        } else {
            [status appendString:@"  Status: INVALID or EXPIRED ❌\n"];
        }

        if ([auth needsRefresh]) {
            [status appendString:@"  Needs Refresh: YES (expires in < 5 minutes)\n"];
        } else {
            [status appendString:@"  Needs Refresh: NO\n"];
        }
    } else {
        [status appendString:@"✗ No Access Token - NOT AUTHENTICATED ❌\n"];
    }

    if (auth && auth.refreshToken) {
        [status appendFormat:@"✓ Refresh Token: %@\n", [self maskString:auth.refreshToken]];
    } else {
        [status appendString:@"✗ No Refresh Token\n"];
    }

    [status appendString:@"\n"];

    // Camera Status
    [status appendString:@"───────────────────────────────────────────────────────────────────\n"];
    [status appendString:@"CAMERAS\n"];
    [status appendString:@"───────────────────────────────────────────────────────────────────\n"];

    NSArray *cameras = adapter.cameras;
    if (cameras && cameras.count > 0) {
        [status appendFormat:@"✓ Found %lu cameras:\n\n", (unsigned long)cameras.count];

        for (RTSPGoogleHomeCamera *camera in cameras) {
            [status appendFormat:@"  • %@\n", camera.displayName];
            [status appendFormat:@"    Device ID: %@\n", camera.deviceID];
            [status appendFormat:@"    Type: %@\n", camera.deviceType];
            [status appendFormat:@"    Room: %@\n", camera.roomHint ?: @"(none)"];
            [status appendFormat:@"    Online: %@\n", camera.isOnline ? @"YES ✓" : @"NO ❌"];
            [status appendString:@"\n"];
        }
    } else {
        [status appendString:@"✗ No cameras discovered ❌\n"];
        [status appendString:@"\n"];
        [status appendString:@"  Possible reasons:\n"];
        [status appendString:@"  1. Not authenticated yet\n"];
        [status appendString:@"  2. Devices not authorized during OAuth\n"];
        [status appendString:@"  3. No cameras in Google Home app\n"];
        [status appendString:@"  4. Wrong Google account\n"];
        [status appendString:@"  5. Token expired\n"];
    }

    [status appendString:@"\n"];

    // API Test
    [status appendString:@"───────────────────────────────────────────────────────────────────\n"];
    [status appendString:@"API ENDPOINT TEST\n"];
    [status appendString:@"───────────────────────────────────────────────────────────────────\n"];

    if (auth && auth.projectID) {
        NSString *endpoint = [NSString stringWithFormat:@"https://smartdevicemanagement.googleapis.com/v1/enterprises/%@/devices", auth.projectID];
        [status appendFormat:@"Endpoint URL:\n%@\n\n", endpoint];

        if (auth.accessToken) {
            [status appendString:@"Authorization Header:\n"];
            [status appendFormat:@"Bearer %@...\n", [auth.accessToken substringToIndex:MIN(30, auth.accessToken.length)]];
        } else {
            [status appendString:@"❌ NO ACCESS TOKEN - Cannot make API requests\n"];
        }
    } else {
        [status appendString:@"❌ Project ID not configured\n"];
    }

    [status appendString:@"\n"];

    // Diagnostic Info
    [status appendString:@"───────────────────────────────────────────────────────────────────\n"];
    [status appendString:@"DIAGNOSTIC INFORMATION\n"];
    [status appendString:@"───────────────────────────────────────────────────────────────────\n"];

    // Check saved auth file
    NSString *appSupport = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
    NSString *authPath = [[appSupport stringByAppendingPathComponent:@"RTSP Rotator"] stringByAppendingPathComponent:@"googlehome_auth.dat"];

    if ([[NSFileManager defaultManager] fileExistsAtPath:authPath]) {
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:authPath error:nil];
        [status appendFormat:@"✓ Auth file exists: %@\n", authPath];
        [status appendFormat:@"  Last modified: %@\n", [formatter stringFromDate:attrs[NSFileModificationDate]]];
        [status appendFormat:@"  File size: %lld bytes\n", [attrs[NSFileSize] longLongValue]];
    } else {
        [status appendFormat:@"✗ Auth file does NOT exist: %@\n", authPath];
        [status appendString:@"  This means authentication has never been saved!\n"];
    }

    [status appendString:@"\n"];

    [status appendString:@"═══════════════════════════════════════════════════════════════════\n"];
    [status appendString:@"SUMMARY\n"];
    [status appendString:@"═══════════════════════════════════════════════════════════════════\n\n"];

    // Overall status
    BOOL allConfigured = (clientID && clientSecret && projectID);
    BOOL authenticated = (auth && auth.accessToken && [auth isValid]);
    BOOL hasCameras = (cameras && cameras.count > 0);

    if (allConfigured && authenticated && hasCameras) {
        [status appendString:@"✓✓✓ EVERYTHING LOOKS GOOD! ✓✓✓\n"];
    } else {
        [status appendString:@"❌ ISSUES DETECTED:\n\n"];

        if (!allConfigured) {
            [status appendString:@"  ❌ OAuth credentials not fully configured\n"];
            [status appendString:@"     → Go to Preferences and enter all three values\n\n"];
        }

        if (!authenticated) {
            [status appendString:@"  ❌ Not authenticated or token expired\n"];
            [status appendString:@"     → Go to 'Google Home' menu > 'Authenticate with Google...'\n\n"];
        }

        if (authenticated && !hasCameras) {
            [status appendString:@"  ❌ Authenticated but no cameras found\n"];
            [status appendString:@"     → You may not have selected devices during OAuth\n"];
            [status appendString:@"     → Re-authenticate and watch for device selection screen\n"];
            [status appendString:@"     → Make sure cameras are in your Google Home app\n\n"];
        }
    }

    [status appendString:@"\n"];
    [status appendFormat:@"Last updated: %@\n", [formatter stringFromDate:[NSDate date]]];

    // Update text view
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textView.string = status;
    });
}

- (NSString *)maskString:(NSString *)string {
    if (!string || string.length < 10) return @"********";

    NSString *start = [string substringToIndex:MIN(10, string.length)];
    NSString *end = [string substringFromIndex:MAX(0, string.length - 4)];

    return [NSString stringWithFormat:@"%@...%@", start, end];
}

- (void)copyAll:(id)sender {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    [pasteboard setString:self.textView.string forType:NSPasteboardTypeString];

    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"Copied";
    alert.informativeText = @"Status information copied to clipboard";
    alert.alertStyle = NSAlertStyleInformational;
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];
}

@end
