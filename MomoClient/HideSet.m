//
//  HideSet.m
//  MOMO
//
//  Created by apple on 12-6-10.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "HideSet.h"
#import "Global.h"
@implementation HideSet
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/
- (void)dealloc {
    [super dealloc];
    [tableview release];
    [HUD release];
    [request cancel];
	[request release];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"隐身模式";
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
    
    tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
    tableview.delegate=self;
    tableview.dataSource=self;
    [self.view addSubview:tableview];
    PincheAppDelegate *appDelegate = [PincheAppDelegate getAppDelegate];
    FMResultSet *rs=[appDelegate.db executeQuery:@"SELECT *FROM PersonSet WHERE id = ?",@"1"]; 
    NSString *hide=nil;
    while ([rs next]){  
        hide=[rs stringForColumn:@"hide"];
    }
    s=[hide intValue];
    [rs close];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)selectedrow:(NSInteger)state{
//    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:HUD];
//    HUD.dimBackground = YES;
//    HUD.delegate = self;
//    HUD.labelText = @"正在提交中，请稍候...";
//    [HUD showWhileExecuting:@selector(urlrequest:) onTarget:self withObject:[NSNumber numberWithInt:state] animated:YES]; 
    [self urlrequest:[NSNumber numberWithInt:state]];
}

-(void)urlrequest:(NSNumber *)state{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *userid = [userDefault objectForKey:@"login_user_id"];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSString *status = [numberFormatter stringFromNumber:state];
    [numberFormatter release];
    //NSLog(@"status:%@",status);
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userid forKey:@"userid"];
    [params setObject:status forKey:@"state"];
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    //NSLog(@"postURL:%@",postURL);
    NSString *baseurl=@"setstate.php";
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
            NSLog(@"result:%@",result);
            NSDictionary *mydict = [result JSONValue];
            if([[mydict objectForKey: @"regTag"] isEqualToNumber:[NSNumber numberWithInt:1]]){

            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"操作失败，请重新设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                [alertView release];
        }
            //[mydict release];
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
{  
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{        
    
    static NSString *CellIdentifier = @"Cell2";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.font=[UIFont systemFontOfSize:15];
    }
    int row=[indexPath row];
    if (row==s) {
          cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    if (row==0) {
        cell.textLabel.text=@"对所有人可见";
    }else if (row==1) {
        cell.textLabel.text=@"对陌生人隐身";
    }else if (row==2) {
        cell.textLabel.text=@"对所有人隐身";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int row=[indexPath row];
    switch (row) {
        case 0:
            if (s!=0) {
                [self change:row];
                [self selectedrow:0];
                s=0;
            }
            
            break;
        case 1:
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"“对陌生人隐身“模式将使您不能出现在其他人的附近列表上，您确定这样做么？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.tag=1;
            [alert show];
            [alert release];
        }
            break;
        case 2:
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"“对所有人隐身“模式下所有人都不更新与你的距离，您确定这样做么？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.tag=2;
            [alert show];
            [alert release];
        }
            break;
        default:
            break;
    }
}
-(void)change:(int)row{
    if (s!=row) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
        UITableViewCell *cell=[tableview cellForRowAtIndexPath:indexPath];
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        NSIndexPath *oldindexPath=[NSIndexPath indexPathForRow:s inSection:0];
        UITableViewCell *oldcell=[tableview cellForRowAtIndexPath:oldindexPath];
        oldcell.accessoryType=UITableViewCellAccessoryNone;
        PincheAppDelegate *appDelegate = [PincheAppDelegate getAppDelegate];
        [appDelegate.db executeUpdate:@"UPDATE PersonSet SET hide = ? WHERE id = ? ",[NSString stringWithFormat:@"%d",row],@"1"];
    }
    s=row;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag==1) {
        if (buttonIndex==0) {
            [self change:alertView.tag];
            [self selectedrow:alertView.tag];
        }
	} 
    if (alertView.tag==2) {
        if (buttonIndex==0) {
            [self change:alertView.tag];
            [self selectedrow:alertView.tag];
        }
	} 
}
@end
