//
//  UserinfoVC.h
//  dache
//
//  Created by 超 曾 on 12-7-14.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "SWSnapshotStackView.h"
#import "Global.h"
#import "ClientConnection.h"
#import "EGOImageView.h"

@class ASIHTTPRequest;
@class SendMessageVC;
@class MyRoadVC;
@class SendMessageVC;
@class ASIHTTPRequest;

@interface UserinfoVC : UIViewController
{
    SWSnapshotStackView *imageView;
    NSMutableDictionary *mydict;
    UIToolbar *m_pToolBar;
    UIButton *m_pButtonAdd;
    UIButton *m_pButtonAdd2;
    UIButton *m_pButtonAdd3;
    MyRoadVC *vcRoad;
    SendMessageVC *vcMessage;
    ASIHTTPRequest *request;
    UILabel *usernameLabel;
    UILabel *sexLabel;
    UILabel *starttimeLabel;
    UILabel *startposnameLabel;
    UILabel *endposnameLabel;
    UILabel *yaoqiuLabel;
    UILabel *qianmingLabel;
    NSMutableArray *data;
}
@property (nonatomic,retain)NSMutableArray *data;
@property (nonatomic,retain)IBOutlet SWSnapshotStackView *imageView;
@property (nonatomic,retain)NSMutableDictionary *mydict;
@property (nonatomic,retain)UIToolbar *m_pToolBar;
@property (nonatomic,retain)UIButton *m_pButtonAdd;
@property (nonatomic,retain)UIButton *m_pButtonAdd2;
@property (nonatomic,retain)UIButton *m_pButtonAdd3;
@property (nonatomic,retain)MyRoadVC *vcRoad;
@property (nonatomic,retain)SendMessageVC *vcMessage;
@property (nonatomic,retain)ASIHTTPRequest *request;

@property (nonatomic,retain)IBOutlet UILabel *usernameLabel;
@property (nonatomic,retain)IBOutlet UILabel *sexLabel;
@property (nonatomic,retain)IBOutlet UILabel *starttimeLabel;
@property (nonatomic,retain)IBOutlet UILabel *startposnameLabel;
@property (nonatomic,retain)IBOutlet UILabel *endposnameLabel;
@property (nonatomic,retain)IBOutlet UILabel *yaoqiuLabel;
@property (nonatomic,retain)IBOutlet UILabel *qianmingLabel;

@end
