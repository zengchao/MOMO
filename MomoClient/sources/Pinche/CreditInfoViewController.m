//
//  CreditInfoViewController.m
//  MOMO
//
//  Created by 超 曾 on 12-5-23.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724


#import "CreditInfoViewController.h"

@interface CreditInfoViewController ()

@end

@implementation CreditInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
