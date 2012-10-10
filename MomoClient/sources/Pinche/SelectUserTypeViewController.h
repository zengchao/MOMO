//
//  SelectUserTypeViewController.h
//  MOMO
//
//  Created by 超 曾 on 12-5-23.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  搭车 拼车 的入口页面
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "InputDataViewController.h"
#import "BbsViewController.h"
#import "MemberInfoVC.h"
#import "SystemConfVC.h"
@interface SelectUserTypeViewController : UIViewController
{
    BbsViewController *vcBbs;
}

@property(nonatomic,retain)IBOutlet UIButton *btnFirst;
@property(nonatomic,retain)IBOutlet UIButton *btnSecond;
@property(nonatomic,retain)IBOutlet UIButton *btnThird;
@property(nonatomic,retain)IBOutlet UIButton *btnBbs;
@property(nonatomic,retain)IBOutlet UIButton *btnSetup;
@property(nonatomic,retain)InputDataViewController *vcInput;
@property(nonatomic,retain)BbsViewController *vcBbs;

-(IBAction)btnOpenDataWin:(id)sender;
-(IBAction)btnOpenBbsWin:(id)sender;

@end
