//
//  MemberInfoVC.m
//  MOMO
//
//  Created by 超 曾 on 12-5-11.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "MemberInfoVC.h"


@implementation MemberInfoVC
@synthesize myTableView;
@synthesize leftBarButtonItem;
@synthesize mydict;
@synthesize scrollImages;
@synthesize pagecontrol;
@synthesize imagesBack;
@synthesize m_pToolBar;
@synthesize imagePicker;
@synthesize imagePicture;
@synthesize imageView;
@synthesize request;
@synthesize subview;
@synthesize imageviews;
@synthesize data;
@synthesize pf;
@synthesize list;
@synthesize b_myinfo;
@synthesize vcEdit;
@synthesize vcRoad;
@synthesize vcMessage;
@synthesize m_pButtonAdd;
@synthesize m_pButtonAdd2;
@synthesize m_pButtonAdd3;

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.myTableView =nil;
    self.leftBarButtonItem =nil;
    self.mydict =nil;
    self.m_pToolBar =nil;
    self.scrollImages=nil;
    self.pagecontrol=nil;
    self.imagesBack=nil;
    self.imagePicker =nil;
    self.imagePicture=nil;
    self.imageView=nil;
    self.request =nil;
    self.m_pButtonAdd=nil;
    self.m_pButtonAdd2 =nil;
    self.m_pButtonAdd3=nil;
    self.subview =nil;
    self.imageviews=nil;
    self.data=nil;
    self.pf=nil;
    self.list=nil;
    self.vcEdit=nil;
    self.vcRoad=nil;
    self.vcMessage=nil;
    
}

- (void)dealloc {
    
	[myTableView release];
    [leftBarButtonItem release];
    [mydict release];
    [m_pToolBar release];
    [scrollImages release];
    [pagecontrol release];
    [imagesBack release];
    [imagePicker release];
    [imagePicture release];
    [imageView release];
    [request cancel];
    [request release];
    [m_pButtonAdd release];
    [m_pButtonAdd2 release];
    [m_pButtonAdd3 release];
    [subview release];
    [imageviews release];
    [data release];
    [pf release];
    [list release];
    [vcEdit release];
    [vcRoad release];
    [vcMessage release];
    
    [super dealloc];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==10) {
        [self dismissModalViewControllerAnimated:TRUE];
        return;
    }
    
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"确定"])
    { 
        [self dismissModalViewControllerAnimated:TRUE];
    }
}

- (void)loadCheweiList
{
//    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:HUD];	
//    HUD.dimBackground = YES;
//    HUD.delegate = self;
//    HUD.labelText = @"";
//    [HUD showWhileExecuting:@selector(loadCheweiListVC) onTarget:self withObject:nil animated:YES];
    [self loadCheweiListVC];
    
}

- (void)loadCheweiListVC
{
    CheweiListVC *vc = [[CheweiListVC alloc] initWithNibName:@"CheweiListVC" bundle:nil];
    vc.member_id = [mydict objectForKey:@"userid"];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentModalViewController:nav animated:YES];
    [vc release];
    [nav release];
}

