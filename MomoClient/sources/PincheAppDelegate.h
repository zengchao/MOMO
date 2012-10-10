//
//  CMPayClientAppDelegate.h
//  CMPayClient
//  曾超
//  QQ:1490724

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h> 

#import "Global.h"
#import "SHKConfiguration.h"
#import "ShareKitDemoConfigurator.h"
#import "StartVC.h"
#import "FMDatabase.h"
#import "MainTabViewController.h"
#import "ASIHTTPRequest.h"

@interface PincheAppDelegate : NSObject <UIApplicationDelegate,UITabBarControllerDelegate> {
    UINavigationController *navigationController;
    NSString *firstlogin;
    NSTimer *timer;
    BOOL shake;
    BOOL alertSound;
    MainTabViewController *mainTabViewController;
    ASIHTTPRequest *request;
    int MessageNum;
    FMDatabase *db;
    NSString *login_user_id;
    BOOL isSound;
    NSString *startTime;
    NSString *endTime;
    UIImageView *mainImageView;
}
@property (nonatomic,retain)NSString *firstlogin;
@property (nonatomic,retain) MainTabViewController *mainTabViewController;
@property (nonatomic,retain)IBOutlet UINavigationController *navigationController;
@property (strong,nonatomic)UIWindow *window;
@property(nonatomic,retain)NSTimer *timer;
@property(nonatomic,assign)BOOL shake;
@property(nonatomic,assign)BOOL alertSound;
@property (retain, nonatomic) ASIHTTPRequest *request;
@property (retain, nonatomic) FMDatabase *db;
@property(nonatomic,assign)BOOL isSound;
@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,copy)NSString *endTime;
+(PincheAppDelegate*)getAppDelegate;

- (void)signOut;
-(void)MessgaeAlert:(NSString *)UserID;

@end
