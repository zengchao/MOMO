//
//  RegInputBirthVC.h
//  MOMO
//
//  Created by 超 曾 on 12-4-19.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "Global.h" 
#import "RegUploadPicVC.h"
#import "LBS_Member.h"
#import "NSObject+SBJson.h"
#import "Global.h"
@class ASIHTTPRequest;

@interface RegInputBirthVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    ASIHTTPRequest *request;
    UITableView *myTableView;
    MBProgressHUD *HUD;
    UIDatePicker *myDatePicker;
    UILabel *lblAge;
    UILabel *lblXingzuo;
    LBS_Member *lbsMember;
}
@property(nonatomic,retain)UITableView *myTableView;
@property(nonatomic,retain)UIDatePicker *myDatePicker;
@property(nonatomic,retain)UILabel *lblAge;
@property(nonatomic,retain)UILabel *lblXingzuo;
@property(nonatomic,retain)LBS_Member *lbsMember;
@property (retain, nonatomic) ASIHTTPRequest *request;

@end
