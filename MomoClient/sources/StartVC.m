//
//  StartVC.m
//  MOMO
//
//  Created by 超 曾 on 12-6-26.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "StartVC.h"

@implementation StartVC
@synthesize backReg,backLogin,vcLogin,vcReg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"搭车";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)dealloc
{
    [super dealloc];
    [backLogin release];
    [backReg release];
    [vcLogin release];
    [vcReg release];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.backLogin =nil;
    self.backReg =nil;
    self.vcLogin =nil;
    self.vcReg =nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)callRegisterWindow:(UIButton *)sender
{
    if(![Utility connectedToNetwork])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        vcReg = [[RegStepOneVC alloc] initWithNibName:@"RegStepOneVC" bundle:nil];
        backReg = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = backReg;
        [self.navigationController pushViewController:vcReg animated:YES];
    }
}

- (IBAction)callLoginWindow:(UIButton *)sender
{
    if(![Utility connectedToNetwork])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }else{
        vcLogin = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        backLogin = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = backLogin;  
        [self.navigationController pushViewController:vcLogin animated:YES];
        
    }
}


@end
