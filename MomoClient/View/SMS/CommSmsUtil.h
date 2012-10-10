//
//  CommUtil.h
//  quanquan
//
//  Created by clspace on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "HistoryDial.h"
//#import "HistoryDialDAO.h"
//#import "ILib.h"

@interface CommSmsUtil : NSObject <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
{
    UIViewController * pre;
}

@property (nonatomic,retain) UIViewController * pre;

- (CommSmsUtil*)getIns:(UIViewController*) p;

//单条短信发送
- (void) singleSmsSend:(HistoryDial *) hisDial withVC:(UIViewController *)vc ;
//单条邮件发送
- (void) singleEmailSend:(HistoryDial *) hisDial withVC:(UIViewController *)vc;


//单条短信发送
- (void) singleMobileSmsSend:(NSString *) mobile withVC:(UIViewController *)vc ;
 

//多条短信发送方法
- (void)MultiSmsSend:(NSMutableArray *) UserCardArray withVC:(UIViewController *)vc;
//多条邮件发送方法
- (void)MultiEmailSend:(NSMutableArray *) UserCardArray withVC:(UIViewController *)vc;



@end
