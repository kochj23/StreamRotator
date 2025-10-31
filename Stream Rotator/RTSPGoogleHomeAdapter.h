//
//  RTSPGoogleHomeAdapter.h
//  RTSP Rotator
//
//  Google Home / Nest camera integration adapter
//

#import <Foundation/Foundation.h>
#import "RTSPDashboardManager.h"

NS_ASSUME_NONNULL_BEGIN

/// Google Home camera authentication
@interface RTSPGoogleHomeAuth : NSObject <NSCoding, NSSecureCoding>

@property (nonatomic, strong, nullable) NSString *accessToken;
@property (nonatomic, strong, nullable) NSString *refreshToken;
@property (nonatomic, strong, nullable) NSDate *tokenExpiration;
@property (nonatomic, strong, nullable) NSString *projectID;
@property (nonatomic, strong, nullable) NSString *clientID;
@property (nonatomic, strong, nullable) NSString *clientSecret;

/// Check if authentication is valid
- (BOOL)isValid;

/// Check if token needs refresh
- (BOOL)needsRefresh;

@end

/// Google Home camera information
@interface RTSPGoogleHomeCamera : NSObject

@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *deviceType; // "CAMERA", "DOORBELL", etc.
@property (nonatomic, strong, nullable) NSURL *streamURL;
@property (nonatomic, strong, nullable) NSURL *snapshotURL;
@property (nonatomic, strong, nullable) NSString *roomHint;
@property (nonatomic, assign) BOOL isOnline;
@property (nonatomic, strong, nullable) NSDictionary *traits; // Camera capabilities

/// Convert to RTSPCameraConfig
- (RTSPCameraConfig *)toCameraConfig;

@end

@class RTSPGoogleHomeAdapter;

/// Google Home adapter delegate
@protocol RTSPGoogleHomeAdapterDelegate <NSObject>
@optional
- (void)googleHomeAdapter:(RTSPGoogleHomeAdapter *)adapter didAuthenticateSuccessfully:(RTSPGoogleHomeAuth *)auth;
- (void)googleHomeAdapter:(RTSPGoogleHomeAdapter *)adapter authenticationFailedWithError:(NSError *)error;
- (void)googleHomeAdapter:(RTSPGoogleHomeAdapter *)adapter didDiscoverCameras:(NSArray<RTSPGoogleHomeCamera *> *)cameras;
- (void)googleHomeAdapter:(RTSPGoogleHomeAdapter *)adapter didUpdateCamera:(RTSPGoogleHomeCamera *)camera;
@end

/// Google Home / Nest camera integration
@interface RTSPGoogleHomeAdapter : NSObject

/// Shared instance
+ (instancetype)sharedAdapter;

/// Delegate for authentication and discovery events
@property (nonatomic, weak) id<RTSPGoogleHomeAdapterDelegate> delegate;

/// Current authentication
@property (nonatomic, strong, nullable) RTSPGoogleHomeAuth *authentication;

/// Discovered cameras
- (NSArray<RTSPGoogleHomeCamera *> *)cameras;

/// Authenticate with Google Home
/// Uses OAuth 2.0 flow - opens browser for user consent
- (void)authenticateWithCompletionHandler:(nullable void (^)(BOOL success, NSError *_Nullable error))completion;

/// Refresh access token
- (void)refreshTokenWithCompletionHandler:(nullable void (^)(BOOL success, NSError *_Nullable error))completion;

/// Discover all Google Home cameras
- (void)discoverCamerasWithCompletionHandler:(nullable void (^)(NSArray<RTSPGoogleHomeCamera *> *cameras, NSError *_Nullable error))completion;

/// Get stream URL for specific camera
- (void)getStreamURLForCamera:(RTSPGoogleHomeCamera *)camera
            completionHandler:(nullable void (^)(NSURL *_Nullable streamURL, NSError *_Nullable error))completion;

/// Get snapshot URL for camera
- (void)getSnapshotURLForCamera:(RTSPGoogleHomeCamera *)camera
              completionHandler:(nullable void (^)(NSURL *_Nullable snapshotURL, NSError *_Nullable error))completion;

/// Convert Google Home cameras to camera configs
- (NSArray<RTSPCameraConfig *> *)convertCamerasToConfigs:(NSArray<RTSPGoogleHomeCamera *> *)cameras;

/// Import Google Home cameras into dashboard
- (void)importCamerasIntoDashboard:(RTSPDashboard *)dashboard
                 completionHandler:(nullable void (^)(NSInteger importedCount, NSError *_Nullable error))completion;

/// Save authentication
- (BOOL)saveAuthentication;

/// Load authentication
- (BOOL)loadAuthentication;

/// Clear authentication (logout)
- (void)clearAuthentication;

@end

NS_ASSUME_NONNULL_END
