//
//  SendMessageVC.m
//  MOMO
//
//  Created by 超 曾 on 12-5-12.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "SendMessageVC.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

#define CHATFILENAME	@"chatLog.xml"

#define TEXTFIELDTAG	100
#define TOOLBARTAG		200
#define TABLEVIEWTAG	300
#define LOADINGVIEWTAG	400

@interface SendMessageVC ()
- (void)soundFetchComplete:(ASIHTTPRequest *)therequest;
- (void)soundFetchFailed:(ASIHTTPRequest *)therequest;
@end

@implementation SendMessageVC
@synthesize leftBarButtonItem,rightBarButtonItem;
@synthesize t_userid,t_username;
@synthesize imagePicker;
@synthesize imagePicture;
@synthesize form_request;
@synthesize request;
@synthesize audioRecorder;
@synthesize audioPlayer;
@synthesize mydistance;
@synthesize subview;
@synthesize tag_dic;
//@synthesize vcMember;
@synthesize vcUser;
@synthesize login_user_pic,user_pic;

- (void)dealloc {
	[currentChatInfo release];
	[currentString release];
	
	[chatArray release];
	[chatFile release];
    
    [imagePicture release];
    [imagePicker release];
    [form_request cancel];
    [form_request release];
    [request cancel];
    [request release];
    if([self.audioRecorder isRecording]){
        [self.audioRecorder stop];
    }
    self.audioRecorder =nil;
    if([self.audioPlayer isPlaying]){
        [self.audioPlayer stop];
    }
    self.audioPlayer =nil;
    [mydistance release];
    [subview release];
    [tag_dic release];
    //[vcMember release];
    [vcUser release];
    [login_user_pic release];
    [user_pic release];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.leftBarButtonItem =nil;
    self.rightBarButtonItem =nil;
    self.t_userid =nil;
    self.t_username =nil;
    
    self.imagePicture =nil;
    self.imagePicker =nil;
    self.form_request =nil;
    self.request =nil;
    if([self.audioRecorder isRecording]){
        [self.audioRecorder stop];
    }
    self.audioRecorder =nil;
    if([self.audioPlayer isPlaying]){
        [self.audioPlayer stop];
    }
    self.audioPlayer =nil;
    self.mydistance =nil;
    self.subview =nil;
    self.tag_dic =nil;
    //self.vcMember=nil;
    self.vcUser=nil;
    self.login_user_pic=nil;
    self.user_pic=nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        //self.title=@"会员资料";
        cur_tag=0;
        tag_dic = [[NSMutableDictionary alloc] init];
        // 创建拍照控件对象
        self.imagePicker = [[[UIImagePickerController alloc] init] autorelease];
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
        {
            NSLog(@"模拟器没有摄像头");
        }else{
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;        
            // 设置媒体类型为所有对照相机有效的类型
            self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            self.imagePicker.allowsEditing = NO;
            // 设置拍照控件对象的委托
            self.imagePicker.delegate = self;
        }
    }
    return self;
}

- (NSString *)getCurrentTime
{
    NSDate *dateNow = [NSDate date];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];  
    [formatter setDateFormat : @"yyyy-MM-dd HH:mm:ss"];  
    
    return  [NSString stringWithFormat:@"%@", [formatter stringFromDate:dateNow]];
}

