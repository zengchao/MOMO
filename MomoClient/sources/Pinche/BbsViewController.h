//
//  BbsViewController.h
//  MOMO
//
//  Created by 超 曾 on 12-5-23.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  公告板 ,提供展示和发布功能
//  QQ:1490724

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "MBProgressHUD.h"
#import "EGORefreshTableHeaderView.h"
#import "Global.h"
#import "BbsDetailVC.h"
#import "ASIHTTPRequest.h"

@interface BbsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,EGORefreshTableHeaderDelegate,MFMailComposeViewControllerDelegate>
{
    UITableView *myTableView;
    MBProgressHUD *HUD;
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    NSMutableArray *list;
    ASIHTTPRequest *request;
    BbsDetailVC *vcBbsDetail;
}
@property(nonatomic,retain)ASIHTTPRequest *request;
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,retain)NSMutableArray *list;
@property (nonatomic,retain)BbsDetailVC *vcBbsDetail;

-(void)loadList;
@end
