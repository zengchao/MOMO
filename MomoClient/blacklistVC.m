//
//  blacklistVC.m
//  MOMO
//
//  Created by apple on 12-6-13.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "blacklistVC.h"
#import "Global.h"
@implementation blacklistVC
@synthesize array,request;
@synthesize tableview;
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
-(void)addHUD{
//    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:HUD];	
//    HUD.dimBackground = YES;
//    HUD.delegate = self;
//    HUD.labelText = @"";
//    [HUD showWhileExecuting:@selector(loadBlackList) onTarget:self withObject:nil animated:YES];
    [self loadBlackList];
}

-(void)loadBlackList{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *sender = [userDefault objectForKey:@"login_user_id"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:sender forKey:@"userid"];
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    
    NSString *baseurl=@"getblacklist.php";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL]];
	[self setRequest:[ASIHTTPRequest requestWithURL:url]];
	[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:TRUE];
	[request startSynchronous];
    if (request) {
        if ([request error]) {
            NSString *result = [[request error] localizedDescription];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            
        } else if ([request responseString]){
            NSString *result = [request responseString];
            //NSLog(@"%@",result); 
            
            if([result isEqualToString:@"40023"] || [result isEqualToString:@"40024"]){
                self.array=nil;
            }
            else{
                NSArray *resultArr = [result JSONValue];
                NSMutableArray *bigArray=[[NSMutableArray alloc] init];
                for (NSDictionary *dic in resultArr) {
                    NSMutableArray *smallArray=[[[NSMutableArray alloc] init] autorelease];
                    [smallArray addObject:[dic objectForKey:@"userid"]];
                    [smallArray addObject:[dic objectForKey:@"username"]];
                    [smallArray addObject:[dic objectForKey:@"sex"]];
                    [smallArray addObject:[dic objectForKey:@"pic"]];
                    [smallArray addObject:[dic objectForKey:@"startposname"]];
                    [smallArray addObject:[dic objectForKey:@"endposname"]];
                    [smallArray addObject:[dic objectForKey:@"startoff_time"]];
                    [smallArray addObject:[dic objectForKey:@"backoff_time"]];
                    [smallArray addObject:[dic objectForKey:@"req_sex"]];
                    [smallArray addObject:[dic objectForKey:@"req_smoke"]];
                    [smallArray addObject:[dic objectForKey:@"req_fee"]];
                    [smallArray addObject:[dic objectForKey:@"membertype"]];
                    [smallArray addObject:[dic objectForKey:@"qianming"]];
                    [smallArray addObject:[dic objectForKey:@"req_peoples"]];
                   [bigArray addObject:smallArray]; 
                }
                self.array=bigArray;
                [bigArray release];
                // NSLog(@"%@",array);
            }
            [tableview reloadData];
        }
    }
}
-(void)viewWillAppear:(BOOL)animated{
     [self addHUD];
}
- (void)viewDidLoad
{   
    [super viewDidLoad];
    self.title = @"黑名单";
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
    
    array=[[NSMutableArray alloc] init];
    tableview=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableview.delegate=self;
    tableview.dataSource=self;
    [self.view addSubview:tableview];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"解除" style:UIBarButtonItemStyleBordered target:self action:@selector(delete)];
    self.navigationItem.rightBarButtonItem=deleteItem;
    [deleteItem release];
}

-(void)delete{
    [self.tableview setEditing:!self.tableview.editing animated:YES];
    if (self.tableview.editing)
        [self.navigationItem.rightBarButtonItem setTitle:@"完成"];
    else
        [self.navigationItem.rightBarButtonItem setTitle:@"解除"];
}

-(void)secondRequest:(NSString *)userid{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *sender = [userDefault objectForKey:@"login_user_id"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:sender forKey:@"userid"];
    [params setObject:userid forKey:@"black_userid"];
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    
    //NSLog(@"postURL:%@",postURL);
    NSString *baseurl=@"delblacklist.php";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL]];
	[self setRequest:[ASIHTTPRequest requestWithURL:url]];
	[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:TRUE];
    
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
        }
    }
    else{
        NSLog(@"request is nil.");
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{       return [array count];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{        
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        //cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        EGOImageView *thumbnail = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"small_loading_pic.png"]];
        thumbnail.frame = CGRectMake(36,5,75,75);
        thumbnail.tag= 1;
        [cell.contentView addSubview:thumbnail];
        [thumbnail release];
        UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 27, 31, 31)];
        cellImageView.tag=6;
        [cell.contentView addSubview:cellImageView];
        [cellImageView release];
        
        CGRect nameValueRect = CGRectMake(116, 0, 100, 30);
        UILabel *nameValue = [[UILabel alloc] initWithFrame: 
                              nameValueRect];
        nameValue.font=[UIFont systemFontOfSize:12];
        nameValue.tag = 2;
        [cell.contentView addSubview:nameValue];
        [nameValue release];      
 
        CGRect startRect = CGRectMake(116, 35, 160, 20);
        UILabel *startlable = [[UILabel alloc] initWithFrame: 
                             startRect];
        startlable.font=[UIFont systemFontOfSize:12];
        startlable.tag = 4;
        [cell.contentView addSubview:startlable];
        [startlable release];
        CGRect endRect = CGRectMake(116, 60, 160, 20);
        UILabel *endlable = [[UILabel alloc] initWithFrame: 
                             endRect];
        endlable.font=[UIFont systemFontOfSize:12];
        endlable.tag = 5;
        [cell.contentView addSubview:endlable];
        [endlable release];
    }
    NSUInteger row = [indexPath row];
    if ([array count]>0) {
        UIImageView * cellImageView=(UIImageView *)[cell.contentView viewWithTag:6];
        int indexs=[[[array objectAtIndex:row] objectAtIndex:11] intValue];
        switch (indexs) {
            case 0:
                cellImageView.image=[UIImage imageNamed:@"leifeng.png"];
                break;
            case 1:
                cellImageView.image=[UIImage imageNamed:@"dache.png"];
                break;
            case 2:
                cellImageView.image=[UIImage imageNamed:@"pinche.png"];
                break;
            default:
                break;
        }
        EGOImageView *ecoimg=(EGOImageView *)[cell.contentView viewWithTag:1];
        ecoimg.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host_url,[[array objectAtIndex:row] objectAtIndex:3]]];
        
        UILabel *name = (UILabel *)[cell.contentView viewWithTag:2];	
        name.text = [[array objectAtIndex:row] objectAtIndex:1];
        
        UILabel *startpos = (UILabel *)[cell.contentView viewWithTag:4];
        UILabel *endpos = (UILabel *)[cell.contentView viewWithTag:5];
        startpos.text =[NSString stringWithFormat:@"起始地:%@",[[array objectAtIndex:row] objectAtIndex:4]];
        endpos.text=[NSString stringWithFormat:@"目的地:%@",[[array objectAtIndex:row] objectAtIndex:5]];
    }  
        return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:	(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {  
    
    NSUInteger row = [indexPath row];
    NSString *bid=[[array objectAtIndex:row] objectAtIndex:4];
    [self secondRequest:bid];
	[self.array removeObjectAtIndex:row];
    [tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath{
    int row=[newIndexPath row];
    BlackDefine *define=[[BlackDefine alloc] init];
    define.array=[array objectAtIndex:row];
    [self.navigationController pushViewController:define animated:YES];
    [define release];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
    [super dealloc];
    [tableview release];
    [array release];
    [HUD release];
    [request cancel];
	[request release];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
