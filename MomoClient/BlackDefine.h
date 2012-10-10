//
//  BlackDefine.h
//  MOMO
//
//  Created by apple on 12-7-4.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "EGOImageView.h"
#import "Global.h"

@interface BlackDefine : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *array;
    ASIHTTPRequest *request;
}
@property(nonatomic,retain)NSMutableArray *array;
@property (retain, nonatomic) ASIHTTPRequest *request;
@end
