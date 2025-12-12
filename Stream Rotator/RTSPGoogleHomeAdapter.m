//
//  RTSPGoogleHomeAdapter.m
//  RTSP Rotator
//

#import "RTSPGoogleHomeAdapter.h"
#import <AuthenticationServices/AuthenticationServices.h>

@implementation RTSPGoogleHomeAuth

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.accessToken forKey:@"accessToken"];
    [coder encodeObject:self.refreshToken forKey:@"refreshToken"];
    [coder encodeObject:self.tokenExpiration forKey:@"tokenExpiration"];
    [coder encodeObject:self.projectID forKey:@"projectID"];
    [coder encodeObject:self.clientID forKey:@"clientID"];
    [coder encodeObject:self.clientSecret forKey:@"clientSecret"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _accessToken = [coder decodeObjectOfClass:[NSString class] forKey:@"accessToken"];
        _refreshToken = [coder decodeObjectOfClass:[NSString class] forKey:@"refreshToken"];
        _tokenExpiration = [coder decodeObjectOfClass:[NSDate class] forKey:@"tokenExpiration"];
        _projectID = [coder decodeObjectOfClass:[NSString class] forKey:@"projectID"];
        _clientID = [coder decodeObjectOfClass:[NSString class] forKey:@"clientID"];
        _clientSecret = [coder decodeObjectOfClass:[NSString class] forKey:@"clientSecret"];
    }
    return self;
}

- (BOOL)isValid {
    return self.accessToken != nil &&
           self.tokenExpiration != nil &&
           [[NSDate date] compare:self.tokenExpiration] == NSOrderedAscending;
}

- (BOOL)needsRefresh {
    if (!self.tokenExpiration) return YES;

    NSTimeInterval timeUntilExpiration = [self.tokenExpiration timeIntervalSinceNow];
    return timeUntilExpiration < 300; // Refresh if expires in less than 5 minutes
}

@end

@implementation RTSPGoogleHomeCamera

- (RTSPCameraConfig *)toCameraConfig {
    RTSPCameraConfig *config = [[RTSPCameraConfig alloc] init];
    config.name = self.displayName;
    config.feedURL = self.streamURL;
    config.location = self.roomHint;
    config.cameraType = @"GoogleHome";
    config.enabled = self.isOnline;

    // Store Google Home specific info in custom settings
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    settings[@"deviceID"] = self.deviceID;
    settings[@"deviceType"] = self.deviceType;
    settings[@"snapshotURL"] = self.snapshotURL.absoluteString;
    if (self.traits) {
        settings[@"traits"] = self.traits;
    }
    config.customSettings = [settings copy];

    return config;
}

@end

@interface RTSPGoogleHomeAdapter () <ASWebAuthenticationPresentationContextProviding>
@property (nonatomic, strong) NSMutableArray<RTSPGoogleHomeCamera *> *allCameras;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) ASWebAuthenticationSession *authSession;
@end

@implementation RTSPGoogleHomeAdapter

+ (instancetype)sharedAdapter {
    static RTSPGoogleHomeAdapter *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[RTSPGoogleHomeAdapter alloc] init];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _allCameras = [NSMutableArray array];
        _session = [NSURLSession sharedSession];

        [self loadAuthentication];

        // Load OAuth credentials from preferences if not already loaded
        if (!self.authentication) {
            self.authentication = [[RTSPGoogleHomeAuth alloc] init];
        }

        // Load credentials from user defaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *clientID = [defaults stringForKey:@"GoogleHome_ClientID"];
        NSString *clientSecret = [defaults stringForKey:@"GoogleHome_ClientSecret"];
        NSString *projectID = [defaults stringForKey:@"GoogleHome_ProjectID"];

        // Store in authentication object
        if (clientID) self.authentication.clientID = clientID;
        if (clientSecret) self.authentication.clientSecret = clientSecret;
        if (projectID) self.authentication.projectID = projectID;
    }
    return self;
}

