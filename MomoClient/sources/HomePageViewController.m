//
//  HomePageViewController.m
//  TicketSystem
//
//  Created by ZYVincent on 12-3-8.
//  Copyright (c) 2012年 __ZYProSoft__. All rights reserved.
//  http://www.ruyijian.com
//    团队QQ群号：219357847
//    团队主题：奋斗路上携手相伴！

#import "HomePageViewController.h"
//#import "ZYProSoftNotiCell.h"
//#import "ZYProSoftNotiContentViewController.h"
//#import "Uitil.h"

@interface HomePageViewController(private)
- (void)getLatestServerUpdateTimeNow;
- (void)getAllZYProSoftNotiNow;
@end
@implementation HomePageViewController
@synthesize currentNotiArray;


//按类型返回图片
- (UIImage *)returnIconImageWithNotiType:(NSInteger)type
{
    UIImage *resultImage = nil;
    /*switch (type) {
        case NOTI_TYPE_NOTI:
            resultImage = [UIImage imageNamed:@"notiTypeNoti.png"];
            break;
        case NOTI_TYPE_MEETING:
            resultImage = [UIImage imageNamed:@"notiTypeMeeting.png"];

            break;
        case NOTI_TYPE_GONGXI:
            resultImage = [UIImage imageNamed:@"notiTypeGongXi.png"];

            break;
        case NOTI_TYPE_GONGGAO:
            resultImage = [UIImage imageNamed:@"notiTypeGongGao.png"];

            break;
        case NOTI_TYPE_JINJI:
            resultImage = [UIImage imageNamed:@"notiTypeJinJi.png"];

            break;
        case NOTI_TYPE_QITA:
            resultImage = [UIImage imageNamed:@"notiTypeQiTa.png"];
            break;
        case NOTI_TYPE_JINGGAO:
            resultImage = [UIImage imageNamed:@"notiTypeJingGao.png"];
            break;
        default:
            resultImage = [UIImage imageNamed:@"notiTypeQiTa.png"];

            break;
    }*/
    return resultImage;
}
//判定视图是否可以推出
- (BOOL)pushViewNowIsUnEnable
{
    if (chooseTypeViewCanMove == NO) {
        return YES;//只要有一个推出就不可以推出新得view
    }
    return NO;
}

//覆盖刷新方法
- (void)refresh
{
    
    [self performSelector:@selector(getAllZYProSoftNotiNow) withObject:nil afterDelay:0.2];

}
//立即刷新
- (void)refreshNow
{

    [self.tableView setContentOffset:CGPointMake(0, -100)];
    [self startLoading];
    
}

