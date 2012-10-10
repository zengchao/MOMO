//
//  FriendViewController.h
//  MOMO_DEMO
//
//  Created by 超 曾 on 12-4-15.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "EGOCache.h"
#import "EGOImageView.h"
#import "EGORefreshTableHeaderView.h"
#import "AddFriendVC.h"
#import "Global.h"
#import "MemberInfoVC.h"
#import "ASIHTTPRequest.h"
#import "UserinfoVC.h"

@interface FriendViewController : UIViewController<MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UITableView *myTableView;
    MBProgressHUD *HUD;
    NSMutableArray *list;
    EGOImageView *thumbnail;
    UILabel *titleLabel;
    NSString *flag;
    NSString *order;
    ASIHTTPRequest *request;
    MemberInfoVC *vcMember;
    AddFriendVC *vcAddFriend;
    UserinfoVC *vcUser;
}
@property(nonatomic,retain)ASIHTTPRequest *request;
@property (nonatomic,retain)UILabel *titleLabel;
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,retain)NSMutableArray *list;
@property(nonatomic,retain)UIBarButtonItem *leftBtn;
@property(nonatomic,retain)UIBarButtonItem *rightBtn;
@property(nonatomic,retain)UISegmentedControl *seg;
@property(nonatomic,retain)MemberInfoVC *vcMember;
@property(nonatomic,retain)AddFriendVC *vcAddFriend;
@property(nonatomic,retain)UserinfoVC *vcUser;

-(void)loadList;

@end
