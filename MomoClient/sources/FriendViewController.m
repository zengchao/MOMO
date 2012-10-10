//
//  FriendViewController.m
//  MOMO_DEMO
//
//  Created by 超 曾 on 12-4-15.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "FriendViewController.h"

@implementation FriendViewController
@synthesize myTableView,list,titleLabel;
@synthesize leftBtn,rightBtn,seg;
@synthesize request;
@synthesize vcMember;
@synthesize vcAddFriend;
@synthesize vcUser;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.myTableView =nil;
    self.list =nil;
    self.titleLabel =nil;
    self.leftBtn =nil;
    self.rightBtn =nil;
    self.seg =nil;
    self.request =nil;
    self.vcMember=nil;
    self.vcAddFriend=nil;
    self.vcUser=nil;
    
}

- (void)dealloc
{
    [request cancel];
    [request release];
    [myTableView release];
    [list release];
    [titleLabel release];
    [leftBtn release];
    [rightBtn release];
    [seg release];
    [vcMember release];
    [vcAddFriend release];
    [vcUser release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.title=@"好友";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadList];
    [myTableView reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
    
    self.navigationItem.title = @"好友";
    flag = @"0";//关注
    order = @"0";//位置距离
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 37)];
    [btnBack setBackgroundColor:[UIColor clearColor]];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"filter.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(filterSelector) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *barButtonIteLeft = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = barButtonIteLeft;
    [barButtonIteLeft release];
    [btnBack release];
    
    rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    seg = [[[UISegmentedControl alloc] initWithItems:[@"关注 粉丝" componentsSeparatedByString:@" "]] autorelease];
    seg.selectedSegmentIndex = 0;
    seg.segmentedControlStyle = UISegmentedControlStyleBar;
    self.navigationItem.titleView = seg;
    [seg addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    
    CGRect tableViewFrame = self.view.bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    myTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    myTableView.scrollEnabled=YES;
    [self.view addSubview:myTableView];
    
}

- (void) segmentChanged:(UISegmentedControl *)paramSender
{ 
    if ([paramSender isEqual:seg])
    {
        NSInteger selectedSegmentIndex = [paramSender selectedSegmentIndex];
        //NSString *selectedSegmentText = [paramSender titleForSegmentAtIndex:selectedSegmentIndex];
        
        switch (selectedSegmentIndex) {
            case 0:
                //关注
                flag=@"0";
                [self loadList];
                [myTableView reloadData];
                break;
                
            case 1:
                //粉丝
                flag=@"1";
                [self loadList];
                [myTableView reloadData];
                break;
        }
        
    }
}


//自定义筛选
-(void)filterSelector
{
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle: @"更改排序模式"
                           delegate:self
                           cancelButtonTitle:@"取消"
                           destructiveButtonTitle:@"位置距离"
                           otherButtonTitles:@"登录时间", @"添加顺序",nil];
    [menu showInView:[UIApplication sharedApplication].keyWindow];
    [menu release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    printf("User Pressed Button %d\n", buttonIndex + 1);
    
    switch (buttonIndex) {
        case 0:
            //位置距离
            order=@"0";
            break;
        case 1:
            //登录时间
            order=@"1";
            break;
        case 2:
            //添加顺序
            order=@"2";
            break;
            
    }
    [self loadList];
    [myTableView reloadData];
    //[actionSheet release];
}

-(void)addFriend
{
    vcAddFriend = [[AddFriendVC alloc] initWithNibName:@"AddFriendVC" bundle:nil];
    UINavigationController* nav = [[[UINavigationController alloc] initWithRootViewController:vcAddFriend] autorelease];
    [self.navigationController presentModalViewController:nav animated:YES];
}

-(NSArray *)blackRequest{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *sender = [userDefault objectForKey:@"login_user_id"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:sender forKey:@"userid"];
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    
    NSString *baseurl=@"selectBlack.php";
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
            if([result isEqualToString:@"40023"] || [result isEqualToString:@"40024"]){
                return nil;
            }
            else{
                NSArray *resultArr = [result JSONValue];
                return resultArr;
            }
        }
    }
    return nil;
}

