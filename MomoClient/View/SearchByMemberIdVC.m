//
//  SearchByMemberIdVC.m
//  MOMO
//
//  Created by 超 曾 on 12-5-11.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "SearchByMemberIdVC.h"

@implementation SearchByMemberIdVC
@synthesize txtMemberId;
@synthesize btnSearch;
//@synthesize vcMember;
@synthesize vcUser;

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.txtMemberId=nil;
    self.btnSearch=nil;
    //self.vcMember=nil;
    self.vcUser=nil;
    
}

- (void)dealloc
{
    [txtMemberId release];
    [btnSearch release];
    //[vcMember release];
    [vcUser release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"添加好友";
    
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
    self.navigationController.title=@"添加好友";
}

-(void)dismissWin
{
    [self dismissModalViewControllerAnimated:YES];
}



-(IBAction)btnSearchClick:(id)sender
{   
    if([txtMemberId.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"会员号不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }  
    NSMutableDictionary *mydict = [[NSMutableDictionary alloc] init];
    [mydict setValue:txtMemberId.text forKey:@"userid"];
    //先请求一遍，如果正确则跳转会员信息界面
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *userid = @"";
    NSString *myid=@"";
    userid = txtMemberId.text;
    myid = [userDefault objectForKey:@"login_user_id"];
    //启动分线程执行    addHUM
    ClientConnection *client = [[ClientConnection alloc] init];
    if ([[client getMyinfo:userid loginUserId:myid] count]==0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该会员号不存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
    else{
//        vcMember = [[MemberInfoVC alloc] initWithNibName:@"MemberInfoVC" bundle:nil];
//        vcMember.mydict = mydict;
//        vcMember.b_myinfo=FALSE;
//        UINavigationController* nav = [[[UINavigationController alloc] initWithRootViewController:vcMember] autorelease];
//        [self.navigationController presentModalViewController:nav animated:YES];
        
        
        vcUser = [[UserinfoVC alloc] initWithNibName:@"UserinfoVC" bundle:nil];
        vcUser.mydict = mydict;
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vcUser];
        [self.navigationController presentModalViewController:nav animated:YES];
        [nav release];
        
    }
    [client release];
    [mydict release];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
