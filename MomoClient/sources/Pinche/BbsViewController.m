//
//  BbsViewController.m
//  MOMO
//
//  Created by 超 曾 on 12-5-23.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "BbsViewController.h"
#import "NSObject+SBJson.h"

@implementation BbsViewController
@synthesize myTableView; 
@synthesize list;
@synthesize request;
@synthesize vcBbsDetail;

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.myTableView=nil;
    self.list=nil;
    self.vcBbsDetail=nil;
    self.request=nil;
    
}

- (void)dealloc
{
    [request cancel];
    [request release];
    [myTableView release];
    [list release];
    [super dealloc];
}

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
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
    
    //背景图
    UIImageView *imageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"320-416.png"]];
    imageView.frame=CGRectMake(0, 0, 320, 416);
    [self.view addSubview:imageView];
    [imageView release];
    
    self.navigationItem.title=@"公告板";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleBordered target:self action:@selector(Bbsrequest)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    CGRect tableViewFrame = self.view.bounds;
    tableViewFrame.size.height=460;
    self.view.backgroundColor = [UIColor whiteColor];
    myTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    myTableView.scrollEnabled=YES;
    //myTableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:myTableView];
    
    [self loadList];
    
}



-(void)Bbsrequest{
    
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    if (mailPicker) {
    mailPicker.mailComposeDelegate = self;
    
    [mailPicker setSubject: @"发布公告"];
    [mailPicker setToRecipients: [NSArray arrayWithObject:@"wangyi2652683@163.com"]];
    NSString *emailBody = @"";
    [mailPicker setMessageBody:emailBody isHTML:YES];
    [self presentModalViewController: mailPicker animated:YES];
    }
    [mailPicker release];

}

- (void)mailComposeController:(MFMailComposeViewController*)controller  
          didFinishWithResult:(MFMailComposeResult)result  
                        error:(NSError*)error {  
    switch (result) 
    { 
        case MFMailComposeResultCancelled: 
            //NSLog(@"Mail send canceled..."); 
            break; 
        case MFMailComposeResultSaved: 
            //NSLog(@"Mail saved..."); 
            break; 
        case MFMailComposeResultSent: 
            //NSLog(@"Mail sent..."); 
            break; 
        case MFMailComposeResultFailed: 
            //NSLog(@"Mail send errored: %@...", [error localizedDescription]); 
            break; 
        default: 
            break; 
    } 
    [self dismissModalViewControllerAnimated:YES]; 
} 

-(void)loadList
{
    [list removeAllObjects];
    list = [[NSMutableArray alloc] init];
    
    NSString *baseurl=@"getAnnounceList.php";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host_url,baseurl]];
	[self setRequest:[ASIHTTPRequest requestWithURL:url]];
	[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
	[request startSynchronous];
    
    if (request) {
        if ([request error]) {
            NSString *result = [[request error] localizedDescription];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            
        } else if ([request responseString]) {
            NSString *result = [request responseString];
            if([result isEqualToString:@"40023"] || [result isEqualToString:@"40024"]){
                
            }else{
                NSLog(@"%@",result);
                NSDictionary *mydict = [result JSONValue]; 
                NSMutableDictionary *tmpDict;
                NSArray *resultArr = (NSArray *)mydict;
                for (NSDictionary *item in resultArr) {
                    tmpDict = [[NSMutableDictionary alloc] init];
                    [tmpDict setValue:[item objectForKey: @"id"] forKey:@"id"];
                    [tmpDict setValue:[item objectForKey: @"userid"] forKey:@"userid"];
                    [tmpDict setValue:[item objectForKey: @"username"] forKey:@"username"];
                    [tmpDict setValue:[item objectForKey: @"title"] forKey:@"title"];
                    [tmpDict setValue:[item objectForKey: @"content"] forKey:@"content"];
                    [tmpDict setValue:[item objectForKey: @"update_time"] forKey:@"update_time"];
                    [tmpDict setValue:[item objectForKey: @"flag"] forKey:@"flag"];                
                    [list addObject:tmpDict];
                    [tmpDict release];
                }
            }
        }
    }else{
        
    }
    
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
    return [list count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void) unselectCurrentRow
{
    [myTableView deselectRowAtIndexPath:
    [myTableView indexPathForSelectedRow] animated:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
    vcBbsDetail = [[BbsDetailVC alloc] initWithNibName:@"BbsDetailVC" bundle:nil];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];
    
    vcBbsDetail.s_id = [[list objectAtIndex:newIndexPath.row] objectForKey:@"id"];
    vcBbsDetail.s_userid = [[list objectAtIndex:newIndexPath.row] objectForKey:@"userid"];
    vcBbsDetail.s_title = [[list objectAtIndex:newIndexPath.row] objectForKey:@"title"];
    vcBbsDetail.s_content = [[list objectAtIndex:newIndexPath.row] objectForKey:@"content"];
    vcBbsDetail.s_updatetime = [[list objectAtIndex:newIndexPath.row] objectForKey:@"update_time"];
    vcBbsDetail.s_flag = [[list objectAtIndex:newIndexPath.row] objectForKey:@"flag"];
    vcBbsDetail.s_username = [[list objectAtIndex:newIndexPath.row] objectForKey:@"username"];
    [self.navigationController pushViewController:vcBbsDetail animated:TRUE];
    
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
    
    cell.textLabel.text = [[list objectAtIndex:indexPath.row] objectForKey:@"title"];
        
    return cell;
    
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	//取新数据
//    [self loadMemberList];
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	//重新加载tableview
    [myTableView reloadData];
    
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:myTableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) ViewFreshData{
    [myTableView setContentOffset:CGPointMake(0, -75) animated:YES];
    [self performSelector:@selector(doneManualRefresh) withObject:nil afterDelay:0.4];
}

-(void)doneManualRefresh{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:myTableView];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:myTableView];
}

@end
