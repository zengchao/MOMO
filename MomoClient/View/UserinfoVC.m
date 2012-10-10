//
//  UserinfoVC.m
//  dache
//
//  Created by 超 曾 on 12-7-14.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "UserinfoVC.h"
#import "SendMessageVC.h"
#import "MyRoadVC.h"
#import "ASIHTTPRequest.h"

@implementation UserinfoVC
@synthesize imageView;
@synthesize mydict;
@synthesize m_pButtonAdd,m_pButtonAdd2,m_pButtonAdd3;
@synthesize vcRoad,vcMessage;
@synthesize request;
@synthesize usernameLabel,sexLabel;
@synthesize starttimeLabel,startposnameLabel,endposnameLabel,yaoqiuLabel,qianmingLabel;
@synthesize data;
@synthesize m_pToolBar;

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imageView=nil;
    self.mydict=nil;
    self.m_pButtonAdd=nil;
    self.m_pButtonAdd2 =nil;
    self.m_pButtonAdd3=nil;
    self.vcRoad=nil;
    self.vcMessage=nil;
    self.request=nil;
    self.usernameLabel=nil;
    self.sexLabel=nil;
    self.starttimeLabel=nil;
    self.startposnameLabel=nil;
    self.endposnameLabel=nil;
    self.yaoqiuLabel=nil;
    self.qianmingLabel=nil;
    self.data=nil;
    self.m_pToolBar=nil;
    
}

