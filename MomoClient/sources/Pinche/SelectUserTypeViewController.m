//
//  SelectUserTypeViewController.m
//  MOMO
//
//  Created by 超 曾 on 12-5-23.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "SelectUserTypeViewController.h"


@implementation SelectUserTypeViewController
@synthesize btnFirst;
@synthesize btnSecond;
@synthesize btnThird;
@synthesize btnBbs;
@synthesize btnSetup;
@synthesize vcInput;
@synthesize vcBbs;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.title=@"拼车";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"搭车";
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 37)];
    [btnBack setBackgroundColor:[UIColor clearColor]];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *barButtonIteLeft = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = barButtonIteLeft;
    [barButtonIteLeft release];
    [btnBack release];
    
    UIButton *btnDone = [[UIButton alloc] initWithFrame:CGRectMake(260, 0, 69, 44)];
    [btnDone setBackgroundColor:[UIColor clearColor]];
    [btnDone setBackgroundImage:[UIImage imageNamed:@"bbs.png"] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(btnOpenBbsWin:) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *barButtonIteRight = [[UIBarButtonItem alloc] initWithCustomView:btnDone];
    self.navigationItem.rightBarButtonItem = barButtonIteRight;
    [barButtonIteRight release];
    [btnDone release];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.btnFirst =nil;
    self.btnSecond =nil;
    self.btnThird =nil;
    self.btnBbs =nil;
    self.btnSetup =nil;
    self.vcInput =nil;
    self.vcBbs=nil;
    
}

- (void)dealloc
{
    [super dealloc];
    [btnFirst release];
    [btnSecond release];
    [btnThird release];
    [btnBbs release];
    [btnSetup release];
    [vcInput release];
    [vcBbs release];
    
}

-(IBAction)btnOpenDataWin:(id)sender
{
    
    vcInput = [[InputDataViewController alloc] initWithNibName:@"InputDataViewController" bundle:nil];
    
    if([sender isEqual:self.btnFirst]){
        //我有车
        vcInput.flag=@"0";
    }else if([sender isEqual:self.btnSecond]){
        //搭车
        vcInput.flag=@"1";
    }else if([sender isEqual:self.btnThird]){
        //拼车
        vcInput.flag=@"2";
    }
    
    [self.navigationController pushViewController:vcInput animated:YES];
        
}

-(IBAction)btnOpenBbsWin:(id)sender
{
    vcBbs = [[[BbsViewController alloc] initWithNibName:@"BbsViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:vcBbs animated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
