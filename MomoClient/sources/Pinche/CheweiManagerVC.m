//
//  CheweiManagerVC.m
//  MOMO
//
//  Created by 超 曾 on 12-6-9.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "CheweiManagerVC.h"
#import "ASIHTTPRequest.h"

@implementation CheweiManagerVC
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
    self.navigationItem.title=@"管理车位";
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
    [myTableView setEditing:FALSE];
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]
                                initWithTitle:@"返回"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(dismissWin)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn release];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]
                                initWithTitle:@"管理"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(manageChewei)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [rightBtn release];
    
    [self loadList];
    
}

- (void)manageChewei
{
    if([myTableView isEditing]){
        [myTableView setEditing:FALSE];
    }else{
        //增加、修改、删除车位
        UIActionSheet *menu = [[UIActionSheet alloc]
                               initWithTitle: @"管理车位"
                               delegate:self
                               cancelButtonTitle:@"取消"
                               destructiveButtonTitle:@"增加车位"
                               otherButtonTitles:@"删除车位", nil];
        [menu showInView:[UIApplication sharedApplication].keyWindow];
        [menu release];
    }
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        [self do_delChewei:[[list objectAtIndex:indexPath.row] objectForKey:@"id"]];
        [list removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [myTableView reloadData];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //增加车位
            [self addChewei];
            break;
        case 1:
            //删除车位
            [myTableView setEditing:TRUE];
            break;
            
    }
}

- (void)addChewei
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"增加车位"
                              message:@"请输入车位名称:"
                              delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *textField = [alertView textFieldAtIndex:0]; 
    textField.keyboardType = UIKeyboardTypeDefault;
    [alertView show];    
    [alertView release];
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"确定"]){ 
        UITextField *textField = [alertView textFieldAtIndex:0]; 
        //NSLog(@"%@",textField.text);
        if([textField.text length]>0){
            [self do_addChewei:textField.text];
            [self loadList];
            [myTableView reloadData];
        }
    }
}

- (void)do_delChewei:(NSString *)cw_id
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"login_user_id"] forKey:@"uid"];
    [params setObject:cw_id forKey:@"id"];
    
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    
    NSString *baseurl=@"delChewei.php";
    
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
                
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                [alertView release];
            }
            //[mydict release];
        }
    }else{
        NSLog(@"request is nil.");
    }
}

- (void)do_addChewei:(NSString *)cw_name
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"login_user_id"] forKey:@"uid"];
    [params setObject:cw_name forKey:@"name"];
    
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    
    NSString *baseurl=@"addChewei.php";
    NSString *tmp = [NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL];
    tmp = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)tmp,NULL,NULL,kCFStringEncodingUTF8);
    NSURL *url = [NSURL URLWithString:tmp];
    [tmp release];
    
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
                
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                [alertView release];
            }
            //[mydict release];
        }
    }else{
        NSLog(@"request is nil.");
    }
    
}

-(void)loadList
{
    [list removeAllObjects];
    list = [[NSMutableArray alloc] init];
    
    self.member_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"login_user_id"];
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
    vc.member_id=self.member_id;
    vc.chewei_id=[[list objectAtIndex:newIndexPath.row] objectForKey:@"id"];
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
    cell.textLabel.text= [[list objectAtIndex:indexPath.row] objectForKey:@"name"];

    return cell;
    
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
    [request cancel];
	[request release];
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

@end
