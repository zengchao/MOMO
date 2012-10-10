//
//  YuyuepingcheVC.m
//  MOMO
//
//  Created by 超 曾 on 12-5-12.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "YuyuepingcheVC.h"

@interface YuyuepingcheVC ()

@end

@implementation YuyuepingcheVC
@synthesize btnOffice;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"预约拼车";
        UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
        if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
        {
            [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"预约拼车";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [btnOffice release];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)btnOfficeClick:(id)sender
{
    OfficeVC *vc = [[OfficeVC alloc] initWithNibName:@"OfficeVC" bundle:nil];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
    
}

@end
