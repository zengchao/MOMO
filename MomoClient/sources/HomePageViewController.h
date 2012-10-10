//
//  HomePageViewController.h
//  TicketSystem
//
//  Created by ZYVincent on 12-3-8.
//---------------------------------
//    文件作用：ZYProSoft团队主页
//            
//            
//    作者：胡涛
//    支持:http://www.ruyijian.com
//    团队QQ群号：219357847
//    团队主题：奋斗路上携手相伴！
//---------------------------------
//  Copyright (c) 2012年 __ZYProSoft__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYPullRefreshTableViewController.h"
//#import "ChooseTypeView.h"
//#import "ZYProSoftNoti.h"

@interface HomePageViewController : ZYPullRefreshTableViewController
/*<ChooseTypeViewDelegate>*/
{
    //ChooseTypeView *chooseTypeView;    
    
    NSMutableArray *currentNotiArray;
    
    BOOL ifNeedUpdateNow;//判断是否需要立即更新
    
    NSInteger selectTypeIndex;//但前选择的查询类型
    BOOL chooseTypeViewCanMove;//判定选择类型视图是否可以推出
}
@property (nonatomic,retain)NSMutableArray *currentNotiArray;

@end