- (void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"123");
    [self getMemberInfo];
    data = [[NSMutableArray alloc] init];
    [self getMyPic];
    
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
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 37)];
    [btnBack setBackgroundColor:[UIColor clearColor]];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(dismissWin) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *barButtonIteLeft = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = barButtonIteLeft;
    [barButtonIteLeft release];
    [btnBack release];
    
    self.navigationController.navigationBarHidden=FALSE;
    self.navigationController.title=@"会员资料";
    
    
    int count = [self getMemberInfo];
    if(count==0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"没有找到该会员的资料" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }else
    {
        data = [[NSMutableArray alloc] init];
        [self getMyPic];
        int rows = [data count]%4>0 ?[data count]/4+1:[data count]/4;
        CGRect tableViewFrame = self.view.bounds;
        if(b_myinfo){
            tableViewFrame.size.height=460;
        }else{            
            tableViewFrame.size.height=460-44;
        }
        
        self.view.backgroundColor = [UIColor whiteColor];
        myTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
        myTableView.delegate = self;
        myTableView.dataSource = self;
        myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        myTableView.scrollEnabled=YES;
        [self.view addSubview:myTableView];
        
        index = 0;
        imagesBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 75*rows)];
        imageviews = [[NSMutableArray alloc] initWithCapacity:[data count]];
        
        imagesBack.backgroundColor =  [UIColor clearColor];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 75*rows)];
        [backgroundImageView setImage:[UIImage imageNamed:@"background.png"]];
        [imagesBack addSubview:backgroundImageView];
        
        scrollImages.delegate = self;
        scrollImages.pagingEnabled = YES;
        scrollImages.showsHorizontalScrollIndicator = NO;
        CGSize size = scrollImages.frame.size;
        for (int i=0; i < [data count]; i++) {
            EGOImageView *iv = [[EGOImageView alloc] initWithFrame:CGRectMake(size.width * i, 0, size.width, size.height)];
            NSLog(@"123_%@",[data objectAtIndex:i]);
            iv.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host_url, [data objectAtIndex:i]]];
            iv.contentMode=UIViewContentModeScaleAspectFit;
            [scrollImages addSubview:iv];
            iv = nil;
        }
        [scrollImages setContentSize:CGSizeMake(size.width * [data count], size.height)];
        pos=0;
        for (int i=0; i<[data count]; i++) {
            int row = i/4;
            EGOImageView *iv = [[EGOImageView alloc] initWithFrame:CGRectMake(70*(i%4)+5*(i%4+1), (70+5) * row, 70, 70)];
            iv.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host_url,[data objectAtIndex:i]]];
            iv.contentMode=UIViewContentModeScaleAspectFit;
            [imagesBack addSubview:iv];
            [imageviews addObject:iv];
            iv = nil;
            pos=i;
        }
        
        pos=pos+1;
        if([data count]<8 && b_myinfo){
            int row = pos/4;
            CGRect rect = CGRectMake(70*(pos%4)+5*(pos%4+1), (70+5) * row, 70, 70);
            
            UIImageView *iv = [[UIImageView alloc] initWithFrame:rect];
            iv.image = [UIImage imageNamed:@"add.jpg"];
            iv.contentMode=UIViewContentModeScaleAspectFit;
            [imagesBack addSubview:iv];
            [imageviews addObject:iv];
            iv = nil;
        }
        
        pf = [[PicFrame alloc] initWithFrame:((UIImageView*)[imageviews objectAtIndex:index]).frame];
        [imagesBack addSubview:pf];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [singleTap setNumberOfTapsRequired:1];
        [scrollImages addGestureRecognizer:singleTap];
        [singleTap release];
        
        UITapGestureRecognizer *smallImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageTap:)];
        [smallImageTap setNumberOfTapsRequired:1];
        [imagesBack addGestureRecognizer:smallImageTap];
        [smallImageTap release];
        
        myTableView.tableHeaderView = imagesBack;
        
        if(!b_myinfo)
        {
            m_pToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height -  40.0, self.view.frame.size.width, 40.0)];
            [m_pToolBar setBarStyle:UIBarStyleBlackOpaque];
            //[m_pToolBar setBackgroundImage:[UIImage imageNamed:@"bottom_banner_bg.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
            m_pToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
            
            //发消息
            m_pButtonAdd = [UIButton buttonWithType:UIButtonTypeCustom];
            [m_pButtonAdd setFrame:CGRectMake(0, 286, 80, 35)];
            [m_pButtonAdd addTarget:self action:@selector(sendMsg:) forControlEvents:UIControlEventTouchUpInside];
            [m_pButtonAdd setTitle:@"发送消息" forState:UIControlStateNormal]; 
            [m_pButtonAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            UIBarButtonItem *mBarButtonItemButtonAdd = [[UIBarButtonItem alloc] initWithCustomView:m_pButtonAdd];
            
            //添加关注
            m_pButtonAdd2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [m_pButtonAdd2 setFrame:CGRectMake(90, 286.0, 80, 35)];
            [m_pButtonAdd2 addTarget:self action:@selector(FollowTA:) forControlEvents:UIControlEventTouchUpInside];
            [m_pButtonAdd2 setTitle:@"添加关注" forState:UIControlStateNormal]; 
            [m_pButtonAdd2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            UIBarButtonItem *mBarButtonItemButtonAdd2 = [[UIBarButtonItem alloc] initWithCustomView:m_pButtonAdd2];
            
            //拉黑/举报
            m_pButtonAdd3 = [UIButton buttonWithType:UIButtonTypeCustom];
            [m_pButtonAdd3 setFrame:CGRectMake(180, 286.0, 80, 35)];
            [m_pButtonAdd3 addTarget:self action:@selector(sendtoblacklist:) forControlEvents:UIControlEventTouchUpInside];
            [m_pButtonAdd3 setTitle:@"拉黑举报" forState:UIControlStateNormal]; 
            [m_pButtonAdd3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            UIBarButtonItem *mBarButtonItemButtonAdd3 = [[UIBarButtonItem alloc] initWithCustomView:m_pButtonAdd3];
            
            UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]; 
            
            [m_pToolBar setItems:[NSArray arrayWithObjects:mBarButtonItemButtonAdd, mBarButtonItemButtonAdd2,mBarButtonItemButtonAdd3,nil]];
            
            [flexibleSpace release];
            
            [self.view addSubview:m_pToolBar];
        }
    }
}

#pragma mark-- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (pageControlUsed) {
        return;
    }
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pagecontrol.currentPage = page;
    index = page;
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
    pf.frame = ((UIImageView*)[imageviews objectAtIndex:index]).frame;
    [pf setAlpha:0];
    [UIView animateWithDuration:0.2f animations:^(void){
        [pf setAlpha:.85f];
    }];
}

- (IBAction)chagepage:(id)sender {
    int page = pagecontrol.currentPage;
    index = page;
	
    CGRect frame = scrollImages.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollImages scrollRectToVisible:frame animated:YES];
    
    pageControlUsed = YES;
    pf.frame = ((UIImageView*)[imageviews objectAtIndex:index]).frame;
    [pf setAlpha:0];
    [UIView animateWithDuration:0.2f animations:^(void){
        [pf setAlpha:.85f];
    }];
    
}
- (void) handleSingleTap:(UITapGestureRecognizer *) gestureRecognizer{
    
    [scrollImages setHidden:TRUE];
    [subview setHidden:TRUE]; 
}

