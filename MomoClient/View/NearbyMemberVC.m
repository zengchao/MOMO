//
//  NearbyMemberVC.m
//  HorizontalTables
//
//  Created by Felipe Laso on 8/7/11.
//  Copyright 2011 Felipe Laso. All rights reserved.
//  QQ:1490724

#import "NearbyMemberVC.h"
#import "Global.h"
#import "ClientConnection.h"
#import "PincheAppDelegate.h"
#import "FMResultSet.h"
#define Posdistance 1279752

@implementation NearbyMemberVC
@synthesize leftBtn,rightBtn;
@synthesize btn;
@synthesize strSex;
@synthesize strTime;
@synthesize list;
@synthesize locationManager;
@synthesize locationMeasurements;
@synthesize bestEffortAtLocation;
@synthesize request;
@synthesize myTableView;
@synthesize vcMember;
@synthesize titleLabel;
@synthesize infoLabel;
@synthesize vcUser;
@synthesize vcFilter;

#pragma mark - View Lifecycle

- (void)dealloc {
    _refreshHeaderView=nil;
    [rightBtn release];
    [leftBtn release];
    [btn release];
    [locationManager release];
    [thumbnail release];
    [titleLabel release];
    [infoLabel release];
    [locationMeasurements release];
    [bestEffortAtLocation release];
    [request cancel];
    [request release];
    [myTableView release];
    [list release];
    [vcMember release];
    [vcUser release];
    [vcFilter release];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    _refreshHeaderView=nil;
    self.leftBtn =nil;
    self.rightBtn =nil;
    self.btn =nil;
    self.list =nil;
    self.locationManager =nil;
    thumbnail =nil;
    self.titleLabel =nil;
    self.infoLabel =nil;
    self.locationMeasurements =nil;
    self.bestEffortAtLocation =nil;
    self.request =nil;
    self.myTableView =nil;
    self.vcMember =nil;
    self.vcUser=nil;
    self.vcFilter=nil;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self getListCount]+1;
}

-(NSInteger)getListCount
{
    int cnt=0;
    if(isGridDisplay){
        cnt = [list count]/4;
        cnt = [list count]%4>0 ?cnt+1:cnt;
    }else{
        cnt=[list count];
    }
    return cnt;
}

