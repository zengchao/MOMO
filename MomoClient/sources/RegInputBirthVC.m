//
//  RegInputBirthVC.m
//  MOMO
//
//  Created by 超 曾 on 12-4-19.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "RegInputBirthVC.h"
#import "ClientConnection.h"

@implementation RegInputBirthVC
@synthesize myTableView;
@synthesize myDatePicker;
@synthesize lblAge;
@synthesize lblXingzuo;
@synthesize lbsMember;
@synthesize request;

-(void)dealloc
{
    [request cancel];
	[request release];
    [super dealloc];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"出生日期";
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
    CGRect tableViewFrame = self.view.bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    self.myTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.myTableView.scrollEnabled=YES;
    [self.view addSubview:self.myTableView];
    self.myTableView.allowsSelection=FALSE;
    
    UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(do_saveinfo)];
    self.navigationItem.rightBarButtonItem = nextBarItem;
    
    UILabel *lblTitle = [[[UILabel alloc] initWithFrame:CGRectMake(15,100,295,80)] autorelease];
    lblTitle.opaque = YES;
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.font = [UIFont systemFontOfSize:15];
    lblTitle.numberOfLines = 4;
    [self.view addSubview:lblTitle];
    lblTitle.text=@"输入你的出生日期，系统会自动算出年龄和星座。你的出生日期将不会出现在个人资料里。此应用需要你年满12岁。";
    
    self.myDatePicker = [[UIDatePicker alloc] init]; 
    self.myDatePicker.frame = CGRectMake(0,200,320,260);
    [self.view addSubview:self.myDatePicker];
    [myDatePicker setDatePickerMode:UIDatePickerModeDate];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [myDatePicker setLocale:locale];
    [locale release];
    [self.myDatePicker addTarget:self action:@selector(datePickerDateChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void) datePickerDateChanged:(UIDatePicker *)paramDatePicker
{
    if ([paramDatePicker isEqual:self.myDatePicker])
    {
        NSDate *selected = [myDatePicker date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *theDate = [dateFormat stringFromDate:selected];
        lbsMember.b_date = [NSString stringWithFormat:@"%@",theDate];
        
        NSTimeInterval dateDiff = [selected timeIntervalSinceNow];
        int age=-1 * trunc(dateDiff/(60*60*24))/365;
        lblAge.text=[NSString stringWithFormat:@"%d",age];
        ClientConnection *client = [[[ClientConnection alloc] init] autorelease];
        lblXingzuo.text = [client getXingzuo:selected];
    }
}

-(NSString *)getXingzuo:(NSDate *)in_date
{
    //计算星座
    
    NSString *retStr=@"";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM"];
    int i_month=0;
    NSString *theMonth = [dateFormat stringFromDate:in_date];
    if([[theMonth substringToIndex:0] isEqualToString:@"0"]){
        i_month = [[theMonth substringFromIndex:1] intValue];
    }else{
        i_month = [theMonth intValue];
    }
    
    [dateFormat setDateFormat:@"dd"];
    int i_day=0;
    NSString *theDay = [dateFormat stringFromDate:in_date];
    if([[theDay substringToIndex:0] isEqualToString:@"0"]){
        i_day = [[theDay substringFromIndex:1] intValue];
    }else{
        i_day = [theDay intValue];
    }
    /*
     摩羯座 12月22日------1月19日
     水瓶座 1月20日-------2月18日  
     双鱼座 2月19日-------3月20日
     白羊座 3月21日-------4月19日  
     金牛座 4月20日-------5月20日  
     双子座 5月21日-------6月21日  
     巨蟹座 6月22日-------7月22日  
     狮子座 7月23日-------8月22日  
     处女座 8月23日-------9月22日 
     天秤座 9月23日------10月23日  
     天蝎座 10月24日-----11月21日  
     射手座 11月22日-----12月21日  
     */
    switch (i_month) {
        case 1:
            if(i_day>=20 && i_day<=31){
                retStr=@"水瓶座";
            }
            if(i_day>=1 && i_day<=19){
                retStr=@"摩羯座";
            }
            break;
        case 2:
            if(i_day>=1 && i_day<=18){
                retStr=@"水瓶座";
            }
            if(i_day>=19 && i_day<=31){
                retStr=@"双鱼座";
            }
            break;
        case 3:
            if(i_day>=1 && i_day<=20){
                retStr=@"双鱼座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"白羊座";
            }
            break;
        case 4:
            if(i_day>=1 && i_day<=19){
                retStr=@"白羊座";
            }
            if(i_day>=20 && i_day<=31){
                retStr=@"金牛座";
            }
            break;
        case 5:
            if(i_day>=1 && i_day<=20){
                retStr=@"金牛座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"双子座";
            }
            break;
        case 6:
            if(i_day>=1 && i_day<=21){
                retStr=@"双子座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"巨蟹座";
            }
            break;
        case 7:
            if(i_day>=1 && i_day<=22){
                retStr=@"巨蟹座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"狮子座";
            }
            break;
        case 8:
            if(i_day>=1 && i_day<=22){
                retStr=@"狮子座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"处女座";
            }
            break;
        case 9:
            if(i_day>=1 && i_day<=22){
                retStr=@"处女座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"天秤座";
            }
            break;
        case 10:
            if(i_day>=1 && i_day<=23){
                retStr=@"天秤座";
            }
            if(i_day>=24 && i_day<=31){
                retStr=@"天蝎座";
            }
            break;   
        case 11:
            if(i_day>=1 && i_day<=21){
                retStr=@"天蝎座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"射手座";
            }
            break;
        case 12:
            if(i_day>=1 && i_day<=21){
                retStr=@"射手座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"摩羯座";
            }
            break;
    }
    return retStr;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [myTableView release];
    [myDatePicker release];
    [lblAge release];
    [lblXingzuo release];
    
    [request cancel];
    [request release];
    
}

-(void)do_saveinfo
{
    if([lblAge.text intValue]<12){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"此应用需要你年满12岁" delegate:self cancelButtonTitle:nil otherButtonTitles:@"是", nil];
        [alertView show];
        [alertView release];
    }else{
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:lbsMember.email forKey:@"email"];
        [params setObject:lbsMember.username forKey:@"username"];
        [params setObject:lbsMember.sex forKey:@"sex"];
        [params setObject:lbsMember.b_date forKey:@"b_date"];
        
        NSString *postURL=[Utility createPostURL:params];
        [params release];
        
        NSString *baseurl=@"lbs_register.php";
        NSString *tmp = [NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL];
        tmp = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)tmp,NULL,NULL,kCFStringEncodingUTF8);
        NSURL *url = [NSURL URLWithString:tmp];
        [self setRequest:[ASIHTTPRequest requestWithURL:url]];
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
        
        [request startSynchronous];
        NSString *result = [request responseString];
        NSDictionary *mydict = [result JSONValue];
        if([[mydict objectForKey: @"regTag"] isEqualToNumber:[NSNumber numberWithInt:1]]){            
            RegUploadPicVC *vc = [[[RegUploadPicVC alloc] initWithNibName:@"RegUploadPicVC" bundle:nil] autorelease];
            vc.lbsMember = lbsMember;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:nil cancelButtonTitle:@"确 定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        }
    }
}