#pragma mark Table view methods
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf type:(NSString *)type image:(NSString *)mypic distance:(NSString *)distance time:(NSString *)msgtime
{
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    if([type isEqualToString:@"0"])
    {
        //UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"bubbleSelf":@"bubble" ofType:@"png"]];
        UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"对话框01":@"对话框" ofType:@"png"]];
        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
        
        UIFont *font = [UIFont systemFontOfSize:12];
        CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(150.0f, 1000.0f) lineBreakMode:UILineBreakModeCharacterWrap];
        
        UILabel *msgtitle = [[UILabel alloc] init];
        msgtitle.backgroundColor = [UIColor clearColor];
        msgtitle.font = font;
        msgtitle.numberOfLines = 0;
        msgtitle.lineBreakMode = UILineBreakModeCharacterWrap;
        
        
        msgtitle.text = [NSString stringWithFormat:@"%@   距离%.2fkm",msgtime, [distance floatValue]/1000];
        
        UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(21.0f, 40.0f, size.width+10, size.height+10)];
        bubbleText.backgroundColor = [UIColor clearColor];
        bubbleText.font = font;
        bubbleText.numberOfLines = 0;
        bubbleText.lineBreakMode = UILineBreakModeCharacterWrap;
        bubbleText.text = text;
        
        bubbleImageView.frame = CGRectMake(0.0f, 25.0f, 160.0f, size.height+40.0f);
        EGOImageView *userImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"small_loading_pic.png"]];
        
        if(fromSelf)
        {
            returnView.frame = CGRectMake(120.0f, 10.0f, 200.0f, size.height+60.0f);
            msgtitle.frame = CGRectMake(-100.0f, 0.0f, 250, 20);
            userImageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host_url, login_user_pic]];
            userImageView.frame = CGRectMake(160.0f, size.height+30.0f, 30, 30);
        }else{
            returnView.frame = CGRectMake(40.0f, 10.0f, 200.0f, size.height+60.0f);
            msgtitle.frame = CGRectMake(20.0f, 0.0f, 250, 20);
            userImageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host_url, user_pic]];
            userImageView.frame = CGRectMake(-30.0f, size.height+30.0f, 30, 30);
            
        }
        [returnView addSubview:bubbleImageView];
        [bubbleImageView release];
        [returnView addSubview:msgtitle];
        [msgtitle release];
        [returnView addSubview:bubbleText];
        [bubbleText release];
        
        [returnView addSubview:userImageView];
        [userImageView release];
        
        
    }else if([type isEqualToString:@"1"]){
        //图片
        EGOImageView *bubbleImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"small_loading_pic.png"]];
        bubbleImageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host_url, mypic]];
        
        UIFont *font = [UIFont systemFontOfSize:12];
        UILabel *msgtitle = [[UILabel alloc] init];
        msgtitle.backgroundColor = [UIColor clearColor];
        msgtitle.font = font;
        msgtitle.numberOfLines = 0;
        msgtitle.lineBreakMode = UILineBreakModeCharacterWrap;
        msgtitle.text = [NSString stringWithFormat:@"%@   距离%.2fkm",msgtime, [distance floatValue]/1000];
        
        bubbleImageView.frame = CGRectMake(20.0f, 30.0f, 150, 100);
        EGOImageView *userImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"small_loading_pic.png"]];
        
        if(fromSelf)
        {
            returnView.frame = CGRectMake(100.0f, 10.0f, 150.0f, 100+40.0f);
            msgtitle.frame = CGRectMake(-100.0f, 0.0f, 250, 20);
            userImageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host_url, login_user_pic]];
            userImageView.frame = CGRectMake(180.0f, 100.0f, 30, 30);
        }else{
            returnView.frame = CGRectMake(30.0f, 10.0f, 150.0f, 100+40.0f);
            msgtitle.frame = CGRectMake(20.0f, 0.0f, 250, 20);
            userImageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host_url, user_pic]];
            userImageView.frame = CGRectMake(-20.0f, 100.0f, 30, 30);
        }
        
        [returnView addSubview:bubbleImageView];
        [bubbleImageView release];
        [returnView addSubview:msgtitle];
        [msgtitle release];
        
        [returnView addSubview:userImageView];
        [userImageView release];
        
        
    }else if([type isEqualToString:@"2"]){
        //地图
        NSString *mapUrl = [NSString stringWithFormat:@"%@%@",@"http://maps.google.com/staticmap?zoom=14&size=150x112&markers=",text];
        EGOImageView *thumbnail = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"small_loading_pic.png"]];
        thumbnail.frame = CGRectMake(0,20,150,112);
        thumbnail.imageURL=[NSURL URLWithString:mapUrl];
        
        [returnView addSubview:thumbnail];
        [thumbnail release];
        
        UIFont *font = [UIFont systemFontOfSize:12];
        UILabel *msgtitle = [[UILabel alloc] init];
        msgtitle.backgroundColor = [UIColor clearColor];
        msgtitle.font = font;
        msgtitle.numberOfLines = 0;
        msgtitle.lineBreakMode = UILineBreakModeCharacterWrap;
        msgtitle.text = [NSString stringWithFormat:@"%@   距离%.2fkm",msgtime, [distance floatValue]/1000];
        
        EGOImageView *userImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"small_loading_pic.png"]];
        
        if(fromSelf)
        {
            returnView.frame = CGRectMake(120.0f, 10.0f, 160.0f, 112+30.0f);
            msgtitle.frame = CGRectMake(-100.0f, 0.0f, 250, 20);
            userImageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host_url, login_user_pic]];
            userImageView.frame = CGRectMake(160.0f, 112.0f, 30, 30);
            
        }else{
            returnView.frame = CGRectMake(40.0f, 10.0f, 160.0f, 112+30.0f);
            msgtitle.frame = CGRectMake(20.0f, 0.0f, 250, 20);
            userImageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host_url, user_pic]];
            userImageView.frame = CGRectMake(-30.0f, 112.0f, 30, 30);
        }
        
        [returnView addSubview:msgtitle];
        [msgtitle release];
        
        
    }else if([type isEqualToString:@"3"]){
        //语音
        UIButton *btnAction = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnAction.frame = CGRectMake(0.0f, 30.0f, 100.0f, 31.0f);
        btnAction.backgroundColor = [UIColor clearColor];
        btnAction.tag=cur_tag;
        [btnAction setTitle:@"播放" forState:UIControlStateNormal];
        [btnAction setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnAction addTarget:self action:@selector(playMusic:) forControlEvents:UIControlEventTouchDown];
        [returnView addSubview:btnAction]; 
        
        //保存对应关系
        [tag_dic setObject:text forKey:[NSString stringWithFormat:@"%d",cur_tag]];
        
        UIFont *font = [UIFont systemFontOfSize:12];
        UILabel *msgtitle = [[UILabel alloc] init];
        msgtitle.backgroundColor = [UIColor clearColor];
        msgtitle.font = font;
        msgtitle.numberOfLines = 0;
        msgtitle.lineBreakMode = UILineBreakModeCharacterWrap;
        msgtitle.text = [NSString stringWithFormat:@"%@   距离%.2fkm",msgtime, [distance floatValue]/1000];
        
        if(fromSelf)
        {
            returnView.frame = CGRectMake(120.0f, 10.0f, 200.0f, 60.0f);
            msgtitle.frame = CGRectMake(-100.0f, 0.0f, 250, 20);
        }else{
            returnView.frame = CGRectMake(0.0f, 10.0f, 200.0f, 60.0f);
            msgtitle.frame = CGRectMake(20.0f, 0.0f, 250, 20);
        }
        
        [returnView addSubview:msgtitle];
        [msgtitle release];
        
        cur_tag = cur_tag + 1;
        
    }
    
	return [returnView autorelease];
}