- (void) handleImageTap:(UITapGestureRecognizer *) gestureRecognizer{
    
    
    CGFloat rowHeight = 75;
    CGFloat columeWith = 75;
    CGFloat gap = 5;
    
    CGPoint loc = [gestureRecognizer locationInView:imagesBack];
    NSInteger touchIndex = floor(loc.x / (columeWith + gap)) + 4 * floor(loc.y / (rowHeight + gap)) ;
    //NSLog(@"%d",[data count]);
    if (touchIndex <= [data count]-1) {
        
        subview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        subview.backgroundColor =  [UIColor blackColor];
        [self.view addSubview:subview];
        
        [scrollImages setHidden:FALSE];
        [self.view bringSubviewToFront:scrollImages];
        
        index = touchIndex;
        pagecontrol.currentPage = index;
        CGRect frame = scrollImages.frame;
        frame.origin.x = frame.size.width * touchIndex;
        frame.origin.y = 0;
        [scrollImages scrollRectToVisible:frame animated:NO];
        
        pageControlUsed = YES;
        pf.frame = ((UIImageView*)[imageviews objectAtIndex:index]).frame;
        [pf setAlpha:0];
        [UIView animateWithDuration:0.2f animations:^(void){
            [pf setAlpha:.85f];
        }]; 
    }else if(touchIndex == [data count] && b_myinfo){
        [scrollImages setHidden:TRUE];
        
        //调用UIActionSheet
        UIActionSheet *menu = [[UIActionSheet alloc]
                               initWithTitle: @"添加图片"
                               delegate:self
                               cancelButtonTitle:@"取消"
                               destructiveButtonTitle:@"相册"
                               otherButtonTitles:@"拍照",nil];
        [menu showInView:[UIApplication sharedApplication].keyWindow];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //printf("User Pressed Button %d\n", buttonIndex + 1);
    
    switch (buttonIndex) {
        case 0:
            [self getExistintPicture];
            break;
        case 1:
            [self getCameraPicture];
            break;
    }
    
    [actionSheet release];
}



-(void)dismissWin
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)editInfo
{
    
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(b_myinfo)
        return 5;
    else
        return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{  
    NSInteger i_row=0;
    if(b_myinfo){
        switch (section) {
            case 0:
                i_row = 4;
                break;
            case 1:
                i_row = 4;
                break;
            case 2:
                i_row = 5;
                break;
            case 3:
                i_row=4;
                break;
            case 4:
                i_row=4;
                break;
                
        }
    }else{
        switch (section) {
            case 0:
                i_row = 4;
                break;
            case 1:
                i_row=2;
                break;
            case 2:
                i_row = 4;
                break;
            case 3:
                i_row = 5;
                break;
            case 4:
                i_row=4;
                break;
            case 5:
                i_row=4;
                break;
                
        }
    }
    return i_row;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *retStr=@"";
    if(b_myinfo){
        switch (section) {
            case 0:
                retStr = @"";
                break;
            case 1:
                retStr = @"基本信息";
                break;
            case 2:
                retStr = @"个人介绍";
                break;
            case 3:
                retStr = @"拼车信息";
                break;
            case 4:
                retStr = @"绑定信息";
                break;
        }
    }else{
        switch (section) {
            case 0:
                retStr = @"";
                break;
            case 1:
                retStr = @"";
                break;
            case 2:
                retStr = @"基本信息";
                break;
            case 3:
                retStr = @"个人介绍";
                break;
            case 4:
                retStr = @"拼车信息";
                break;
            case 5:
                retStr = @"绑定信息";
                break;
        }
    }
    
    return retStr;
}


- (UIView *)bubbleView:(NSString *)text{
	UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
	returnView.backgroundColor=[UIColor clearColor];
	UIFont *font = [UIFont systemFontOfSize:14];
	CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(150.0f, 1000.0f) lineBreakMode:UILineBreakModeCharacterWrap];
    
	UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, size.width, size.height-20)];
	//bubbleText.backgroundColor = [UIColor clearColor];
    [bubbleText setTextColor:[UIColor blackColor]];
	bubbleText.font = font;
	bubbleText.numberOfLines = 0;
	bubbleText.lineBreakMode = UILineBreakModeCharacterWrap;
	bubbleText.text = text;
	
	returnView.frame = CGRectMake(0.0f, 0.0f, 300.0f, size.height);//+112
	
	[returnView addSubview:bubbleText];
	[bubbleText release];
    
	return [returnView autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(void)getMyPic
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *userid=@"";
    if(b_myinfo){
        userid = [userDefault objectForKey:@"login_user_id"];
    }else{
        userid = [mydict objectForKey:@"userid"];
    }
    NSString *tmp=[NSString stringWithFormat:@"%@getMemberPic.php?u=%@",host_url, userid];
    NSLog(@"%@",tmp);
    
    NSMutableURLRequest *req = [[NSMutableURLRequest new] autorelease];      
    
    [req setURL:[NSURL URLWithString:tmp]];
    [req setHTTPMethod:@"GET"];     
    [req addValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [req setTimeoutInterval:10.0f];
    
    
    NSHTTPURLResponse* urlResponse = nil;  
	NSError *error = [[NSError alloc] init]; 
    NSData *responseData = [NSURLConnection sendSynchronousRequest:req returningResponse:&urlResponse error:&error];  
	NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",result);
    
    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {    
        NSDictionary *dict = [result JSONValue];
        NSArray *resultArr = (NSArray *)dict;
        NSLog(@"%d",[resultArr count]);
        int n = [resultArr count];
        if(n > 0){
            for (NSDictionary *item in resultArr) {
                [data addObject:[item objectForKey: @"x_pic"]];
            }
        }else{
            [data addObject:@"upload/no.jpg"];
        }
        
    }
}

- (int)getMemberInfo
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *userid = @"";
    NSString *myid=@"";
    if(b_myinfo){
        userid = [userDefault objectForKey:@"login_user_id"];
        myid = userid;
    }else{
        userid = [mydict objectForKey:@"userid"];
        myid = [userDefault objectForKey:@"login_user_id"];
    }
    ClientConnection *client = [[ClientConnection alloc] init];
    mydict = [[NSMutableDictionary alloc] init];
    mydict = [client getMyinfo:userid loginUserId:myid];
    self.navigationItem.title = [mydict objectForKey:@"username"];
    
    NSString *relation =[NSString stringWithFormat:@"%@",[mydict objectForKey: @"relation"]];
    // NSLog(@"%@",relation);
    
    if([relation isEqualToString:@"0"]){
        [m_pButtonAdd2 setTitle:@"添加关注" forState:UIControlStateNormal];
        [mydict setValue:@"陌生人" forKey:@"relation"];
    }else if([relation isEqualToString:@"1"]){
        [m_pButtonAdd2 setTitle:@"取消关注" forState:UIControlStateNormal];
        [mydict setValue:@"关注" forKey:@"relation"];
    }else if([relation isEqualToString:@"2"]){
        [m_pButtonAdd2 setTitle:@"取消关注" forState:UIControlStateNormal];
        [mydict setValue:@"互为好友" forKey:@"relation"];
    }else{
        [m_pButtonAdd2 setTitle:@"添加关注" forState:UIControlStateNormal];
        [mydict setValue:@"陌生人" forKey:@"relation"];
    }
    [client release];
    
    return [mydict count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [myTableView deselectRowAtIndexPath:
     [myTableView indexPathForSelectedRow] animated:NO];
    
    int i_tag=0;
    if(b_myinfo)
    {
        if(indexPath.section==0&&indexPath.row==0){
            //会员昵称
            i_tag = TAG_USERNAME;
        }else if(indexPath.section==0&&indexPath.row==2){
            //职业
            i_tag = TAG_ZHIYE;
        }else if(indexPath.section==0&&indexPath.row==3){
            //个性签名
            i_tag = TAG_QIANMING;
        }else if(indexPath.section==1&&indexPath.row==1){
            //年龄
            i_tag = TAG_AGE;
        }else if(indexPath.section==1&&indexPath.row==2){
            //年龄
            i_tag = TAG_AGE;
        }else if(indexPath.section==2&&indexPath.row==0){
            //爱好
            i_tag = TAG_AIHAO;
        }else if(indexPath.section==2&&indexPath.row==1){
            //公司
            i_tag = TAG_GONGSI;
        }else if(indexPath.section==2&&indexPath.row==2){
            //学校
            i_tag = TAG_XUEXIAO;
        }else if(indexPath.section==2&&indexPath.row==3){
            //常出没的地方
            i_tag = TAG_DIFANG;
        }else if(indexPath.section==2&&indexPath.row==4){
            //个人主页
            i_tag = TAG_ZHUYE;
        }else if(indexPath.section==3&&indexPath.row==0){
            //座驾
            i_tag = TAG_ZUOJIA;
        }else if(indexPath.section==3&&indexPath.row==1){
            //驾龄
            i_tag = TAG_JIALING;
        }else if(indexPath.section==3&&indexPath.row==2){
            //常走的路线
            i_tag = TAG_LUXIAN;
        }else if(indexPath.section==3&&indexPath.row==3){
            //车牌尾号
            i_tag = TAG_WEIHAO;
        }
    }else{
        
    }
    
    if(i_tag>0 & i_tag<13){
        vcEdit = [[EditItemsViewController alloc] initWithNibName:@"EditItemsViewController" bundle:nil];
        vcEdit.tag = i_tag;
        vcEdit.mydict=mydict;
        [self.navigationController pushViewController:vcEdit animated:TRUE];
    }
    
    if((indexPath.section==3 && indexPath.row==2 && b_myinfo) || (indexPath.section==4 && indexPath.row==2 &&!b_myinfo)){
        if([[mydict objectForKey:@"startposname"] isEqualToString:@""]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该会员还未设置路线" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            [alertView release];
            
        }else{
            vcRoad = [[MyRoadVC alloc] initWithNibName:@"MyRoadVC" bundle:nil];
            vcRoad.member_id = [mydict objectForKey:@"userid"];
            vcRoad.username = [mydict objectForKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"s_ann_subtitle"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"e_ann_subtitle"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"s_latitude"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"e_latitude"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"s_longitude"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"e_longitude"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"starttime"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"endtime"];
            
            [self.navigationController pushViewController:vcRoad animated:TRUE];
        }
    }else{
        if(indexPath.section==4&&indexPath.row==0&&b_myinfo){
            if([[mydict objectForKey:@"sina_weibo_id"] isEqualToString:@""]){
                i_tag = TAG_SINA;
                
                //初始化列表
                list = [[NSMutableArray alloc] initWithCapacity:0];
                NSHTTPCookie *cookie;
                NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                for (cookie in [storage cookies]) {
                    [storage deleteCookie:cookie];
                }
                [[NSUserDefaults standardUserDefaults] setObject:@"sina" forKey:@"bind"];
                [self.navigationController pushViewController:[[[ExampleShareText alloc] initWithNibName:nil bundle:nil] autorelease] animated:YES];
                
            }
            
        }else if(indexPath.section==4&&indexPath.row==1){
            if([[mydict objectForKey:@"renren_id"] isEqualToString:@""]){
                i_tag = TAG_RENREN;
                
                //初始化列表
                list = [[NSMutableArray alloc] initWithCapacity:0];
                NSHTTPCookie *cookie;
                NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                for (cookie in [storage cookies]) {
                    [storage deleteCookie:cookie];
                }
                [[NSUserDefaults standardUserDefaults] setObject:@"renren" forKey:@"bind"];
                [self.navigationController pushViewController:[[[ExampleShareText alloc] initWithNibName:nil bundle:nil] autorelease] animated:YES];
                
            }
            
        }else if(indexPath.section==4&&indexPath.row==2){
            if([[mydict objectForKey:@"douban_id"] isEqualToString:@""]){
                i_tag = TAG_DOUBAN;
                
                //初始化列表
                list = [[NSMutableArray alloc] initWithCapacity:0];
                NSHTTPCookie *cookie;
                NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                for (cookie in [storage cookies]) {
                    [storage deleteCookie:cookie];
                }
                [[NSUserDefaults standardUserDefaults] setObject:@"douban" forKey:@"bind"];
                [self.navigationController pushViewController:[[[ExampleShareText alloc] initWithNibName:nil bundle:nil] autorelease] animated:YES];
                
            }
            
        }else if(indexPath.section==4&&indexPath.row==3){
            i_tag = TAG_MAIL;
        }else{
            //不做任何操作
        }
    }
    
}

-(IBAction)sendMsg:(id)sender
{
//    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:HUD];	
//    HUD.dimBackground = YES;
//    HUD.delegate = self;
//    HUD.labelText = @"";
//    [HUD showWhileExecuting:@selector(loadSendMessageVC) onTarget:self withObject:nil animated:YES];
    [self loadSendMessageVC];
    
}

-(void)sendtoblacklist:(id)sender{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *userid = [userDefault objectForKey:@"login_user_id"];
    NSString *bid=@"";
    bid = [mydict objectForKey:@"userid"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userid forKey:@"userid"];
    [params setObject:bid forKey:@"bid"];
    
    NSString *postURL=[Utility createPostURL:params];
    NSString *baseurl=@"updateBlacklist.php";
    
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
        } else if ([request responseString]) {
            NSString *result = [request responseString];
            //NSLog(@"%@",result);
            NSDictionary *dict = [result JSONValue];
            if([[dict objectForKey: @"regTag"] isEqualToNumber:[NSNumber numberWithInt:1]]){            
                //拉黑成功
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"拉黑成功，请查看黑名单" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alertView.tag=10;
                [alertView show];
                [alertView release];
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                [alertView release];
            }
        }
    }else{
        NSLog(@"request is nil.");
    }
    
}

