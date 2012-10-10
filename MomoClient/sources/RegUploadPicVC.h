//
//  RegUploadPicVC.h
//  MOMO
//
//  Created by 超 曾 on 12-4-19.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"
#import "EGORefreshTableHeaderView.h"
#import "EGOCache.h"
#import "EGOImageView.h"
#import "UploadOp.h"
#import "Global.h"
#import "NSObject+SBJson.h"
#import "ArticleTitleLabel.h"
#import "LBS_Member.h"
#import "LoginViewController.h"
#import "SWSnapshotStackView.h"

@class ASIHTTPRequest;

@interface RegUploadPicVC : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,EGORefreshTableHeaderDelegate,CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> 
{
    UITableView *myTableView;
    MBProgressHUD *HUD;
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    NSMutableArray *list;
    CLLocationManager *locationManager;
    EGOImageView *thumbnail;
    ArticleTitleLabel *titleLabel;
    NSMutableArray *locationMeasurements;
    CLLocation *bestEffortAtLocation;
    
    UIImagePickerController *imagePicker;
    UIImage *imagePicture;
    LBS_Member *lbsMember;
    ASIHTTPRequest *request;
    SWSnapshotStackView *imageView;
    
}
@property (nonatomic,retain)ASIHTTPRequest *request;
@property (nonatomic,retain)UILabel *titleLabel;
//@property (nonatomic,retain)IBOutlet UIImageView *imageView;
@property (nonatomic,retain)IBOutlet UIButton *btnRegister;
@property (nonatomic,retain)IBOutlet UIButton *btnLogin;
@property (nonatomic,retain)UIBarButtonItem *backItem;
@property (nonatomic,retain)UIBarButtonItem *rightBarButtonItem;
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,retain)UIImageView *btnBackImageView;
@property (nonatomic,retain)NSMutableArray *list;
@property (nonatomic,retain)CLLocationManager *locationManager;
@property (nonatomic,retain)NSMutableArray *locationMeasurements;
@property (nonatomic,retain)CLLocation *bestEffortAtLocation;
@property (nonatomic,retain)IBOutlet UIButton *btnPhotoLibrary;
@property (nonatomic,retain)IBOutlet UIButton *btnCamera;
@property (nonatomic,retain)LBS_Member *lbsMember;
@property (nonatomic,retain)IBOutlet SWSnapshotStackView *imageView;

- (IBAction)callRegisterWindow:(UIImageView *)sender;
//- (IBAction)callLoginWindow:(UIImageView *)sender;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void)stopUpdatingLocation:(NSString *)state;
- (IBAction)getCameraPicture:(id)sender;
- (IBAction)getExistintPicture:(id)sender;
- (IBAction)login:(id)sender;
-(void)loadMemberList;
- (void)loadList;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UIImage *imagePicture;
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end