//
//  InviteFriendsVC.m
//  MOMO
//
//  Created by 超 曾 on 12-5-11.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "InviteFriendsVC.h"
#import "ContactsCtrl.h"

@implementation InviteFriendsVC
@synthesize myTableView;
@synthesize contactView;

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.myTableView=nil;
    addressBook=nil;
    self.contactView=nil;
    
}

- (void)dealloc
{
    [myTableView release];
    CFRelease(addressBook);
    [contactView release];
    
    [super dealloc];
    
}

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
    self.title=@"发送邀请给好友";
    
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
    
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 37)];
    [btnBack setBackgroundColor:[UIColor clearColor]];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(dismissWin) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *barButtonIteLeft = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = barButtonIteLeft;
    [barButtonIteLeft release];
    [btnBack release];
    
    self.navigationController.navigationBarHidden=FALSE;
    self.navigationController.title=@"发送邀请给好友";
    
    CGRect tableViewFrame = self.view.bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    myTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    myTableView.scrollEnabled=YES;
    [self.view addSubview:myTableView];
}

-(void)dismissWin
{
    [self dismissModalViewControllerAnimated:YES];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{  
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
    if(newIndexPath.row==0){
        //群发手机短信
        if(addressBook == nil)
            addressBook = ABAddressBookCreate();
        contactView = [[ContactsCtrl alloc] initWithNibName:@"ContactsCtrl" bundle:nil];
        UINavigationController* nav = [[[UINavigationController alloc] initWithRootViewController:contactView] autorelease];
        [self.navigationController presentModalViewController:nav animated:YES];
    }else if(newIndexPath.row==1){
        
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{        
    
    static NSString *CellIdentifier = @"Cell2";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    //删除cell.contentView中所有内容，避免以下建立新的重复
    int i = [[cell.contentView subviews] count] - 1;
    for(;i >= 0 ; i--)
    {
        [[[cell.contentView subviews] objectAtIndex:i] removeFromSuperview];
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    if(indexPath.row==0){
        cell.textLabel.text=@"发送手机短信";
    }else if(indexPath.row==1){
        cell.textLabel.text=@"分享到新浪微博";
    }else if(indexPath.row==2){
        cell.textLabel.text=@"分享到腾讯微博";
    }else if(indexPath.row==3){
        cell.textLabel.text=@"分享到人人网";
    }else if(indexPath.row==4){
        cell.textLabel.text=@"分享到QQ空间";
    }
    return cell;
}


@end
