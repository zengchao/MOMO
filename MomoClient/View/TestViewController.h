//
//  TestViewController.h
//  MOMO
//
//  Created by 超 曾 on 12-6-12.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "CommentViewCell.h"

@interface TestViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *itemView;
    NSMutableArray *list;
}
@property (nonatomic,retain) UITableView *itemView;
@property (nonatomic,retain) NSMutableArray *list;
@end
