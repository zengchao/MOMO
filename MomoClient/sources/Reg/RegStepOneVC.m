//
//  RegStepOneVC.m
//  MOMO
//
//  Created by 超 曾 on 12-4-17.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "RegStepOneVC.h"


@implementation RegStepOneVC
@synthesize myTableView;
@synthesize tfMailAddr;
@synthesize tfPassword;
@synthesize tfConfirmPassword;
@synthesize request;
@synthesize vcNick;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"注册帐号";
        UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
        if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
        {
            [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
        }
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
    [request cancel];
	[request release];
    [vcNick release];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect tableViewFrame = self.view.bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    self.myTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.myTableView.scrollEnabled=YES;
    [self.view addSubview:self.myTableView];
    
    
    UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(doNext)];
    self.navigationItem.rightBarButtonItem = nextBarItem;
    
    UILabel *lblTips = [[[UILabel alloc] initWithFrame:CGRectMake(25,135,280,60)] autorelease];
    lblTips.opaque = YES;
    lblTips.backgroundColor = [UIColor clearColor];
    lblTips.textColor = [UIColor blackColor];
    lblTips.font = [UIFont systemFontOfSize:14];
    lblTips.numberOfLines = 2;
    [self.view addSubview:lblTips];
    lblTips.text=@"邮箱是登录搭车的帐号，是取回密码唯一凭证，请确保邮箱有效和填写正确。";
    
    lbsMember = [[LBS_Member alloc] init];
    UIButton *btnAbout=[UIButton buttonWithType:UIButtonTypeCustom];
    btnAbout.frame=CGRectMake(0, 200, 160, 37);
    [btnAbout setTitle:@"关于搭车同意协议:" forState:UIControlStateNormal];
    btnAbout.titleLabel.textColor=[UIColor redColor];
    btnAbout.titleLabel.font=[UIFont systemFontOfSize:14];
    [btnAbout addTarget:self action:@selector(about_handle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnAbout];
    
    btnCheck=[UIButton buttonWithType:UIButtonTypeCustom];
    btnCheck.frame=CGRectMake(163 , 203, 30 ,30);
    [btnCheck setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
    [btnCheck addTarget:self action:@selector(check_handle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCheck];
    checkFlag=YES;
}

-(void)back{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [myTableView release];
    [tfMailAddr release];
    [tfPassword release];
    [tfConfirmPassword release];
    [request cancel];
	[request release];
    [vcNick release];
    
}

-(void)doNext
{
    NSString *email = [NSString stringWithFormat:@"%@",tfMailAddr.text];
    
    if([email isEqualToString:@"(null)"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"邮箱不能为空" delegate:nil cancelButtonTitle:@"确 定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    if(![Utility isValidateEmail:email]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"邮箱地址不合法" delegate:nil cancelButtonTitle:@"确 定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    if(![Utility isValidateString:tfPassword.text]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您输入的密码必须是英文字母或数字的组合" delegate:nil cancelButtonTitle:@"确 定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    if(![Utility isValidateString:tfConfirmPassword.text]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您输入的密码必须是英文字母或数字的组合" delegate:nil cancelButtonTitle:@"确 定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    if([tfMailAddr.text length]<=0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您没有输入邮箱地址" delegate:self cancelButtonTitle:nil otherButtonTitles:@"是", nil];
        [alertView show];
        [alertView release];
        return;
    }else if([tfPassword.text length]<6){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"密码长度不能少于6位" delegate:self cancelButtonTitle:nil otherButtonTitles:@"是", nil];
        [alertView show];
        [alertView release];
        return;
    }else if(![tfPassword.text isEqualToString:tfConfirmPassword.text]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您两次输入的密码不一致" delegate:self cancelButtonTitle:nil otherButtonTitles:@"是", nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    //邮箱地址可以用于注册，请确认拼写正确
    //调用检查邮箱地址接口
    [tfConfirmPassword resignFirstResponder];
    
//    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:HUD];	
//    HUD.dimBackground = YES;
//    HUD.delegate = self;
//    HUD.labelText = @"";
//    [HUD showWhileExecuting:@selector(checkemail) onTarget:self withObject:nil animated:YES];
    [self checkemail];
}

-(void)checkemail
{
    NSString *email = [NSString stringWithFormat:@"%@",tfMailAddr.text];
    
    if([email isEqualToString:@"(null)"]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"邮箱不能为空" delegate:nil cancelButtonTitle:@"确 定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    if(![Utility isValidateEmail:email]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"邮箱地址不合法" delegate:nil cancelButtonTitle:@"确 定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:tfMailAddr.text forKey:@"email"];
    
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    NSString *baseurl=@"checkemail.php";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL]];
	[self setRequest:[ASIHTTPRequest requestWithURL:url]];
	[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
	[request startSynchronous];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
    
    if (request) {
        if ([request error]) {
            NSString *result = [[request error] localizedDescription];
//            NSLog(@"%@",result);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:self cancelButtonTitle:@"确 定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        } else if ([request responseString]) {
            NSString *result = [request responseString];
//            NSLog(@"%@",result);
            NSDictionary *mydict = [result JSONValue];
            if([[mydict objectForKey: @"checkemailTag"] isEqualToNumber:[NSNumber numberWithInt:0]]){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"%@可用于注册，请确认拼写正确。",email] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"注册", nil];
                [alertView show];
                [alertView release];
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您输入的邮箱地址已经存在" delegate:self cancelButtonTitle:nil otherButtonTitles:@"我要重新填写", nil];
                [alertView show];
                [alertView release];
            }
            [mydict release];
        }
    }else{
        NSLog(@"request is nil.");
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if([buttonTitle isEqualToString:@"注册"]){
        [self checkandreg];
//        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//        [self.navigationController.view addSubview:HUD];	
//        HUD.dimBackground = YES;
//        HUD.delegate = self;
//        HUD.labelText = @"";
//        [HUD showWhileExecuting:@selector(checkandreg) onTarget:self withObject:nil animated:YES];
    }
}

-(void)checkandreg
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:tfMailAddr.text forKey:@"email"];
    [params setObject:tfConfirmPassword.text forKey:@"pwd"];
    
    NSString *postURL=[Utility createPostURL:params];
    NSString *baseurl=@"checkandreg.php";
    //NSLog(@"%@",[NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL]);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL]];
	[self setRequest:[ASIHTTPRequest requestWithURL:url]];
	[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
	[request startSynchronous];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
    
    if (request) {
        if ([request error]) {
            NSString *result = [[request error] localizedDescription];
            //NSLog(@"%@",result);
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:self cancelButtonTitle:@"确 定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        } else if ([request responseString]) {
            NSString *result = [request responseString];
            NSDictionary *mydict = [result JSONValue];
            if([[mydict objectForKey: @"regTag"] isEqualToNumber:[NSNumber numberWithInt:1]]){
                lbsMember.email = tfMailAddr.text;
                lbsMember.password = tfPassword.text;
                vcNick = [[RegInputNickVC alloc] initWithNibName:@"RegInputNickVC" bundle:nil];
                vcNick.lbsMember = lbsMember;
                
                UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"后退" 
                                                                             style:UIBarButtonItemStyleBordered 
                                                                            target:nil action:nil];
                self.navigationItem.backBarButtonItem = backItem;
                [self.navigationController pushViewController:vcNick animated:YES];
            }else{
                
            }
        }
    }else{
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell2";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if(indexPath.row==0){
        UILabel *lblTitle = [[[UILabel alloc] initWithFrame:CGRectMake(8,5,100,30)] autorelease];
        lblTitle.opaque = YES;
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textColor = [UIColor blackColor];
        lblTitle.font = [UIFont systemFontOfSize:17];
        lblTitle.numberOfLines = 1;
        [cell.contentView addSubview:lblTitle];
        lblTitle.text=@"邮箱地址";
        [lblTitle release];
        
        tfMailAddr = [[UITextField alloc] initWithFrame:CGRectMake(95, 8, 200, 30)];
        tfMailAddr.borderStyle = UITextBorderStyleNone;
        tfMailAddr.textColor = [UIColor blackColor];
        tfMailAddr.font = [UIFont systemFontOfSize:17];
        tfMailAddr.placeholder = @"example@mail.com";
        tfMailAddr.backgroundColor = [UIColor clearColor];
        tfMailAddr.keyboardType = UIKeyboardTypeEmailAddress;
        tfMailAddr.returnKeyType = UIReturnKeyDefault;
        tfMailAddr.delegate=self;
        [cell.contentView addSubview:tfMailAddr];
        //tfMailAddr.text=@"wisheo@126.com";
        
    }else if(indexPath.row==1){
        UILabel *lblTitle = [[[UILabel alloc] initWithFrame:CGRectMake(8,5,100,30)] autorelease];
        lblTitle.opaque = YES;
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textColor = [UIColor blackColor];
        lblTitle.font = [UIFont systemFontOfSize:17];
        lblTitle.numberOfLines = 1;
        [cell.contentView addSubview:lblTitle];
        lblTitle.text=@"密码";
        [lblTitle release];
        
        tfPassword = [[UITextField alloc] initWithFrame:CGRectMake(95, 8, 200, 30)];
        tfPassword.borderStyle = UITextBorderStyleNone;
        tfPassword.textColor = [UIColor blackColor];
        tfPassword.font = [UIFont systemFontOfSize:17];
        tfPassword.placeholder = @"不少于6位";
        tfPassword.backgroundColor = [UIColor clearColor];
        tfPassword.keyboardType = UIKeyboardTypeDefault;
        tfPassword.returnKeyType = UIReturnKeyDefault;
        tfPassword.delegate=self;
        tfPassword.secureTextEntry=YES;
        [cell.contentView addSubview:tfPassword];
        //tfPassword.text=@"1111";
        
    }else if(indexPath.row==2){
        UILabel *lblTitle = [[[UILabel alloc] initWithFrame:CGRectMake(8,5,100,30)] autorelease];
        lblTitle.opaque = YES;
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textColor = [UIColor blackColor];
        lblTitle.font = [UIFont systemFontOfSize:17];
        lblTitle.numberOfLines = 1;
        [cell.contentView addSubview:lblTitle];
        lblTitle.text=@"重复密码";
        [lblTitle release];
        
        tfConfirmPassword = [[UITextField alloc] initWithFrame:CGRectMake(95, 8, 200, 30)];
        tfConfirmPassword.borderStyle = UITextBorderStyleNone;
        tfConfirmPassword.textColor = [UIColor blackColor];
        tfConfirmPassword.font = [UIFont systemFontOfSize:17];
        tfConfirmPassword.placeholder = @"再次输入密码";
        tfConfirmPassword.backgroundColor = [UIColor clearColor];
        tfConfirmPassword.keyboardType = UIKeyboardTypeDefault;
        tfConfirmPassword.returnKeyType = UIReturnKeyDefault;
        
        tfConfirmPassword.delegate=self;
        tfConfirmPassword.secureTextEntry=YES;
        [cell.contentView addSubview:tfConfirmPassword];
        //tfConfirmPassword.text=@"1111";
        
    }
    
    
    
    
    
    return cell;
}

- (void) unselectCurrentRow
{
    [self.myTableView deselectRowAtIndexPath:
    [self.myTableView indexPathForSelectedRow] animated:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
    [self performSelector:@selector(unselectCurrentRow) withObject:nil];
    tableView.allowsSelection=FALSE;
}

@end