-(void)AddandCheck{
    //添加UISegmentedControl
    NSArray *segmentedArray=[[NSArray alloc] initWithObjects:@"我是雷锋",@"我要搭车",@"我要拼车",nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
	[segmentedArray release];
	segmentedControl.segmentedControlStyle =  UISegmentedControlStylePlain;
	[segmentedControl addTarget:self action:@selector(segmentedClicked:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.frame=CGRectMake(5, 5, 310, 40);
	segmentedControl.tintColor=[UIColor	blackColor];
    segmentedControl.backgroundColor=[UIColor clearColor];
	[self.view addSubview:segmentedControl];
    [segmentedControl release];
    //检测是否提醒
    PincheAppDelegate *appDelegate= [PincheAppDelegate getAppDelegate];
    FMResultSet *rs=[appDelegate.db executeQuery:@"SELECT *FROM PersonSet WHERE id = ?",@"1"]; 
    NSString *alertString=@"";
    while ([rs next]){  
        alertString=[rs stringForColumn:@"alert"];
    }
    NSLog(@"alert:%@",alertString);
    if ([alertString isEqualToString:@"YES"]) {
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        
        NSString *userID=[userDefault objectForKey:@"login_user_id"];
        [appDelegate MessgaeAlert:userID];
    }
    [rs close];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
    //添加UISegmentedControl
    NSArray *segmentedArray=[[NSArray alloc] initWithObjects:@"我是雷锋",@"我要搭车",@"我要拼车",nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
	[segmentedArray release];
	segmentedControl.segmentedControlStyle =  UISegmentedControlStylePlain;
	[segmentedControl addTarget:self action:@selector(segmentedClicked:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.frame=CGRectMake(5, 5, 310, 40);
	segmentedControl.momentary=YES;
	segmentedControl.tintColor=[UIColor	blackColor];
    segmentedControl.backgroundColor=[UIColor clearColor];
	[self.view addSubview:segmentedControl];
    [segmentedControl release];
    
    self.navigationItem.title=@"附近";
    strSex=0;//默认是全部
    strTime=3;//默认3天 0:15分钟 1:1小时 2:1天 3:3天
    
    isGridDisplay = NO;
    start=0;
    list = [[NSMutableArray alloc] init];
    self.locationMeasurements = [NSMutableArray array];
    
    CGRect tableViewFrame = CGRectMake(0, 50, 320, 440);
    //tableViewFrame.size.height=440;
    self.view.backgroundColor = [UIColor whiteColor];
    myTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    myTableView.scrollEnabled=YES;
    [self.view addSubview:myTableView];


    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 37)];
    [btnBack setBackgroundColor:[UIColor clearColor]];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"filter.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(filterSelector) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *barButtonIteLeft = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = barButtonIteLeft;
    [barButtonIteLeft release];
    [btnBack release];
    
    rightBtn = [[UIBarButtonItem alloc]
                     initWithTitle:@"网格"
                     style:UIBarButtonItemStyleBordered
                     target:self
                action:@selector(changeStyle)];
    self.navigationItem.rightBarButtonItem = rightBtn;
	
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.myTableView.bounds.size.height, self.view.frame.size.width, self.myTableView.bounds.size.height)];
		view.delegate = self;
		[self.myTableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    //NSLog(@"%@",[userDefault objectForKey:@"login_user"]);
    
    if([userDefault objectForKey:@"login_user_id"]==nil || [[userDefault objectForKey:@"login_user_id"] isEqualToString:@""]){
        //登陆失败
    }else{
        //读取本地数据库中的会员数据
        [self loadLocaldbMember];
        [self.myTableView reloadData];
//        [self loadMemberList];
        
//        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//        [self.navigationController.view addSubview:HUD];	
//        HUD.dimBackground = YES;
//        HUD.delegate = self;
//        HUD.labelText = @"";
//        [HUD showWhileExecuting:@selector(loadMemberList) onTarget:self withObject:nil animated:YES]; 
        [self loadMemberList];
    }
    
    [self AddandCheck];//wang
}

-(void)segmentedClicked:(id)sender{
    UISegmentedControl *segmentedControl=(UISegmentedControl *)sender;
	int selectIndex = segmentedControl.selectedSegmentIndex;
    if([list_tmp count]>0){
        [list removeAllObjects];
        int count = [list_tmp count];
        for(int i = 0; i < count; i++)
        {        
            //id obj = [[list_tmp objectAtIndex:i] copy];
            //NSLog(@"%@",[[list_tmp objectAtIndex:i] objectForKey:@"membertype"]);
            int type=[[[list_tmp objectAtIndex:i] objectForKey:@"membertype"] intValue];
            if (type==selectIndex) {
                [list addObject: [list_tmp objectAtIndex:i]];
            }
            
        }
        [myTableView reloadData];
    }
}

-(void)loadMemberList
{
    start=0;
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = (double)10;
    [locationManager startUpdatingLocation];
    [self performSelector:@selector(stopUpdatingLocation:) withObject:@"Timed Out" afterDelay:(double)5];
    
    NSMutableArray *tmpArray = [self loadList];
    list = [[NSMutableArray alloc] init];
    if([tmpArray count]>0){
        
        int count = [tmpArray count];
        for(int i = 0; i < count; i++)
        {        
            //id obj = [[tmpArray objectAtIndex:i] copy];
            [list addObject: [tmpArray objectAtIndex:i]];
        }
    }else{
        
    }
    NSLog(@"1_%d",[list count]);
    
    [self.myTableView reloadData];
}

- (void)stopUpdatingLocation:(NSString *)state {
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
}

//自定义筛选
-(void)filterSelector
{
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle: @"筛选"
                           delegate:self
                           cancelButtonTitle:@"取消"
                           destructiveButtonTitle:@"全部"
                           otherButtonTitles:@"根据起始地", @"根据目的地",@"根据出发时间", nil];
    
    [menu showInView:[UIApplication sharedApplication].keyWindow];
    [menu release];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //全部
            leftBtn.title=@"筛选";
            strSex=0;
            [self ViewFreshData];
            break;
        case 1:
            //只看男
            leftBtn.title=@"筛选(男♂)";
            strSex=1;
            [self ViewFreshData];
            break;
        case 2:
            //只看女
            leftBtn.title=@"筛选(女♀)";
            strSex=2;
            [self ViewFreshData];
            break;
        case 3:
            //自定义
            leftBtn.title=@"自定义";
            
            vcFilter = [[CustomFilterVC alloc] initWithNibName:@"CustomFilterVC" bundle:nil];
            vcFilter.delegate=self;
            UINavigationController* nav = [[[UINavigationController alloc] initWithRootViewController:vcFilter] autorelease];
            [self.navigationController presentModalViewController:nav animated:YES];
            break;
            
    }
    
    //[actionSheet release];
}

- (void)passValue:(NSInteger)sex time:(NSInteger)time
{  
    strSex = sex;
    strTime = time;
    [self ViewFreshData];
} 

-(void)changeStyle
{
    if(isGridDisplay){
        //切换为列表显示
        rightBtn.title=@"网格";
        isGridDisplay=!isGridDisplay;
    }else{
        //切换为网格显示
        rightBtn.title=@"列表";
        isGridDisplay=!isGridDisplay;
    }
    [self.myTableView reloadData];
    
}

- (NSMutableArray *)loadList
{
    //int retCount=0;
    list_tmp=[[NSMutableArray alloc] init];
    
    CLLocation *location = [locationManager location];
	CLLocationCoordinate2D coordinate= [location coordinate];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if([userDefault objectForKey:@"login_user"]==nil || [[userDefault objectForKey:@"login_user"] isEqualToString:@""]){
        [params setObject:[NSString stringWithFormat:@"%f",coordinate.latitude] forKey:@"x"];
        [params setObject:[NSString stringWithFormat:@"%f",coordinate.longitude] forKey:@"y"];
    }else{
        if(coordinate.latitude<=0 && coordinate.longitude<=0){
            [params setObject:[NSString stringWithFormat:@"%f",coordinate.latitude] forKey:@"x"];
            [params setObject:[NSString stringWithFormat:@"%f",coordinate.longitude] forKey:@"y"];
        }else{
            [params setObject:[userDefault objectForKey:@"login_user"] forKey:@"u"];
            [params setObject:[userDefault objectForKey:@"login_pwd"] forKey:@"p"];
            [params setObject:[NSString stringWithFormat:@"%d",strSex] forKey:@"sex"];
            [params setObject:[NSString stringWithFormat:@"%d",strTime] forKey:@"time"];
            [params setObject:[NSString stringWithFormat:@"%d",start] forKey:@"s"];
            [params setObject:[NSString stringWithFormat:@"%d",start+20] forKey:@"e"];
            [params setObject:[NSString stringWithFormat:@"%f",coordinate.latitude] forKey:@"x"];
            [params setObject:[NSString stringWithFormat:@"%f",coordinate.longitude] forKey:@"y"];
            
        }
    }
    
    
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    NSString *baseurl=@"updatepos.php";
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL]);
    
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
            if([result isEqualToString:@"40023"] || [result isEqualToString:@"40024"]){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                [alertView release];
                
            }else{
                NSDictionary *mydict = [result JSONValue];
                NSMutableDictionary *tmpDict;
                NSArray *resultArr = (NSArray *)mydict;
                //retCount = [resultArr count];
                NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
                MemberDAO *memberDao = [[[MemberDAO alloc] init] autorelease];
                LBS_Member *member ;
                for (NSDictionary *item in resultArr) {
                    member = [memberDao returnMember:item];
                    
                    tmpDict = [[NSMutableDictionary alloc] init];
                    [tmpDict setValue:[item objectForKey: @"userid"] forKey:@"userid"];
                    [tmpDict setValue:[item objectForKey: @"username"] forKey:@"username"];
                    [tmpDict setValue:[item objectForKey: @"sex"] forKey:@"sex"];
                    [tmpDict setValue:[item objectForKey: @"zhiye"] forKey:@"zhiye"];
                    [tmpDict setValue:[item objectForKey: @"qianming"] forKey:@"qianming"];
                    [tmpDict setValue:[item objectForKey: @"regdate"] forKey:@"regdate"];
                    [tmpDict setValue:[item objectForKey: @"aihao"] forKey:@"aihao"];
                    [tmpDict setValue:[item objectForKey: @"gongsi"] forKey:@"gongsi"];
                    [tmpDict setValue:[item objectForKey: @"regdate"] forKey:@"regdate"];
                    [tmpDict setValue:[item objectForKey: @"xuexiao"] forKey:@"xuexiao"];
                    [tmpDict setValue:[item objectForKey: @"difang"] forKey:@"difang"];      
                    [tmpDict setValue:[item objectForKey: @"zhuye"] forKey:@"zhuye"];
                    [tmpDict setValue:[item objectForKey: @"email"] forKey:@"email"];
                    [tmpDict setValue:[item objectForKey: @"status"] forKey:@"status"];
                    [tmpDict setValue:[item objectForKey: @"update_time"] forKey:@"update_time"];
                    [tmpDict setValue:[item objectForKey: @"pic"] forKey:@"pic"];
                    [tmpDict setValue:[item objectForKey: @"distance"] forKey:@"distance"];
                    [tmpDict setValue:[item objectForKey: @"membertype"] forKey:@"membertype"];
                    [tmpDict setValue:[item objectForKey: @"state"] forKey:@"state"];
                    
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd"];
                    NSTimeInterval dateDiff = [[dateFormat dateFromString:[item objectForKey: @"b_date"]] timeIntervalSinceNow];
                    
                    int age=-1 * trunc(dateDiff/(60*60*24))/365;
                    [tmpDict setValue:[item objectForKey: @"b_date"] forKey:@"b_date"];
                    if(age==0){
                        [tmpDict setValue:@"未知" forKey:@"age"];   
                    }else{
                        [tmpDict setValue:[NSString stringWithFormat:@"%d",age] forKey:@"age"];
                    }
                    
                    NSDate *tmpDate = [dateFormat dateFromString:[item objectForKey:@"b_date"]];
                    
                    ClientConnection *client = [[[ClientConnection alloc] init] autorelease];
                    [tmpDict setValue:[client getXingzuo:tmpDate] forKey:@"xingzuo"];
                    [tmpDict setValue:[item objectForKey:@"startposname"] forKey:@"startposname"];
                    [tmpDict setValue:[item objectForKey:@"endposname"] forKey:@"endposname"];
                    
                    
                    member.distance = [item objectForKey: @"distance"];
                    [tmpArray addObject:member];
                    [list_tmp addObject:tmpDict];
                    [tmpDict release];
                    [member release];
                    
                }
                [memberDao AddMember:tmpArray];
            }
        }
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"request is nil." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        
    }
    return list_tmp;
}

