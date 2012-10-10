//
//  MessageSet.m
//  MOMO
//
//  Created by apple on 12-6-11.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "MessageSet.h"
#import "PincheAppDelegate.h"
@implementation MessageSet
@synthesize _tableView;
@synthesize Text1,Text2,Text3;
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

- (void)dealloc {
    [super dealloc];
    [_tableView release];
    _tableView = nil;
	[array release];
    array=nil;
    [Text1 release];
    [Text2 release];
    [Text3 release];
    //[MessageArray release];
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
    self.title=@"消息设置";
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
    
    PincheAppDelegate *appDelegate= [PincheAppDelegate getAppDelegate];
    FMResultSet *rs=[appDelegate.db executeQuery:@"SELECT *FROM PersonSet WHERE id = ?",@"1"]; 
    while ([rs next]){  
        self.Text1=[rs stringForColumn:@"alert"];
        self.Text2=[rs stringForColumn:@"alertSound"];
        self.Text3=[rs stringForColumn:@"alertshake"];
    }
    [rs close];
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds  style:UITableViewStyleGrouped];
	_tableView.delegate = self;
	_tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.scrollEnabled=NO;
    [self.view addSubview:_tableView];
    array =[[NSArray alloc] initWithObjects:@"提醒",@"声音",@"震动",nil];
    isalert=[Text1 boolValue];
}
-(void)switHandle:(id)sender{
    UISwitch *swit2=(UISwitch *)sender;
    int index=swit2.tag-10;
    BOOL state=swit2.on;
    PincheAppDelegate *appDelegate = [PincheAppDelegate getAppDelegate];
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *UserID = [userDefault objectForKey:@"login_user_id"];
    
    switch (index) {
        case 0://提醒
            [appDelegate.db executeUpdate:@"UPDATE PersonSet SET alert = ? WHERE id = ? ",[NSString stringWithFormat:@"%@",state ? @"YES":@"NO"],@"1"];
            if (state) {
                [appDelegate MessgaeAlert:UserID];
            }
            else if (!state) {  
            NSTimer *time=appDelegate.timer;
            [time invalidate];
            [UIApplication sharedApplication].applicationIconBadgeNumber=0;
            }
            isalert=!isalert;
            break;
        case 1://声音
            if (isalert) {//
                [appDelegate.db executeUpdate:@"UPDATE PersonSet SET alertSound = ? WHERE id = ? ",[NSString stringWithFormat:@"%@",state ? @"YES":@"NO"],@"1"];
                if (state) {
                    //notificationToCancel.soundName=UILocalNotificationDefaultSoundName;
                    appDelegate.alertSound=YES;
                }
                else if (!state) {
                    //notificationToCancel.soundName=nil;
                    appDelegate.alertSound=NO;
                }
            }
            break;
        case 2://震动
             if (isalert) {
                 [appDelegate.db executeUpdate:@"UPDATE PersonSet SET alertshake = ? WHERE id = ? ",[NSString stringWithFormat:@"%@",state ? @"YES":@"NO"],@"1"];
                 if (state) {
                     appDelegate.shake=YES;
                 }
                 else if (!state) {
                    appDelegate.shake=NO;
                 }
             }
            break;
        default:
            break;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    else{
        return 2;
    }        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
       UISwitch *swit=[[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 100, 30)];
        swit.clearsContextBeforeDrawing=YES;
        swit.tag=1;
        [swit addTarget:self action:@selector(switHandle:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:swit];
        [swit release];        
        cell.textLabel.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    int row=[indexPath row];
    UISwitch *swit=(UISwitch *)[cell.contentView viewWithTag:1];
    if (indexPath.section==0) {
        cell.textLabel.text = [array objectAtIndex:row];  
        swit.tag=10;
        swit.on=[Text1 boolValue];
    }else if (indexPath.section==1) {
        cell.textLabel.text =[array objectAtIndex:row+1];
        swit.tag=row+11;
        if (row==0) {
            swit.on=[Text2 boolValue];
        }
        if (row==1) {
            swit.on=[Text3 boolValue];
        }
    }
	return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *retStr=@"";
    switch (section) {
        case 0:
            retStr = @"搭车提醒功能（新消息push功能）";
            break;
        case 1:
            retStr = @"只能控制应用内的，push提醒的控制需要在手机设置—通知-搭车里面打开";
            break;
    }
    return retStr;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
