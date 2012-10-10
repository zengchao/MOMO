//
//  MainTabViewController.h
//  TicketSystem
//
//  Created by ZYVincent on 12-2-19.
//---------------------------------
//    文件作用：主界面TabbarViewController
//            
//            
//    作者：胡涛
//    支持:http://www.ruyijian.com
//    团队QQ群号：219357847
//    团队主题：奋斗路上携手相伴！
//---------------------------------
//  Copyright (c) 2012年 __ZYProSoft__. All rights reserved.
//


#import "UICustomTabBar.h"

@interface MainTabViewController : UITabBarController<UICustomTabBar>
{
    NSMutableArray *customTabBarItems;//自定义tabbarItem
}
@property (nonatomic,retain)NSMutableArray *customTabBarItems;

//- (void)refreshTicketDataNow;

@end
