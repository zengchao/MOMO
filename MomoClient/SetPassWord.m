//
//  SetPassWord.m
//  MOMO
//
//  Created by apple on 12-6-8.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "SetPassWord.h"
#import "Global.h"
#import "Utility.h"
@implementation SetPassWord
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
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
    [super dealloc];
    [tableview release];
    [HUD release];
    [request cancel];
	[request release];
    newpwd=nil;
    oldpwd=nil;
    rnewpwd=nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"修改密码";
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
    
    tableview=[[UITableView alloc] initWithFrame:CGRectMake(5, 5, 310, 280) style:UITableViewStyleGrouped];
	tableview.delegate=self;
	tableview.dataSource=self;
	[tableview setRowHeight:50];
    tableview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableview.backgroundColor=[UIColor clearColor];
    tableview.scrollEnabled=NO;
    [self.view addSubview:tableview];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(sumbit)];
    self.navigationItem.rightBarButtonItem=saveItem;
    [saveItem release];
}
-(void)sumbit{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *password=[userDefault objectForKey:@"login_pwd"];
    NSString *c1=oldpwd.text;
    NSString *c2=newpwd.text;
    NSString *c3=rnewpwd.text;
    if([c1 isEqualToString:@""]||[c2 isEqualToString:@""]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"系统提示" message:@"密码不能为空！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    if (![c2 isEqualToString:c3]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"系统提示" message:@"新密码前后不一致" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    if (![c1 isEqualToString:password]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"系统提示" message:@"原密码错误！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
        [alert release];
        oldpwd.text=@"";
        newpwd.text=@"";
        rnewpwd.text=@"";
        return;
    }
    if(c2.length<6||c3.length<6){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"系统提示" message:@"新密码不能小于6位!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
//    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:HUD];	
//    HUD.dimBackground = YES;
//    HUD.delegate = self;
//    HUD.labelText = @"正在提交中，请稍候...";
//    [HUD showWhileExecuting:@selector(getUrlCon) onTarget:self withObject:nil animated:YES]; 
    [self getUrlCon];
    
}
-(void)getUrlCon{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *sender = [userDefault objectForKey:@"login_user_id"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:sender forKey:@"userid"];
    [params setObject:newpwd.text forKey:@"newpwd"];
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    NSString *baseurl=@"setpwd.php";
   // NSLog(@"%@",postURL);
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
            
        } else if ([request responseString]){
            NSString *result = [request responseString];
            NSLog(@"%@",result);
            if (result) {
                [userDefault setObject:newpwd.text forKey:@"login_pwd"];
                [userDefault setObject:@"1" forKey:@"firstlogin"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alertView.tag=10;
                [alertView show];
                [alertView release];
               
            }
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==10) {
         [self.navigationController popViewControllerAnimated:YES];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.contentView.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
		UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(5, 10, 100, 30)];
		label.tag=1;
		label.backgroundColor=[UIColor clearColor];
		[cell.contentView addSubview:label];
		[label release];
		UITextField *tf=[[UITextField alloc] initWithFrame:CGRectMake(120, 15, 150, 30)];
		tf.tag=2;
		tf.borderStyle=UITextBorderStyleNone;
        tf.secureTextEntry=YES;
		[cell.contentView addSubview:tf];
        [tf release];
    }
	UILabel *label=(UILabel *)[cell.contentView viewWithTag:1];
	UITextField *tf=(UITextField *)[cell.contentView viewWithTag:2];
	int row=[indexPath row];
	if (row==0) {
		label.text=@"旧密码";
        tf.placeholder=@"请输入原密码";
        oldpwd=tf;
        [oldpwd becomeFirstResponder];
    }
    if (row==1) {
		label.text=@"新密码";
		tf.placeholder=@"至少6位";
        newpwd=tf;
    }
	if (row==2){
		label.text=@"重复密码";
		tf.placeholder=@"请再重复一次";
        rnewpwd=tf;
	}
    
    // Configure the cell...
    
    return cell;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
