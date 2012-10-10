//
//  AppDelegate.m
//  Phone
//
//  Created by xin dong on 10-9-6.
//  Copyright Lixf 2010. All rights reserved.
//

#import "AppDelegate.h"
#import "ContactsCtrl.h"
@implementation AppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {   
	if(addressBook == nil)
		addressBook = ABAddressBookCreate();
	[window addSubview:contactView.view];
    [window makeKeyAndVisible];
	return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application{
	CFRelease(addressBook);
}


- (void)dealloc {
	[contactView release];
    [window release];
    [super dealloc];
}


@end
