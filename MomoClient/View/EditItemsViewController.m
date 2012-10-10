//
//  EditItemsViewController.m
//  MOMO
//
//  Created by 超 曾 on 12-5-16.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "EditItemsViewController.h"
#import "NSObject+SBJson.h"
#import "Global.h"

@implementation EditItemsViewController
@synthesize tag,label,textField,textValue;
@synthesize mySegmentedControl;
@synthesize myDatePicker;
@synthesize mydict;
@synthesize textRect,textView;

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
    UIBarButtonItem *btn_right1 = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonSystemItemSave target:self action:@selector(onSaveUserInfo)];
    
    self.navigationItem.rightBarButtonItem = btn_right1;
    [btn_right1 release];
    
    // 捕捉键盘出现和消失时的事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self initTitle];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.textRect = self.textView.frame;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [label release];
    [textField release];
    [textValue release];
    [mySegmentedControl release];
    [myDatePicker release];
    [mydict release];
    [textView release];
    [self setTextView:nil];    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.textView.frame;
    
    newTextViewFrame.size.height = keyboardTop - self.textView.frame.origin.y;
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    textView.frame = newTextViewFrame;
    
    [UIView commitAnimations];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.textView.frame = self.textRect;
    
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)initTitle
{
    switch (tag) {
        case TAG_USERNAME:
            self.title=@"会员名称";
            label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 80, 31)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont fontWithName:@"Arial" size:14];
            label.textAlignment = UITextAlignmentCenter;
            label.text = @"名称：";
            
            textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, 220, 31)];
            textField.borderStyle=UITextBorderStyleRoundedRect;
            textField.backgroundColor = [UIColor clearColor];
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.returnKeyType = UIReturnKeyDefault;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.font = [UIFont fontWithName:@"Arial" size:14];
            textField.textAlignment = UITextAlignmentLeft;
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textField.tag = tag;
            textField.delegate=self;
            textField.text = [mydict objectForKey:@"username"];
            [textField setHidden:FALSE];
            
            [self.view addSubview:label];
            [self.view addSubview:textField];
            break;
            
        case TAG_ZHIYE:
            self.title=@"职业";
            textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
            [textView setPlaceholder:@"请输入您的爱好"];
            textView.text =[NSString stringWithFormat:@"%@",[mydict objectForKey:@"zhiye"]];
            [self.view addSubview:textView];
            if([textView.text isEqualToString:@"<null>"]){
                textView.text=@"";
            }
            break;
            
        case TAG_QIANMING:
            self.title=@"个人签名";
            textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
            [textView setPlaceholder:@"请输入个人签名"];
            textView.text =[NSString stringWithFormat:@"%@",[mydict objectForKey:@"qianming"]];
            [self.view addSubview:textView];
            if([textView.text isEqualToString:@"<null>"]){
                textView.text=@"";
            }
            break;
            
        case TAG_AGE:
            self.title=@"年龄";
            label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 80, 31)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont fontWithName:@"Arial" size:14];
            label.textAlignment = UITextAlignmentCenter;
            label.text = @"年龄：";
            
            textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, 220, 31)];
            textField.borderStyle=UITextBorderStyleRoundedRect;
            textField.backgroundColor = [UIColor clearColor];
            textField.returnKeyType = UIReturnKeyDefault;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.font = [UIFont fontWithName:@"Arial" size:14];
            textField.textAlignment = UITextAlignmentLeft;
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textField.tag = tag;
            textField.text = [mydict objectForKey:@"b_date"];
            [textField setEnabled:FALSE];
            
            
            [self.view addSubview:label];
            [self.view addSubview:textField];
            
            
            myDatePicker = [[UIDatePicker alloc] init]; 
            myDatePicker.center = self.view.center; 
            myDatePicker.datePickerMode = UIDatePickerModeDate;
            [self.view addSubview:self.myDatePicker];
            [myDatePicker release];
            
            if([textField.text isEqualToString:@""]){
                
            }else{
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *date = [dateFormatter dateFromString:textField.text];
                [myDatePicker setDate:date];
                [dateFormatter release];
            }
            
            [self.myDatePicker addTarget:self
                                  action:@selector(datePickerDateChanged:) forControlEvents:UIControlEventValueChanged];
            
            break;
        case TAG_AIHAO:
            //爱好
            self.title=@"爱好";
            textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
            [textView setPlaceholder:@"请输入您的爱好"];
            textView.text =[NSString stringWithFormat:@"%@",[mydict objectForKey:@"aihao"]];
            [self.view addSubview:textView];
            if([textView.text isEqualToString:@"<null>"]){
                textView.text=@"";
            }
            break;
        case TAG_GONGSI:
            //公司
            self.title=@"公司";
            textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
            [textView setPlaceholder:@"请输入您的公司"];
            textView.text =[NSString stringWithFormat:@"%@",[mydict objectForKey:@"gongsi"]];
            [self.view addSubview:textView];
            if([textView.text isEqualToString:@"<null>"]){
                textView.text=@"";
            }
            break;
        case TAG_XUEXIAO:
            //学校
            self.title=@"学校";
            textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
            [textView setPlaceholder:@"请输入您的学校"];
            textView.text =[NSString stringWithFormat:@"%@",[mydict objectForKey:@"xuexiao"]];
            [self.view addSubview:textView];
            if([textView.text isEqualToString:@"<null>"]){
                textView.text=@"";
            }
            break;
        case TAG_DIFANG:
            //地方
            self.title=@"地方";
            textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
            [textView setPlaceholder:@"请输入您常出入的地方"];
            textView.text =[NSString stringWithFormat:@"%@",[mydict objectForKey:@"difang"]];
            [self.view addSubview:textView];
            if([textView.text isEqualToString:@"<null>"]){
                textView.text=@"";
            }
            break;
        case TAG_ZHUYE:
            //主页
            self.title=@"个人主页";
            textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
            [textView setPlaceholder:@"请输入您的个人主页"];
            textView.text =[NSString stringWithFormat:@"%@",[mydict objectForKey:@"zhuye"]];
            [self.view addSubview:textView];
            if([textView.text isEqualToString:@"<null>"]){
                textView.text=@"";
            }
            break;
        case TAG_SINA:
            //sina
            break;
        case TAG_RENREN:
            //人人
            break;
        case TAG_DOUBAN:
            //豆瓣
            break;
        case TAG_MAIL:
            //邮箱
            break;
        case TAG_ZUOJIA:
            //座驾
            self.title=@"座驾";
            label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 80, 31)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont fontWithName:@"Arial" size:14];
            label.textAlignment = UITextAlignmentCenter;
            label.text = @"座驾：";
            
            textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, 220, 31)];
            textField.borderStyle=UITextBorderStyleRoundedRect;
            textField.backgroundColor = [UIColor clearColor];
            textField.returnKeyType = UIReturnKeyDefault;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.font = [UIFont fontWithName:@"Arial" size:14];
            textField.textAlignment = UITextAlignmentLeft;
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textField.tag = tag;
            textField.text = [mydict objectForKey:@"zuojia"];
            
            [self.view addSubview:label];
            [self.view addSubview:textField];
            
            break;
        case TAG_JIALING:
            //驾龄
            self.title=@"驾龄";
            label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 80, 31)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont fontWithName:@"Arial" size:14];
            label.textAlignment = UITextAlignmentCenter;
            label.text = @"驾龄：";
            
            textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, 220, 31)];
            textField.borderStyle=UITextBorderStyleRoundedRect;
            textField.backgroundColor = [UIColor clearColor];
            textField.returnKeyType = UIReturnKeyDefault;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.font = [UIFont fontWithName:@"Arial" size:14];
            textField.textAlignment = UITextAlignmentLeft;
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textField.tag = tag;
            textField.text = [mydict objectForKey:@"jialing"];
            
            [self.view addSubview:label];
            [self.view addSubview:textField];
            
            break;
        case TAG_LUXIAN:
            //常走的路线
            
            
            break;
        case TAG_WEIHAO:
            //车牌尾号
            self.title=@"车牌尾号";
            label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 80, 31)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont fontWithName:@"Arial" size:14];
            label.textAlignment = UITextAlignmentCenter;
            label.text = @"车牌尾号：";
            
            textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, 220, 31)];
            textField.borderStyle=UITextBorderStyleRoundedRect;
            textField.backgroundColor = [UIColor clearColor];
            textField.returnKeyType = UIReturnKeyDefault;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.font = [UIFont fontWithName:@"Arial" size:14];
            textField.textAlignment = UITextAlignmentLeft;
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textField.tag = tag;
            textField.text = [mydict objectForKey:@"weihao"];
            
            [self.view addSubview:label];
            [self.view addSubview:textField];
            
            break;
            
            
    }
}

