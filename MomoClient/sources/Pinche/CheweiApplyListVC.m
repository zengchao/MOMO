//
//  CheweiApplyListVC.m
//  MOMO
//
//  Created by 超 曾 on 12-6-9.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "CheweiApplyListVC.h"
#import "ASIHTTPRequest.h"

@implementation CheweiApplyListVC
@synthesize member_id;
@synthesize myTableView;
@synthesize list;
@synthesize chewei_name,chewei_id;
@synthesize request;
@synthesize curid;

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
    self.navigationItem.title=@"车位申请记录";
    
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
    
    if([self.member_id isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"login_user_id"]]){
//        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]
//                                initWithTitle:@"管理"
//                                style:UIBarButtonItemStyleBordered
//                                target:self
//                                action:@selector(do_apply_manage)];
//        self.navigationItem.rightBarButtonItem = rightBtn;
    }else{
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]
                                     initWithTitle:@"申请"
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(do_applyChewei)];
        self.navigationItem.rightBarButtonItem = rightBtn;
        [rightBtn release];
    }
    [self loadList];
    
    
}

- (void)do_apply_manage
{
    //NSLog(@"manage");
}

- (void)do_applyChewei
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"login_user_id"] forKey:@"uid"];
    [params setObject:chewei_id forKey:@"id"];
    
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    NSString *baseurl=@"applyChewei.php";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL]];
	[self setRequest:[ASIHTTPRequest requestWithURL:url]];
	[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
	[request startSynchronous];
    
    if (request) {
        if ([request error]) {
            NSString *result = [[request error] localizedDescription];
            //NSLog(@"%@",result);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        } else if ([request responseString]) {
            NSString *result = [request responseString];
            //NSLog(@"%@",result);
            NSDictionary *mydict = [result JSONValue];
            if([[mydict objectForKey: @"regTag"] isEqualToNumber:[NSNumber numberWithInt:1]]){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您已申请成功，等待车主审核" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                [alertView release];
            }else if([[mydict objectForKey: @"regTag"] isEqualToNumber:[NSNumber numberWithInt:0]]){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您已申请过一次" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                [alertView release];
            }
            //[mydict release];
        }
    }else{
        NSLog(@"request is nil.");
    }
    
    [self loadList];
    [myTableView reloadData];
    
}

- (void)dismissWin
{
    [self dismissModalViewControllerAnimated:TRUE];
}

- (void)dealloc
{
    [super dealloc];
    [member_id release];
    [myTableView release];
    [list release];
    [chewei_id release];
    [chewei_name release];
    [request cancel];
	[request release];
    [curid release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [member_id release];
    [myTableView release];
    [list release];
    [chewei_id release];
    [chewei_name release];
    [request cancel];
	[request release];
    [curid release];
    
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
    [params setObject:self.chewei_id forKey:@"cwid"];
    
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    NSString *baseurl=@"getCheweiApplyList.php";
    
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
                    [tmpDict setValue:[item objectForKey: @"chewei_id"] forKey:@"chewei_id"];
                    [tmpDict setValue:[item objectForKey: @"chewei_name"] forKey:@"chewei_name"];
                    [tmpDict setValue:[item objectForKey: @"apply_userid"] forKey:@"apply_userid"]; 
                    [tmpDict setValue:[item objectForKey: @"apply_username"] forKey:@"apply_username"]; 
                    [tmpDict setValue:[item objectForKey: @"apply_time"] forKey:@"apply_time"]; 
                    [tmpDict setValue:[item objectForKey: @"apply_status"] forKey:@"apply_status"]; 
                    [tmpDict setValue:[item objectForKey: @"verify_status"] forKey:@"verify_status"]; 
                    [tmpDict setValue:[item objectForKey: @"verify_time"] forKey:@"verify_time"]; 
                    
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
    curid = [[list objectAtIndex:newIndexPath.row] objectForKey:@"id"];
    [self manageChewei];
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
    NSString *s_chewei_name = [NSString stringWithFormat:@"%@",[[list objectAtIndex:indexPath.row] objectForKey:@"chewei_name"]];
    NSString *s_apply_username = [NSString stringWithFormat:@"%@",[[list objectAtIndex:indexPath.row] objectForKey:@"apply_username"]];
    NSString *s_verify_status = [NSString stringWithFormat:@"%@",[[list objectAtIndex:indexPath.row] objectForKey:@"verify_status"]];
    
    
    if([s_verify_status isEqualToString:@"1"]){
        cell.textLabel.text = [NSString stringWithFormat:@"%@申请%@(%@)",s_apply_username,s_chewei_name,@"已批准"];
    }else if([s_verify_status isEqualToString:@"0"]){
        cell.textLabel.text = [NSString stringWithFormat:@"%@申请%@(%@)",s_apply_username,s_chewei_name,@"未处理"];
    }else{
        cell.textLabel.text=@"";
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

- (void)manageChewei
{

    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle: @"管理车位申请"
                           delegate:self
                           cancelButtonTitle:@"取消"
                           destructiveButtonTitle:@"批准"
                           otherButtonTitles:@"拒绝", nil];
    [menu showInView:[UIApplication sharedApplication].keyWindow];
    [menu release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //批准
            [self verify:@"1" sid:curid];
           
            break;
        case 1:
            //拒绝
            [self verify:@"0" sid:curid];
            break;
            
    }
    [self loadList];
    [myTableView reloadData];
}

- (void)verify:(NSString *)flag sid:(NSString *)sid
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:sid forKey:@"id"];
    [params setObject:flag forKey:@"flag"];
    
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    NSString *baseurl=@"updateApplyStatus.php";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL]];
	[self setRequest:[ASIHTTPRequest requestWithURL:url]];
	[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
	[request startSynchronous];
    
    if (request) {
        if ([request error]) {
            NSString *result = [[request error] localizedDescription];
            //NSLog(@"%@",result);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        } else if ([request responseString]) {
            NSString *result = [request responseString];
            //NSLog(@"%@",result);
            NSDictionary *mydict = [result JSONValue];
            if([[mydict objectForKey: @"regTag"] isEqualToNumber:[NSNumber numberWithInt:1]]){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"更新成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                [alertView release];
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"更新失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                [alertView release];
            }
            //[mydict release];
        }
    }else{
        NSLog(@"request is nil.");
    }
}


@end