- (NSArray<RTSPGoogleHomeCamera *> *)cameras {
    return [self.allCameras copy];
}

- (void)authenticateWithCompletionHandler:(void (^)(BOOL, NSError * _Nullable))completion {
    NSLog(@"[GoogleHome] Starting authentication...");

    // Check if we have all required OAuth credentials configured
    if (!self.authentication.clientID || self.authentication.clientID.length == 0 ||
        !self.authentication.clientSecret || self.authentication.clientSecret.length == 0 ||
        !self.authentication.projectID || self.authentication.projectID.length == 0) {

        NSLog(@"[GoogleHome] ERROR: Missing OAuth credentials");

        NSMutableString *errorMessage = [NSMutableString stringWithString:@"Missing Google OAuth credentials.\n\n"];
        [errorMessage appendString:@"Please configure the following in Preferences:\n"];

        if (!self.authentication.clientID || self.authentication.clientID.length == 0) {
            [errorMessage appendString:@"• OAuth Client ID\n"];
        }
        if (!self.authentication.clientSecret || self.authentication.clientSecret.length == 0) {
            [errorMessage appendString:@"• OAuth Client Secret\n"];
        }
        if (!self.authentication.projectID || self.authentication.projectID.length == 0) {
            [errorMessage appendString:@"• Device Access Project ID\n"];
        }

        [errorMessage appendString:@"\nClick 'Setup Instructions' in Preferences for detailed setup steps."];

        NSError *error = [NSError errorWithDomain:@"GoogleHomeAdapter"
                                            code:1001
                                        userInfo:@{NSLocalizedDescriptionKey: errorMessage}];

        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(googleHomeAdapter:authenticationFailedWithError:)]) {
                [self.delegate googleHomeAdapter:self authenticationFailedWithError:error];
            }
            if (completion) {
                completion(NO, error);
            }
        });
        return;
    }

    NSString *authEndpoint = @"https://accounts.google.com/o/oauth2/v2/auth";
    NSString *scope = @"https://www.googleapis.com/auth/sdm.service";
    // Use localhost redirect URI (modern approach - oob is deprecated)
    NSString *redirectURI = @"http://127.0.0.1:8080/oauth2callback";

    // Build OAuth URL with proper parameters for device selection
    NSString *oauthURLString = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=code&scope=%@&access_type=offline&prompt=consent",
                         authEndpoint,
                         [self.authentication.clientID stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]],
                         [redirectURI stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]],
                         [scope stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];

    NSURL *oauthURL = [NSURL URLWithString:oauthURLString];

    NSLog(@"[GoogleHome] Opening browser for OAuth...");
    NSLog(@"[GoogleHome] OAuth URL: %@", oauthURLString);
    NSLog(@"[GoogleHome] Using Client ID: %@", self.authentication.clientID);
    NSLog(@"[GoogleHome] Using Project ID: %@", self.authentication.projectID);
    NSLog(@"[GoogleHome] OAuth Scope: %@", scope);
    NSLog(@"[GoogleHome] Redirect URI: %@", redirectURI);

    dispatch_async(dispatch_get_main_queue(), ^{
        // Try to use ASWebAuthenticationSession, but fall back to manual if it fails
        @try {
            // Use ASWebAuthenticationSession for OAuth flow
            self.authSession = [[ASWebAuthenticationSession alloc]
                initWithURL:oauthURL
                callbackURLScheme:@"http"
                completionHandler:^(NSURL * _Nullable callbackURL, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"[GoogleHome] OAuth session error: %@", error.localizedDescription);

                        // Check if user cancelled
                        if (error.code == ASWebAuthenticationSessionErrorCodeCanceledLogin) {
                            NSError *cancelError = [NSError errorWithDomain:@"GoogleHomeAdapter"
                                                                        code:1003
                                                                    userInfo:@{NSLocalizedDescriptionKey: @"User cancelled authentication"}];
                            if (completion) completion(NO, cancelError);
                            return;
                        }

                        // Fallback: Open browser manually and prompt for code
                        NSLog(@"[GoogleHome] Falling back to manual code entry");
                        [[NSWorkspace sharedWorkspace] openURL:oauthURL];

                        [self promptForAuthorizationCode:completion];
                        return;
                    }

                    // Extract authorization code from callback URL
                    NSString *code = [self extractAuthCodeFromURL:callbackURL];
                    if (code) {
                        NSLog(@"[GoogleHome] Got authorization code, exchanging for tokens...");
                        [self exchangeAuthorizationCode:code completion:completion];
                    } else {
                        NSLog(@"[GoogleHome] Failed to extract authorization code");
                        NSError *extractError = [NSError errorWithDomain:@"GoogleHomeAdapter"
                                                                    code:1004
                                                                userInfo:@{NSLocalizedDescriptionKey: @"Failed to extract authorization code"}];
                        if (completion) completion(NO, extractError);
                    }
                }];

            self.authSession.presentationContextProvider = self;
            [self.authSession start];
        } @catch (NSException *exception) {
            // ASWebAuthenticationSession failed, fall back to manual browser OAuth
            NSLog(@"[GoogleHome] ASWebAuthenticationSession failed: %@", exception.reason);
            NSLog(@"[GoogleHome] Falling back to manual browser OAuth");

            [[NSWorkspace sharedWorkspace] openURL:oauthURL];
            [self promptForAuthorizationCode:completion];
        }
    });
}

