//
//  SoundSet.h
//  MOMO
//
//  Created by apple on 12-6-13.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "PincheAppDelegate.h"
#import "FMResultSet.h"
@interface SoundSet : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tableview;
    UISwitch *swit;
    IBOutlet UILabel *lable1;
    IBOutlet UILabel *lable2;
    IBOutlet UILabel *tolable;
    IBOutlet UIPickerView *picker;
    NSMutableArray *array;
    NSString *soundTime;
}
@property(nonatomic,retain)UISwitch *swit;
@property(nonatomic,retain)UILabel *lable1;
@property(nonatomic,retain)UILabel *lable2;
@property(nonatomic,copy)NSString *soundTime;
@end
