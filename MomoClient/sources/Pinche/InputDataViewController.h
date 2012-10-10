//
//  InputDataViewController.h
//  MOMO
//
//  Created by 超 曾 on 12-5-23.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  输入搭车、拼车等具体的要求
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "SelectTimeViewController.h"
#import "NearbyMemberVC.h"
#import "sendLocViewController.h"
#import "MapDirectionsViewController.h"
#import "ASIHTTPRequest.h"

@interface InputDataViewController : UIViewController
{
    NSString *flag;//0 有车 1搭车 2拼车 
    NSMutableDictionary *mydict;
    ASIHTTPRequest *request;
    
}
@property(nonatomic,retain)ASIHTTPRequest *request;
@property(nonatomic,retain)NSMutableDictionary *mydict;
@property(nonatomic,retain)NSString *flag;
@property(nonatomic,retain)IBOutlet UIButton *btnStartpos;
@property(nonatomic,retain)IBOutlet UIButton *btnEndpos;
@property(nonatomic,retain)IBOutlet UIButton *btnTime;
@property(nonatomic,retain)IBOutlet UISegmentedControl *segSex;
@property(nonatomic,retain)IBOutlet UISegmentedControl *segSmoke;
@property(nonatomic,retain)IBOutlet UISegmentedControl *segFee;
@property(nonatomic,retain)IBOutlet UIButton *btnDecrease;
@property(nonatomic,retain)IBOutlet UIButton *btnAdd;
@property(nonatomic,retain)IBOutlet UITextField *txtPeoples;
@property(nonatomic,retain)IBOutlet UILabel *labelStartpos;
@property(nonatomic,retain)IBOutlet UILabel *labelEndpos;
@property(nonatomic,retain)IBOutlet UIButton *btnRoute;
@property(nonatomic,retain)sendLocViewController *vcLoc;
@property(nonatomic,retain)SelectTimeViewController *vcSelect;
@property(nonatomic,retain)NearbyMemberVC *vcNear;
@property(nonatomic,retain)MapDirectionsViewController *vcMapD;

-(IBAction)OpenMapWin:(id)sender;
-(IBAction)OpenDateWin:(id)sender;
-(IBAction)ModifyPeoples:(id)sender;
-(IBAction)queryRoute:(id)sender;
-(IBAction)segmentChanged:(UISegmentedControl *)paramSender;

@end
