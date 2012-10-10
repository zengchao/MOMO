//
//  SelectTimeViewController.h
//  MOMO
//
//  Created by 超 曾 on 12-5-23.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  选择时间
//  QQ:1490724

#import <UIKit/UIKit.h>

@interface SelectTimeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
    UIDatePicker *myDatePicker;
    NSMutableArray *list;
    int currow;
}
@property(nonatomic,retain)UITableView *myTableView;
@property(nonatomic,retain)UIDatePicker *myDatePicker;
@property(nonatomic,retain)NSMutableArray *list;

@end