- (void)getTwoUserPic
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"login_user_id"] forKey:@"uid"];//本人
    [params setObject:t_userid forKey:@"mid"];//对方
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    
    NSString *baseurl=@"getTwoUserPic.php";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL]];
	[self setRequest:[ASIHTTPRequest requestWithURL:url]];
	[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
	[request startSynchronous];
    //显示网络请求信息在status bar上
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
    
    if (request) {
        if ([request error]) {
            NSString *result = [[request error] localizedDescription];
            NSLog(@"%@",result);
            
            login_user_pic = @"";
            user_pic = @"";
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            
        } else if ([request responseString]) {
            NSString *result = [request responseString];
            NSLog(@"%@",result);
            NSDictionary *mydict = [result JSONValue];
            
            if([[mydict objectForKey: @"loginTag"] isEqualToNumber:[NSNumber numberWithInt:1]]){
                login_user_pic = [mydict objectForKey:@"login_user_pic"];
                user_pic = [mydict objectForKey:@"user_pic"];
                
            }else if([[mydict objectForKey: @"loginTag"] isEqualToNumber:[NSNumber numberWithInt:0]]){
                //                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                //                [alertView show];
                //                [alertView release];
                login_user_pic = @"";
                user_pic = @"";
                
            }
        }
    }else{
        NSLog(@"request is nil.");
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
	self.navigationItem.leftBarButtonItem.title = @"返回";
	self.navigationItem.leftBarButtonItem.enabled = YES;
    isMySpeaking=TRUE;
    
	UIView *chatView = [self bubbleView:[NSString stringWithFormat:@"%@", textField.text] from:isMySpeaking type:@"0" image:nil distance:mydistance time:[self getCurrentTime]];
	[chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:textField.text, @"text", isMySpeaking?@"我":t_username, @"speaker", chatView, @"view", nil]];
    
    //同步数据到服务器
    [self sendmsg:textField.text];
    
	UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
	[tableView reloadData];
	[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
	textField.text = @"";
	return YES;
}

-(void)sendmsg:(NSString *)msg
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *sender = [userDefault objectForKey:@"login_user_id"];
    NSString *recver = t_userid;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:sender forKey:@"sender"];
    [params setObject:recver forKey:@"recver"];
    [params setObject:msg forKey:@"content"];
    [params setObject:mydistance forKey:@"distance"];
    
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    
    NSString *baseurl=@"sendmessage.php";
    
    
    NSString *tmp = [NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL];
    tmp = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)tmp,
                                                              NULL,
                                                              NULL,
                                                              kCFStringEncodingUTF8);
    NSURL *url = [NSURL URLWithString:tmp];
    
	[self setRequest:[ASIHTTPRequest requestWithURL:url]];
	[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
	[request startSynchronous];
    
    if (request) {
        if ([request error]) {
            NSString *result = [[request error] localizedDescription];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            
        } else if ([request responseString]) {
            NSString *result = [request responseString];
            NSDictionary *mydict = [result JSONValue];
            if([[mydict objectForKey: @"regTag"] isEqualToNumber:[NSNumber numberWithInt:1]]){ 
                //发送成功
            }
        }
    }else{
        
    }
    
    [self hideKeyboard];
    [tmp release];
    
}

-(NSString *)getuserdistance
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *sender = [userDefault objectForKey:@"login_user_id"];
    NSString *recver = t_userid;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:sender forKey:@"uid"];
    [params setObject:recver forKey:@"mid"];
    
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    
    NSString *baseurl=@"distance.php";
    
    
    NSString *tmp = [NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL];
    tmp = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)tmp,
                                                              NULL,
                                                              NULL,
                                                              kCFStringEncodingUTF8);
    NSURL *url = [NSURL URLWithString:tmp];
    [tmp release];
    
	[self setRequest:[ASIHTTPRequest requestWithURL:url]];
	[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
	[request startSynchronous];
    
    if (request) {
        if ([request error]) {
            NSString *result = [[request error] localizedDescription];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            
        } else if ([request responseString]) {
            NSString *result = [request responseString];
            NSDictionary *mydict = [result JSONValue];
            return [mydict objectForKey: @"distance"];
        }
    }else{
        
    }
    
    
    return @"";
}

-(void)sendmap:(NSString *)map
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *sender = [userDefault objectForKey:@"login_user_id"];
    NSString *recver = t_userid;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:sender forKey:@"sender"];
    [params setObject:recver forKey:@"recver"];
    [params setObject:map forKey:@"map"];
    [params setObject:mydistance forKey:@"distance"];
    
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    
    NSString *baseurl=@"sendmap.php";
    
    
    NSString *tmp = [NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL];
    
    tmp = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)tmp,
                                                              NULL,
                                                              NULL,
                                                              kCFStringEncodingUTF8);
    NSLog(@"%@",tmp);
    NSURL *url = [NSURL URLWithString:tmp];
    [tmp release];
    
	[self setRequest:[ASIHTTPRequest requestWithURL:url]];
	[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
	[request startSynchronous];
    
    if (request) {
        if ([request error]) {
            NSString *result = [[request error] localizedDescription];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            
        } else if ([request responseString]) {
            NSString *result = [request responseString];
            NSDictionary *mydict = [result JSONValue];
            if([[mydict objectForKey: @"regTag"] isEqualToNumber:[NSNumber numberWithInt:1]]){ 
                //发送成功
            }
        }
    }else{
        
    }
}

