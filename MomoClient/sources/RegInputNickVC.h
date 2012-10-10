//
//  RegInputNickVC.h
//  MOMO
//
//  Created by 超 曾 on 12-4-19.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "Global.h" 
#import "RegInputBirthVC.h"
#import "LBS_Member.h"
#import "Global.h"
@class RegInputBirthVC;

@interface RegInputNickVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    UITableView *myTableView;
    MBProgressHUD *HUD;
    UITextField *tfNickname;
    UISegmentedControl *mySeg;
    LBS_Member *lbsMember;
}
@property(nonatomic,retain)UITableView *myTableView;
@property(nonatomic,retain)UITextField *tfNickname;
@property(nonatomic,retain)IBOutlet UISegmentedControl *mySeg;
@property(nonatomic,retain)LBS_Member *lbsMember;
@property(nonatomic,retain)RegInputBirthVC *vcBirth;

@end