- (int)loadLocaldbMember
{
    MemberDAO *memberDao = [[[MemberDAO alloc] init] autorelease];
    NSMutableArray *tmpArray = [memberDao getMemberList];
    NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
    for (LBS_Member *item in tmpArray) {
        [tmpDict setValue:item.userid forKey:@"userid"];
        [tmpDict setValue:item.username forKey:@"username"];
        [tmpDict setValue:item.sex forKey:@"sex"];
        [tmpDict setValue:item.zhiye forKey:@"zhiye"];
        [tmpDict setValue:item.qianming forKey:@"qianming"];
        [tmpDict setValue:item.regdate forKey:@"regdate"];
        [tmpDict setValue:item.aihao forKey:@"aihao"];
        [tmpDict setValue:item.gongsi forKey:@"gongsi"];
        [tmpDict setValue:item.regdate forKey:@"regdate"];
        [tmpDict setValue:item.xuexiao forKey:@"xuexiao"];
        [tmpDict setValue:item.difang forKey:@"difang"];      
        [tmpDict setValue:item.zhuye forKey:@"zhuye"];
        [tmpDict setValue:item.email forKey:@"email"];
        [tmpDict setValue:item.status forKey:@"status"];
        [tmpDict setValue:item.update_time forKey:@"update_time"];
        [tmpDict setValue:item.pic forKey:@"pic"];
        [tmpDict setValue:item.distance forKey:@"distance"];
        [tmpDict setValue:item.membertype forKey:@"membertype"]; 
        [tmpDict setValue:item.state forKey:@"state"]; 
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSTimeInterval dateDiff = [[dateFormat dateFromString:item.b_date] timeIntervalSinceNow];
        
        int age=-1 * trunc(dateDiff/(60*60*24))/365;
        [tmpDict setValue:item.b_date forKey:@"b_date"];
        if(age==0){
            [tmpDict setValue:@"未知" forKey:@"age"];   
        }else{
            [tmpDict setValue:[NSString stringWithFormat:@"%d",age] forKey:@"age"];
        }
        
        NSDate *tmpDate = [dateFormat dateFromString:item.b_date];
        ClientConnection *client = [[[ClientConnection alloc] init] autorelease];
        [tmpDict setValue:[client getXingzuo:tmpDate] forKey:@"xingzuo"];
        
        [list addObject:tmpDict];
        [tmpDict release];
        [dateFormat release];
        
    }
    //NSLog(@"%d",[list count]);
    return [list count];
}

