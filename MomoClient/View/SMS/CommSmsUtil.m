//
//  CommUtil.m
//  quanquan
//
//  Created by clspace on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommSmsUtil.h"


static CommSmsUtil * myCommSmsUtil;

@implementation CommSmsUtil
@synthesize pre;

-(CommSmsUtil*)getIns:(UIViewController*)p
{
	if(myCommSmsUtil==NULL){
		myCommSmsUtil=[CommSmsUtil new];
	}
	myCommSmsUtil.pre=p;
	return myCommSmsUtil;
}




//单条短信发送方法
- (void) singleSmsSend:(HistoryDial *) hisDial withVC:(UIViewController *)vc
{
    NSString *mobile=hisDial.mobile; //读取用户号码
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
	if (messageClass != nil) 
    { 			
		if ([messageClass canSendText]) 
        {
			//发送短信
            MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            picker.messageComposeDelegate = [self getIns:vc];
            [[[[picker viewControllers] lastObject] navigationItem] setTitle:@"新建短信"];//修改短信界面标题
            //[picker setBody:@"hello!你好！"]; //设置短信内容
            picker.recipients = [NSArray arrayWithObjects:mobile, nil];
            [vc presentModalViewController:picker animated:YES];
            [picker release];
		}
		else 
        {	
//            [Api alert:@"设备不支持短信发送！"];
		}
	}
	else {
//        [Api alert:@"设备不支持短信发送！"];
	}   
}



//多条短信发送方法
- (void)MultiSmsSend:(NSMutableArray *) UserCardArray withVC:(UIViewController *)vc
{
    
    NSMutableArray *mdnarray=[[NSMutableArray alloc]init];
    for(int i=0; i<[UserCardArray count]; i++)
    {
        NSString *mobileNo = [UserCardArray objectAtIndex:i];
        if(![mobileNo isEqualToString:@""] && !(mobileNo==nil))
        {
            [mdnarray addObject:mobileNo];
        } 
    }
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
	if (messageClass != nil) 
    { 			
		if ([messageClass canSendText]) 
        {
			//发送短信
            MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            picker.messageComposeDelegate = [self getIns:vc];
            [[[[picker viewControllers] lastObject] navigationItem] setTitle:@"新建短信"];//修改短信界面标题
            //[picker setBody:@"hello!你好！"]; //设置短信内容
            picker.recipients = mdnarray;
            [vc presentModalViewController:picker animated:YES];
            [picker release];
		}
		else 
        {	
//            [Api alert:@"设备不支持短信发送！"];
		}
	}
	else {
//        [Api alert:@"设备不支持短信发送！"];
	}   
}





//单条短信发送方法
- (void) singleMobileSmsSend:(NSString *) mobile withVC:(UIViewController *)vc
{
   
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
	if (messageClass != nil) 
    { 			
		if ([messageClass canSendText]) 
        {
			//发送短信
            MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            picker.messageComposeDelegate = [self getIns:vc];
            [[[[picker viewControllers] lastObject] navigationItem] setTitle:@"新建短信"];//修改短信界面标题
            //[picker setBody:@"hello!你好！"]; //设置短信内容
            picker.recipients = [NSArray arrayWithObjects:mobile, nil];
            [vc presentModalViewController:picker animated:YES];
            [picker release];
		}
		else 
        {	
//            [Api alert:@"设备不支持短信发送！"];
		}
	}
	else {
//        [Api alert:@"设备不支持短信发送！"];
	}   
}

//短信发送回调方法
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller 
                 didFinishWithResult:(MessageComposeResult)result {
	
	switch (result)
	{
		case MessageComposeResultCancelled:
            //[Api alert:@"短信发送取消！"];
			break;
		case MessageComposeResultSent:
//            [Api alert:@"短信已经成功发送！"];
			break;
		case MessageComposeResultFailed:
//            [Api alert:@"短信发送失败！"];
			break;
		default:
//            [Api alert:@"短信未发送！"];
			break;
	}
   [pre dismissModalViewControllerAnimated:YES];
}





