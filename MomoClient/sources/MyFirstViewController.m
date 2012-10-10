//
//  FirstViewController.m
//  Sample_TabBar_Nav
//
//  Created by daniel on 10-10-30.
//  Copyright 2010 http://desheng.me [desheng.young@gmail.com]. NO right reserved.
//

#import "FirstViewController.h"
#import "Sample_TabBar_NavAppDelegate.h"
#import "SecondViewController.h"

@implementation FirstViewController

- (void)dealloc {
  [super dealloc];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"FirstViewController";
}

- (void)gotoSecondViewController {
  UIBarButtonItem *backItem = [[[UIBarButtonItem alloc] initWithTitle:@"First" 
                                                                style:UIBarButtonItemStyleBordered 
                                                               target:nil 
                                                               action:nil] autorelease];
  self.navigationItem.backBarButtonItem = backItem;
  
  SecondViewController *second = [[[SecondViewController alloc] init] autorelease];
  Sample_TabBar_NavAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate.navigationController pushViewController:second animated:YES];
}


@end
