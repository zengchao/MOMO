//
//  MessageSet.h
//  MOMO
//
//  Created by apple on 12-6-11.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>

@interface MessageSet : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSArray *array;
    BOOL isalert;
    NSString *Text1;
    NSString *Text2;
    NSString *Text3;
}

@property (nonatomic, retain) UITableView *_tableView;
//@property (nonatomic,retain)NSMutableArray *MessageArray;
@property (nonatomic, copy)NSString *Text1;
@property (nonatomic, copy)NSString *Text2;
@property (nonatomic, copy)NSString *Text3;
@end
