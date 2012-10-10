//
//  SystemConfVC.m
//  MOMO
//
//  Created by 超 曾 on 12-5-11.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#define m_appleID 123456789
#import "SystemConfVC.h"
#import "Global.h"

@implementation SystemConfVC
@synthesize myTableView;
@synthesize modelText;
@synthesize timerText;
@synthesize request;
@synthesize vcMember;
@synthesize vcSelect;

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.myTableView=nil;
    self.modelText=nil;
    self.timerText=nil;
    self.request=nil;
    self.vcMember=nil;
    self.vcSelect=nil;
    
}

- (void)dealloc
{
    [myTableView release];
    [modelText release];
    [timerText release];
    [request cancel];
    [request release];
    [vcMember release];
    [vcSelect release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    PincheAppDelegate *appDelegate = [PincheAppDelegate getAppDelegate];
    FMResultSet *rs=[appDelegate.db executeQuery:@"SELECT *FROM PersonSet WHERE id = ?",@"1"]; 
    NSString *hide=nil;
    NSString *soundTime=nil;
    NSString *startTime=nil;
    NSString *endTime=nil;
    while ([rs next]){  
        hide=[rs stringForColumn:@"hide"];
        soundTime=[rs stringForColumn:@"soundTime"];
        startTime=[rs stringForColumn:@"startTime"];
        endTime=[rs stringForColumn:@"endTime"];
    }
    [rs close];
    if ([soundTime isEqualToString:@"YES"]) {
        self.timerText=[NSString stringWithFormat:@"%@~%@",startTime,endTime];
    }else{
        self.timerText=@"";
    }
    int index=[hide intValue];
    switch (index) {
        case 0:
            modelText=@"对所有人可见";
            break;
        case 1:
            modelText=@"对陌生人隐身";
            break;
        case 2:
            modelText=@"对所有人隐身";
            break;
        default:
            break;
    }
    [myTableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"系统设置";
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
    
    CGRect tableViewFrame = self.view.bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    myTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    myTableView.scrollEnabled=YES;
    [self.view addSubview:myTableView];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{  
    NSInteger i_row=0;
    switch (section) {
        case 0:
            i_row = 1;
            break;
        case 1:
            i_row = 2;
            break;
        case 2:
            i_row = 2;
            break;
        case 3:
            i_row = 4;
            break;
        case 4:
            i_row = 4;
            break;
            
    }
    return i_row;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *retStr=@"";
    switch (section) {
        case 0:
            retStr = @"";
            break;
        case 1:
            retStr = @"";
            break;
        case 2:
            retStr = @"消息设置";
            break;
        case 3:
            retStr = @"账号管理";
            break;
        case 4:
            retStr = @"";
            break;
            
    }
    return retStr;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)openRoleWin
{
    vcSelect = [[SelectUserTypeViewController alloc] initWithNibName:@"SelectUserTypeViewController" bundle:nil];
    [self.navigationController pushViewController:vcSelect animated:TRUE];
}

- (void)openMyInfoWin
{
    vcMember = [[MemberInfoVC alloc] initWithNibName:@"MemberInfoVC" bundle:nil];
    vcMember.b_myinfo=TRUE;
    UINavigationController* nav = [[[UINavigationController alloc] initWithRootViewController:vcMember] autorelease];
    [self.navigationController presentModalViewController:nav animated:YES];
    
    
}

- (void)manageChewei
{
    CheweiManagerVC *vc = [[CheweiManagerVC alloc] initWithNibName:@"CheweiManagerVC" bundle:nil];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentModalViewController:nav animated:YES];
    [vc release];
    [nav release];
}

-(void)appRecommend{
    AppRec *app=[[AppRec alloc] init];
    app.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:app animated:YES];
    [app release];
}

-(void)manageHide{    
    HideSet *hide=[[HideSet alloc] init];
    hide.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:hide animated:YES];
    [hide release];
}

