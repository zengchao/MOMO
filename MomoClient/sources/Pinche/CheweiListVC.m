//
//  CheweiListVC.m
//  MOMO
//
//  Created by 超 曾 on 12-6-9.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "CheweiListVC.h"

@implementation CheweiListVC
@synthesize member_id;
@synthesize myTableView;
@synthesize list;
@synthesize request;

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
    self.navigationItem.title=@"TA的车位";
    list = [[NSMutableArray alloc] init];
    
    CGRect tableViewFrame = self.view.bounds;
    tableViewFrame.size.height=460;
    self.view.backgroundColor = [UIColor whiteColor];
    myTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    myTableView.scrollEnabled=YES;
    [self.view addSubview:myTableView];
    
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]
                                initWithTitle:@"返回"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(dismissWin)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn release];
    
    [self loadList];
    
}

- (void)dismissWin
{
    [self dismissModalViewControllerAnimated:TRUE];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [member_id release];
    [myTableView release];
    [list release];
    [request cancel];
    [request release];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)loadList
{
    [list removeAllObjects];
    list = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.member_id forKey:@"uid"];
    
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    NSString *baseurl=@"getCheweiList.php";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL]];
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
                NSDictionary *mydict = [result JSONValue];  
                NSMutableDictionary *tmpDict;
                NSArray *resultArr = (NSArray *)mydict;
                for (NSDictionary *item in resultArr) {
                    tmpDict = [[NSMutableDictionary alloc] init];
                    [tmpDict setValue:[item objectForKey: @"id"] forKey:@"id"];
                    [tmpDict setValue:[item objectForKey: @"userid"] forKey:@"userid"];
                    [tmpDict setValue:[item objectForKey: @"username"] forKey:@"username"];
                    [tmpDict setValue:[item objectForKey: @"name"] forKey:@"name"];
                    [tmpDict setValue:[item objectForKey: @"status"] forKey:@"status"];
                    [tmpDict setValue:[item objectForKey: @"update_time"] forKey:@"update_time"];             
                    [list addObject:tmpDict];
                    [tmpDict release];
                }
            }
        }
    }else{
        
    }
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
    CheweiApplyListVC *vc = [[CheweiApplyListVC alloc] initWithNibName:@"CheweiApplyListVC" bundle:nil];
    vc.member_id = self.member_id;
    vc.chewei_id = [[list objectAtIndex:newIndexPath.row] objectForKey:@"id"];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentModalViewController:nav animated:YES];
    [vc release];
    [nav release];
    
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
    NSString *status = [NSString stringWithFormat:@"%@",[[list objectAtIndex:indexPath.row] objectForKey:@"status"]];
    NSString *chewei_name = [NSString stringWithFormat:@"%@",[[list objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    if([status isEqualToString:@"1"]){
        cell.textLabel.text = [NSString stringWithFormat:@"%@   %@",chewei_name,@"不可申请占座"];
    }else if([status isEqualToString:@"0"]){
        cell.textLabel.text = [NSString stringWithFormat:@"%@   %@",chewei_name,@"可申请占座"];
    }
    
    
    return cell;
    
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	//取新数据
    [self loadList];
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