-(void) ViewFreshData{
    [self.myTableView setContentOffset:CGPointMake(0, -75) animated:YES];
    [self performSelector:@selector(doneManualRefresh) withObject:nil afterDelay:0.4];
}

-(void)doneManualRefresh{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.myTableView];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.myTableView];
}

-(void)btnClicked:(id)sender event:(id)event{
	NSSet *touches=[event allTouches];
	UITouch *touch=[touches anyObject];
	CGPoint pos=[touch locationInView:self.myTableView];
	NSIndexPath *indexPath=[self.myTableView indexPathForRowAtPoint:pos];
	NSInteger row=[indexPath row];
    int i=0;
    
    if(pos.x >= 3 && pos.x <=79 )
    {
        i=0;
    }else if(pos.x >= 3*2+76 && pos.x <=3*2+76*2 )
    {
        i=1;
    }else if(pos.x >= 3*3+76*2 && pos.x <=3*3+76*3 )
    {
        i=2;
    }else if(pos.x >= 3*4+76*3 && pos.x <=3*4+76*4 )
    {
        i=3;
    }
    
    vcUser = [[UserinfoVC alloc] initWithNibName:@"UserinfoVC" bundle:nil]; 
    vcUser.mydict = [list objectAtIndex:row * 4 + i];
    UINavigationController* nav = [[[UINavigationController alloc] initWithRootViewController:vcUser] autorelease];
    [self.navigationController presentModalViewController:nav animated:YES];
    
    
}