- (void)dealloc
{   
    [imageView release];
    [mydict release];
    [m_pButtonAdd release];
    [m_pButtonAdd2 release];
    [m_pButtonAdd3 release];
    [vcRoad release];
    [vcMessage release];
    [request cancel];
    [request release];
    [usernameLabel release];
    [sexLabel release];
    [startposnameLabel release];
    [starttimeLabel release];
    [endposnameLabel release];
    [qianmingLabel release];
    [yaoqiuLabel release];
    [data release];
    [m_pToolBar release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if 1  
    // Tested with the views contentMode set to redraw (forces call to drawRect:
    // on change of views frame) enabled and disabled.
    imageView.contentMode = UIViewContentModeRedraw;
#endif  
    
    imageView.displayAsStack = YES;
    imageView.image = [UIImage imageNamed:@"no.jpg"];
    
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 37)];
    [btnBack setBackgroundColor:[UIColor clearColor]];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(dismissWin) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *barButtonIteLeft = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = barButtonIteLeft;
    [barButtonIteLeft release];
    [btnBack release];
    
    self.navigationController.navigationBarHidden=FALSE;
    self.navigationController.title=@"会员资料";
    
    
    int count = [self getMemberInfo];
    if(count==0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"没有找到该会员的资料" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }else{
        data = [[NSMutableArray alloc] init];
        [self getMyPic];
        
        EGOImageView *iv = [[EGOImageView alloc] initWithFrame:CGRectMake(242,18, 60, 60)];
        
        iv.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host_url, [data objectAtIndex:0]]];
        iv.contentMode=UIViewContentModeScaleAspectFit;
        [self.view addSubview:iv];
        [iv release];
        
        m_pToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height -  40.0, self.view.frame.size.width, 40.0)];
        [m_pToolBar setBarStyle:UIBarStyleBlackOpaque];
        //[m_pToolBar setBackgroundImage:[UIImage imageNamed:@"bottom_banner_bg.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
        m_pToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
        //发消息
        m_pButtonAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_pButtonAdd setFrame:CGRectMake(0, 286, 80, 35)];
        [m_pButtonAdd addTarget:self action:@selector(sendMsg:) forControlEvents:UIControlEventTouchUpInside];
        [m_pButtonAdd setTitle:@"发送消息" forState:UIControlStateNormal]; 
        [m_pButtonAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIBarButtonItem *mBarButtonItemButtonAdd = [[UIBarButtonItem alloc] initWithCustomView:m_pButtonAdd];
        
        //添加关注
        m_pButtonAdd2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_pButtonAdd2 setFrame:CGRectMake(90, 286.0, 80, 35)];
        [m_pButtonAdd2 addTarget:self action:@selector(FollowTA:) forControlEvents:UIControlEventTouchUpInside];
        [m_pButtonAdd2 setTitle:@"添加关注" forState:UIControlStateNormal]; 
        [m_pButtonAdd2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIBarButtonItem *mBarButtonItemButtonAdd2 = [[UIBarButtonItem alloc] initWithCustomView:m_pButtonAdd2];
        
        //拉黑/举报
        m_pButtonAdd3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [m_pButtonAdd3 setFrame:CGRectMake(180, 286.0, 80, 35)];
        [m_pButtonAdd3 addTarget:self action:@selector(sendtoblacklist:) forControlEvents:UIControlEventTouchUpInside];
        [m_pButtonAdd3 setTitle:@"拉黑举报" forState:UIControlStateNormal]; 
        [m_pButtonAdd3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIBarButtonItem *mBarButtonItemButtonAdd3 = [[UIBarButtonItem alloc] initWithCustomView:m_pButtonAdd3];
        
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]; 
        
        [m_pToolBar setItems:[NSArray arrayWithObjects:mBarButtonItemButtonAdd, mBarButtonItemButtonAdd2,mBarButtonItemButtonAdd3,nil]];
        
        [flexibleSpace release];
        
        [self.view addSubview:m_pToolBar];
        
    }
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dismissWin
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)getMyPic
{
    //NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *userid=@"";

    userid = [mydict objectForKey:@"userid"];
    
    NSString *tmp=[NSString stringWithFormat:@"%@getMemberPic.php?u=%@",host_url, userid];
    NSLog(@"%@",tmp);
    
    NSMutableURLRequest *req = [[NSMutableURLRequest new] autorelease];      
    
    [req setURL:[NSURL URLWithString:tmp]];
    [req setHTTPMethod:@"GET"];     
    [req addValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [req setTimeoutInterval:10.0f];
    
    
    NSHTTPURLResponse* urlResponse = nil;  
	NSError *error = [[NSError alloc] init]; 
    NSData *responseData = [NSURLConnection sendSynchronousRequest:req returningResponse:&urlResponse error:&error];  
	NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",result);
    
    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {    
        NSDictionary *dict = [result JSONValue];
        NSArray *resultArr = (NSArray *)dict;
        NSLog(@"%d",[resultArr count]);
        int n = [resultArr count];
        if(n > 0){
            for (NSDictionary *item in resultArr) {
                [data addObject:[item objectForKey: @"x_pic"]];
            }
        }else{
            [data addObject:@"upload/no.jpg"];
        }
        
    }
}

- (int)getMemberInfo
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *userid = @"";
    NSString *myid=@"";
    
    userid = [mydict objectForKey:@"userid"];
    myid = [userDefault objectForKey:@"login_user_id"];
    
    ClientConnection *client = [[ClientConnection alloc] init];
    mydict = [[NSMutableDictionary alloc] init];
    mydict = [client getMyinfo:userid loginUserId:myid];
    self.navigationItem.title = [mydict objectForKey:@"username"];
    
    NSString *relation =[NSString stringWithFormat:@"%@",[mydict objectForKey: @"relation"]];
    // NSLog(@"%@",relation);
    
    if([relation isEqualToString:@"0"]){
        [m_pButtonAdd2 setTitle:@"添加关注" forState:UIControlStateNormal];
        [mydict setValue:@"陌生人" forKey:@"relation"];
    }else if([relation isEqualToString:@"1"]){
        [m_pButtonAdd2 setTitle:@"取消关注" forState:UIControlStateNormal];
        [mydict setValue:@"关注" forKey:@"relation"];
    }else if([relation isEqualToString:@"2"]){
        [m_pButtonAdd2 setTitle:@"取消关注" forState:UIControlStateNormal];
        [mydict setValue:@"互为好友" forKey:@"relation"];
    }else{
        [m_pButtonAdd2 setTitle:@"添加关注" forState:UIControlStateNormal];
        [mydict setValue:@"陌生人" forKey:@"relation"];
    }
    [client release];
    
    usernameLabel.text = [mydict objectForKey:@"username"];
    NSString *sex = [mydict objectForKey:@"sex"];
    if([sex isEqualToString:@"0"]){
        sex=@"男 ♂";
    }else {
        sex=@"女 ♀";
    }
    sexLabel.text=sex;
    qianmingLabel.text=[mydict objectForKey:@"qianming"];
    starttimeLabel.text=[mydict objectForKey:@"startoff_time"];
    startposnameLabel.text=[mydict objectForKey:@"startposname"];
    endposnameLabel.text=[mydict objectForKey:@"endposname"];
    
    NSString *req_sex = [mydict objectForKey:@"req_sex"];
    NSString *req_smoke = [mydict objectForKey:@"req_smoke"];
    NSString *req_fee = [mydict objectForKey:@"req_fee"];
    NSString *req_peoples = [NSString stringWithFormat:@"乘客人数:%@",[mydict objectForKey:@"req_peoples"]];
    
    if([req_sex isEqualToString:@"0"]){
        req_sex = @"性别:只接受男性";
    }else if([req_sex isEqualToString:@"1"]){
        req_sex = @"性别:只接受女性";
    }else if([req_sex isEqualToString:@"2"]){
        req_sex = @"性别:男女均可";
    }
    
    if([req_smoke isEqualToString:@"0"]){
        req_smoke = @"吸烟:接受";
    }else if([req_smoke isEqualToString:@"1"]){
        req_smoke = @"吸烟:不接受";
    }else if([req_smoke isEqualToString:@"2"]){
        req_smoke = @"吸烟:无要求";
    }
    
    if([req_fee isEqualToString:@"0"]){
        req_fee = @"分担油费:接受";
    }else if([req_fee isEqualToString:@"1"]){
        req_fee = @"分担油费:不接受";
    }
    
    yaoqiuLabel.text = [NSString stringWithFormat:@"%@,%@,%@,%@",req_sex,req_smoke,req_fee,req_peoples];
    
    
    
    
    return [mydict count];
}


