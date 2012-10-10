//
//  BbsDetailVC.h
//  MOMO
//
//  Created by 超 曾 on 12-6-2.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>

@interface BbsDetailVC : UIViewController
{
    NSString *s_userid;
    NSString *s_username;
    NSString *s_title;
    NSString *s_content;
    NSString *s_updatetime;
    NSString *s_flag;
    NSString *s_id;
}
@property(nonatomic,retain)NSString *s_userid;
@property(nonatomic,retain)NSString *s_username;
@property(nonatomic,retain)NSString *s_title;
@property(nonatomic,retain)NSString *s_content;
@property(nonatomic,retain)NSString *s_updatetime;
@property(nonatomic,retain)NSString *s_flag;
@property(nonatomic,retain)NSString *s_id;


@property(nonatomic,retain)IBOutlet UILabel *labelTitle;
@property(nonatomic,retain)IBOutlet UILabel *labelUsername;
@property(nonatomic,retain)IBOutlet UILabel *labelUpdatetime;
@property(nonatomic,retain)IBOutlet UITextView *textviewContent;


@end
