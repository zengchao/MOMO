//
//  SearchByMemberIdVC.h
//  MOMO
//
//  Created by 超 曾 on 12-5-11.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "MemberInfoVC.h"

@interface SearchByMemberIdVC : UIViewController
{
    UITextField *txtMemberId;
    UIButton *btnSearch;
    //MemberInfoVC *vcMember;
    UserinfoVC *vcUser;
}
@property(nonatomic,retain)IBOutlet UITextField *txtMemberId;
@property(nonatomic,retain)IBOutlet UIButton *btnSearch;
//@property(nonatomic,retain)MemberInfoVC *vcMember;
@property(nonatomic,retain)UserinfoVC *vcUser;

-(IBAction)btnSearchClick:(id)sender;

@end
