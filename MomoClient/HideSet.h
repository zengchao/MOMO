//
//  HideSet.h
//  MOMO
//
//  Created by apple on 12-6-10.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "Utility.h"
#import "ASIHTTPRequest.h"
#import "PincheAppDelegate.h"
#import "FMResultSet.h"
@interface HideSet : UIViewController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>{
    UITableView *tableview;
    MBProgressHUD *HUD;
    int s;
    ASIHTTPRequest *request;
}
@property (retain, nonatomic) ASIHTTPRequest *request;

-(void)urlrequest:(NSNumber *)state;
-(void)change:(int)row;
@end