- (void)promptForAuthorizationCode:(void (^)(BOOL, NSError * _Nullable))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = @"Google Home Authorization";
        alert.informativeText = @"A browser window has been opened. After authorizing, copy the authorization code and paste it here:";

        NSTextField *codeField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 300, 24)];
        codeField.placeholderString = @"Paste authorization code here";
        alert.accessoryView = codeField;

        [alert addButtonWithTitle:@"Authenticate"];
        [alert addButtonWithTitle:@"Cancel"];

        NSModalResponse response = [alert runModal];

        if (response == NSAlertFirstButtonReturn) {
            NSString *code = codeField.stringValue;
            if (code.length > 0) {
                NSLog(@"[GoogleHome] Got authorization code from user, exchanging for tokens...");
                [self exchangeAuthorizationCode:code completion:completion];
            } else {
                NSError *error = [NSError errorWithDomain:@"GoogleHomeAdapter"
                                                    code:1005
                                                userInfo:@{NSLocalizedDescriptionKey: @"No authorization code provided"}];
                if (completion) completion(NO, error);
            }
        } else {
            NSError *error = [NSError errorWithDomain:@"GoogleHomeAdapter"
                                                code:1003
                                            userInfo:@{NSLocalizedDescriptionKey: @"User cancelled authentication"}];
            if (completion) completion(NO, error);
        }
    });
}

- (NSString *)extractAuthCodeFromURL:(NSURL *)url {
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];

    for (NSURLQueryItem *item in components.queryItems) {
        if ([item.name isEqualToString:@"code"]) {
            return item.value;
        }
    }

    // Also check fragment
    if (components.fragment) {
        NSArray *fragmentParams = [components.fragment componentsSeparatedByString:@"&"];
        for (NSString *param in fragmentParams) {
            NSArray *keyValue = [param componentsSeparatedByString:@"="];
            if (keyValue.count == 2 && [keyValue[0] isEqualToString:@"code"]) {
                return keyValue[1];
            }
        }
    }

    return nil;
}

