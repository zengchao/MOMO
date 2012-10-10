//
//  NearbyMemberVC.h
//  HorizontalTables
//
//  Created by Felipe Laso on 8/7/11.
//  Copyright 2011 Felipe Laso. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "CustomFilterVC.h"
#import "MemberInfoVC.h"
#import "Global.h"
#import <MapKit/MapKit.h>
#import "SBJson.h"
#import "EGOCache.h"
#import "EGOImageView.h"
#import "ArticleTitleLabel.h"
#import "LBS_Member.h"
#import "MemberDAO.h"
#import "MBProgressHUD.h"
#import "UserinfoVC.h"

@class ASIHTTPRequest;
@class MemberInfoVC;

@interface NearbyMemberVC : UIViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,UIActionSheetDelegate,UIViewPassValueDelegate,CLLocationManagerDelegate,MBProgressHUDDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    NSInteger strSex;
    NSInteger strTime;
    MBProgressHUD *HUD;
    
    NSMutableArray *list;
    CLLocationManager *locationManager;
    EGOImageView *thumbnail;
    ArticleTitleLabel *titleLabel;
    UILabel *infoLabel;
    NSMutableArray *locationMeasurements;
    CLLocation *bestEffortAtLocation;
    BOOL isGridDisplay;
    int start;
    ASIHTTPRequest *request;
    UITableView *myTableView;
    NSMutableArray *list_tmp;
    MemberInfoVC *vcMember;
    UserinfoVC *vcUser;
    CustomFilterVC *vcFilter;
    
}
@property(nonatomic,retain)UITableView *myTableView;
@property(nonatomic,retain)UIBarButtonItem *leftBtn;
@property(nonatomic,retain)UIBarButtonItem *rightBtn;
@property(nonatomic,retain)UIButton *btn;
@property(nonatomic, assign) NSInteger strSex;//性别
@property(nonatomic, assign) NSInteger strTime;//最近登录时间间隔
@property(nonatomic,retain)MemberInfoVC *vcMember;
@property(nonatomic,retain)UserinfoVC *vcUser;
@property(nonatomic,retain)CustomFilterVC *vcFilter;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;


@property(nonatomic,retain)NSMutableArray *list;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSMutableArray *locationMeasurements;
@property (nonatomic, retain) CLLocation *bestEffortAtLocation;
@property (retain, nonatomic) ASIHTTPRequest *request;
@property (nonatomic, retain) ArticleTitleLabel *titleLabel;
@property (nonatomic, retain) UILabel *infoLabel;

- (NSInteger)getListCount;
- (int)loadLocaldbMember;
- (NSMutableArray *)loadList;
-(void) ViewFreshData;
@end