//获取通知信息
- (void)getAllZYProSoftNotiNow
{

    //组合查询参数
    /*NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",QUERY_NEW_ZYPROSOFT_NOTI_TYPE],@"queryType",[[NSUserDefaults standardUserDefaults]objectForKey:@"currentRequestTime"], @"param1",nil];
    [[ZYNetworkHelper shareZYNetworkHelper]requestDataWithApplicationType:TicketSystemRequestQueryType withParams:paramDict withHelperDelegate:self withSuccessRequestMethod:@"getZYProSoftNotiSuccess:" withFaildRequestMethod:@"getZYProSoftNotiFaild:"]; */
    
}
//获取通知信息成功
- (void)getZYProSoftNotiSuccess:(NSObject *)result
{
    /*
    [self stopLoading];
    if (self.currentNotiArray) {
        self.currentNotiArray = nil;
        self.currentNotiArray = [NSMutableArray array];
    }
    //解析noti对象
    NSArray *resultArray = (NSArray *)result;
    for (NSDictionary *item in resultArray) {
        ZYProSoftNoti *tempNoti = [[ZYProSoftNoti alloc]init];
        tempNoti.noti_id = [item objectForKey:@"team_noti_id"];
        tempNoti.noti_type = [item objectForKey:@"team_noti_type"];
        tempNoti.noti_subject = [item objectForKey:@"team_noti_subject"];
        tempNoti.noti_users = [item objectForKey:@"team_noti_users"];
        tempNoti.noti_content = [item objectForKey:@"team_noti_content"];
        tempNoti.noti_dateTime = [item objectForKey:@"update_time"];
            
        [self.currentNotiArray insertObject:tempNoti atIndex:0];
        [tempNoti release];
    }
    self.navigationItem.leftBarButtonItem = nil;//消失左边导航按钮
    [self.tableView reloadData];//刷新数据
    [self stopLoading];
     */
}
//获取通知信息失败
- (void)getZYProSoftNotiFaild:(NSObject *)result
{
    [self stopLoading];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //贴皮肤
    UIImageView *backImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"homePageBackground.png"]];
    self.tableView.backgroundView = backImgView;
    [backImgView release];
    
    //搜索栏换皮肤
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchBar.backgroundImgView.image = [UIImage imageNamed:@"searchBarBackground.png"];
    [self.searchBar.typeSelectButton setBackgroundImage:[UIImage imageNamed:@"typeSelectButton.png"]forState:UIControlStateNormal];
    [self.searchBar.searchButton setBackgroundImage:[UIImage imageNamed:@"searchButton.png"] forState:UIControlStateNormal];
    self.searchBar.searchField.placeholder = @"请选择查询类型，默认为公告类型";
    //在导航条右侧添加一个刷新按钮
    UIBarButtonItem *rightRefreshItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshNow)];
    self.navigationItem.rightBarButtonItem = rightRefreshItem;
    [rightRefreshItem release];
    
    /*
    //初始化选择类型
    NSArray *indexArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",NOTI_TYPE_GONGGAO],[NSString stringWithFormat:@"%d",NOTI_TYPE_NOTI],[NSString stringWithFormat:@"%d",NOTI_TYPE_GONGXI],[NSString stringWithFormat:@"%d",NOTI_TYPE_JINGGAO],[NSString stringWithFormat:@"%d",NOTI_TYPE_JINJI],[NSString stringWithFormat:@"%d",NOTI_TYPE_MEETING],[NSString stringWithFormat:@"%d",NOTI_TYPE_QITA], nil];
    NSArray *titleArray = [NSArray arrayWithObjects:@"公告",@"通知", @"恭喜", @"警告", @"紧急", @"会议", @"其他", nil];
    //添加选择类型得View
    chooseTypeView = [[ChooseTypeView alloc]init];
    chooseTypeView.delegate = self;
    chooseTypeView.indexArray = indexArray;
    chooseTypeView.sourceArray = titleArray;
    chooseTypeView.cancelBtn.tag = NOTI_CHOOSETYPE_CANCEL_BUTTON_TAG;
    chooseTypeView.yesBtn.tag = NOTI_CHOOSETYPE_YES_BUTTON_TAG;
    chooseTypeView.frame = CGRectMake(0, 480, 320, 200);
    [self.tabBarController.view addSubview:chooseTypeView];
    [chooseTypeView release];
    
    //生成一个当前时间得时间
    NSString *currentTime = [Uitil returnCurrentDateTime];
    [[NSUserDefaults standardUserDefaults]setObject:currentTime forKey:@"currentRequestTime"];
    
    //初始化noti数组
    currentNotiArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    //初始化是需要更新的
    ifNeedUpdateNow = YES;
    
    //默认查询类型
    selectTypeIndex = NOTI_TYPE_GONGGAO;
    
    //默认可以推出
    chooseTypeViewCanMove = YES;
        
    //获取最新通知
    [self refreshNow];
     */
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.currentNotiArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
/*
- (ZYProSoftNotiCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ZYProSoftNotiCell *cell = (ZYProSoftNotiCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ZYProSoftNotiCell" owner:self options:nil]objectAtIndex:0];
    }
    // Configure the cell...
    //cell贴皮肤
    UIImageView *cellNormal = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"notiCellBackgroundNormal.png"]];
    UIImageView *cellSelected = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"notiCellBackgroundSelected.png"]];
    cell.backgroundView = cellNormal;
    cell.selectedBackgroundView = cellSelected;
    [cellNormal release];
    [cellSelected release];
    
    //设置数据
    ZYProSoftNoti *noti = [self.currentNotiArray objectAtIndex:indexPath.row];
    [cell setWithNotiSubject:noti.noti_subject withNotiUser:noti.noti_users];
    cell.notiTypeImgView.image = [self returnIconImageWithNotiType:[noti.noti_type intValue]];//设置图片
    NSInteger notiType = [noti.noti_type intValue];
    if (notiType == NOTI_TYPE_JINGGAO || notiType == NOTI_TYPE_MEETING || notiType == NOTI_TYPE_JINJI) {
        cell.subjectLabel.textColor = [UIColor redColor];
    }
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    ZYProSoftNoti *noti = [self.currentNotiArray objectAtIndex:indexPath.row];
    ZYProSoftNotiContentViewController *detailViewController = [[ZYProSoftNotiContentViewController alloc]initWithNibName:@"ZYProSoftNotiContentViewController" bundle:nil];
    detailViewController.selfNoti = noti;
    [self.navigationController pushViewController:detailViewController animated:YES];
    */
}

