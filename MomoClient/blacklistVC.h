//
//  blacklistVC.h
//  MOMO
//
//  Created by apple on 12-6-13.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "EGOImageView.h"
#import "BlackDefine.h"
@interface blacklistVC : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>{
    UITableView *tableview;
    NSMutableArray *array;
    MBProgressHUD *HUD;
    ASIHTTPRequest *request;
}
@property(nonatomic,retain)NSMutableArray *array;
@property(nonatomic,retain)UITableView *tableview;
@property (retain, nonatomic) ASIHTTPRequest *request;
@end
