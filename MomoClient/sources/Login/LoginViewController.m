//
//  LoginViewController.m
//  
//
//  Created by 超 曾 on 12-3-27.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "LoginViewController.h"
#import "Global.h"


@implementation LoginViewController
@synthesize txtPhoneNumber,txtLoginPwd,tipLabel1,tipLabel2,btnCheck,btnLogin,btnRegister,btnForgetPwd,locationManager;
@synthesize delegate,request;
@synthesize vcReg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
    
    [request cancel];
	[request release];
    [vcReg release];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"登陆";
    
    CGRect frame = CGRectMake(20,31,280,31);
    txtPhoneNumber = [[UITextField alloc] initWithFrame:frame];
    txtPhoneNumber.borderStyle = UITextBorderStyleRoundedRect;
    txtPhoneNumber.textColor = [UIColor blackColor];
    txtPhoneNumber.font = [UIFont systemFontOfSize:17.0];
    txtPhoneNumber.placeholder = @"";
    txtPhoneNumber.backgroundColor = [UIColor clearColor];
    txtPhoneNumber.autocorrectionType = UITextAutocorrectionTypeNo;	    
    txtPhoneNumber.keyboardType = UIKeyboardTypeEmailAddress;
    txtPhoneNumber.returnKeyType = UIReturnKeyDefault;
    txtPhoneNumber.clearButtonMode = UITextFieldViewModeWhileEditing;    
    txtPhoneNumber.delegate = self;
    [self.view addSubview:txtPhoneNumber];
    txtPhoneNumber.text=@"wisheo@126.com";
    
    frame = CGRectMake(20,99,280,31);
    txtLoginPwd = [[UITextField alloc] initWithFrame:frame];
    txtLoginPwd.borderStyle = UITextBorderStyleRoundedRect;
    txtLoginPwd.textColor = [UIColor blackColor];
    txtLoginPwd.font = [UIFont systemFontOfSize:17.0];
    txtLoginPwd.placeholder = @"";
    txtLoginPwd.backgroundColor = [UIColor clearColor];
    txtLoginPwd.autocorrectionType = UITextAutocorrectionTypeNo;	    
    txtLoginPwd.keyboardType = UIKeyboardTypeDefault;
    txtLoginPwd.returnKeyType = UIReturnKeyDefault;
    txtLoginPwd.clearButtonMode = UITextFieldViewModeWhileEditing;    
    txtLoginPwd.delegate = self;
    txtLoginPwd.secureTextEntry=YES;
    [self.view addSubview:txtLoginPwd];
    txtLoginPwd.text=@"1111";
    
    
    
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 37)];
    [btnBack setBackgroundColor:[UIColor clearColor]];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"index.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *barButtonIteLeft = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = barButtonIteLeft;
    [barButtonIteLeft release];
    [btnBack release];
    
    UIButton *btnDone = [[UIButton alloc] initWithFrame:CGRectMake(260, 0, 55, 37)];
    [btnDone setBackgroundColor:[UIColor clearColor]];
    [btnDone setBackgroundImage:[UIImage imageNamed:@"wancheng.png"] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(finished) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *barButtonIteRight = [[UIBarButtonItem alloc] initWithCustomView:btnDone];
    self.navigationItem.rightBarButtonItem = barButtonIteRight;
    [barButtonIteRight release];
    [btnDone release];
    
    checkFlag = FALSE;
    goFlag = TRUE;

    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *rememberUser = [userDefault objectForKey:@"rememberUser"];
    if([rememberUser isEqualToString:@"1"]){
        self.txtPhoneNumber.text = [userDefault objectForKey:@"login_user"];
        self.txtLoginPwd.text = [userDefault objectForKey:@"login_pwd"];
        [btnCheck setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        checkFlag=TRUE;
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (void)finished {
    [[self locationManager] startUpdatingLocation];
    CLLocation *location = [locationManager location];
	CLLocationCoordinate2D coordinate = [location coordinate];
    [self dologin:coordinate.latitude ypos:coordinate.longitude];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [txtPhoneNumber release];
    [txtLoginPwd release];
    [tipLabel1 release];
    [tipLabel2 release];
    [btnCheck release];
    [btnLogin release];
    [btnRegister release];
    [btnForgetPwd release];
    [request cancel];
	[request release];
    [vcReg release];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSTimeInterval animationDuration = 0.30f;       
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];       
    [UIView setAnimationDuration:animationDuration];       
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);       
    self.view.frame = rect;
    [UIView commitAnimations];
    
    [txtLoginPwd resignFirstResponder];
    [txtPhoneNumber resignFirstResponder];
}

-(IBAction)check_handle:(id)sender
{
    if(!checkFlag){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"勾选记住登录信息，本地登录将被保存在本地，是否继续？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alertView show];
        [alertView release];
        
        [btnCheck setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        checkFlag=TRUE;
    }else {
        [btnCheck setBackgroundImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        checkFlag=FALSE;
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        [userDefault setObject:nil forKey:@"rememberUser"];
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10 && buttonIndex==1) {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];	
        HUD.dimBackground = YES;
        HUD.delegate = self;
        HUD.labelText = @"正在验证中，请稍候...";
        [HUD showWhileExecuting:@selector(checkemail) onTarget:self withObject:nil animated:YES]; 
        //[self checkemail];
        return;
    }
    
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"是"])
    { 
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        [userDefault setObject:@"1" forKey:@"rememberUser"];
        [userDefault setObject:self.txtPhoneNumber.text forKey:@"login_user"];
        [userDefault setObject:self.txtLoginPwd.text forKey:@"login_pwd"];
    }
    
    if([buttonTitle isEqualToString:@"确定"]){
        
    }
    
    
}