- (void)uploadPicFailed:(ASIHTTPRequest *)theRequest
{
    
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"上传失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

- (void)uploadPicFinished:(ASIHTTPRequest *)theRequest
{
    //NSString* result = [theRequest responseString];
    //    NSDictionary *mydict = [result JSONValue];
    //    NSString *server_id = [mydict objectForKey:@"id"];
    
    
    UIView *chatView = [self bubbleView:@"" from:TRUE type:@"1" image:[self documentPath:@"temp.png"]  distance:mydistance time:[self getCurrentTime]];
    
    [chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"", @"text", isMySpeaking?@"我":t_username, @"speaker", chatView, @"view", nil]];
    
    
    UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
	[tableView reloadData];
	[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
    
    //删除临时文件
    /*NSString *pathAsString = [self documentPath:@"temp.png"];
     NSError *error;
     NSFileManager *fileMgr = [NSFileManager defaultManager];
     
     if([fileMgr fileExistsAtPath:pathAsString]){
     if ([fileMgr removeItemAtPath:pathAsString error:&error] != YES){
     NSLog(@"Unable to delete file: %@", [error localizedDescription]);
     }else {
     NSLog(@"deleted.");
     }
     }else{
     NSLog(@"not exist.");
     }*/
}

- (void)uploadSoundFailed:(ASIHTTPRequest *)theRequest
{
    
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"上传失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

- (void)uploadSoundFinished:(ASIHTTPRequest *)theRequest
{
    //NSString* result = [theRequest responseString];
    UIView *chatView = [self bubbleView:@"" from:TRUE type:@"3" image:nil distance:mydistance time:[self getCurrentTime]];
    
    [chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"", @"text", isMySpeaking?@"我":t_username, @"speaker", chatView, @"view", nil]];
    
    
    UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
	[tableView reloadData];
	[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
}

//发送我的图片（拍照/相册照片）
- (void)sendMyPic
{
    //同步数据到服务器
    
    [form_request cancel];
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *sender = [userDefault objectForKey:@"login_user_id"];
    NSString *recver = t_userid;
    NSString *tmp=[NSString stringWithFormat:@"%@sendpic.php?sender=%@&recver=%@&distance=%@",host_url, sender,recver,mydistance];
    
    tmp = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)tmp,
                                                              NULL,
                                                              NULL,
                                                              kCFStringEncodingGB_18030_2000);
    
    [self setForm_request:[ASIFormDataRequest requestWithURL:[NSURL URLWithString:tmp]]];
    [form_request setTimeOutSeconds:20];
    [form_request setDelegate:self];
    [form_request setDidFailSelector:@selector(uploadPicFailed:)];
    [form_request setDidFinishSelector:@selector(uploadPicFinished:)];
    [form_request setFile:[self documentPath:@"temp.png"] forKey:@"file"];
    [form_request startAsynchronous];
    [tmp release];
    
}

//发送我的语音消息
- (void)sendMySound
{
    NSString *mysound = [self documentPath:@"Recording.m4a"];
    
    //同步数据到服务器
    [self sendsound:mysound];
    
}

-(void)sendsound:(NSString *)filePath
{
    //同步数据到服务器
    
    [form_request cancel];
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *sender = [userDefault objectForKey:@"login_user_id"];
    NSString *recver = t_userid;
    NSString *tmp=[NSString stringWithFormat:@"%@sendsound.php?sender=%@&recver=%@",host_url, sender,recver];
    
    tmp = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)tmp,
                                                              NULL,
                                                              NULL,
                                                              kCFStringEncodingGB_18030_2000);
    
    [self setForm_request:[ASIFormDataRequest requestWithURL:[NSURL URLWithString:tmp]]];
    [form_request setTimeOutSeconds:20];
    [form_request setDelegate:self];
    [form_request setDidFailSelector:@selector(uploadSoundFailed:)];
    [form_request setDidFinishSelector:@selector(uploadSoundFinished:)];
    [form_request setFile:filePath forKey:@"file"];
    [form_request startAsynchronous];
    [tmp release];
    
}

//发送我的地理位置
-(void)sendMyMap
{   
    
    NSString *mymap = @"";//@"39.917,116.397,blue";
    mymap = [NSString stringWithFormat:@"%@,%@,blue",[[NSUserDefaults standardUserDefaults] objectForKey:@"xpos"],[[NSUserDefaults standardUserDefaults] objectForKey:@"ypos"]];
    NSLog(@"%@",mymap);
    UIView *chatView = [self bubbleView:mymap from:TRUE type:@"2" image:nil  distance:mydistance time:[self getCurrentTime]]; 
    
	[chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:mymap, @"text", isMySpeaking?@"我":t_username, @"speaker", chatView, @"view", nil]];
    
    //同步数据到服务器
    [self sendmap:mymap];
    
	UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
	[tableView reloadData];
	[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
	
}