- (void)loadSendMessageVC
{
    vcMessage = [[SendMessageVC alloc] init];
    vcMessage.t_userid=[mydict objectForKey:@"userid"];
    vcMessage.t_username=[mydict objectForKey:@"username"];
    UINavigationController* nav = [[[UINavigationController alloc] initWithRootViewController:vcMessage] autorelease];
    [self.navigationController presentModalViewController:nav animated:YES];
}

- (IBAction)FollowTA:(id)sender
{
//    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:HUD];	
//    HUD.dimBackground = YES;
//    HUD.delegate = self;
//    HUD.labelText = @"";
//    [HUD showWhileExecuting:@selector(addfollow) onTarget:self withObject:nil animated:YES];
    [self addfollow];
    
}

-(void)addfollow
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *login_user_id = [userDefault objectForKey:@"login_user_id"];
    NSString *userid=@"";
    userid = [mydict objectForKey:@"userid"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userid forKey:@"u"];
    [params setObject:login_user_id forKey:@"my"];
    
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    
    NSString *baseurl=@"addfollow.php";
    
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
            //NSLog(@"%@",result);
            NSDictionary *dict = [result JSONValue];
            if([[dict objectForKey: @"regTag"] isEqualToNumber:[NSNumber numberWithInt:1]]){            
                //关注成功
                [m_pButtonAdd2 setTitle:@"取消关注" forState:UIControlStateNormal];
                [mydict setValue:@"关注" forKey:@"relation"];
                [myTableView reloadData];
            }else if([[dict objectForKey: @"regTag"] isEqualToNumber:[NSNumber numberWithInt:0]]){            
                //取消关注
                [m_pButtonAdd2 setTitle:@"添加关注" forState:UIControlStateNormal];
                [mydict setValue:@"陌生人" forKey:@"relation"];
                [myTableView reloadData];
            }else if([[dict objectForKey: @"regTag"] isEqualToNumber:[NSNumber numberWithInt:2]]){            
                //互为好友
                [m_pButtonAdd2 setTitle:@"取消关注" forState:UIControlStateNormal];
                [mydict setValue:@"互为好友" forKey:@"relation"];
                [myTableView reloadData];
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                [alertView release];
            }
        }
    }else{
        NSLog(@"request is nil.");
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        self.title=@"会员资料";
        // 创建拍照控件对象
        self.imagePicker = [[[UIImagePickerController alloc] init] autorelease];
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
        {
            NSLog(@"模拟器没有摄像头");
        }else{
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;        
            // 设置媒体类型为所有对照相机有效的类型
            self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            self.imagePicker.allowsEditing = NO;
            // 设置拍照控件对象的委托
            self.imagePicker.delegate = self;
        }
    }
    return self;
}