-(IBAction)doNext_handle:(id)sender
{
//    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:HUD];	
//    HUD.dimBackground = YES;
//    HUD.delegate = self;
//    HUD.labelText = @"正在验证中，请稍候...";
//    [HUD showWhileExecuting:@selector(getUrlCon) onTarget:self withObject:nil animated:YES];    
    [self getUrlCon];
}

- (void)dologin:(double)xpos ypos:(double)ypos
{
    NSString *email = [NSString stringWithFormat:@"%@",txtPhoneNumber.text];
    NSString *password = [NSString stringWithFormat:@"%@",txtLoginPwd.text];
    
    if([email isEqualToString:@"(null)"] || [email length]<=0 ){
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
    if(![Utility isValidateString:password]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您输入的密码必须是英文字母或数字的组合" delegate:nil cancelButtonTitle:@"确 定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    
//    if([password length]<6){
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"密码长度不能少于6位" delegate:self cancelButtonTitle:nil otherButtonTitles:@"是", nil];
//        [alertView show];
//        [alertView release];
//        return;
//    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:email forKey:@"name"];
    [params setObject:password forKey:@"pwd"];
    [params setObject:[NSString stringWithFormat:@"%f",xpos] forKey:@"x"];
    [params setObject:[NSString stringWithFormat:@"%f",ypos] forKey:@"y"];
    
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    
    NSString *baseurl=@"Login.php";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL]];
	[self setRequest:[ASIHTTPRequest requestWithURL:url]];
	[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
	[request startSynchronous];
    //显示网络请求信息在status bar上
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
    
    if (request) {
        if ([request error]) {
            NSString *result = [[request error] localizedDescription];
            NSLog(@"%@",result);
            //NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"login_user"];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"login_pwd"];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            
        } else if ([request responseString]) {
            NSString *result = [request responseString];
            NSLog(@"%@",result);
            NSDictionary *mydict = [result JSONValue];
            
            if([[mydict objectForKey: @"loginTag"] isEqualToNumber:[NSNumber numberWithInt:20010]]){
                //NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"firstlogin"];
                [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"login_user"];
                [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"login_pwd"];
                [[NSUserDefaults standardUserDefaults] setObject:[mydict objectForKey: @"login_user_id"] forKey:@"login_user_id"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"sina_bind_userid"];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"rememberUser"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",xpos] forKey:@"xpos"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",ypos] forKey:@"ypos"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSLog(@"%@,%@,blue",[[NSUserDefaults standardUserDefaults] objectForKey:@"xpos"],[[NSUserDefaults standardUserDefaults] objectForKey:@"ypos"]);
                
                //PincheAppDelegate *appDelegate = [PincheAppDelegate getAppDelegate];
                //[appDelegate.window addSubview:appDelegate.tabBarController.view];
                //appDelegate.tabBarController.selectedIndex=0;
                
                PincheAppDelegate *appDelegate = [PincheAppDelegate getAppDelegate];
                [appDelegate.window addSubview:appDelegate.mainTabViewController.view];
                appDelegate.mainTabViewController.selectedIndex=0;
                
                
            }else if([[mydict objectForKey: @"loginTag"] isEqualToNumber:[NSNumber numberWithInt:20011]]){
                NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
                [userDefault setObject:nil forKey:@"login_user"];
                [userDefault setObject:nil forKey:@"login_pwd"];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"邮箱或密码不正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                [alertView release];
            }
        }
    }else{
        NSLog(@"request is nil.");
    }
}