-(void)getReplyList
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *sender = [NSString stringWithFormat:@"%@",[userDefault objectForKey:@"login_user_id"]];
    NSString *tmp=[NSString stringWithFormat:@"%@getReplyList.php?sender=%@&recver=%@",host_url, sender,t_userid];
    NSMutableURLRequest *req = [[NSMutableURLRequest new] autorelease];      
    //    NSLog(@"%@",tmp);
    [req setURL:[NSURL URLWithString:tmp]];
    [req setHTTPMethod:@"GET"];     
    [req addValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [req setTimeoutInterval:10.0f];
    
    NSHTTPURLResponse* urlResponse = nil;  
	NSError *error = [[NSError alloc] init]; 
    NSData *responseData = [NSURLConnection sendSynchronousRequest:req returningResponse:&urlResponse error:&error];  
	NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {      
        NSLog(@"%@",result);
        if([result isEqualToString:@"40023"] || [result isEqualToString:@"40024"]){
            
        }else{
            NSDictionary *dict = [result JSONValue];
            NSArray *resultArr = (NSArray *)dict;
            for (NSDictionary *item in resultArr) {
                NSString *content = [item objectForKey:@"content"];
                NSLog(@"%@,%@",sender,[item objectForKey:@"sender_id"]);
                NSString *flag = @"";
                if([sender isEqualToString:[NSString stringWithFormat:@"%@",[item objectForKey:@"sender_id"]]]){
                    isMySpeaking=TRUE;
                    flag=@"";
                    NSLog(@"TRUE,%@",flag);
                    
                }else{
                    isMySpeaking=FALSE;
                    flag=@"";
                    NSLog(@"FALSE,%@",flag);
                    
                }
                UIView *chatView ;
                if([[item objectForKey:@"type"] isEqualToString:@"1"]){
                    //图片
                    chatView = [self bubbleView:@"" from:isMySpeaking type:@"1" image:[item objectForKey:@"pic"]  distance:[item objectForKey:@"distance"] time:[item objectForKey:@"update_time"]];
                }else if([[item objectForKey:@"type"] isEqualToString:@"0"]){
                    //文字
                    chatView = [self bubbleView:[NSString stringWithFormat:@"%@",content] from:isMySpeaking type:@"0" image:nil  distance:[item objectForKey:@"distance"] time:[item objectForKey:@"update_time"]];
                }else if([[item objectForKey:@"type"] isEqualToString:@"2"]){
                    //地图
                    chatView = [self bubbleView:[item objectForKey:@"map"] from:isMySpeaking type:@"2" image:nil  distance:[item objectForKey:@"distance"] time:[item objectForKey:@"update_time"]];
                }else if([[item objectForKey:@"type"] isEqualToString:@"3"]){
                    //语音
                    chatView = [self bubbleView:[item objectForKey:@"sound"] from:isMySpeaking type:@"3" image:nil  distance:[item objectForKey:@"distance"] time:[item objectForKey:@"update_time"]];
                }
                [chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:content, @"text", flag, @"speaker", chatView, @"view", nil]];
                
                
            }
        }
    }  
    [result release];
    
}
-(void)timerRequest{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *UserID = [userDefault objectForKey:@"login_user_id"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:UserID forKey:@"userid"];
    [params setObject:t_userid forKey:@"sender_id"];
    NSString *postURL=[Utility createPostURL:params];
    NSLog(@"postURL:%@",postURL);
    NSString *baseurl=@"getReply.php";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL]];
	[self setRequest:[ASIHTTPRequest requestWithURL:url]];
	[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
	[request startSynchronous];
    if (request) {
        if ([request error]) {
            NSString *result = [[request error] localizedDescription];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            
        } else if ([request responseString]){
            NSString *result = [request responseString];
            //NSLog(@"result:%@",result);
            if([result isEqualToString:@"40023"] || [result isEqualToString:@"40024"]){
                
            }
            else{ 
                NSMutableArray *resultArr=[result JSONValue];
                for (NSDictionary *item in resultArr) {
                    NSString *content = [item objectForKey:@"content"];
                    NSString *flag = t_username;
                    isMySpeaking=FALSE;
                    UIView *chatView ;
                    if([[item objectForKey:@"type"] isEqualToString:@"1"]){
                        //图片
                        chatView = [self bubbleView:@"" from:isMySpeaking type:@"1" image:[item objectForKey:@"pic"]  distance:[item objectForKey:@"distance"] time:[item objectForKey:@"update_time"]];
                    }else if([[item objectForKey:@"type"] isEqualToString:@"0"]){
                        //文字
                        chatView = [self bubbleView:[NSString stringWithFormat:@"%@: %@", flag, content] from:isMySpeaking type:@"0" image:nil  distance:[item objectForKey:@"distance"] time:[item objectForKey:@"update_time"]];
                    }else if([[item objectForKey:@"type"] isEqualToString:@"2"]){
                        //地图
                        chatView = [self bubbleView:[item objectForKey:@"map"] from:isMySpeaking type:@"2" image:nil  distance:[item objectForKey:@"distance"] time:[item objectForKey:@"update_time"]];
                    }else if([[item objectForKey:@"type"] isEqualToString:@"3"]){
                        //语音
                        chatView = [self bubbleView:[item objectForKey:@"sound"] from:isMySpeaking type:@"3" image:nil  distance:[item objectForKey:@"distance"] time:[item objectForKey:@"update_time"]];
                    }
                    [chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:content, @"text", flag, @"speaker", chatView, @"view", nil]];
                }
                UITableView *tableView=(UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
                [tableView reloadData];
                
            }
            
        }
    }
}
-(void)viewWillAppear:(BOOL)animated{
    timer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerRequest) userInfo:nil repeats:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [timer invalidate];//wang
}

#pragma mark navigation button methods
- (BOOL) hideKeyboard {
	UITextField *textField = (UITextField *)[self.view viewWithTag:TEXTFIELDTAG];
	if(textField.editing) {
		textField.text = @"";
		[self.view endEditing:YES];
		
		return YES;
	}
	
	return NO;
}

- (void) clickOutOfTextField:(id)sender {
	[self hideKeyboard];
}