-(void)loadList
{
    [list removeAllObjects];
    list = [[NSMutableArray alloc] init];
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *login_user_id = [userDefault objectForKey:@"login_user_id"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:login_user_id forKey:@"u"];
    [params setObject:flag forKey:@"flag"];
    [params setObject:order forKey:@"order"];
    
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    NSString *baseurl=@"getFriendList.php";
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL]);
    
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
                NSArray *blackArr=[self blackRequest];
                NSDictionary *mydict = [result JSONValue];
                NSMutableDictionary *tmpDict;
                NSArray *resultArr = (NSArray *)mydict;
                for (NSDictionary *item in resultArr) {
                    tmpDict = [[NSMutableDictionary alloc] init];
                    [tmpDict setValue:[item objectForKey: @"userid"] forKey:@"userid"];
                    //NSLog(@"%@",[item objectForKey: @"userid"]);
                    
                    [tmpDict setValue:[item objectForKey: @"fid"] forKey:@"fid"];
                    [tmpDict setValue:[item objectForKey: @"fname"] forKey:@"fname"];
                    [tmpDict setValue:[item objectForKey: @"friend_pic"] forKey:@"friend_pic"];
                    [tmpDict setValue:[item objectForKey: @"status"] forKey:@"status"];
                    //NSLog(@"update_time=%@",[item objectForKey: @"update_time"]);
                    [tmpDict setValue:[item objectForKey: @"update_time"] forKey:@"update_time"];
                    [tmpDict setValue:[item objectForKey: @"distance"] forKey:@"distance"];
                    
                    [tmpDict setValue:[item objectForKey: @"startposname"] forKey:@"startposname"];
                    [tmpDict setValue:[item objectForKey: @"endposname"] forKey:@"endposname"];
                    [tmpDict setValue:[item objectForKey: @"membertype"] forKey:@"membertype"];
                    [tmpDict setValue:[item objectForKey: @"state"] forKey:@"state"];
                    
                    NSString *temp = [NSString stringWithFormat:@"%@",[item objectForKey: @"qianming"]];
                    if(temp==nil || [temp isEqualToString:@""] || [temp isEqualToString:@"<null>"]){
                        [tmpDict setValue:@"" forKey:@"qianming"];
                    }else{
                        [tmpDict setValue:[item objectForKey: @"qianming"] forKey:@"qianming"];
                    }
                    
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd"];
                    NSTimeInterval dateDiff = [[dateFormat dateFromString:[item objectForKey: @"b_date"]] timeIntervalSinceNow];
                    [dateFormat release];
                    
                    int age=-1 * trunc(dateDiff/(60*60*24))/365;
                    [tmpDict setValue:[item objectForKey: @"b_date"] forKey:@"b_date"];
                    if(age==0){
                        [tmpDict setValue:@"未知" forKey:@"age"];   
                    }else{
                        [tmpDict setValue:[NSString stringWithFormat:@"%d",age] forKey:@"age"];
                    }
                    
                    //黑名单判断
                    NSString *userid=[item objectForKey: @"userid"];
                    BOOL isblack=NO;
                    for (NSDictionary *item2 in blackArr) {
                        NSString *userid2=[item2 objectForKey:@"userid"];
                        NSString *black_userid=[item2 objectForKey:@"black_userid"];
                        if ([userid isEqualToString:userid2]||[userid isEqualToString:black_userid]){
                            isblack=YES;
                            break;
                        }
                    }
                    
                    //隐身判断
                    int state=[[tmpDict objectForKey:@"state"] intValue];
                    if (state==0||state==1) {
                        if (!isblack) {
                            [list addObject:tmpDict];
                        }
                    }
                    [tmpDict release];
                    
                }
            }
        }
    }else{
        
    }
}


