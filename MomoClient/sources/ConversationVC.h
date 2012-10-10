//
//  ConversationVC.h
//  MOMO
//
//  Created by 超 曾 on 12-4-29.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "EGOCache.h"
#import "EGOImageView.h"
#import "Global.h"
#import "SendMessageVC.h"
#import "ASIHTTPRequest.h"

@interface ConversationVC : UIViewController<MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
    MBProgressHUD *HUD;
    NSMutableArray *list;
    EGOImageView *thumbnail;
    UILabel *titleLabel;
    ASIHTTPRequest *request;
    SendMessageVC *vcMessage;
}
@property (nonatomic,retain)ASIHTTPRequest *request;
@property (nonatomic,retain)UILabel *titleLabel;
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,retain)NSMutableArray *list;
@property (nonatomic,retain)SendMessageVC *vcMessage;

-(void)loadList;
@end