- (void) rightButtonAction {
//    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:HUD];	
//    HUD.dimBackground = YES;
//    HUD.delegate = self;
//    HUD.labelText = @"";
//    [HUD showWhileExecuting:@selector(loadMemberInfoVC) onTarget:self withObject:nil animated:YES];
    [self loadMemberInfoVC];
}

- (void)loadMemberInfoVC
{
//    vcMember = [[MemberInfoVC alloc] initWithNibName:@"MemberInfoVC" bundle:nil];
//    NSMutableDictionary *mydict = [[[NSMutableDictionary alloc] init] autorelease];
//    [mydict setValue:t_userid forKey:@"userid"];
//    vcMember.mydict = mydict;
//    vcMember.b_myinfo=FALSE;
//    [self.navigationController pushViewController:vcMember animated:TRUE];
    
    
    vcUser = [[UserinfoVC alloc] initWithNibName:@"UserinfoVC" bundle:nil];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:t_userid forKey:@"userid"];
    vcUser.mydict = dict;
    [dict release];
    
    [self.navigationController pushViewController:vcUser animated:TRUE];
    
    
}

- (void) leftButtonAction {
    [self dismissModalViewControllerAnimated:TRUE];
}


- (void) finshLoadFile {
	UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
	[tableView reloadData];
    
	UIView *loadingView = (UIView *)[self.view viewWithTag:LOADINGVIEWTAG];
	loadingView.hidden = YES;
    
	loadingLog = NO;
	self.navigationItem.leftBarButtonItem.enabled = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	
	NSDictionary *chatInfo = [chatArray lastObject];
	if([[chatInfo objectForKey:@"speaker"] isEqualToString:@"我"])
        isMySpeaking = NO;
	else
        isMySpeaking = YES;
}

#pragma mark view controller methods
- (id)init {
	if(self = [super init]) {
        self.title=@"发消息";
	}
	return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = contentView;
    [contentView release];
    
    chatArray = [[NSMutableArray alloc] initWithCapacity:0];
    isMySpeaking = YES;
    loadingLog = NO;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    chatFile = [[NSString alloc] initWithString:[documentsDirectory stringByAppendingPathComponent:CHATFILENAME]];
    
    currentString = [[NSMutableString alloc] initWithCapacity:0];
    currentChatInfo = [[NSMutableDictionary alloc] initWithCapacity:3];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"好友资料" 
                        style:UIBarButtonItemStyleBordered 
                    target:self
                action:@selector(rightButtonAction)] autorelease];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"消息" 
                    style:UIBarButtonItemStyleBordered
                        target:self
                    action:@selector(leftButtonAction)] autorelease];
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 37)];
    [btnBack setBackgroundColor:[UIColor clearColor]];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"message.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(dismissWin) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *barButtonIteLeft = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = barButtonIteLeft;
    [barButtonIteLeft release];
    [btnBack release];
    
    UIButton *btnAction = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAction setBackgroundImage:[UIImage imageNamed:@"bg-addbutton.png"] forState:UIControlStateNormal];
    btnAction.frame = CGRectMake(0.0f, 0.0f, 30.0f, 31.0f);
    btnAction.backgroundColor = [UIColor clearColor];
    [btnAction addTarget:self action:@selector(btnActionClick:) forControlEvents:UIControlEventTouchDown];
    
    UITextField *textfield = [[[UITextField alloc] initWithFrame:CGRectMake(30.0f, 0.0f, 250.0f, 31.0f)] autorelease];
    textfield.tag = TEXTFIELDTAG;
    textfield.delegate = self;
    textfield.autocorrectionType = UITextAutocorrectionTypeNo;
    textfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textfield.enablesReturnKeyAutomatically = YES;
    textfield.borderStyle = UITextBorderStyleRoundedRect;
    textfield.returnKeyType = UIReturnKeySend;
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 372.0f, 320.0f, 44.0f)];
    toolBar.tag = TOOLBARTAG;
    NSMutableArray* allitems = [[NSMutableArray alloc] init];
    [allitems addObject:[[[UIBarButtonItem alloc] initWithCustomView:btnAction] autorelease]];
    [allitems addObject:[[[UIBarButtonItem alloc] initWithCustomView:textfield] autorelease]];
    
    [toolBar setItems:allitems];
    [allitems release];
    [self.view addSubview:toolBar];
    [toolBar release];
    
    //背景图
//    UIImageView *imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"320-367.png"]];
//    imageView.frame=CGRectMake(0, 0, 320, 364);
//    [self.view addSubview:imageView];
//    [imageView release];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 372.0f) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //tableView.backgroundColor = [UIColor colorWithRed:0.859f green:0.886f blue:0.929f alpha:1.0f];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.tag = TABLEVIEWTAG;
    [self.view addSubview:tableView];
    [tableView release];
    
    
    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 372.0f)];
    loadingView.backgroundColor = [UIColor darkGrayColor];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake(loadingView.frame.size.width/2, loadingView.frame.size.height/2);
    [activityView startAnimating];
    [loadingView addSubview:activityView];
    [activityView release];
    loadingView.hidden = YES;
    loadingView.tag = LOADINGVIEWTAG;
    [self.view addSubview:loadingView];
    [loadingView release];
    
    //获取双方的头像
    [self getTwoUserPic];
    
    [self getReplyList];
    mydistance = [self getuserdistance];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
    if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
    }
    [audioSession setActive:YES error:&err];
    err = nil;
    if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
    }
    BOOL audioHWAvailable = audioSession.inputIsAvailable;
    if (! audioHWAvailable) {
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: @"Audio input hardware not available"
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [cantRecordAlert show];
        [cantRecordAlert release]; 
        return;
    }
    
    
}

