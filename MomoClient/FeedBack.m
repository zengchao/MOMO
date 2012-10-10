//
//  FeedBack.m
//  MOMO
//
//  Created by apple on 12-6-13.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "FeedBack.h"
#import "MemberInfoVC.h"
@implementation FeedBack
//@synthesize request;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"意见反馈";
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
    
    tv=[[UITextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 200.0f)];
	tv.backgroundColor=[UIColor clearColor];
	tv.textColor=[UIColor blackColor];
	tv.font=[UIFont systemFontOfSize:18];
	tv.text=@"意见反馈";	
    [tv becomeFirstResponder];
	[self.view addSubview:tv];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(save)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem=saveItem;
    self.navigationItem.leftBarButtonItem=backItem;
    [saveItem release];
    [backItem release];
    
}

-(void)save{
//        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//        [self.navigationController.view addSubview:HUD];	
//        HUD.dimBackground = YES;
//        HUD.delegate = self;
//        HUD.labelText = @"";
//        [HUD showWhileExecuting:@selector(feedbackList) onTarget:self withObject:nil animated:YES];
    [self feedbackList];
}

-(void)feedbackList{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *userid = [userDefault objectForKey:@"login_user_id"];
    NSString *baseurl=@"feedback.php";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host_url,baseurl]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request setPostValue:userid forKey:@"userid"];
    [request setPostValue:tv.text forKey:@"content"];
    [request setDelegate:self];
	[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:TRUE];
    
	[request startSynchronous];
    if (request) {
        if ([request error]) {
            NSString *result = [[request error] localizedDescription];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            
            
        } else if ([request responseData]){
           NSData *data = [request responseData];
            NSString *result=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"result:%@",result);
            [result release];
        }
    }
}
-(void)back{
    [self dismissModalViewControllerAnimated:YES];

}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
