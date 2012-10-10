//
//  QWeiboSDK4iOSDemoAppDelegate.h
//  QWeiboSDK4iOSDemo
//
//  Created on 11-1-13.
//   
//

#import <UIKit/UIKit.h>

@class QWeiboSDK4iOSDemoViewController;

@interface QWeiboSDK4iOSDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    QWeiboSDK4iOSDemoViewController *viewController;
	UINavigationController *navigationController;
	
	NSString *appKey;
	NSString *appSecret;
	NSString *tokenKey;
	NSString *tokenSecret;
	NSString *verifier;
	
	NSString *response;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet QWeiboSDK4iOSDemoViewController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *appSecret;
@property (nonatomic, copy) NSString *tokenKey;
@property (nonatomic, copy) NSString *tokenSecret;
@property (nonatomic, copy) NSString *verifier;
@property (nonatomic, copy) NSString *response;

- (void)parseTokenKeyWithResponse:(NSString *)response;

- (void)saveDefaultKey;

- (UIViewController *)mainViewController;

@end