//计算距今时间间隔
-(NSString *)ElapsedTime:(NSString *)startDateString 
{
    if([startDateString isEqual:[NSNull null]] || startDateString==nil || [startDateString isEqualToString:@""])
    {
        return @"";
    }else{
        startDateString=[startDateString substringToIndex:19]; //截取
        
        NSString *returnResult = [NSString stringWithFormat:@""];
        NSDateFormatter *startDateFormatter = [[NSDateFormatter alloc] init];
        [startDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        //开始时间
        NSDate *startDate = [startDateFormatter dateFromString:startDateString];
        [startDateFormatter release];
        //现在时间
        NSDate *nowDate  = [ [ NSDate alloc] init ];  
        
        NSCalendar* chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar ]; 
        
        NSUInteger unitFlags =  
        NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit; 
        
        //取相距时间额
        NSDateComponents *cps = [chineseClendar components:unitFlags fromDate:startDate  toDate:nowDate  options:0];  
        [chineseClendar release];
        [nowDate release];
        
        NSInteger diffHour = [cps hour];  
        NSInteger diffMin    = [cps minute];  
        NSInteger diffSec   = [cps second];  
        NSInteger diffDay   = [cps day];  
        NSInteger diffMon  = [cps month];  
        NSInteger diffYear = [cps year];  
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd" ];
        
        if (diffYear > 0 || diffMon > 0 || diffDay > 2)
        {
            returnResult = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:startDate]];
        }
        else if (diffDay == 1)
        {
            returnResult = @"昨天";
        }
        else if (diffHour > 0)
        {
            returnResult = [NSString stringWithFormat:@"%d小时前",diffHour, diffMin, diffSec];
        }
        else if (diffMin > 0)
        {
            returnResult = [NSString stringWithFormat:@"%d分钟前", diffMin, diffSec];
        }
        else if (diffSec > 0)
        {
            returnResult = [NSString stringWithFormat:@"%d秒前", diffSec];
        }
        
        [dateFormatter release];
        return returnResult;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"count=%d",[list count]);
    return [list count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    if([list count]>0){
        UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 27, 31, 31)];
        
        int indexs=[[[list objectAtIndex:indexPath.row] objectForKey:@"membertype"] intValue];
        
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
        [cell.contentView addSubview:cellImageView];
        [cellImageView release];
        
        thumbnail = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"no.jpg"]];
        thumbnail.frame = CGRectMake(40,5,75,75);
        thumbnail.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host_url,[[list objectAtIndex:indexPath.row] objectForKey:@"friend_pic"]]];
        [cell.contentView addSubview:thumbnail];
        
        //会员名
        NSString *username = [[list objectAtIndex:indexPath.row] objectForKey:@"fname"];
        
        //性别
        NSString *sex = [[list objectAtIndex:indexPath.row] objectForKey:@"sex"];
        if([sex isEqualToString:@"1"]){
            sex=@"♂";
        }else {
            sex=@"♀";
        }
        float distance = [[[list objectAtIndex:indexPath.row] objectForKey:@"distance"] floatValue]/1000;
        //NSString *qianming = [[list objectAtIndex:indexPath.row] objectForKey:@"qianming"];
        NSString *age = [[list objectAtIndex:indexPath.row] objectForKey:@"age"];
        NSString *update_time = [[list objectAtIndex:indexPath.row] objectForKey:@"update_time"];
        //NSLog(@"uuu_%@",update_time);
        
        NSString *startposname = [[list objectAtIndex:indexPath.row] objectForKey:@"startposname"];
        NSString *endposname = [[list objectAtIndex:indexPath.row] objectForKey:@"endposname"];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCellWidth - kArticleCellHorizontalInnerPadding * 2 +45, 5,200, 20)];
        titleLabel.opaque=YES;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.numberOfLines = 1;
        [cell.contentView addSubview:titleLabel];
        titleLabel.text = [NSString stringWithFormat:@"%@",username];
        [titleLabel release];
        
        //显示微博图标
        //显示年龄 性别
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCellWidth - kArticleCellHorizontalInnerPadding * 2 +45, 25,40, 20)];
        titleLabel.opaque=YES;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.numberOfLines = 1;
        [cell.contentView addSubview:titleLabel];
        titleLabel.text = [NSString stringWithFormat:@"%@ %@",age,sex];
        [titleLabel release];
        
        //显示距离和最近登录时间
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCellWidth - kArticleCellHorizontalInnerPadding * 2 +90, 25,200, 20)];
        titleLabel.opaque=YES;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.numberOfLines = 1;
        [cell.contentView addSubview:titleLabel];
        titleLabel.text = [NSString stringWithFormat:@"%.2fkm | %@",distance,[self ElapsedTime:update_time]];
        [titleLabel release];
        
        //签名
//        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCellWidth - kArticleCellHorizontalInnerPadding * 2 +25, 45,250, 20)];
//        titleLabel.opaque=YES;
//        titleLabel.textColor = [UIColor blackColor];
//        titleLabel.font = [UIFont systemFontOfSize:12];
//        titleLabel.numberOfLines = 1;
//        [cell.contentView addSubview:titleLabel];
//        titleLabel.text = [NSString stringWithFormat:@"%@",qianming];
//        [titleLabel release];
        //路径
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCellWidth - kArticleCellHorizontalInnerPadding * 2 +50, 45,195, 40)];
        titleLabel.opaque=YES;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.numberOfLines = 0;
        [cell.contentView addSubview:titleLabel];

        if([startposname isEqualToString:@""]){
            titleLabel.text=@"暂未提交拼车信息";
        }else{
            titleLabel.text = [NSString stringWithFormat:@"%@ 到 %@",startposname,endposname];
            NSLog(@"%@",titleLabel.text);
        }
    }
    
    
    return cell;
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    vcMember = [[MemberInfoVC alloc] initWithNibName:@"MemberInfoVC" bundle:nil];
//    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
//    [dict setValue:[[list objectAtIndex:indexPath.row] objectForKey:@"fid"] forKey:@"userid"];
//    vcMember.mydict = dict;
//    vcMember.b_myinfo=FALSE;
//    
//    UINavigationController* nav = [[[UINavigationController alloc] initWithRootViewController:vcMember] autorelease];
//    [self.navigationController presentModalViewController:nav animated:YES];    
    
    
    vcUser = [[UserinfoVC alloc] initWithNibName:@"UserinfoVC" bundle:nil];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[[list objectAtIndex:indexPath.row] objectForKey:@"fid"] forKey:@"userid"];
    vcUser.mydict = dict;
    [dict release];
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vcUser];
    [self.navigationController presentModalViewController:nav animated:YES];
    [nav release];
    
    
}
@end
