//
//  CheweiManagerVC.h
//  MOMO
//
//  Created by 超 曾 on 12-6-9.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  车主对车位的管理 新增车位、修改车位名称、修改车位状态（占座、取消占座）、删除车位
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "Global.h"
#import "CheweiApplyListVC.h"
@class ASIHTTPRequest;

@interface CheweiManagerVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    NSString *member_id;
    UITableView *myTableView;
    NSMutableArray *list;
    ASIHTTPRequest *request;
}
@property(nonatomic,retain)UITableView *myTableView;
@property (nonatomic,retain)NSMutableArray *list;
@property(nonatomic,retain)NSString *member_id;
@property (retain, nonatomic) ASIHTTPRequest *request;

@end
