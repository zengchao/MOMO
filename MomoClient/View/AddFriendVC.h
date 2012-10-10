//
//  AddFriendVC.h
//  MOMO
//
//  Created by 超 曾 on 12-5-11.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "SearchByMemberIdVC.h"
#import "InviteFriendsVC.h"
#import "ExampleShareText.h"


@interface AddFriendVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
    SearchByMemberIdVC *vcSearch;
    
}
@property (nonatomic,retain)UITableView *myTableView;
@property (nonatomic,retain)SearchByMemberIdVC *vcSearch;

@end
