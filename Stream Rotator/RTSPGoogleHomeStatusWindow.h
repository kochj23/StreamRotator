//
//  RTSPGoogleHomeStatusWindow.h
//  Stream Rotator
//

#import <Cocoa/Cocoa.h>

@interface RTSPGoogleHomeStatusWindow : NSWindow

+ (instancetype)sharedWindow;
- (void)show;
- (void)refresh;

@end
