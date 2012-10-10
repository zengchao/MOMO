//
//  CustomFilterVC.h
//  MOMO
//
//  Created by 超 曾 on 12-5-11.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>

@protocol UIViewPassValueDelegate  
- (void)passValue:(NSInteger)sex time:(NSInteger)time;
@end 

@interface CustomFilterVC : UIViewController
{
    NSObject<UIViewPassValueDelegate> * delegate;
    NSInteger in_sex;
    NSInteger in_time;
}
@property(nonatomic,retain)UIBarButtonItem *leftBtn;
@property(nonatomic,retain)IBOutlet UISegmentedControl *userSeg;
@property(nonatomic,retain)IBOutlet UISegmentedControl *dateSeg;
@property(nonatomic,retain)IBOutlet UIButton *btnConfirm;
@property(nonatomic,assign)NSInteger in_sex;//性别
@property(nonatomic,assign)NSInteger in_time;//最近登录时间间隔
@property(nonatomic,retain) NSObject<UIViewPassValueDelegate> * delegate;

-(IBAction)btnConfirmClick:(id)sender;

@end
