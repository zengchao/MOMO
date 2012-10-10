//
//  ZYPullRefreshTableViewController.h
//  TicketSystem
//
//  Created by ZYVincent on 12-2-22.
//---------------------------------
//    文件作用：带下拉刷新和搜索栏功能得自定义TableViewController
//    可以作为带搜索栏和下拉刷新功能得TableViewController得基类
//    作者：胡涛
//    支持:http://www.ruyijian.com
//    团队QQ群号：219357847
//    团队主题：奋斗路上携手相伴！
//---------------------------------
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZYSearchBar.h"

@interface ZYPullRefreshTableViewController : UITableViewController<ZYSearchBarDelegate>{
    
    //头部增加得图片
    UIView *refreshHeadView;
    //下拉标签
    UILabel *refreshTextLabel;
    //箭头标签
    UIImageView *arrowImgView;
    //活动指示
    UIActivityIndicatorView *activeView;
    
    BOOL isLoading;//是否正在刷新
    BOOL isDragging;//是否正在下拉
    
    NSString *pullString;//下拉刷新
    NSString *releaseString;//释放刷新
    NSString *refreshString;//正在刷新
    
    //搜索栏
    ZYSearchBar *searchBar;
}
@property (nonatomic,retain)UIView *refreshHeadView;
@property (nonatomic,retain)UILabel *refreshTextLabel;
@property (nonatomic,retain)UIImageView *arrowImgView;
@property (nonatomic,retain)UIActivityIndicatorView *activeView;
@property (nonatomic)BOOL isLoading;
@property (nonatomic)BOOL isDragging;
@property (nonatomic,copy)NSString *pullString;
@property (nonatomic,copy)NSString *releaseString;
@property (nonatomic,copy)NSString *refreshString;
@property (nonatomic,retain)ZYSearchBar *searchBar;


//开始刷新
- (void)startLoading;
//停止刷新
- (void)stopLoading;
//执行刷新时得方法
- (void)refresh;
//初始化头部字符串
- (void)setupStrings;
//插入头部试图到tableView里面
- (void)addHeadViewToTableView;

//在tableView头部包围距离内插入searchbar
- (void)addSearchBarToTableView;


@end