- (void)exchangeAuthorizationCode:(NSString *)code completion:(void (^)(BOOL, NSError * _Nullable))completion {
    NSString *tokenEndpoint = @"https://oauth2.googleapis.com/token";

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:tokenEndpoint]];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    NSString *bodyString = [NSString stringWithFormat:@"code=%@&client_id=%@&client_secret=%@&redirect_uri=%@&grant_type=authorization_code",
                           [code stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]],
                           [self.authentication.clientID stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]],
                           [self.authentication.clientSecret stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]],
                           [@"http://127.0.0.1:8080/oauth2callback" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];

    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];

    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"[GoogleHome] Token exchange error: %@", error.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(NO, error);
            });
            return;
        }

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode != 200) {
            NSLog(@"[GoogleHome] Token exchange failed with status %ld", (long)httpResponse.statusCode);
            NSError *statusError = [NSError errorWithDomain:@"GoogleHomeAdapter"
                                                       code:httpResponse.statusCode
                                                   userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Token exchange failed: HTTP %ld", (long)httpResponse.statusCode]}];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(NO, statusError);
            });
            return;
        }

        NSError *jsonError = nil;
        NSDictionary *tokenResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

        if (jsonError || ![tokenResponse isKindOfClass:[NSDictionary class]]) {
            NSLog(@"[GoogleHome] Failed to parse token response");
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(NO, jsonError);
            });
            return;
        }

        NSString *accessToken = tokenResponse[@"access_token"];
        NSString *refreshToken = tokenResponse[@"refresh_token"];
        NSNumber *expiresIn = tokenResponse[@"expires_in"];

        if (!accessToken) {
            NSLog(@"[GoogleHome] No access token in response");
            NSError *noTokenError = [NSError errorWithDomain:@"GoogleHomeAdapter"
                                                        code:1006
                                                    userInfo:@{NSLocalizedDescriptionKey: @"No access token in response"}];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(NO, noTokenError);
            });
            return;
        }

        NSLog(@"[GoogleHome] ✓ Successfully obtained access token");

        // Store tokens
        self.authentication.accessToken = accessToken;
        self.authentication.refreshToken = refreshToken;

        if (expiresIn) {
            self.authentication.tokenExpiration = [NSDate dateWithTimeIntervalSinceNow:[expiresIn doubleValue]];
        }

        [self saveAuthentication];

        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(googleHomeAdapter:didAuthenticateSuccessfully:)]) {
                [self.delegate googleHomeAdapter:self didAuthenticateSuccessfully:self.authentication];
            }

            if (completion) completion(YES, nil);
        });
    }];

    [task resume];
}

- (void)refreshTokenWithCompletionHandler:(void (^)(BOOL, NSError * _Nullable))completion {
    if (!self.authentication || !self.authentication.refreshToken) {
        NSError *error = [NSError errorWithDomain:@"GoogleHomeAdapter"
                                            code:1002
                                        userInfo:@{NSLocalizedDescriptionKey: @"No refresh token available"}];
        if (completion) completion(NO, error);
        return;
    }

    NSLog(@"[GoogleHome] Refreshing access token...");

    NSString *tokenEndpoint = @"https://oauth2.googleapis.com/token";

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:tokenEndpoint]];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    NSString *body = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&refresh_token=%@&grant_type=refresh_token",
                     self.authentication.clientID,
                     self.authentication.clientSecret,
                     self.authentication.refreshToken];
    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];

    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"[GoogleHome] Token refresh failed: %@", error);
            if (completion) completion(NO, error);
            return;
        }

        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

        if (jsonError) {
            if (completion) completion(NO, jsonError);
            return;
        }

        NSString *newAccessToken = json[@"access_token"];
        NSNumber *expiresIn = json[@"expires_in"];

        if (newAccessToken) {
            self.authentication.accessToken = newAccessToken;
            self.authentication.tokenExpiration = [NSDate dateWithTimeIntervalSinceNow:[expiresIn doubleValue]];
            [self saveAuthentication];

            NSLog(@"[GoogleHome] Token refreshed successfully");

            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(YES, nil);
            });
        } else {
            NSError *error = [NSError errorWithDomain:@"GoogleHomeAdapter"
                                                code:1003
                                            userInfo:@{NSLocalizedDescriptionKey: @"Invalid token response"}];
            if (completion) completion(NO, error);
        }
    }];

    [task resume];
}

