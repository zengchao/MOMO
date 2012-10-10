//
//  StartVC.h
//  MOMO
//
//  Created by 超 曾 on 12-6-26.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "Global.h"
#import "RegStepOneVC.h"
#import "LoginViewController.h"
@class LoginViewController;
@class RegStepOneVC;

@interface StartVC : UIViewController

@property(nonatomic,retain)UIBarButtonItem *backReg;
@property(nonatomic,retain)UIBarButtonItem *backLogin;
@property(nonatomic,retain)LoginViewController *vcLogin;
@property(nonatomic,retain)RegStepOneVC *vcReg;

- (IBAction)callRegisterWindow:(UIButton *)sender;
- (IBAction)callLoginWindow:(UIButton *)sender;

@end