-(void)getUrlCon
{
    [[self locationManager] startUpdatingLocation];
    CLLocation *location = [locationManager location];
	CLLocationCoordinate2D coordinate = [location coordinate];
    [self dologin:coordinate.latitude ypos:coordinate.longitude];
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    if (alertView.tag==10) {
        alertView.frame = CGRectMake(alertView.frame.origin.x, alertView.frame.origin.y-75,alertView.frame.size.width , alertView.frame.size.height+60);
        
        UILabel *label_userId = [[UILabel alloc] initWithFrame:CGRectMake(20, 125, 60, 20)];
        label_userId.text = @"邮箱:";
        label_userId.backgroundColor = [UIColor clearColor];
        label_userId.textColor = [UIColor whiteColor];
        [alertView addSubview:label_userId];
        [label_userId release];
        
        
        for (UIView *Outlet in [alertView subviews]) {
            //NSLog(@"000%d",Outlet.tag);
            if(![Outlet isKindOfClass:[UITextField class]]&&![Outlet isKindOfClass:[UILabel class]]&&![Outlet isKindOfClass:[UILabel class]])
            {	
                if (Outlet.tag==1||Outlet.tag==2) {
                    UIButton* button = (UIButton*)Outlet;
                    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y+45,button.frame.size.width , button.frame.size.height);
                }
            }
        }
        
		//textField:email
        textField = [[UITextField alloc] initWithFrame:CGRectMake(60, 120, 210, 30)];
        [textField setBorderStyle:UITextBorderStyleRoundedRect];
        textField.clearButtonMode=UITextFieldViewModeWhileEditing;
        [alertView addSubview:textField];
    }
    
}


-(IBAction)doForgetPwd_handle:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入您注册时填写的邮箱，点击确定密码重设邮件则会发送到您的邮箱中，请注意查收" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag=10;
    [alertView show];
    [alertView release];
}

-(IBAction)doRegister_handle:(id)sender
{
    vcReg = [[RegStepOneVC alloc] initWithNibName:@"RegStepOneVC" bundle:nil];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];
    [self.navigationController pushViewController:vcReg animated:YES];
    [vcReg release];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;        
}

#pragma mark -
#pragma mark Location manager

/**
 Return a location manager -- create one if necessary.
 */
- (CLLocationManager *)locationManager {
	
    if (locationManager != nil) {
		return locationManager;
	}
	
	locationManager = [[CLLocationManager alloc] init];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
	[locationManager setDelegate:self];
	
	return locationManager;
}


/**
 Conditionally enable the Add button:
 If the location manager is generating updates, then enable the button;
 If the location manager is failing, then disable the button.
 */
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
}

@end