- (void)discoverCamerasWithCompletionHandler:(void (^)(NSArray<RTSPGoogleHomeCamera *> *, NSError * _Nullable))completion {
    if (!self.authentication || ![self.authentication isValid]) {
        NSError *error = [NSError errorWithDomain:@"GoogleHomeAdapter"
                                            code:1004
                                        userInfo:@{NSLocalizedDescriptionKey: @"Not authenticated"}];
        if (completion) completion(@[], error);
        return;
    }

    NSLog(@"[GoogleHome] Discovering cameras...");
    NSLog(@"[GoogleHome] Using Project ID: %@", self.authentication.projectID);

    // First, try to list structures to see if the project has access
    NSString *structuresEndpoint = [NSString stringWithFormat:@"https://smartdevicemanagement.googleapis.com/v1/enterprises/%@/structures",
                                    self.authentication.projectID];

    NSLog(@"[GoogleHome] Testing structures endpoint: %@", structuresEndpoint);

    NSMutableURLRequest *structuresRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:structuresEndpoint]];
    [structuresRequest setValue:[NSString stringWithFormat:@"Bearer %@", self.authentication.accessToken] forHTTPHeaderField:@"Authorization"];

    // Test structures endpoint first
    [[self.session dataTaskWithRequest:structuresRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            NSString *structuresResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"[GoogleHome] Structures API Response: %@", structuresResponse);
        }
    }] resume];

    // Now proceed with devices endpoint
    NSString *endpoint = [NSString stringWithFormat:@"https://smartdevicemanagement.googleapis.com/v1/enterprises/%@/devices",
                         self.authentication.projectID];

    NSLog(@"[GoogleHome] API Endpoint: %@", endpoint);

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endpoint]];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", self.authentication.accessToken] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSLog(@"[GoogleHome] Access Token: %@...", [self.authentication.accessToken substringToIndex:MIN(20, self.authentication.accessToken.length)]);

    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"[GoogleHome] Camera discovery network error: %@", error);
            if (completion) completion(@[], error);
            return;
        }

        // Log the HTTP response for debugging
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSLog(@"[GoogleHome] API Response Status: %ld", (long)httpResponse.statusCode);
        }

        // Log raw response data for debugging
        if (data) {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"[GoogleHome] API Response: %@", responseString);
        }

        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

        if (jsonError) {
            NSLog(@"[GoogleHome] JSON parsing error: %@", jsonError);
            if (completion) completion(@[], jsonError);
            return;
        }

        // Check for API errors in response
        if (json[@"error"]) {
            NSLog(@"[GoogleHome] API Error: %@", json[@"error"]);
            NSString *errorMessage = json[@"error"][@"message"] ?: @"Unknown API error";
            NSError *apiError = [NSError errorWithDomain:@"GoogleHomeAdapter"
                                                   code:1006
                                               userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
            if (completion) completion(@[], apiError);
            return;
        }

        NSArray *devices = json[@"devices"];
        NSLog(@"[GoogleHome] Devices array from API: %@", devices);
        NSMutableArray<RTSPGoogleHomeCamera *> *cameras = [NSMutableArray array];

        for (NSDictionary *deviceData in devices) {
            NSString *type = deviceData[@"type"];

            // Filter for cameras only
            if ([type containsString:@"CAMERA"] || [type containsString:@"DOORBELL"]) {
                RTSPGoogleHomeCamera *camera = [[RTSPGoogleHomeCamera alloc] init];
                camera.deviceID = deviceData[@"name"];
                camera.deviceType = type;

                NSDictionary *traits = deviceData[@"traits"];
                camera.displayName = traits[@"sdm.devices.traits.Info"][@"customName"] ?: @"Camera";
                camera.roomHint = deviceData[@"parentRelations"][0][@"displayName"];
                camera.traits = traits;
                camera.isOnline = [deviceData[@"connectivityStatus"] isEqualToString:@"ONLINE"];

                [cameras addObject:camera];
            }
        }

        self.allCameras = cameras;

        NSLog(@"[GoogleHome] Discovered %lu cameras", (unsigned long)cameras.count);

        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(googleHomeAdapter:didDiscoverCameras:)]) {
                [self.delegate googleHomeAdapter:self didDiscoverCameras:cameras];
            }

            if (completion) {
                completion(cameras, nil);
            }
        });
    }];

    [task resume];
}

