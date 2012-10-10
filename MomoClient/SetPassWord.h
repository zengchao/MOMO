//
//  SetPassWord.h
//  MOMO
//
//  Created by apple on 12-6-8.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"

@class ASIHTTPRequest;
@interface SetPassWord : UIViewController<UITableViewDelegate,UITableViewDataSource, MBProgressHUDDelegate>{
    UITextField *oldpwd;
    UITextField *newpwd;
    UITextField *rnewpwd;
    UITableView *tableview;
    ASIHTTPRequest *request;
    MBProgressHUD *HUD;
}
@property (retain, nonatomic) ASIHTTPRequest *request;

@end
