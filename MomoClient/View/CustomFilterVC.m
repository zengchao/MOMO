//
//  CustomFilterVC.m
//  MOMO
//
//  Created by 超 曾 on 12-5-11.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "CustomFilterVC.h"

@implementation CustomFilterVC
@synthesize leftBtn;
@synthesize userSeg;
@synthesize dateSeg;
@synthesize btnConfirm;
@synthesize in_time,in_sex;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"自定义筛选";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    leftBtn = [[UIBarButtonItem alloc]
               initWithTitle:@"取消"
               style:UIBarButtonItemStyleBordered
               target:self
               action:@selector(dismissWin)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationController.navigationBarHidden=FALSE;
    self.navigationController.title=@"自定义筛选";
    
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }

}

-(IBAction)btnConfirmClick:(id)sender
{
    in_sex = userSeg.selectedSegmentIndex;
    in_time = dateSeg.selectedSegmentIndex;
    [delegate passValue:in_sex time:in_time]; 
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [leftBtn release];
    [userSeg release];
    [dateSeg release];
    [btnConfirm release];
    
}

-(void)dismissWin
{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
