//
//  CheweiListVC.h
//  MOMO
//
//  Created by 超 曾 on 12-6-9.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "EGORefreshTableHeaderView.h"
#import "Global.h"
#import "CheweiApplyListVC.h"
#import "CheweiManagerVC.h"
#import "ASIHTTPRequest.h"

@interface CheweiListVC : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,EGORefreshTableHeaderDelegate>
{
    NSString *member_id;
    UITableView *myTableView;
    NSMutableArray *list;
    MBProgressHUD *HUD;
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    ASIHTTPRequest *request;
}
@property(nonatomic,retain)ASIHTTPRequest *request;
@property(nonatomic,retain)UITableView *myTableView;
@property (nonatomic,retain)NSMutableArray *list;
@property(nonatomic,retain)NSString *member_id;

@end
