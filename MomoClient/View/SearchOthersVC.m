//
//  SearchOthersVC.m
//  MOMO
//
//  Created by 超 曾 on 12-5-12.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "SearchOthersVC.h"

@interface SearchOthersVC ()

@end

@implementation SearchOthersVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"实时找客";
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
    self.title=@"实时找客";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