-(IBAction)sendMsg:(id)sender
{
    [self loadSendMessageVC];
}

- (void)loadSendMessageVC
{
    vcMessage = [[SendMessageVC alloc] init];
    vcMessage.t_userid=[mydict objectForKey:@"userid"];
    vcMessage.t_username=[mydict objectForKey:@"username"];
    UINavigationController* nav = [[[UINavigationController alloc] initWithRootViewController:vcMessage] autorelease];
    [self.navigationController presentModalViewController:nav animated:YES];
}

- (IBAction)FollowTA:(id)sender
{
    [self addfollow];
    
}

-(void)addfollow
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *login_user_id = [userDefault objectForKey:@"login_user_id"];
    NSString *userid=@"";
    userid = [mydict objectForKey:@"userid"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userid forKey:@"u"];
    [params setObject:login_user_id forKey:@"my"];
    
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    
    NSString *baseurl=@"addfollow.php";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL]];
	[self setRequest:[ASIHTTPRequest requestWithURL:url]];
	[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
	[request startSynchronous];
    
    if (request) {
        if ([request error]) {
            NSString *result = [[request error] localizedDescription];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        } else if ([request responseString]) {
            NSString *result = [request responseString];
            //NSLog(@"%@",result);
            NSDictionary *dict = [result JSONValue];
            if([[dict objectForKey: @"regTag"] isEqualToNumber:[NSNumber numberWithInt:1]]){            
                //关注成功
                [m_pButtonAdd2 setTitle:@"取消关注" forState:UIControlStateNormal];
                [mydict setValue:@"关注" forKey:@"relation"];
                
            }else if([[dict objectForKey: @"regTag"] isEqualToNumber:[NSNumber numberWithInt:0]]){            
                //取消关注
                [m_pButtonAdd2 setTitle:@"添加关注" forState:UIControlStateNormal];
                [mydict setValue:@"陌生人" forKey:@"relation"];
                
            }else if([[dict objectForKey: @"regTag"] isEqualToNumber:[NSNumber numberWithInt:2]]){            
                //互为好友
                [m_pButtonAdd2 setTitle:@"取消关注" forState:UIControlStateNormal];
                [mydict setValue:@"互为好友" forKey:@"relation"];
                
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                [alertView release];
            }
        }
    }else{
        NSLog(@"request is nil.");
    }
}

@end
