//
//  SystemConfVC.h
//  MOMO
//
//  Created by 超 曾 on 12-5-11.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "PincheAppDelegate.h"
#import "MemberInfoVC.h"
#import "blacklistVC.h"
#import "FeedBack.h"
#import "HideSet.h"
#import "MessageSet.h"
#import "SetPassWord.h"
#import "SoundSet.h"
#import "UserHelp.h"
#import "PositionSV.h"
#import "FMResultSet.h"
#import "ASIHTTPRequest.h"
#import "AppRec.h"
#import "SelectUserTypeViewController.h"

@class SelectUserTypeViewController;

@interface SystemConfVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate>
{
    UITableView *myTableView;
    NSString *modelText;
    NSString *timerText;
    ASIHTTPRequest *request;
    MemberInfoVC *vcMember;
    SelectUserTypeViewController *vcSelect;
    
    
}
@property (nonatomic,retain)UITableView *myTableView;
@property (nonatomic,retain)NSString *modelText;
@property (nonatomic,copy)NSString *timerText;
@property (retain, nonatomic) ASIHTTPRequest *request;
@property (nonatomic,retain)MemberInfoVC *vcMember;
@property (nonatomic,retain)SelectUserTypeViewController *vcSelect;

@end
