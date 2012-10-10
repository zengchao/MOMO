//
//  MyRoadVC.h
//  MOMO
//
//  Created by 超 曾 on 12-6-8.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "SelectTimeViewController.h"
#import "sendLocViewController.h"
#import "MapDirectionsViewController.h"
#import "Global.h"

@interface MyRoadVC : UIViewController
{
    NSMutableDictionary *mydict;
    NSString *member_id;
    NSString *username;
}
@property(nonatomic,retain)NSString *member_id;
@property(nonatomic,retain)NSString *username;
@property(nonatomic,retain)NSMutableDictionary *mydict;
@property(nonatomic,retain)IBOutlet UIButton *btnStartpos;
@property(nonatomic,retain)IBOutlet UIButton *btnEndpos;
@property(nonatomic,retain)IBOutlet UIButton *btnTime;
@property(nonatomic,retain)IBOutlet UIButton *btnRoute;
-(IBAction)OpenMapWin:(id)sender;
-(IBAction)OpenDateWin:(id)sender;
-(IBAction)queryRoute:(id)sender;
@end
