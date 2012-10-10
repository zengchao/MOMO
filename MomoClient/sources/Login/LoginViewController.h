//
//  LoginViewController.h
//
//  Created by 超 曾 on 12-3-27.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"
#import "PincheAppDelegate.h"
#import "UINavigationBar+customImage.h"

@class ASIHTTPRequest;
@class RegStepOneVC;

@protocol LoginViewControllerDelegate <NSObject>
- (void)loginSuccessed:(NSObject*)result;
@end

@interface LoginViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate,CLLocationManagerDelegate>
{
    ASIHTTPRequest *request;
    BOOL checkFlag;
    BOOL goFlag;
    MBProgressHUD *HUD;
    NSString *myMobileno;
    NSString *mySmscode;
    CLLocationManager *locationManager;
    id<LoginViewControllerDelegate> delegate;
    UITextField *textField;
}
@property (nonatomic,assign)id<LoginViewControllerDelegate> delegate;
@property(nonatomic,assign)UITextField *txtPhoneNumber;
@property(nonatomic,assign)UITextField *txtLoginPwd;
@property(nonatomic,assign)IBOutlet UILabel *tipLabel1;
@property(nonatomic,assign)IBOutlet UILabel *tipLabel2;
@property(nonatomic,assign)IBOutlet UIButton *btnCheck;
@property(nonatomic,assign)IBOutlet UIButton *btnLogin;
@property(nonatomic,assign)IBOutlet UIButton *btnRegister;
@property(nonatomic,assign)IBOutlet UIButton *btnForgetPwd;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (retain, nonatomic) ASIHTTPRequest *request;
@property (retain, nonatomic) RegStepOneVC *vcReg;


-(IBAction)check_handle:(id)sender;
-(IBAction)doNext_handle:(id)sender;
-(IBAction)doForgetPwd_handle:(id)sender;
-(IBAction)doRegister_handle:(id)sender;
- (void)dologin:(double)xpos ypos:(double)ypos;
@end
