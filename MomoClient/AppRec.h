//
//  AppRec.h
//  MOMO
//
//  Created by apple on 12-7-2.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "ImageLoader.h"
#import "EGOImageView.h"
@interface AppRec : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>{
    UITableView *tableview;
    NSMutableArray *array;
    MBProgressHUD *HUD;
    ASIHTTPRequest *request;
    NSOperationQueue *queue;
	NSMutableDictionary *dict;
}
@property(nonatomic,retain)NSMutableArray *array;
@property(nonatomic,retain)UITableView *tableview;
@property (retain, nonatomic) ASIHTTPRequest *request;
@end
