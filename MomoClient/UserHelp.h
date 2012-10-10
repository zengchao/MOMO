//
//  UserHelp.h
//  MOMO
//
//  Created by apple on 12-6-18.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>

@interface UserHelp : UIViewController
{
    UITextView *textView; 
    IBOutlet UIView *aboutView;
}
@property(nonatomic,retain) UITextView *textView;
-(void)segmentedClicked:(id)sender;
@end
