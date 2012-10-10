//
//  ZYPullRefreshTableViewController.m
//  TicketSystem
//
//  Created by ZYVincent on 12-2-22.
//  Copyright (c) 2012年 __ZYProSoft__. All rights reserved.
//  支持:http://www.ruyijian.com
//    团队QQ群号：219357847
//    团队主题：奋斗路上携手相伴！

#import "ZYPullRefreshTableViewController.h"

#define REFRESH_HEAD_HEIGHT 60.f
#define SEARCHBAR_HEIGHT 40.f

@implementation ZYPullRefreshTableViewController
@synthesize refreshHeadView,refreshTextLabel,arrowImgView,activeView;
@synthesize refreshString,pullString,releaseString;
@synthesize isLoading,isDragging;
@synthesize searchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setupStrings];//初始化字符串
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
    // Do any additional setup after loading the view from its nib.
    [self addHeadViewToTableView];//将头部视图添加到tableview得上部包围距离中
    [self addSearchBarToTableView];//将搜索栏添加到tableview上
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setupStrings
{
    //设置静态字符串
    pullString = [[NSString alloc]init];
    pullString = @"下拉刷新列表数据";
    releaseString = [[NSString alloc]init];
    releaseString = @"释放开始刷新...";
    refreshString = [[NSString alloc]init];
    refreshString = @"正在刷新....";
}
//插入搜索栏
- (void)addSearchBarToTableView
{
    searchBar = [[ZYSearchBar alloc]init];
    searchBar.delegate = self;
    searchBar.frame = CGRectMake(0, -SEARCHBAR_HEIGHT, 320, 40);
    [self.tableView addSubview:searchBar];
    [searchBar release];
    self.tableView.contentInset = UIEdgeInsetsMake(SEARCHBAR_HEIGHT, 0, 0, 0);
    
}
#pragma mark - searchbarDelegate
//这里写搜索得方法，只针对当前所有得信息查询
//searchBar Delegate
- (void)searchResultWithKeyWord:(NSString *)keyword
{
    
}
//类型选择代理方法
- (void)beginChooseType:(id)sender
{
    
}

- (void)addHeadViewToTableView
{
    //设置头部
    refreshHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, -(REFRESH_HEAD_HEIGHT+SEARCHBAR_HEIGHT), 320, REFRESH_HEAD_HEIGHT)];
    refreshHeadView.backgroundColor = [UIColor clearColor];
    
    //设置标签
    refreshTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEAD_HEIGHT)];
    refreshTextLabel.backgroundColor = [UIColor clearColor];
    refreshTextLabel.font = [UIFont boldSystemFontOfSize:14];
    refreshTextLabel.textAlignment = UITextAlignmentCenter;
    
    //设置箭头位置
    arrowImgView = [[UIImageView alloc]init];
    arrowImgView.frame = CGRectMake(floorf((REFRESH_HEAD_HEIGHT - 27)/2), floorf((REFRESH_HEAD_HEIGHT - 44)/2), 27, 44);
    arrowImgView.image = [UIImage imageNamed:@"arrow.png"];
    
    //设置活动指示
    activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activeView.frame = CGRectMake(floorf((REFRESH_HEAD_HEIGHT -20)/2), floorf((REFRESH_HEAD_HEIGHT-20)/2), 20, 20);
    activeView.hidesWhenStopped = YES;
    
    //添加到头部视图
    [refreshHeadView addSubview:refreshTextLabel];
    [refreshHeadView addSubview:arrowImgView];
    [refreshHeadView addSubview:activeView];
    
    [self.tableView addSubview:refreshHeadView];
    
    [refreshHeadView release];
    [refreshTextLabel release];
    [arrowImgView release];
    [activeView release];
    
}

//重写scollview得方法

//开始拖动得时得方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (isLoading) {
        return;
    }
    isDragging = YES;
}
//拖动中得方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /*
    if (isLoading) {
        // 更改tableView被包围得头部边距
        if (scrollView.contentOffset.y > 0)
            self.tableView.contentInset = UIEdgeInsetsZero;//头部包围距离为0
        else if (scrollView.contentOffset.y >= -(REFRESH_HEAD_HEIGHT+SEARCHBAR_HEIGHT))
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);//头部包围距离为偏移距离
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // 更改箭头得方向
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -(REFRESH_HEAD_HEIGHT+SEARCHBAR_HEIGHT)) {
            // 下拉超过了头部视图高度翻转箭头
            refreshTextLabel.text = self.releaseString;
            [arrowImgView layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // 已经在头部视图高度范围内则翻转箭头
            refreshTextLabel.text = self.pullString;
            [arrowImgView layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }*/
}
//结束拖动后开始减速得方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (isLoading) {
        return;
    }
    isDragging = NO;
    if (scrollView.contentOffset.y <= -(REFRESH_HEAD_HEIGHT+SEARCHBAR_HEIGHT)) {
        [self startLoading];
    }
    
}
//开始转动刷新
- (void)startLoading
{
    isLoading = YES;
    
    //显示头部,用动画缓和
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEAD_HEIGHT+SEARCHBAR_HEIGHT, 0, 0, 0);//改变tableview头部被包围状态
    self.refreshTextLabel.text = self.refreshString;
    self.arrowImgView.hidden = YES;
    [self.activeView startAnimating];
    
    [UIView commitAnimations];
    
    //执行刷新方法
    [self refresh];
    
}
//停止刷新
- (void)stopLoading
{
    /*
    isLoading = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];//动画结束完执行完更改头部视图得内容
    self.tableView.contentInset = UIEdgeInsetsMake(SEARCHBAR_HEIGHT, 0, 0, 0);//恢复头部零距离包围tableview
    [arrowImgView layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];*/
}
//animationdelegate
/*
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    //刷新停止后需要恢复头部视图得内容
    self.refreshTextLabel.text = self.pullString;
    self.arrowImgView.hidden = NO;
    [self.activeView stopAnimating];
     
}
 */
//刷新要执行得方法,需要覆盖此方法
- (void)refresh
{
    
}

@end