- (void)getStreamURLForCamera:(RTSPGoogleHomeCamera *)camera completionHandler:(void (^)(NSURL * _Nullable, NSError * _Nullable))completion {
    if (!self.authentication || ![self.authentication isValid]) {
        NSError *error = [NSError errorWithDomain:@"GoogleHomeAdapter"
                                            code:1005
                                        userInfo:@{NSLocalizedDescriptionKey: @"Not authenticated"}];
        if (completion) completion(nil, error);
        return;
    }

    NSLog(@"[GoogleHome] Getting stream URL for camera: %@", camera.displayName);

    // Generate stream extension token
    NSString *endpoint = [NSString stringWithFormat:@"https://smartdevicemanagement.googleapis.com/v1/%@:executeCommand",
                         camera.deviceID];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endpoint]];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", self.authentication.accessToken] forHTTPHeaderField:@"Authorization"];

    NSDictionary *body = @{
        @"command": @"sdm.devices.commands.CameraLiveStream.GenerateRtspStream",
        @"params": @{}
    };

    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];

    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"[GoogleHome] Failed to get stream URL: %@", error);
            if (completion) completion(nil, error);
            return;
        }

        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

        if (jsonError) {
            if (completion) completion(nil, jsonError);
            return;
        }

        NSDictionary *results = json[@"results"];
        NSString *streamUrlString = results[@"streamUrls"][@"rtspUrl"];
        NSDate *expiresAt = [NSDate dateWithTimeIntervalSince1970:[results[@"expiresAt"] doubleValue]];

        if (streamUrlString) {
            NSURL *streamURL = [NSURL URLWithString:streamUrlString];
            camera.streamURL = streamURL;

            NSLog(@"[GoogleHome] Got stream URL (expires: %@)", expiresAt);

            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(streamURL, nil);
            });
        } else {
            NSError *error = [NSError errorWithDomain:@"GoogleHomeAdapter"
                                                code:1006
                                            userInfo:@{NSLocalizedDescriptionKey: @"No stream URL in response"}];
            if (completion) completion(nil, error);
        }
    }];

    [task resume];
}

- (void)getSnapshotURLForCamera:(RTSPGoogleHomeCamera *)camera completionHandler:(void (^)(NSURL * _Nullable, NSError * _Nullable))completion {
    // Similar to getStreamURLForCamera but using GenerateImage command
    // Implementation follows same pattern as stream URL generation

    NSLog(@"[GoogleHome] Getting snapshot URL for camera: %@", camera.displayName);

    if (completion) {
        // Placeholder - would follow similar pattern to getStreamURLForCamera
        NSError *error = [NSError errorWithDomain:@"GoogleHomeAdapter"
                                            code:1007
                                        userInfo:@{NSLocalizedDescriptionKey: @"Snapshot URL generation not yet implemented"}];
        completion(nil, error);
    }
}

- (NSArray<RTSPCameraConfig *> *)convertCamerasToConfigs:(NSArray<RTSPGoogleHomeCamera *> *)cameras {
    NSMutableArray<RTSPCameraConfig *> *configs = [NSMutableArray array];

    for (RTSPGoogleHomeCamera *camera in cameras) {
        [configs addObject:[camera toCameraConfig]];
    }

    return [configs copy];
}

