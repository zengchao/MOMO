

//  曾超
//  QQ:1490724


#import "PincheAppDelegate.h"
#import "ASIHTTPRequest.h"

@implementation PincheAppDelegate
@synthesize firstlogin;
@synthesize window;
@synthesize navigationController;
@synthesize timer,shake,request,alertSound;
@synthesize mainTabViewController;
@synthesize db,isSound,startTime,endTime;

//初始检查正式数据库是否存在
- (void)initDatebase
{    
    //将资源数据库结构拷贝到文档目录
    //资源DB结构
    NSString *bundPath = [[[NSBundle mainBundle] resourcePath]
                          stringByAppendingPathComponent:@"pinche.db"];    
    //最终数据库路径
    NSString *dbPath  = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
                         stringByAppendingPathComponent:@"pinche.db"];
    NSLog(@"%@",dbPath);
    //文件管理
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:dbPath])
    {
        //数据库文件不存在,将资源拷贝到
        [fm copyItemAtPath:bundPath toPath:dbPath error:nil];
    }
    //[fm release];
    db= [FMDatabase databaseWithPath:dbPath];  
    if (![db open]) {  
        //NSLog(@"Could not open db");  
        return ;  
    }
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS PersonSet (id INTEGER PRIMARY KEY,hide TEXT ,soundTime TEXT,startTime TEXT,endTime TEXT,alert TEXT,alertSound TEXT,alertshake TEXT);"];
    FMResultSet *rs=[db executeQuery:@"SELECT * FROM PersonSet"];
    if (![rs next]) {
        [db executeUpdate:@"INSERT INTO PersonSet (hide,soundTime,startTime,endTime,alert,alertSound,alertshake) VALUES (?,?,?,?,?,?,?)",@"0",@"NO",@"00:00",@"01:00",@"NO",@"YES",@"NO"];
    }
    [rs close];
}

+(PincheAppDelegate*)getAppDelegate
{
    return (PincheAppDelegate*)[UIApplication sharedApplication].delegate;
}

- (void)signOut 
{
	[navigationController.view removeFromSuperview];
    
    if(![Utility connectedToNetwork])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    StartVC *first = [[[StartVC alloc] initWithNibName:@"StartVC" bundle:nil] autorelease];
    navigationController = [[UINavigationController alloc] initWithRootViewController:first];
    [self.window addSubview:navigationController.view];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"firstlogin"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"login_user"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"login_pwd"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"login_user_id"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"sina_bind_userid"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"rememberUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [self.window makeKeyAndVisible];
    
}

-(void)timerRequest:(NSTimer *)Ontimer{
    NSMutableDictionary *dic=[Ontimer userInfo];
    NSString *UserID=[dic objectForKey:@"userid"];
    UILocalNotification *noti=[dic objectForKey:@"UILocalNotification"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:UserID forKey:@"userid"];
    NSString *postURL=[Utility createPostURL:params];
    NSString *baseurl=@"getmessage.php";
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
            if([result isEqualToString:@"40023"] || [result isEqualToString:@"40024"]){
                MessageNum=0;
            }
            else{
                NSMutableArray *resultArray=[result JSONValue];
                NSMutableArray *array=[[NSMutableArray alloc] init];
                for (NSMutableDictionary *item in resultArray) {
                    if ([[item objectForKey:@"sender_black"] intValue]==0) {
                        [array addObject:item];
                    }
                }
                //NSLog(@"%d",[array count]);
                if ([array count] != MessageNum) {
                    BOOL is = YES;//*
                    if (isSound) {
                        NSDate *date=[NSDate date];
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"HH"];
                        NSString *strDate = [dateFormatter stringFromDate:date];
                        if ([strDate intValue]<=[endTime intValue]&&[strDate intValue]>=[startTime intValue]) {
                            noti.soundName =nil;
                            is=NO;
                        }
                    }
                    NSLog(@"BOOL is:%d",is);
                    if (shake && is)
                    {
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                        NSLog(@"shake");
                    }
                    if (alertSound && is) {
                        noti.soundName =UILocalNotificationDefaultSoundName;
                        NSLog(@"alertSound");
                    }
                    else if(!alertSound){
                        noti.soundName=nil;
                        NSLog(@"NOSound");
                    }
                    noti.fireDate=[NSDate date];
                    noti.applicationIconBadgeNumber=[array count];
                    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
                    MessageNum=[array count];
                }   
                [array release];
            }
        }
    }
}

