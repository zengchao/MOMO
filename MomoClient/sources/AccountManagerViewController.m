//
//  AccountManagerViewController.m
//
//  Created by 超 曾 on 12-3-28.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "AccountManagerViewController.h"

@implementation AccountManagerViewController 

@synthesize myTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
    
    CGRect tableViewFrame = self.view.bounds;
    [self.navigationController setNavigationBarHidden:FALSE];
    
    //tableViewFrame.origin.y = 40;
    //tableViewFrame.size.height=420;
    self.view.backgroundColor = [UIColor whiteColor];
    myTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    myTableView.scrollEnabled=YES;
    //myTableView.allowsSelection=FALSE;
    [self.view addSubview:myTableView];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    myTableView = nil;
}

- (void)dealloc
{
    [myTableView release];
    [super dealloc];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        CGRect rect = CGRectMake(5,5,25,25);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        [cell.contentView addSubview:imageView];
        [imageView release];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 285, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment=UITextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        [cell.contentView addSubview:titleLabel];  
        [titleLabel release];
        
        UILabel *smallLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 315, 20)];
        smallLabel.backgroundColor = [UIColor clearColor];
        smallLabel.textColor = [UIColor blackColor];
        smallLabel.textAlignment=UITextAlignmentLeft;
        smallLabel.font = [UIFont systemFontOfSize:12];
        smallLabel.lineBreakMode = UILineBreakModeTailTruncation;
        [cell.contentView addSubview:smallLabel]; 
        [smallLabel release];
        
        if(indexPath.section==0){
            if(indexPath.row==0){
                
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}



@end
