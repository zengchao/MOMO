//
//  QWeiboSDK4iOSDemoAppDelegate.m
//  QWeiboSDK4iOSDemo
//
//  Created on 11-1-13.
//   
//

#import "QWeiboSDK4iOSDemoAppDelegate.h"
#import "QWeiboSDK4iOSDemoViewController.h"
#import "NSURL+QAdditions.h"

#define AppKey			@"appKey"
#define AppSecret		@"appSecret"
#define AppTokenKey		@"tokenKey"
#define AppTokenSecret	@"tokenSecret"

@implementation QWeiboSDK4iOSDemoAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize navigationController;

@synthesize appKey;
@synthesize appSecret;
@synthesize tokenKey;
@synthesize tokenSecret;
@synthesize verifier;
@synthesize response;


#pragma mark -
#pragma mark private methods

- (void)loadDefaultKey {
	
	self.appKey = [[NSUserDefaults standardUserDefaults] valueForKey:AppKey];
	self.appSecret = [[NSUserDefaults standardUserDefaults] valueForKey:AppSecret];
	self.tokenKey = [[NSUserDefaults standardUserDefaults] valueForKey:AppTokenKey];
	self.tokenSecret = [[NSUserDefaults standardUserDefaults] valueForKey:AppTokenSecret];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	[self loadDefaultKey];
	//for test
	self.appKey = @"27d1186230a443d1ac7f514a96376ada";
	self.appSecret = @"eff11cc20a1d582b81f1affe3e754889";
    // Add the view controller's view to the window and display.
    navigationController.viewControllers = [NSArray arrayWithObject:viewController];
	[self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	
	[appKey release];
	[appSecret release];
	[tokenKey release];
	[tokenSecret release];
	[verifier release];
	
    [viewController release];
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark instance methods

- (void)parseTokenKeyWithResponse:(NSString *)aResponse {
	
	NSDictionary *params = [NSURL parseURLQueryString:aResponse];
	self.tokenKey = [params objectForKey:@"oauth_token"];
	self.tokenSecret = [params objectForKey:@"oauth_token_secret"];
	
}

- (void)saveDefaultKey {
	
	[[NSUserDefaults standardUserDefaults] setValue:self.appKey forKey:AppKey];
	[[NSUserDefaults standardUserDefaults] setValue:self.appSecret forKey:AppSecret];
	[[NSUserDefaults standardUserDefaults] setValue:self.tokenKey forKey:AppTokenKey];
	[[NSUserDefaults standardUserDefaults] setValue:self.tokenSecret forKey:AppTokenSecret];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (UIViewController *)mainViewController {
	
	return self.navigationController;
}

@end