// 打开摄像头
- (IBAction)getCameraPicture{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker =
        [[UIImagePickerController alloc] init];
        picker.delegate = self; 
        picker.allowsEditing = YES;
        // 摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentModalViewController:picker animated:YES];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Error" 
                              message:@"你没有摄像头" 
                              delegate:nil 
                              cancelButtonTitle:@"Drat!" 
                              otherButtonTitles:nil];
        [alert show];
    }
    
}

// 选取图片
- (IBAction)getExistintPicture
{
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker =
        [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        // 图片库
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentModalViewController:picker animated:YES];
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Error accessing photo library" 
                              message:@"Device does not support a photo library" 
                              delegate:nil 
                              cancelButtonTitle:@"Drat!" 
                              otherButtonTitles:nil];
        [alert show];
    }
    
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // 处理静态照片
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        if (editedImage) {
            imageToSave = editedImage;
        }
        else {
            imageToSave = originalImage;
        }
        // 将静态照片（原始的或者被编辑过的）保存到相册（Camera Roll）
        UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
        // 根据图片控件的尺寸缩放照片（只是为了显示效果。实际传输时依然使用原始照片）
        UIImage* scaledImage = [self imageWithImage:imageToSave scaledToSize:self.imageView.bounds.size];
        self.imageView.image = scaledImage;
        // 缓存传输照片
        self.imagePicture = imageToSave;
    }
    UploadOp *op = [[[UploadOp alloc] init] autorelease];
    op.imageToSend = self.imagePicture;
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    op.email = [userDefault objectForKey:@"login_user"];
    NSString *result = [op uploading];
    NSLog(@"Result of Uploading: %@", result);
    
    
    [self viewDidLoad];
    [myTableView reloadData];
    
    [picker dismissModalViewControllerAnimated:YES];
    [picker release];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
    [picker release];
}