- (void)btnMoreClick:(id)sender
{
//    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:HUD];	
//    HUD.dimBackground = YES;
//    HUD.delegate = self;
//    HUD.labelText = @"";
//    [HUD showWhileExecuting:@selector(startLoadmore) onTarget:self withObject:nil animated:YES];
    [self startLoadmore];
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
    
    int cnt = 4;
    int j = 0;
    if(isGridDisplay)
    {
        if(([list count]/4)<indexPath.row+1)
        {
            cnt = [list count]%4;    
        }
        j = [list count]%4>0 ?[list count]/4+1:[list count]/4;
    }else{
        cnt=1;
        j=[list count];
    }
//    NSString *username = [[list objectAtIndex:0] objectForKey:@"username"];
//    NSLog(@"%@",username);
    
    if(indexPath.row ==j){
        if((isGridDisplay && j>=5) || (!isGridDisplay && j>=20 )){
//            UILabel *labelMore = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];       
//            labelMore.textAlignment = UITextAlignmentCenter;
//            labelMore.font = [UIFont boldSystemFontOfSize:16.0];
//            labelMore.text = @"显示更多...";
//            [cell.contentView addSubview:labelMore];
            
            UIButton *btnMore = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btnMore.frame = CGRectMake(20, 5, 280, 30);
            btnMore.backgroundColor = [UIColor clearColor];
            [btnMore setTitle:@"显示更多" forState:UIControlStateNormal];
            [btnMore setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btnMore addTarget:self action:@selector(btnMoreClick:) forControlEvents:UIControlEventTouchDown];
            
            [cell.contentView addSubview:btnMore];
        }
    }else{
        
        for(int i=0;i<cnt;i++)
        {
            int cur_row = indexPath.row;
            if(isGridDisplay){
                cur_row = indexPath.row * 4 + i;
            }
            EGOImageView *asyncImageView = [[EGOImageView alloc] init];
            asyncImageView.frame = CGRectMake(kArticleCellHorizontalInnerPadding*(i+1)+(kCellWidth - kArticleCellHorizontalInnerPadding * 2)*i, kArticleCellVerticalInnerPadding, kCellWidth - kArticleCellHorizontalInnerPadding * 2, kCellHeight - kArticleCellVerticalInnerPadding * 2);
            
            //添加边框  
            CALayer * layer = [asyncImageView layer];  
            layer.borderColor = [[UIColor whiteColor] CGColor];  
            layer.borderWidth = 1.0f;  
            //添加四个边阴影  
            asyncImageView.layer.shadowColor = [UIColor blackColor].CGColor;  
            asyncImageView.layer.shadowOffset = CGSizeMake(0, 0);  
            asyncImageView.layer.shadowOpacity = 0.5;  
            asyncImageView.layer.shadowRadius = 2.0;//给iamgeview添加阴影 < wbr > 和边框  
            //添加两个边阴影  
            asyncImageView.layer.shadowColor = [UIColor blackColor].CGColor;  
            asyncImageView.layer.shadowOffset = CGSizeMake(2, 2);  
            asyncImageView.layer.shadowOpacity = 0.5;  
            asyncImageView.layer.shadowRadius = 2.0; 
            
            [cell.contentView addSubview:asyncImageView];
            
            thumbnail = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"no.jpg"]];
            thumbnail.frame = CGRectMake(kArticleCellHorizontalInnerPadding*(i+1)+(kCellWidth - kArticleCellHorizontalInnerPadding * 2)*i, kArticleCellVerticalInnerPadding, kCellWidth - kArticleCellHorizontalInnerPadding * 2, kCellHeight - kArticleCellVerticalInnerPadding * 2);
            thumbnail.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host_url,[[list objectAtIndex:cur_row] objectForKey:@"pic"]]];
            [cell.contentView addSubview:thumbnail];
            
