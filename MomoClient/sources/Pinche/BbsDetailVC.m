//
//  BbsDetailVC.m
//  MOMO
//
//  Created by 超 曾 on 12-6-2.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "BbsDetailVC.h"

@implementation BbsDetailVC
@synthesize s_id,s_title,s_content,s_userid,s_flag,s_updatetime,s_username;
@synthesize labelTitle,labelUsername,labelUpdatetime,textviewContent;

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
    self.navigationItem.title=@"公告详情";
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
    
    labelTitle.text = s_title;
    labelUpdatetime.text=s_updatetime;
    labelUsername.text=s_username;
    textviewContent.text=s_content;
    textviewContent.editable=NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [s_id release];
    [s_title release];
    [s_userid release];
    [s_username release];
    [s_content release];
    [s_updatetime release];
    [s_flag release];
    [labelUsername release];
    [labelTitle release];
    [labelUpdatetime release];
    [textviewContent release];
    
}

-(void)dealloc
{
    [s_id release];
    [s_title release];
    [s_userid release];
    [s_username release];
    [s_content release];
    [s_updatetime release];
    [s_flag release];
    [labelUsername release];
    [labelTitle release];
    [labelUpdatetime release];
    [textviewContent release];
    
    [super dealloc];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