#pragma mark - Utilities

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void) sinaError:(NSError *)_error
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"错误信息"
                              message:@"登录失败"
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

- (void)continueClicked {
	
	NSString *consumerKey = tencentAppKey;
	NSString *consumerSecret = tencentAppSecret;
	
	if (![consumerKey isEqualToString:@""] && ![consumerSecret isEqualToString:@""]) {
        QWeiboSyncApi *api = [[[QWeiboSyncApi alloc] init] autorelease];
        NSString *retString = [api getRequestTokenWithConsumerKey:consumerKey consumerSecret:consumerSecret];
        //NSLog(@"Get requestToken:%@", retString);
        
        NSDictionary *params = [NSURL parseURLQueryString:retString];
        
        QVerifyWebViewController *verifyController = [[QVerifyWebViewController alloc] init];
        verifyController.tokenKey = [params objectForKey:@"oauth_token"];
        verifyController.tokenSecret = [params objectForKey:@"oauth_token_secret"];
        
        [self.navigationController pushViewController:verifyController animated:TRUE];		
	}
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommentViewCell";
    
    CommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CommentViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    // Configure the cell...
    
    
    
    
    if(self.b_myinfo){
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }else {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    if(b_myinfo){
        switch (indexPath.section) {
            case 0:
                if(indexPath.row==0){
                    cell.nameLabel.text=@"名称：";
                    //NSLog(@"111_%@",[NSString stringWithFormat:@"%@",[mydict objectForKey:@"username"]]);
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@",[mydict objectForKey:@"username"]];
                }else if(indexPath.row==1){
                    cell.nameLabel.text=@"会员号：";
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@",[mydict objectForKey:@"userid"]];
                    cell.accessoryType=UITableViewCellAccessoryNone;
                }else if(indexPath.row==2){
                    cell.nameLabel.text=@"职业：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"zhiye"]];
                }else if(indexPath.row==3){
                    cell.nameLabel.text=@"个人签名：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"qianming"]];
                }
                break;
            case 1:
                if(indexPath.row==0){
                    NSString *sex = [mydict objectForKey:@"sex"];
                    if([sex isEqualToString:@"0"]){
                        sex=@"男 ♂";
                    }else {
                        sex=@"女 ♀";
                    }
                    cell.nameLabel.text=@"性别：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",sex];
                    cell.accessoryType=UITableViewCellAccessoryNone;
                }else if(indexPath.row==1){
                    cell.nameLabel.text=@"年龄：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"age"]];
                }else if(indexPath.row==2){
                    cell.nameLabel.text=@"星座：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"xingzuo"]];
                    cell.accessoryType=UITableViewCellAccessoryNone;
                }else if(indexPath.row==3){
                    cell.nameLabel.text=@"注册日期：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"regdate"]];
                    cell.accessoryType=UITableViewCellAccessoryNone;
                }
                break;
                
            case 2:
                if(indexPath.row==0){
                    cell.nameLabel.text=@"爱好和特点：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"aihao"]];
                }else if(indexPath.row==1){
                    cell.nameLabel.text=@"公司：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"gongsi"]];
                }else if(indexPath.row==2){
                    cell.nameLabel.text=@"学校：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"xuexiao"]];
                }else if(indexPath.row==3){
                    cell.nameLabel.text=@"常去的地方：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"difang"]];
                }else if(indexPath.row==4){
                    cell.nameLabel.text=@"个人主页：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"zhuye"]];
                }
                break;
            case 3:
                if(indexPath.row==0){
                    cell.nameLabel.text=@"座驾：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"zuojia"]];
                }else if(indexPath.row==1){
                    cell.nameLabel.text=@"驾龄：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"jialing"]];
                }else if(indexPath.row==2){
                    cell.nameLabel.text=@"常走路线：";
                    NSString *startposname = [NSString stringWithFormat:@"%@",[mydict objectForKey:@"startposname"]];
                    NSLog(@"%@",startposname);
                    if([startposname isEqualToString:@""]){
                        cell.contentLabel.text=[NSString stringWithFormat:@"%@",@"暂未提交拼车信息"];
                    }else{
                        cell.contentLabel.text=[NSString stringWithFormat:@"%@",@"点击查看详情"];
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }
                    
                }else if(indexPath.row==3){
                    cell.nameLabel.text=@"车牌尾号：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"weihao"]];
                }
                
                break;
                
            case 4:
                if(indexPath.row==0){
                    if([[mydict objectForKey:@"sina_weibo_id"] isEqualToString:@""]){
                        if(b_myinfo){
                            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                        }else{
                            cell.accessoryType=UITableViewCellAccessoryNone;
                        }
                        cell.nameLabel.text=@"新浪微博：";
                        cell.contentLabel.text=@"未绑定";
                    }else{
                        cell.accessoryType=UITableViewCellAccessoryNone;
                        cell.nameLabel.text=@"新浪微博：";
                        cell.contentLabel.text=@"已绑定";
                    }
                }else if(indexPath.row==1){                
                    if([[mydict objectForKey:@"renren_id"] isEqualToString:@""]){
                        if(self.b_myinfo)cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                        cell.nameLabel.text=@"人人帐号：";
                        cell.contentLabel.text=@"未绑定";
                    }else{
                        if(self.b_myinfo)cell.accessoryType=UITableViewCellAccessoryNone;
                        cell.nameLabel.text=@"人人帐号：";
                        cell.contentLabel.text=@"已绑定";
                    }
                    
                }else if(indexPath.row==2){
                    if([[mydict objectForKey:@"douban_id"] isEqualToString:@""]){
                        if(self.b_myinfo)cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                        cell.nameLabel.text=@"豆瓣帐号：";
                        cell.contentLabel.text=@"未绑定";
                    }else{
                        if(self.b_myinfo)cell.accessoryType=UITableViewCellAccessoryNone;
                        cell.nameLabel.text=@"豆瓣帐号：";
                        cell.contentLabel.text=@"已绑定";
                    }
                }else if(indexPath.row==3){
                    if(self.b_myinfo)cell.accessoryType=UITableViewCellAccessoryNone;
                    cell.nameLabel.text=@"验证邮箱：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"email"]];
                }
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.section) {
            case 0:
                if(indexPath.row==0){
                    cell.nameLabel.text=@"名称：";
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@",[mydict objectForKey:@"username"]];
                }else if(indexPath.row==1){
                    cell.nameLabel.text=@"会员号：";
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@",[mydict objectForKey:@"userid"]];
                    cell.accessoryType=UITableViewCellAccessoryNone;
                }else if(indexPath.row==2){
                    cell.nameLabel.text=@"职业：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"zhiye"]];
                }else if(indexPath.row==3){
                    cell.nameLabel.text=@"个人签名：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"qianming"]];
                }
                break;
            case 1:
                if(indexPath.row==0){
                    cell.nameLabel.text=@"位置信息：";
                    NSString *distance = [NSString stringWithFormat:@"%.2f",[[mydict objectForKey:@"distance"] floatValue]/1024];
                    cell.contentLabel.text= [NSString stringWithFormat:@"%@km",distance];
                }else if(indexPath.row==1){
                    cell.nameLabel.text=@"关系：";
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@",[mydict objectForKey:@"relation"]];
                    cell.accessoryType=UITableViewCellAccessoryNone;
                }
                break;
            case 2:
                if(indexPath.row==0){
                    NSString *sex = [NSString stringWithFormat:@"%@",[mydict objectForKey:@"sex"]];
                    if([sex isEqualToString:@"0"]){
                        sex=@"男 ♂";
                    }else {
                        sex=@"女 ♀";
                    }
                    cell.nameLabel.text=@"性别：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",sex];
                    cell.accessoryType=UITableViewCellAccessoryNone;
                }else if(indexPath.row==1){
                    cell.nameLabel.text=@"年龄：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"age"]];
                }else if(indexPath.row==2){
                    cell.nameLabel.text=@"星座：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"xingzuo"]];
                    cell.accessoryType=UITableViewCellAccessoryNone;
                }else if(indexPath.row==3){
                    cell.nameLabel.text=@"注册日期：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"regdate"]];
                    cell.accessoryType=UITableViewCellAccessoryNone;
                }
                break;
                
            case 3:
                if(indexPath.row==0){
                    cell.nameLabel.text=@"爱好/特点：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"aihao"]];
                }else if(indexPath.row==1){
                    cell.nameLabel.text=@"公司：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"gongsi"]];
                }else if(indexPath.row==2){
                    cell.nameLabel.text=@"学校：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"xuexiao"]];
                }else if(indexPath.row==3){
                    cell.nameLabel.text=@"常去之地：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"difang"]];
                }else if(indexPath.row==4){
                    cell.nameLabel.text=@"个人主页：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"zhuye"]];
                }
                break;
            case 4:
                if(indexPath.row==0){
                    cell.nameLabel.text=@"座驾：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"zuojia"]];
                }else if(indexPath.row==1){
                    cell.nameLabel.text=@"驾龄：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@年",[mydict objectForKey:@"jialing"]];
                }else if(indexPath.row==2){
                    cell.nameLabel.text=@"常走路线：";
                    NSString *startposname = [NSString stringWithFormat:@"%@",[mydict objectForKey:@"startposname"]];
                    NSLog(@"%@",startposname);
                    if([startposname isEqualToString:@""]){
                        cell.contentLabel.text=[NSString stringWithFormat:@"%@",@"暂未提交拼车信息"];
                    }else{
                        cell.contentLabel.text=[NSString stringWithFormat:@"%@",@"点击查看详情"];
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }
                }else if(indexPath.row==3){
                    cell.nameLabel.text=@"车牌尾号：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"weihao"]];
                }
                
                break;
                
            case 5:
                if(indexPath.row==0){
                    if([[mydict objectForKey:@"sina_weibo_id"] isEqualToString:@""]){
                        if(b_myinfo){
                            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                        }else{
                            cell.accessoryType=UITableViewCellAccessoryNone;
                        }
                        cell.nameLabel.text=@"新浪微博：";
                        cell.contentLabel.text=@"未绑定";
                    }else{
                        cell.accessoryType=UITableViewCellAccessoryNone;
                        cell.nameLabel.text=@"新浪微博：";
                        cell.contentLabel.text=@"已绑定";
                    }
                }else if(indexPath.row==1){                
                    if([[mydict objectForKey:@"renren_id"] isEqualToString:@""]){
                        if(self.b_myinfo)cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                        cell.nameLabel.text=@"人人帐号：";
                        cell.contentLabel.text=@"未绑定";
                    }else{
                        if(self.b_myinfo)cell.accessoryType=UITableViewCellAccessoryNone;
                        cell.nameLabel.text=@"人人帐号：";
                        cell.contentLabel.text=@"已绑定";
                    }
                    
                }else if(indexPath.row==2){
                    if([[mydict objectForKey:@"renren_id"] isEqualToString:@""]){
                        if(self.b_myinfo)cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                        cell.nameLabel.text=@"豆瓣帐号：";
                        cell.contentLabel.text=@"未绑定";
                    }else{
                        if(self.b_myinfo)cell.accessoryType=UITableViewCellAccessoryNone;
                        cell.nameLabel.text=@"豆瓣帐号：";
                        cell.contentLabel.text=@"已绑定";
                    }
                }else if(indexPath.row==3){
                    if(self.b_myinfo)cell.accessoryType=UITableViewCellAccessoryNone;
                    cell.nameLabel.text=@"验证邮箱：";
                    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[mydict objectForKey:@"email"]];
                }
                break;
            default:
                break;
        }
    }
    
    
    [cell.contentLabel sizeToFit];
    double height = 25 + cell.contentLabel.frame.size.height;
    if([cell.contentLabel.text isEqualToString:@""]){
        height = 40;
    }
    cell.frame = CGRectMake(0, 0, 320, height);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}





@end
