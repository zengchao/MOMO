//
//  ALTabBarController.m
//  ALCommon
//
//  Created by Andrew Little on 10-08-17.
//  Copyright (c) 2010 Little Apps - www.myroles.ca. All rights reserved.
//

#import "ALTabBarController.h"
#import "NearbyMemberVC.h"

#define SELECTED_VIEW_CONTROLLER_TAG 98456345

@implementation ALTabBarController

@synthesize customTabBarView;

- (void)dealloc {
    
    [customTabBarView release];
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self hideExistingTabBar];
    
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"TabBarView" owner:self options:nil];
    self.customTabBarView = [nibObjects objectAtIndex:0];
    self.customTabBarView.delegate = self;
    
    [self.view addSubview:self.customTabBarView];
}

- (void)hideExistingTabBar
{
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
			break;
		}
	}
}

#pragma mark ALTabBarDelegate



- (void) touchDownAtItemAtIndex:(NSUInteger)itemIndex
{
    // Remove the current view controller's view
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];
    
    // Get the right view controller
    //NSDictionary* data = [tabBarItems objectAtIndex:itemIndex];
    //UIViewController* viewController = [data objectForKey:@"viewController"];
    
    
    
    NearbyMemberVC *detailController1 = [[[NearbyMemberVC alloc] init] autorelease];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:detailController1];
    

    
    // Set the view controller's frame to account for the tab bar
    nav1.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height-44);
    
    // Se the tag so we can find it later
    nav1.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    
    // Add the new view controller's view
    [self.view addSubview:nav1.view];
    [nav1 release];
    
    
}
-(void)tabWasSelected:(NSInteger)index {
    self.selectedIndex = index;
    [self touchDownAtItemAtIndex:index];
}


@end