//单条邮件发送方法
- (void) singleEmailSend:(HistoryDial *) hisDial withVC:(UIViewController *)vc
{
    NSString *email=hisDial.email; //读取用户号码
    
    if (email==nil || [email isEqualToString:@""])  //邮箱不存在时
    {
//        [Api alert:@"该联系人没有邮箱！"];
    }
    else
    {
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        if (mailClass != nil) 
        {
            if ([mailClass canSendMail])
            {
                
                MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
                picker.mailComposeDelegate = [self getIns:vc];
                [[[[picker viewControllers] lastObject] navigationItem] setTitle:@"新建邮件"]; 
                NSArray *toRecipients = [NSArray arrayWithObject:email]; 
                [picker setToRecipients:toRecipients];
                [picker setSubject:@""];
                [picker setMessageBody:@"" isHTML:YES];
                [vc presentModalViewController:picker animated:YES];
                [picker release];
                
            }
            else {
//                [Api alert:@"您没有配置邮件服务！"];
            }
        }
        else	{
//            [Api alert:@"您没有配置邮件服务！"];
        }
    }
    
}
 


//多条邮件发送方法
- (void)MultiEmailSend:(NSMutableArray *) UserCardArray withVC:(UIViewController *)vc
{
    
    NSMutableArray *emailarray=[[NSMutableArray alloc]init];
    for(int i=0; i<[UserCardArray count]; i++)
    {
//        UserCard *uCard = [UserCardArray objectAtIndex:i];
//        if(![uCard.email isEqualToString:@""] && !(uCard.email==nil))
//        {
//            [emailarray addObject:uCard.email];
//        } 
    }
    
    if (!([emailarray count]>0))  //邮箱不存在时
    {
//        [Api alert:@"该群组联系人没有邮箱！"];
    }
    else
    {
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        if (mailClass != nil) 
        {
            if ([mailClass canSendMail])
            {
                
                MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
                picker.mailComposeDelegate = [self getIns:vc];
                [[[[picker viewControllers] lastObject] navigationItem] setTitle:@"新建邮件"]; 
                NSArray *toRecipients = emailarray; 
                [picker setToRecipients:toRecipients];
                [picker setSubject:@""];
                [picker setMessageBody:@"" isHTML:NO];
                [vc presentModalViewController:picker animated:YES];
                [picker release];
                
            }
            else {
//                [Api alert:@"您没有配置邮件服务！"];
            }
        }
        else	{
//            [Api alert:@"您没有配置邮件服务！"];
        }
    }
    
}



//邮件发送回调方法
- (void)mailComposeController:(MFMailComposeViewController*)controller 
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
    
	switch (result)
	{
		case MFMailComposeResultCancelled:
//            [Api alert:@"邮件发送取消！"];
			break;
		case MFMailComposeResultSaved:
//            [Api alert:@"邮件保存成功！"];
			break;
		case MFMailComposeResultSent:
//            [Api alert:@"邮件已经成功发送！"];
			break;
		case MFMailComposeResultFailed:
//            [Api alert:@"邮件发送失败！"];
			break;
		default:
//            [Api alert:@"邮件未发送！"];
			break;
	}
	[pre dismissModalViewControllerAnimated:YES];
}




//单个邮件发送方法
- (void) callEmailSend:(NSString *) email  withVC:(UIViewController *)vc
{
    if (email==nil || [email isEqualToString:@""])  //邮箱不存在时
    {
//        [Api alert:@"该联系人没有邮箱！"];
    }
    else
    {
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        if (mailClass != nil) 
        {
            if ([mailClass canSendMail])
            {
                
                MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
                picker.mailComposeDelegate = [self getIns:vc];
                NSArray *toRecipients = [NSArray arrayWithObject:email]; 
                [picker setToRecipients:toRecipients];
                [picker setSubject:@""];
                [picker setMessageBody:@"" isHTML:YES];
                [vc presentModalViewController:picker animated:YES];
                [picker release];
                
            }
            else {
//                [Api alert:@"您没有配置邮件服务！"];
            }
        }
        else	{
//            [Api alert:@"您没有配置邮件服务！"];
        }
    }
    
}






@end