- (void)dismissWin
{
    [self dismissModalViewControllerAnimated:TRUE];
}

- (void)btnActionClick:(id)sender
{
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle: @"发送"
                           delegate:self
                           cancelButtonTitle:@"取消"
                           destructiveButtonTitle:@"拍照"
                           otherButtonTitles:@"照片", @"我的位置",@"语音",nil];
    [menu showInView:[UIApplication sharedApplication].keyWindow];
    [menu release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //拍照
            [self getCameraPicture];
            break;
        case 1:
            //照片
            [self getExistintPicture];
            break;
        case 2:
            //我的位置
            [self sendMyMap];
            break;
        case 3:
            //语音:
            //[self sendMySound];
            //[self startRecording];
            break;
    }
}

- (void)stopRecording:(id)sender
{
    [subview removeFromSuperview];
    [self.audioRecorder stop];
    [self sendMySound];
}

- (void)startRecording
{
    subview = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
    
    UIButton *btnStop =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnStop setAlpha:1.0f];
    btnStop.frame = CGRectMake(110,225,100,31);
    btnStop.backgroundColor = [UIColor clearColor];
    [btnStop setTitle:@"停止录音" forState:UIControlStateNormal];
    //[btnStop setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [btnStop addTarget:self
                action:@selector(stopRecording:)
      forControlEvents:UIControlEventTouchDown];
    [subview addSubview:btnStop];
    
    [self.view addSubview:subview];
    
    NSError *error=nil;
    NSString *pathAsString = [self audioRecordingPath];
    NSURL *audioRecordingURL = [NSURL fileURLWithPath:pathAsString];
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:audioRecordingURL settings:[self audioRecordingSettings] error:&error]; 
    if(self.audioRecorder!=nil){
        self.audioRecorder.delegate=self;
        if([self.audioRecorder prepareToRecord] && [self.audioRecorder record]){
            
            
        }else{
            
            self.audioRecorder=nil;
        }
    }else{
        
    }
}