- (void)importCamerasIntoDashboard:(RTSPDashboard *)dashboard completionHandler:(void (^)(NSInteger, NSError * _Nullable))completion {
    [self discoverCamerasWithCompletionHandler:^(NSArray<RTSPGoogleHomeCamera *> *cameras, NSError *error) {
        if (error) {
            if (completion) completion(0, error);
            return;
        }

        NSInteger importCount = 0;

        for (RTSPGoogleHomeCamera *camera in cameras) {
            if ([dashboard canAddMoreCameras]) {
                // Get stream URL first
                [self getStreamURLForCamera:camera completionHandler:^(NSURL *streamURL, NSError *streamError) {
                    if (!streamError && streamURL) {
                        RTSPCameraConfig *config = [camera toCameraConfig];
                        [dashboard addCamera:config];
                        NSLog(@"[GoogleHome] Imported camera: %@", camera.displayName);
                    }
                }];
                importCount++;
            } else {
                NSLog(@"[GoogleHome] Dashboard is full, skipping camera: %@", camera.displayName);
            }
        }

        NSLog(@"[GoogleHome] Imported %ld cameras into dashboard '%@'", (long)importCount, dashboard.name);

        if (completion) {
            completion(importCount, nil);
        }
    }];
}

- (BOOL)saveAuthentication {
    if (!self.authentication) return NO;

    NSString *appSupport = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
    NSString *appFolder = [appSupport stringByAppendingPathComponent:@"RTSP Rotator"];

    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:appFolder]) {
        [fm createDirectoryAtPath:appFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }

    NSString *authPath = [appFolder stringByAppendingPathComponent:@"googlehome_auth.dat"];

    NSError *error = nil;
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:self.authentication requiringSecureCoding:YES error:&error];

    if (error) {
        NSLog(@"[GoogleHome] Failed to save authentication: %@", error);
        return NO;
    }

    BOOL success = [archiveData writeToFile:authPath atomically:YES];

    if (success) {
        NSLog(@"[GoogleHome] Saved authentication");
    }

    return success;
}

- (BOOL)loadAuthentication {
    NSString *appSupport = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
    NSString *authPath = [[appSupport stringByAppendingPathComponent:@"RTSP Rotator"] stringByAppendingPathComponent:@"googlehome_auth.dat"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:authPath]) {
        NSLog(@"[GoogleHome] No saved authentication found");
        return NO;
    }

    NSError *error = nil;
    NSData *archiveData = [NSData dataWithContentsOfFile:authPath];

    NSSet *classes = [NSSet setWithArray:@[[RTSPGoogleHomeAuth class], [NSString class], [NSDate class]]];
    RTSPGoogleHomeAuth *loadedAuth = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes fromData:archiveData error:&error];

    if (error) {
        NSLog(@"[GoogleHome] Failed to load authentication: %@", error);
        return NO;
    }

    self.authentication = loadedAuth;

    NSLog(@"[GoogleHome] Loaded authentication (valid: %@)", loadedAuth.isValid ? @"YES" : @"NO");
    return YES;
}

- (void)clearAuthentication {
    self.authentication = nil;

    NSString *appSupport = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
    NSString *authPath = [[appSupport stringByAppendingPathComponent:@"RTSP Rotator"] stringByAppendingPathComponent:@"googlehome_auth.dat"];

    [[NSFileManager defaultManager] removeItemAtPath:authPath error:nil];

    NSLog(@"[GoogleHome] Cleared authentication");
}

#pragma mark - ASWebAuthenticationPresentationContextProviding

- (ASPresentationAnchor)presentationAnchorForWebAuthenticationSession:(ASWebAuthenticationSession *)session {
    // Return the main window for presenting the authentication UI
    return [NSApp mainWindow] ?: [[NSApp windows] firstObject];
}

@end