//            NSLog(@"%d",[list count]);
            //会员名
            NSString *username = [[list objectAtIndex:cur_row] objectForKey:@"username"];
//            NSLog(@"%@",username);
            //性别
            NSString *sex = [[list objectAtIndex:cur_row] objectForKey:@"sex"];
            if([sex isEqualToString:@"1"]){
                sex=@"♂";
            }else {
                sex=@"♀";
            }
            float distance = [[[list objectAtIndex:cur_row] objectForKey:@"distance"] floatValue]/1000;
            
            //NSString *qianming = [[list objectAtIndex:cur_row] objectForKey:@"qianming"];
            NSString *age = [[list objectAtIndex:cur_row] objectForKey:@"age"];
            NSString *update_time = [[list objectAtIndex:cur_row] objectForKey:@"update_time"];
            NSLog(@"%@",update_time);
            
            NSString *startposname = [NSString stringWithFormat:@"%@",[[list objectAtIndex:cur_row] objectForKey:@"startposname"]];
            NSLog(@"s=%@",startposname);
            NSString *endposname = [NSString stringWithFormat:@"%@",[[list objectAtIndex:cur_row] objectForKey:@"endposname"]];
            
            
            if(isGridDisplay){
                titleLabel = [[[ArticleTitleLabel alloc] initWithFrame:CGRectMake(0, thumbnail.frame.size.height * 0.632, thumbnail.frame.size.width, thumbnail.frame.size.height * 0.37)] autorelease];
                titleLabel.opaque = YES;
                [titleLabel setPersistentBackgroundColor:[UIColor colorWithRed:0 green:0.4745098 blue:0.29019808 alpha:0.9]];
                titleLabel.textColor = [UIColor whiteColor];
                titleLabel.font = [UIFont boldSystemFontOfSize:11];
                titleLabel.numberOfLines = 2;
                [thumbnail addSubview:titleLabel];
                [thumbnail release];
                
                CGRect frameAvatar;  
                frameAvatar.size.width  = 76;  
                frameAvatar.size.height = 76;  
                frameAvatar.origin.x = 3*(i+1)+76*i;  
                frameAvatar.origin.y = 3;
                
                btn=[[UIButton alloc] initWithFrame:frameAvatar];
                [btn addTarget:self action:@selector(btnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btn];
                [btn release];
                
                if(distance>=10000)titleLabel.text=[NSString stringWithFormat:@"遥远 %@",sex];
                else
                titleLabel.text=[NSString stringWithFormat:@"%.2fkm %@",distance,sex];
                
                cell.backgroundColor = [UIColor colorWithRed:0 green:0.40784314 blue:0.21568627 alpha:1.0];
                cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:thumbnail.frame] autorelease];
                cell.selectedBackgroundView.backgroundColor = kHorizontalTableSelectedBackgroundColor;
            }else{
                //添加身份图标
                thumbnail.frame = CGRectMake(kArticleCellHorizontalInnerPadding*(i+1)+(kCellWidth - kArticleCellHorizontalInnerPadding * 2)*i+35, kArticleCellVerticalInnerPadding, kCellWidth - kArticleCellHorizontalInnerPadding * 2, kCellHeight - kArticleCellVerticalInnerPadding * 2);
                asyncImageView.frame =thumbnail.frame;
                UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 27, 31, 31)];
                
                int indexs=[[[list objectAtIndex:cur_row] objectForKey:@"membertype"] intValue];
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
                
                
                infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCellWidth - kArticleCellHorizontalInnerPadding * 2 +10+35, 5,200, 20)];
                //infoLabel.frame=CGRectMake(kCellWidth - kArticleCellHorizontalInnerPadding * 2 +10+35, 5,200, 20);
                infoLabel.opaque=YES;
                infoLabel.textColor = [UIColor blackColor];
                infoLabel.font = [UIFont systemFontOfSize:12];
                infoLabel.numberOfLines = 1;
                [cell.contentView addSubview:infoLabel];
                infoLabel.text = [NSString stringWithFormat:@"%@",username];
                [infoLabel release];
                
                //显示微博图标
                //显示年龄 性别
                infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCellWidth - kArticleCellHorizontalInnerPadding * 2 +10+35, 25,40, 20)];
                infoLabel.opaque=YES;
                infoLabel.textColor = [UIColor blackColor];
                infoLabel.font = [UIFont systemFontOfSize:12];
                infoLabel.numberOfLines = 1;
                [cell.contentView addSubview:infoLabel];
                infoLabel.text = [NSString stringWithFormat:@"%@ %@",age,sex];
                [infoLabel release];
                
                //显示距离和最近登录时间
                infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCellWidth - kArticleCellHorizontalInnerPadding * 2 +60+35, 25,200, 20)];
                infoLabel.opaque=YES;
                infoLabel.textColor = [UIColor blackColor];
                infoLabel.font = [UIFont systemFontOfSize:12];
                infoLabel.numberOfLines = 1;
                [cell.contentView addSubview:infoLabel];
                if(distance>=10000)infoLabel.text = [NSString stringWithFormat:@"遥远 | %@",[self ElapsedTime:update_time]];
                else
                infoLabel.text = [NSString stringWithFormat:@"%.2fkm | %@",distance,[self ElapsedTime:update_time]];
                [infoLabel release];
                
                //签名
                infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCellWidth - kArticleCellHorizontalInnerPadding * 2 +10+35, 45,200, 40)];
                infoLabel.opaque=YES;
                infoLabel.textColor = [UIColor blackColor];
                infoLabel.font = [UIFont systemFontOfSize:12];
                infoLabel.numberOfLines = 2;
                [cell.contentView addSubview:infoLabel];