-(void)doNext
{
    if([lblAge.text intValue]<12){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"此应用需要你年满12岁" delegate:self cancelButtonTitle:nil otherButtonTitles:@"是", nil];
        [alertView show];
        [alertView release];
    }else{
        RegUploadPicVC *vc = [[[RegUploadPicVC alloc] initWithNibName:@"RegUploadPicVC" bundle:nil] autorelease];
        //vc.lbsMember = lbsMember;
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"出生日期" 
                                                                     style:UIBarButtonItemStyleBordered 
                                                                    target:nil 
                                                                    action:nil];
        self.navigationItem.backBarButtonItem = backItem;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
    [self doNext];
	return YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
        lblTitle.text=@"年龄";
        
        lblAge = [[UILabel alloc] initWithFrame:CGRectMake(100,5,190,30)];
        lblAge.opaque = YES;
        lblAge.backgroundColor = [UIColor clearColor];
        lblAge.textColor = [UIColor blackColor];
        lblAge.textAlignment = UITextAlignmentRight;
        lblAge.font = [UIFont systemFontOfSize:17];
        lblAge.numberOfLines = 1;
        [cell.contentView addSubview:lblAge];
        
        
    }else if(indexPath.row==1){
        UILabel *lblTitle = [[[UILabel alloc] initWithFrame:CGRectMake(8,5,100,30)] autorelease];
        lblTitle.opaque = YES;
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textColor = [UIColor blackColor];
        lblTitle.font = [UIFont systemFontOfSize:17];
        lblTitle.numberOfLines = 1;
        [cell.contentView addSubview:lblTitle];
        lblTitle.text=@"星座";
        
        lblXingzuo = [[[UILabel alloc] initWithFrame:CGRectMake(100,5,190,30)] autorelease];
        lblXingzuo.opaque = YES;
        lblXingzuo.backgroundColor = [UIColor clearColor];
        lblXingzuo.textColor = [UIColor blackColor];
        lblXingzuo.textAlignment = UITextAlignmentRight;
        lblXingzuo.font = [UIFont systemFontOfSize:17];
        lblXingzuo.numberOfLines = 1;
        [cell.contentView addSubview:lblXingzuo];
        lblXingzuo.text=@"";
        
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
//    [self performSelector:@selector(unselectCurrentRow) withObject:nil];
//    tableView.allowsSelection=FALSE;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
