//
//  FeedBack.h
//  MOMO
//
//  Created by apple on 12-6-13.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
//#import "SendMessageVC.h"
@interface FeedBack :UIViewController <MBProgressHUDDelegate>{
    UITextView *tv;
    MBProgressHUD *HUD;
}
@end
