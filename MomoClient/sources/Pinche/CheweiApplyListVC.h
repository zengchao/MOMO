//
//  CheweiApplyListVC.h
//  MOMO
//
//  Created by 超 曾 on 12-6-9.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "EGORefreshTableHeaderView.h"
#import "Global.h"
@class ASIHTTPRequest;

@interface CheweiApplyListVC : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,EGORefreshTableHeaderDelegate,UIActionSheetDelegate>
{
    NSString *member_id;
    NSString *chewei_id;
    NSString *chewei_name;
    UITableView *myTableView;
    NSMutableArray *list;
    MBProgressHUD *HUD;
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    ASIHTTPRequest *request;
    NSString *curid;//当前选中的行的id  lbs_chewei_apply.id
}
@property(nonatomic,retain)UITableView *myTableView;
@property (nonatomic,retain)NSMutableArray *list;
@property(nonatomic,retain)NSString *member_id;
@property(nonatomic,retain)NSString *chewei_id;
@property(nonatomic,retain)NSString *chewei_name;
@property(nonatomic,retain)NSString *curid;
@property (retain, nonatomic) ASIHTTPRequest *request;

@end
