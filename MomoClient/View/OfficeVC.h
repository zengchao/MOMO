//
//  OfficeVC.h
//  MOMO
//
//  Created by 超 曾 on 12-5-12.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface OfficeVC : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{
    UITableView *myTableView;
    MBProgressHUD *HUD;
}

@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,retain)UIBarButtonItem *rightBarButtonItem;

@end