//选择类型视图代理
- (void)tapOnChooseTypeViewButton:(id)sender withSelectIndex:(NSInteger)index
{
    /*
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case NOTI_CHOOSETYPE_CANCEL_BUTTON_TAG:
            [ZYViewAnimation animationBasicBottomForwordView:chooseTypeView duration:0.3 destination:200];
            chooseTypeViewCanMove = YES;//恢复可以推出
            searchBar.searchButton.enabled = YES;//恢复搜索按钮
            break;
        case NOTI_CHOOSETYPE_YES_BUTTON_TAG:
            [ZYViewAnimation animationBasicBottomForwordView:chooseTypeView duration:0.3 destination:200];
            chooseTypeViewCanMove = YES;//恢复可以推出 
            searchBar.searchButton.enabled = YES;//恢复搜索按钮
            
            selectTypeIndex = index;
            [searchBar.typeSelectButton setTitle:@"查询类型" forState:UIControlStateNormal];
            //临时改变按钮标题
            switch (index) {
                case NOTI_TYPE_GONGGAO:
                    searchBar.searchField.text = @"所有 公告类型";
                    break;
                case NOTI_TYPE_NOTI:
                    searchBar.searchField.text = @"所有 通知类型";
                    break;
                case NOTI_TYPE_GONGXI:
                    searchBar.searchField.text = @"所有 恭喜类型";
                    break;
                case NOTI_TYPE_JINGGAO:
                    searchBar.searchField.text = @"所有 警告类型";
                    break;
                case NOTI_TYPE_MEETING:
                    searchBar.searchField.text = @"所有 会议类型";
                    break;
                case NOTI_TYPE_QITA:
                    searchBar.searchField.text = @"所有 其他类型";
                    break;
                case NOTI_TYPE_JINJI:
                    searchBar.searchField.text = @"所有 紧急类型";

                    break;
                default:
                    searchBar.searchField.text = @"所有 其他类型";
                    break;
            }
            break;
        default:
            break;
    }
*/
}
//搜索栏方法覆盖
- (void)beginChooseType:(id)sender
{
    /*
    //如果现在不能推出新得view直接返回
    if ([self pushViewNowIsUnEnable]) {
        return;
    }
    [ZYViewAnimation animationBasicTopForwordView:chooseTypeView duration:0.3 destination:200];
    chooseTypeViewCanMove = NO;//已经被推出来了，不能再移动了
    searchBar.searchButton.enabled = FALSE;//禁止搜索按钮，必须选择类型
     */
}
- (void)searchResultWithKeyWord:(NSString *)keyword
{
    /*
    //组合查询参数
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",QUERY_NOTI_BY_NOTI_TYPE],@"queryType",[NSString stringWithFormat:@"%d",selectTypeIndex],@"param1",nil];
    [[ZYNetworkHelper shareZYNetworkHelper]requestDataWithApplicationType:TicketSystemRequestQueryType withParams:paramDict withHelperDelegate:self withSuccessRequestMethod:@"searchNotiSuccess:" withFaildRequestMethod:@"searchNotiFaild:"];
    [MBProgressHUD showHUDAddedTo:self.view withLabel:@"正在搜索指定类型通知...." animated:YES];
     */
}
//搜索反馈成功
- (void)searchNotiSuccess:(NSObject *)result
{
    /*
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (self.currentNotiArray) {
        self.currentNotiArray = nil;
        self.currentNotiArray = [NSMutableArray array];
    }
    //解析noti对象
    NSArray *resultArray = (NSArray *)result;
    for (int i=0 ; i <[resultArray count]; i++) {
        NSDictionary *item = [resultArray objectAtIndex:i];
        ZYProSoftNoti *tempNoti = [[ZYProSoftNoti alloc]init];
        tempNoti.noti_id = [item objectForKey:@"team_noti_id"];
        tempNoti.noti_type = [item objectForKey:@"team_noti_type"];
        tempNoti.noti_subject = [item objectForKey:@"team_noti_subject"];
        tempNoti.noti_users = [item objectForKey:@"team_noti_users"];
        tempNoti.noti_content = [item objectForKey:@"team_noti_content"];
        tempNoti.noti_dateTime = [item objectForKey:@"update_time"];
        
        [self.currentNotiArray insertObject:tempNoti atIndex:0];
        [tempNoti release];
    }
    //设置一个导航左按钮来返回到所有信息页面
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"查看所有" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshNow)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItem release];
    
    [self.tableView reloadData];//刷新数据
     */
}
//搜索反馈失败
- (void)searchNotiFaild:(NSObject *)result
{
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
