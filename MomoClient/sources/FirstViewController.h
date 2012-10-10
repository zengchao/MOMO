
////  曾超
////  QQ:1490724

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "EGORefreshTableHeaderView.h"
#import <MapKit/MapKit.h>
#import "EGOCache.h"
#import "EGOImageView.h"
#import "ArticleTitleLabel.h"
#import "RegStepOneVC.h"
#import "RegUploadPicVC.h"
#import "PostAnnotation.h"
#import "Global.h"
#import "ASIHTTPRequest.h"
//@class ASIHTTPRequest;

@interface FirstViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,EGORefreshTableHeaderDelegate,CLLocationManagerDelegate> 
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
    IBOutlet MKMapView *mapView;
    PostAnnotation *annotation;
    ASIHTTPRequest *request;
}
@property (nonatomic,retain)UILabel *titleLabel;
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
@property (nonatomic,retain)ASIHTTPRequest *request;

- (IBAction)callRegisterWindow:(UIImageView *)sender;
- (IBAction)callLoginWindow:(UIImageView *)sender;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void)stopUpdatingLocation:(NSString *)state;
//- (void)loadlist2;
-(void)loadMemberList;
- (void)loadList;
@end
