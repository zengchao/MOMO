//
//  RegStepOneVC.h
//  MOMO
//
//  Created by 超 曾 on 12-4-17.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "Global.h"  
#import "RegInputNickVC.h"
#import "LBS_Member.h"
#import "NSObject+SBJson.h"
@class ASIHTTPRequest;
@class RegInputNickVC;

@interface RegStepOneVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    UITableView *myTableView;
    UITextField *tfMailAddr;
    UITextField *tfPassword;
    UITextField *tfConfirmPassword;
    MBProgressHUD *HUD;
    LBS_Member *lbsMember;
    ASIHTTPRequest *request;
    BOOL checkFlag;
    UIButton *btnCheck;
}
@property (retain, nonatomic) ASIHTTPRequest *request;
@property(nonatomic,retain)UITableView *myTableView;
@property(nonatomic,retain)UITextField *tfMailAddr;
@property(nonatomic,retain)UITextField *tfPassword;
@property(nonatomic,retain)UITextField *tfConfirmPassword;
@property(nonatomic,retain)RegInputNickVC *vcNick;

@end
