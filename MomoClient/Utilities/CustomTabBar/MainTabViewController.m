//
//  MainTabViewController.m
//  TicketSystem
//
//  Created by ZYVincent on 12-2-19.
//  Copyright (c) 2012年 __ZYProSoft__. All rights reserved.
//  http://www.ruyijian.com
//    团队QQ群号：219357847
//    团队主题：奋斗路上携手相伴！

#import "MainTabViewController.h"
#import "NearbyMemberVC.h"
#import "ConversationVC.h"
#import "FriendViewController.h"
#import "SelectUserTypeViewController.h"
#import "SystemConfVC.h"

#define RED_VALUE 2
#define GREEN_VALUE 75
#define BLUE_VALUE 104
#define COLOR_ALPHA 1

@implementation MainTabViewController
@synthesize customTabBarItems;

//替换默认得tabbar
- (void)initCustomTabBar
{
    customTabBarItems=[[NSMutableArray alloc]init];
    
    //自定义tabbar
    UIView *customTabBar=[[UIView alloc]init];
    customTabBar.frame=self.tabBar.frame;
    
    customTabBar.frame=self.tabBar.bounds;
    [self.tabBar addSubview:customTabBar];
    [customTabBar release];
    
    for (int i=0;i<4; i++) {
        
        NSString *tabBarClickedImageName=[NSString stringWithFormat:@"bar%dSelected.png",i];
        NSString *tabBarImageName=[NSString stringWithFormat:@"bar%dNormal.png",i];
        
        UICustomTabBar *tabBar=[[UICustomTabBar alloc]
                                initWithNormalStateImage:[UIImage imageNamed:tabBarImageName] 
                                andClickedStateImage:[UIImage imageNamed:tabBarClickedImageName]];
        
        tabBar.frame = CGRectMake(80*i,1,80,44);
        tabBar.delegate=self;
        tabBar.tabBarTag=i;
        
        [customTabBar addSubview:tabBar];
        [tabBar release];
        [customTabBarItems addObject:tabBar];
        
        //如果是第一个那么默认是选中的
        if (0==i) {
            [tabBar switchToClickedState];
        }
    }
}
//tabbar代理方法
- (void)tabBarDidTapped:(id)sender{
    
    UICustomTabBar *tabBar=(UICustomTabBar*)sender;
    for (UICustomTabBar *tabBarInstance in customTabBarItems) {
        [tabBarInstance switchToNormalState];
    }
    [tabBar switchToClickedState];
    //NSLog(@"%d",tabBar.tabBarTag);
    UIViewController *selectedController=[self.viewControllers objectAtIndex:tabBar.tabBarTag];
    self.selectedViewController=selectedController;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //设置tabbar颜色
        //self.tabBar.tintColor = [UIColor colorWithRed:RED_VALUE/255.0 green:GREEN_VALUE/255.0 blue:BLUE_VALUE/255.0 alpha:COLOR_ALPHA];
        [self.tabBar setBackgroundImage:[UIImage imageNamed:@"banner.png"]];
        NearbyMemberVC *detailController1 = [[[NearbyMemberVC alloc] init] autorelease];
        UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:detailController1];
        
        
        
        FriendViewController *detailController2 = [[[FriendViewController alloc] init] autorelease];
        UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:detailController2];
        
        ConversationVC *detailController3 = [[[ConversationVC alloc] init] autorelease];
        UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:detailController3];
        
//        SelectUserTypeViewController *detailController4 = [[[SelectUserTypeViewController alloc] initWithNibName:@"SelectUserTypeViewController" bundle:nil] autorelease];
//        UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:detailController4];
        
        SystemConfVC *detailController4 = [[[SystemConfVC alloc] init] autorelease];
        UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:detailController4];        
        
        //添加到tabbarcontroller
        NSMutableArray *navControllers = [NSMutableArray arrayWithObjects:nav1,nav2,nav3,nav4,nil];
        self.viewControllers = navControllers;
        [nav1 release];
        [nav2 release];
        [nav3 release];
        [nav4 release];
        
        
        [self initCustomTabBar];//自定tabbar
        
    }
    return self;
}

//立即刷新票类信息
/*- (void)refreshTicketDataNow
{
    if (self.selectedIndex == 1) {
        TicketPreordainViewController *viewController = [ticketQueryNavController.viewControllers objectAtIndex:0];
        [viewController refreshNow];
    }
}*/

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)dealloc{
    [customTabBarItems release];
    [super dealloc];
}
@end