-(NSDictionary *)audioRecordingSettings
{
    NSDictionary *result=nil;
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    [settings setValue:[NSNumber numberWithInteger:kAudioFormatAppleLossless] forKey:AVFormatIDKey];
    [settings setValue:[NSNumber numberWithFloat:11025.0f] forKey:AVSampleRateKey];
    [settings setValue:[NSNumber numberWithInteger:1] forKey:AVNumberOfChannelsKey];
    [settings setValue:[NSNumber numberWithInteger:AVAudioQualityLow] forKey:AVEncoderAudioQualityKey];
    result = [NSDictionary dictionaryWithDictionary:settings];
    [settings release];
    
    return result;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [chatArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UIView *chatView = [[chatArray objectAtIndex:[indexPath row]] objectForKey:@"view"];
	return chatView.frame.size.height+10.0f;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_0
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
#else
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
#endif
        
		cell.backgroundColor = [UIColor colorWithRed:0.859f green:0.886f blue:0.929f alpha:1.0f];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Set up the cell...
	NSDictionary *chatInfo = [chatArray objectAtIndex:[indexPath row]];
	for(UIView *subview1 in [cell.contentView subviews])
		[subview1 removeFromSuperview];
	[cell.contentView addSubview:[chatInfo objectForKey:@"view"]];
    return cell;
}



- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    //newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    newTextViewFrame.origin.y = keyboardTop - 44;
    newTextViewFrame.size.height = 44;
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    //textView.frame = newTextViewFrame;
    
    UIToolbar *toolbar = (UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
	toolbar.frame = newTextViewFrame;
    
	UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
	tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, keyboardTop - self.view.bounds.origin.y-44);
	if([chatArray count])
		[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    [UIView commitAnimations];
    
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    //textView.frame = self.view.bounds;
	UIToolbar *toolbar = (UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
	toolbar.frame = CGRectMake(0.0f, 372.0f, 320.0f, 44.0f);
	UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
	tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 372.0f);
    
    [UIView commitAnimations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// 打开摄像头
- (IBAction)getCameraPicture{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker =
        [[UIImagePickerController alloc] init];
        picker.delegate = self; 
        picker.allowsEditing = YES;
        // 摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentModalViewController:picker animated:YES];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Error" 
                              message:@"你没有摄像头" 
                              delegate:nil 
                              cancelButtonTitle:@"Drat!" 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    
}

// 选取图片
- (IBAction)getExistintPicture
{
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker =
        [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        // 图片库
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentModalViewController:picker animated:YES];
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Error accessing photo library" 
                              message:@"Device does not support a photo library" 
                              delegate:nil 
                              cancelButtonTitle:@"Drat!" 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // 处理静态照片
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        if (editedImage) {
            imageToSave = editedImage;
        }
        else {
            imageToSave = originalImage;
        }
        // 将静态照片（原始的或者被编辑过的）保存到相册（Camera Roll）
        //UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
        
        [self writeImage:imageToSave toFileAtPath:[self documentPath:@"temp.png"]];
        self.imagePicture = imageToSave;
    }
    //    UploadOp *op = [[[UploadOp alloc] init] autorelease];
    //    op.imageToSend = self.imagePicture;
    
    [picker dismissModalViewControllerAnimated:YES];
    [picker release];
    [self sendMyPic];
}

- (NSString *)documentPath:(NSString *)filename
{
    NSString *result=nil;
    NSArray *folders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsFolder = [folders objectAtIndex:0];
    result = [documentsFolder stringByAppendingPathComponent:filename];
    return result;
}

- (BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath
{
    if ((image == nil) || (aPath == nil) || ([aPath isEqualToString:@""]))
        return NO;
    @try
    {
        
        NSData *imageData = nil;
        NSString *ext = [aPath pathExtension];
        if ([ext isEqualToString:@"png"])
        {
            imageData = UIImagePNGRepresentation(image); 
        }
        else 
        {
            // the rest, we write to jpeg
            
            // 0. best, 1. lost. about compress.
            
            imageData = UIImageJPEGRepresentation(image, 0);     
            
        }
        
        if ((imageData == nil) || ([imageData length] <= 0))
            return NO;
        
        [imageData writeToFile:aPath atomically:YES];       
        return YES;
    }
    @catch (NSException *e) 
    {
        NSLog(@"create thumbnail exception.");
    }
    return NO;
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error 
  contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        // Show error message...
        
    }
    else  // No errors
    {
        
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
    [picker release];
}

#pragma mark - Utilities

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(NSString *)audioRecordingPath
{
    NSString *result=nil;
    NSArray *folders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsFolder = [folders objectAtIndex:0];
    result = [documentsFolder stringByAppendingPathComponent:@"Recording.m4a"];
    return result;
}


-(void)stopRecordingOnAudioRecorder:(AVAudioRecorder *)paramRecorder
{
    [paramRecorder stop];
    
}


-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    self.audioRecorder=nil;
    
}

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder{ 
    //resultView.text=@"Recording process is interrupted";
}


- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withFlags:(NSUInteger)flags{
    if (flags == AVAudioSessionInterruptionFlags_ShouldResume){ 
        //resultView.text=@"Resuming the recording...";
        [recorder record];
    } 
}

- (void) deleteTmpFile
{
    NSString *pathAsString = [self audioRecordingPath];
    NSError *error;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    //NSLog(@"%@",pathAsString);
    
    if([fileMgr fileExistsAtPath:pathAsString]){
        if ([fileMgr removeItemAtPath:pathAsString error:&error] != YES){
            //NSLog(@"Unable to delete file: %@", [error localizedDescription]);
        }else {
            //NSLog(@"deleted.");
        }
    }else{
        //NSLog(@"not exist.");
    }
    
}

-(void)playMusic:(id)sender
{
    NSString *filePath=@"";
    
    UIButton *btn = (UIButton *)sender;
    NSLog(@"%@",[NSString stringWithFormat:@"%d",btn.tag]);
    NSLog(@"%@",[tag_dic objectForKey:[NSString stringWithFormat:@"%d",btn.tag]]);
    filePath = [NSString stringWithFormat:@"%@%@",host_url,[tag_dic objectForKey:[NSString stringWithFormat:@"%d",btn.tag]]];
    
    NSLog(@"%@",filePath);
    [self FollowDown:filePath];
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    //resultView.text=@"Playing process is interrupted.";
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags
{
    if(flags == AVAudioSessionInterruptionFlags_ShouldResume && player!=nil){
        //resultView.text=@"Resuming the playing...";
        [player play];
        
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if(flag){
        //resultView.text=@"Audio player stopped correctly.";
        
    }else{
        //resultView.text=@"Audio player did not stop correctly.";
    }
    
    if([player isEqual:self.audioPlayer]){
        self.audioPlayer=nil;
    }else{
        //This is not our player
    }
    
}

- (void)FollowDown:(NSString *)filepath
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];	
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD showWhileExecuting:@selector(downloadFile:) onTarget:self withObject:filepath animated:YES];
    
}

- (void)downloadFile:(NSString *)filepath
{
    NSLog(@"%@",filepath);
    
    if (!networkQueue) {
		networkQueue = [[ASINetworkQueue alloc] init];	
	}
	failed = NO;
	[networkQueue reset];
    //	[networkQueue setDownloadProgressDelegate:progressIndicator];
	[networkQueue setRequestDidFinishSelector:@selector(soundFetchComplete:)];
	[networkQueue setRequestDidFailSelector:@selector(soundFetchFailed:)];
    //	[networkQueue setShowAccurateProgress:[accurateProgress isOn]];
	[networkQueue setDelegate:self];
	
	request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:filepath]];
	[request setDownloadDestinationPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"download.m4a"]];
    //	[request setDownloadProgressDelegate:imageProgressIndicator1];
    //    [request setUserInfo:[NSDictionary dictionaryWithObject:@"request1" forKey:@"name"]];
	[networkQueue addOperation:request];
	
	[networkQueue go];
}


- (void)soundFetchComplete:(ASIHTTPRequest *)therequest
{
	NSString *filePath = [therequest downloadDestinationPath];
    NSLog(@"%@",filePath);
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    //Start audio player
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
    if(self.audioPlayer!=nil){
        self.audioPlayer.delegate=self;
        [self.audioPlayer setVolume:1.0];
        
        if([self.audioPlayer prepareToPlay] && [self.audioPlayer play]){
            NSLog(@"successfully to started playing.");
        }else{
            NSLog(@"failed to instance AVAduioPlayer");
        }
    }else{
        NSLog(@"failed to instance AVAduioPlayer");
        
    }
}

- (void)soundFetchFailed:(ASIHTTPRequest *)therequest
{
	if (!failed) {
		if ([[therequest error] domain] != NetworkRequestErrorDomain || [[therequest error] code] != ASIRequestCancelledErrorType) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Download failed" message:@"Failed to download file." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alertView show];
            [alertView release];
		}
		failed = YES;
	}
}


@end