-(void)manageMessage{
    MessageSet *message=[[MessageSet alloc] init];
    message.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:message animated:YES];
    [message release];
    
}

-(void)manageSound{
    SoundSet *sound=[[SoundSet alloc] init];
    sound.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:sound animated:YES];
    [sound release];
    
}

-(void)blacklist{
    blacklistVC *black=[[blacklistVC alloc] init];
    black.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:black animated:YES];
    [black release];
}

-(void)sendFeed{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *email=[userDefault objectForKey:@"login_user"];
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    if (mailPicker) {
        mailPicker.mailComposeDelegate = self;
        [mailPicker setSubject: @"意见反馈"];
        [mailPicker setToRecipients: [NSArray arrayWithObject:@"promo@iplayfun.com"]];
        [mailPicker setCcRecipients: [NSArray arrayWithObject:email]];
        NSString *emailBody = @"内容";
        [mailPicker setMessageBody:emailBody isHTML:YES];
        [self presentModalViewController: mailPicker animated:YES];
    }
    [mailPicker release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result  
                        error:(NSError*)error {  
    switch (result) 
    { 
        case MFMailComposeResultCancelled: 
            NSLog(@"Mail send canceled..."); 
            break; 
        case MFMailComposeResultSaved: 
            NSLog(@"Mail saved..."); 
            break; 
        case MFMailComposeResultSent: 
            NSLog(@"Mail sent..."); 
            break; 
        case MFMailComposeResultFailed: 
            NSLog(@"Mail send errored: %@...", [error localizedDescription]); 
            break; 
        default: 
            break; 
    } 
    [self dismissModalViewControllerAnimated:YES]; 
} 

-(void)WriteAssessing{
    NSString *str =[NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",m_appleID]; 
        //NSLog(@"%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
-(void)Userhelp{
    UserHelp *help = [[[UserHelp alloc] init] autorelease];
    help.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:help animated:YES];
    
}
-(void)PositionInfo{
    PositionSV *psv = [[[PositionSV alloc] init] autorelease];
    psv.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:psv animated:YES];

}

-(void)UsersignOut{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您确定要重新登陆么" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag=10;
    [alertView show];
    [alertView release];
}

-(void)ActionSheet{
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle: @"密码设置"
                           delegate:self
                           cancelButtonTitle:@"取消"
                           destructiveButtonTitle:@"修改密码"
                           otherButtonTitles:@"忘记密码", nil];
    [menu showInView:[UIApplication sharedApplication].keyWindow];
    [menu release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //修改密码
        { 
            SetPassWord *set=[[[SetPassWord alloc] init] autorelease];
            [self.navigationController pushViewController:set animated:YES];
        }
        break;
        case 1:
            //忘记密码
        {
            NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
            NSString *email=[userDefault objectForKey:@"login_user"];
            NSString *title=[NSString stringWithFormat:@"确认邮箱：%@",email];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:@"点击确定密码重设邮件则会发送到您的邮箱中，请注意查收" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            [alert show];
            [alert release];
        }
            break;
        case 2:
            //NSLog(@"取消");
			break;
		default:
			break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //wang
    if (alertView.tag==10 && buttonIndex==1) {
        [[PincheAppDelegate getAppDelegate] signOut];
        return;
    }
	if (buttonIndex==1) {
        //wang
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        //NSString *userid=[userDefault objectForKey:@"login_user_id"];
        NSString *email=[userDefault objectForKey:@"login_user"];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        //[params setObject:userid forKey:@"userid"];
        [params setObject:email forKey:@"email"];
        NSString *postURL=[Utility createPostURL:params];
        [params release];
        //NSLog(@"%@",postURL);
        NSString *baseurl=@"sendmail.php";
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL]];
        [self setRequest:[ASIHTTPRequest requestWithURL:url]];
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request startSynchronous];
        if (request) {
            if ([request error]) {
                NSString *result = [[request error] localizedDescription];
                //            NSLog(@"%@",result);
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:self cancelButtonTitle:@"确 定" otherButtonTitles:nil, nil];
                [alertView show];
                [alertView release];
            } else if ([request responseString]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"发送成功" delegate:nil cancelButtonTitle:@"确 定" otherButtonTitles:nil, nil];
                [alertView show];
                [alertView release];
            }
        }
        else{
            NSLog(@"request is nil.");
        }
        
	} 
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
    switch (newIndexPath.section) {
        case 0://app
            if (newIndexPath.row==0) {
                [self appRecommend];
            }
            break;
        case 1:
            switch (newIndexPath.row) {
                case 0:
                    //隐身模式
                    [self manageHide];
                    break;
                case 1:
                    //定位服务
                    [self PositionInfo];
                    break;
            }
            break;
        case 2:
            switch (newIndexPath.row) {
                case 0:
                    //消息设置
                    [self manageMessage];
                    break;
                case 1:
                    //静音时段
                    [self manageSound];
                    break;
            }
            break;
        case 3:
            switch (newIndexPath.row) {
                case 0:
                    //角色选择
                    [self openRoleWin];
                    break;
                case 1:
                    //我的资料
                    [self openMyInfoWin];
                    break;
                //case 2:
                    //我的车位
                //    [self manageChewei];
                //    break;
                case 2:
                    //密码设置
                    [self ActionSheet];
                    break;
                case 3:
                    //黑名单
                    [self blacklist];
                    break;
            }
            break;
            
        case 4:
            switch (newIndexPath.row) {
                case 0://意见反馈
                    [self sendFeed];
                    break;
                case 1://评价
                    [self WriteAssessing];
                    break;
                case 2://用户帮助
                    [self Userhelp];
                    break;
                case 3:
                    [self UsersignOut];
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
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
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text=@"精品APP推荐";
            break;
        case 1:
            if(indexPath.row==0){
                cell.textLabel.text=@"隐身模式";
                cell.textLabel.backgroundColor=[UIColor clearColor];
                UILabel *lable=[[UILabel alloc] init];
                lable.frame=CGRectMake(180, 5, 120, 30);
                lable.text=modelText;
                lable.font=[UIFont systemFontOfSize:15];
                lable.backgroundColor=[UIColor clearColor];
                [cell.contentView addSubview:lable];
            }else if(indexPath.row==1){
                cell.textLabel.text=@"定位服务";
            }
            break;
        case 2:
            if(indexPath.row==0){
                cell.textLabel.text=@"消息设置";
            }else if(indexPath.row==1){
                cell.textLabel.text=@"静音时段";
                cell.textLabel.backgroundColor=[UIColor clearColor];
                UILabel *lable=[[UILabel alloc] init];
                lable.frame=CGRectMake(180, 5, 120, 30);
                lable.text=timerText;
                lable.font=[UIFont systemFontOfSize:15];
                lable.backgroundColor=[UIColor clearColor];
                [cell.contentView addSubview:lable];
            }
            break;
            
        case 3:
            if(indexPath.row==0){
                cell.textLabel.text=@"我的角色";
            }else if(indexPath.row==1){
                cell.textLabel.text=@"我的资料";
            //}else if(indexPath.row==2){
                //cell.textLabel.text=@"我的车位";
            }else if(indexPath.row==2){
                cell.textLabel.text=@"密码设置";
            }else if(indexPath.row==3){
                cell.textLabel.text=@"黑名单";
            }
            break;
            
        case 4:
            if(indexPath.row==0){
                cell.textLabel.text=@"意见反馈";
            }else if(indexPath.row==1){
                cell.textLabel.text=@"给我们评价";
            }else if(indexPath.row==2){
                cell.textLabel.text=@"用户帮助";
            }else if(indexPath.row==3){
                cell.textLabel.text=@"注销";
            }
            break;
        default:
            break;
    }
    
    return cell;
}


@end
