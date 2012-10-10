//
//  BlackDefine.m
//  MOMO
//
//  Created by apple on 12-7-4.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "BlackDefine.h"

@implementation BlackDefine
@synthesize array;
@synthesize request;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)dealloc {
    [super dealloc];
    [array release];
    [request cancel];
	[request release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
    
    CGRect tableViewFrame=self.view.bounds;
    UITableView *myTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    myTableView.scrollEnabled=YES;
    EGOImageView *thumbnail = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"small_loading_pic.png"]];
    thumbnail.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host_url,[array objectAtIndex:3]]];
    thumbnail.frame = CGRectMake(125, 5, 75, 75);
    UIView *headView=[[UIView alloc] initWithFrame:CGRectMake(5, 5, 320, 75)];
    [headView addSubview:thumbnail];
    [thumbnail release];
    myTableView.tableHeaderView=headView;
    [self.view addSubview:myTableView];
    [myTableView release];
    [headView release];
    
    UIToolbar *m_pToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height -  40.0, self.view.frame.size.width, 40.0)];
    [m_pToolBar setBarStyle:UIBarStyleBlackOpaque];
    m_pToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    UIButton *m_pButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [m_pButton setFrame:CGRectMake(120, 0, 80, 35)];
    [m_pButton addTarget:self action:@selector(deleteblacklist) forControlEvents:UIControlEventTouchUpInside];
    [m_pButton setTitle:@"取消拉黑" forState:UIControlStateNormal]; 
    [m_pButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [m_pToolBar addSubview:m_pButton];
    [self.view addSubview:m_pToolBar];
    [m_pToolBar release];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *retStr=@"";
    switch (section) {
        case 0:
            retStr = @"个人信息：";
            break;
        case 1:
            retStr = @"搭车信息:";
            break;
        case 2:
            retStr = @"对乘车或车主的特殊要求:";
            break;
    }
    return retStr;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        CGRect titleRect = CGRectMake(15, 5, 90, 30);
        UILabel *titlelable = [[UILabel alloc] initWithFrame: 
                             titleRect];
        titlelable.backgroundColor=[UIColor clearColor];
        titlelable.tag = 1;
        [cell.contentView addSubview:titlelable];
        [titlelable release];
        
        CGRect contentRect = CGRectMake(105, 5, 200, 30);
        UILabel *contentValue = [[UILabel alloc] initWithFrame: 
                              contentRect];
        contentValue.backgroundColor=[UIColor clearColor];
        contentValue.tag = 2;
        [cell.contentView addSubview:contentValue];
        [contentValue release];
    }
    UILabel *title = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *content = (UILabel *)[cell.contentView viewWithTag:2];
    switch (indexPath.section) {
        case 0:
            if(indexPath.row==0){
                title.text=@"名称：";
                content.text = [array objectAtIndex:1];
            }else if(indexPath.row==1){
                title.text=@"会员号：";
                content.text = [array objectAtIndex:0];
            }else if(indexPath.row==2){
                title.text=@"性别：";
                NSString *sex=[array objectAtIndex:2];
                int index=[sex intValue];
                if (index==1) {
                content.text =@"男";
                }else if (index==2) {
                content.text =@"女";
                }
            }else if(indexPath.row==3){
                title.text=@"个人签名：";
                content.text = [array objectAtIndex:12];
            }
            break;
        case 1:
            if(indexPath.row==0){
                title.text=@"起始地：";
                content.text = [array objectAtIndex:4];
            }else if(indexPath.row==1){
                title.text=@"目的地：";
                content.text = [array objectAtIndex:5];
            }else if(indexPath.row==2){
                title.text=@"上班时间：";
                content.text = [array objectAtIndex:6];
            }else if(indexPath.row==3){
                title.text=@"下班时间：";
                content.text = [array objectAtIndex:7];
            }
            break;
        case 2:
            if(indexPath.row==0){
                title.text=@"性别要求：";
                NSString *sex=[array objectAtIndex:8];
                int index=[sex intValue];
                if (index==1) {
                    content.text =@"男";
                }else if (index==2) {
                    content.text =@"女";
                }
            }else if(indexPath.row==1){
                title.text=@"是否吸烟：";
                int index=[[array objectAtIndex:9] intValue];
                if (index==0) {
                    content.text =@"是";
                }else if (index==1) {
                    content.text =@"否";
                }
                else if (index==2) {
                    content.text =@"不限";
                }
            }else if(indexPath.row==2){
                title.text=@"是否分担油费：";
                int index=[[array objectAtIndex:10] intValue];
                if (index==0) {
                    content.text =@"是";
                }else if (index==1) {
                    content.text =@"否";
                }
            }else if(indexPath.row==3){
                title.text=@"乘车人数：";
                content.text = [array objectAtIndex:13];
            }
            break;
        default:
            break;
    }
    
	return cell;
}


-(void)deleteblacklist{
    [NSThread detachNewThreadSelector:@selector(startThread) toTarget:self withObject:nil];
}
-(void)startThread{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *userid = [userDefault objectForKey:@"login_user_id"];
    NSString *blackid=[array objectAtIndex:0];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userid forKey:@"userid"];
    [params setObject:blackid forKey:@"black_userid"];
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    //NSLog(@"postURL:%@",postURL);
    NSString *baseurl=@"delblacklist.php";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL]];
    [self setRequest:[ASIHTTPRequest requestWithURL:url]];
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request startSynchronous];
    if (request) {
        if ([request error]) {
            NSString *result = [[request error] localizedDescription];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            
        } else if ([request responseString]) {
            NSString *result = [request responseString];
            NSLog(@"result:%@",result);
            if (result==nil) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"删除失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                [alertView release];
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"删除成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alertView.tag=10;
                [alertView show];
                [alertView release];
            }
        }
    }
    else{
        NSLog(@"request is nil.");
    }
    [pool release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag==10 && buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
	} 
	
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