- (void) datePickerDateChanged:(UIDatePicker *)paramDatePicker{
    if ([paramDatePicker isEqual:self.myDatePicker]){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];;
        NSDate *selected = [paramDatePicker date];
        NSString *date = [dateFormatter stringFromDate:selected];
        [dateFormatter release];
        textField.text = date;
        
    }
}

-(void)onSaveUserInfo
{
    NSString *host = [NSString stringWithFormat:@"%@%@", host_url, @"updateMemberInfo.php"];

    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *email = [userDefault objectForKey:@"login_user"];
    NSMutableURLRequest *req = [[NSMutableURLRequest new] autorelease]; 
    NSString *tmp=@"";
    switch (tag) {
        case TAG_USERNAME:
            tmp=[NSString stringWithFormat:@"%@?email=%@&username=%@",host,email,textField.text];
            break;
        case TAG_ZHIYE:
            tmp=[NSString stringWithFormat:@"%@?email=%@&zhiye=%@",host,email,textView.text];
            break;
        case TAG_QIANMING:
            tmp=[NSString stringWithFormat:@"%@?email=%@&qianming=%@",host,email,textView.text];
            break;
        case TAG_AGE:
            tmp=[NSString stringWithFormat:@"%@?email=%@&b_date=%@",host,email,textField.text];
            break;
        case TAG_AIHAO:
            tmp=[NSString stringWithFormat:@"%@?email=%@&aihao=%@",host,email,textView.text];
            break;
        case TAG_GONGSI:
            tmp=[NSString stringWithFormat:@"%@?email=%@&gongsi=%@",host,email,textView.text];
            break;
        case TAG_XUEXIAO:
            tmp=[NSString stringWithFormat:@"%@?email=%@&xuexiao=%@",host,email,textView.text];
            break;
        case TAG_DIFANG:
            tmp=[NSString stringWithFormat:@"%@?email=%@&difang=%@",host,email,textView.text];
            break;
        case TAG_ZHUYE:
            tmp=[NSString stringWithFormat:@"%@?email=%@&zhuye=%@",host,email,textView.text];
            break;
        case TAG_ZUOJIA:
            tmp=[NSString stringWithFormat:@"%@?email=%@&zj=%@",host,email,textField.text];
            break;
        case TAG_JIALING:
            tmp=[NSString stringWithFormat:@"%@?email=%@&jl=%@",host,email,textField.text];
            break;
        case TAG_WEIHAO:
            tmp=[NSString stringWithFormat:@"%@?email=%@&wh=%@",host,email,textField.text];
            break;
            
    }
    if(tag==TAG_WEIHAO){
        if(![Utility isValidateString:tmp]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您输入的车牌尾号必须是英文字母或数字的组合" delegate:nil cancelButtonTitle:@"确 定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            return;
        }
    }
    //NSLog(@"%@",tmp);
    tmp = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)tmp,NULL,NULL,kCFStringEncodingUTF8);    
    [req setURL:[NSURL URLWithString:tmp]];
    [tmp release];
    [req setHTTPMethod:@"GET"];     
    [req addValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [req setTimeoutInterval:10.0f];
    
    NSHTTPURLResponse* urlResponse = nil;  
    NSError *error = [[NSError alloc] init]; 
    NSData *responseData = [NSURLConnection sendSynchronousRequest:req returningResponse:&urlResponse error:&error];  
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",result); 
    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
        NSDictionary *dict = [result JSONValue]; 
        
        if([[dict objectForKey: @"regTag"] isEqualToNumber:[NSNumber numberWithInt:1]]){            
            [self.navigationController popViewControllerAnimated:TRUE];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"保存数据失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
    [result release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)txt
{
	[txt resignFirstResponder];
	return YES;
}

@end