//                infoLabel.text = [NSString stringWithFormat:@"%@",qianming];
                if([startposname isEqualToString:@""]){
                    infoLabel.text=@"暂未提交拼车信息";
                }else{
                    infoLabel.text = [NSString stringWithFormat:@"%@ 到 %@",startposname,endposname];
                }
                [infoLabel release];
                
            }
            
            
        }
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int cnt = 4;
    int j = 0;
    if(isGridDisplay)
    {
        if(([list count]/4)<indexPath.row+1)
        {
            cnt = [list count]%4;    
        }
        j = [list count]%4>0 ?[list count]/4+1:[list count]/4;
    }else{
        cnt=1;
        j=[list count];
    }
    
    if(indexPath.row ==j){
        return 40;
    }else{
        return 85;
    }
}

#pragma mark - Memory Management

- (void)awakeFromNib
{
    [self.myTableView setBackgroundColor:kVerticalTableBackgroundColor];
    self.myTableView.rowHeight = kCellHeight + (kRowVerticalPadding * 0.5) + ((kRowVerticalPadding * 0.5) * 0.5);
}

- (void)reloadTableViewDataSource{
	//取新数据
    
    [self loadMemberList];
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	//重新加载tableview
    [self.myTableView reloadData];
    
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
	
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


/*
 * We want to get and store a location measurement that meets the desired accuracy. For this example, we are
 *      going to use horizontal accuracy as the deciding factor. In other cases, you may wish to use vertical
 *      accuracy, or both together.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // store all of the measurements, just so we can see what kind of data we might receive
    [locationMeasurements addObject:newLocation];
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    // test the measurement to see if it is more accurate than the previous measurement
    if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        // store the location as the "best effort"
        self.bestEffortAtLocation = newLocation;
        // test the measurement to see if it meets the desired accuracy
        //
        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue 
        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of 
        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
        //
        if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
            // we have a measurement that meets our requirements, so we can stop updating the location
            // 
            // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
            //
            [self stopUpdatingLocation:NSLocalizedString(@"Acquired Location", @"Acquired Location")];
            // we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:nil];
        }
    }
    // update the display with the new location data
    [self.myTableView reloadData];    
    
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a 
    // timeout that will stop the location manager to save power.
    if ([error code] != kCLErrorLocationUnknown) {
        [self stopUpdatingLocation:NSLocalizedString(@"Error", @"Error")];
    }
}


-(BOOL)canBecomeFirstResponder 

{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated

{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated 

{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [self ViewFreshData];
    }
}

- (void)startLoadmore
{
    start=start+20;
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = (double)10;
    [locationManager startUpdatingLocation];
    [self performSelector:@selector(stopUpdatingLocation:) withObject:@"Timed Out" afterDelay:(double)5];
    
    NSMutableArray *tmpArray = [self loadList];
    if([tmpArray count]>0){
        int count = [tmpArray count];
        for(int i = 0; i < count; i++)
        {        
            //id obj = [[tmpArray objectAtIndex:i] copy];
            [list addObject: [tmpArray objectAtIndex:i]];
        }
        
    }
    [self.myTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSInteger listCount = [self getListCount]; 
    if(indexPath.row==listCount){
        
//        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//        [self.navigationController.view addSubview:HUD];	
//        HUD.dimBackground = YES;
//        HUD.delegate = self;
//        HUD.labelText = @"";
//        [HUD showWhileExecuting:@selector(startLoadmore) onTarget:self withObject:nil animated:YES];
        [self startLoadmore];
        
    }else{
//        vcMember = [[MemberInfoVC alloc] initWithNibName:@"MemberInfoVC" bundle:nil];
//        vcMember.b_myinfo=FALSE;
//        vcMember.mydict = [list objectAtIndex:indexPath.row];
//        
//        UINavigationController* nav = [[[UINavigationController alloc] initWithRootViewController:vcMember] autorelease];
//        [self.navigationController presentModalViewController:nav animated:YES];
        
        
        vcUser = [[UserinfoVC alloc] initWithNibName:@"UserinfoVC" bundle:nil];
        vcUser.mydict = [list objectAtIndex:indexPath.row];
        UINavigationController* nav = [[[UINavigationController alloc] initWithRootViewController:vcUser] autorelease];
        [self.navigationController presentModalViewController:nav animated:YES];
        
    }
}


@end