-(void)MessgaeAlert:(NSString *)UserID{
    //NSLog(@"本地提醒:%@",UserID);
    login_user_id=UserID;
    FMResultSet *rs=[db executeQuery:@"SELECT *FROM PersonSet WHERE id = ?",@"1"]; 
    while ([rs next]){  
        self.isSound=[[rs stringForColumn:@"soundTime"] boolValue];
        self.startTime=[rs stringForColumn:@"startTime"];
        self.endTime=[rs stringForColumn:@"endTime"];
        self.shake=[[rs stringForColumn:@"alertshake"] boolValue];
        self.alertSound=[[rs stringForColumn:@"alertSound"] boolValue];
    }
    [rs close];

    UILocalNotification *noti=[[UILocalNotification alloc] init];
    noti.timeZone = [NSTimeZone defaultTimeZone];
    noti.applicationIconBadgeNumber =0;
    noti.alertBody=@"消息提醒！";
    noti.alertAction = @"打开";
    NSDictionary* info = [NSDictionary dictionaryWithObject:UserID forKey:@"login_user_id"];
    noti.userInfo = info;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:UserID forKey:@"userid"];
    [dic setObject:noti forKey:@"UILocalNotification"];
    [noti release];
    timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(timerRequest:) userInfo:dic repeats:YES]; 
    [dic release];
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveAnn" object:nil];
}


-(void)RemoveView{    
    [mainImageView removeFromSuperview];
}

-(void)RemovemainView{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationDidStopSelector:@selector(RemoveView)];
    mainImageView.alpha = 0;
    [UIView commitAnimations];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if(![Utility connectedToNetwork])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    [self initDatebase];
    application.applicationIconBadgeNumber=0;
    mainTabViewController = [[MainTabViewController alloc] init];
    
    firstlogin = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"firstlogin"]];
    if([firstlogin isEqualToString:@"0"]){
        //不是第一次登陆了
        [self.window addSubview:self.mainTabViewController.view];
        self.mainTabViewController.selectedIndex=0;
    }else{
        StartVC *first = [[[StartVC alloc] initWithNibName:@"StartVC" bundle:nil] autorelease];
        navigationController = [[UINavigationController alloc] initWithRootViewController:first];
        [self.window addSubview:navigationController.view];
        
        UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
        if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
        {
            [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
        }
    }
    
    DefaultSHKConfigurator *configurator = [[ShareKitDemoConfigurator alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    [configurator release];
    
    mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 20.0, 320.0, 460.0)];
    //mainImageView.frame=self.window.bounds;
    [mainImageView setImage:[UIImage imageNamed:@"Default.png"]];
    mainImageView.userInteractionEnabled = NO;
    [self.window addSubview:mainImageView];
    [self performSelector:@selector(RemovemainView) withObject:nil afterDelay:0];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
	// Handle the notificaton when the app is running
	NSLog(@"Recieved Notification %@",notif);
    if([[notif.userInfo objectForKey:@"login_user_id"]isEqualToString:login_user_id]) 
    {   
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"有新消息到来"message:notif.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        app.applicationIconBadgeNumber=notif.applicationIconBadgeNumber;
    } 
}


- (void)applicationWillResignActive:(UIApplication *)application
{
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

- (void)dealloc
{
    [navigationController release];
    [window release];
    timer=nil;
    [firstlogin release];
    [super dealloc];
}

@end
