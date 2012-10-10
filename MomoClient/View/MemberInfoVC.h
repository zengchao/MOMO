//
//  MemberInfoVC.h
//  MOMO
//
//  Created by 超 曾 on 12-5-11.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "SendMessageVC.h"
#import "MBProgressHUD.h"
#import "EditItemsViewController.h"
#import "PicFrame.h"
#import "EGOImageView.h"
#import "Global.h"
#import "UploadOp.h"
#import "QWeiboSyncApi.h"
#import "QVerifyWebViewController.h"
#import "NSURL+QAdditions.h"
#import "MyRoadVC.h"
#import "CheweiListVC.h"
#import "CommentViewCell.h"
#import "ClientConnection.h"
#import "ExampleShareText.h"


@class ASIHTTPRequest;
@class SendMessageVC;

@interface MemberInfoVC : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,/*OAuthControllerDelegate,*/UIAlertViewDelegate>
{
    UITableView *myTableView;
    NSMutableDictionary *mydict;
    MBProgressHUD *HUD;
    NSMutableArray *data;
    NSMutableArray *imageviews;
    NSInteger index;
    BOOL pageControlUsed;
    PicFrame *pf;
    UIImagePickerController *imagePicker;
    UIImage *imagePicture;
    int pos;
	NSMutableArray *list;
    ASIHTTPRequest *request;
    UIView *subview;
    UIImageView *imageView;
    UIBarButtonItem *leftBarButtonItem;
    BOOL b_myinfo;//是否为本人的资料
    UIToolbar *m_pToolBar;
    UIScrollView *scrollImages;
    UIPageControl *pagecontrol;
    UIView *imagesBack;
    UIButton *m_pButtonAdd;
    UIButton *m_pButtonAdd2;
    UIButton *m_pButtonAdd3;
    
    EditItemsViewController *vcEdit;
    MyRoadVC *vcRoad;
    SendMessageVC *vcMessage;
    
}
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,retain)NSMutableDictionary *mydict;
@property (nonatomic,retain)NSMutableArray *data;
@property (nonatomic,retain)NSMutableArray *imageviews;
@property (nonatomic,retain)PicFrame *pf;
@property (nonatomic,retain)UIImagePickerController *imagePicker;
@property (nonatomic,retain)UIImage *imagePicture;
@property (nonatomic,retain)NSMutableArray *list;
@property (nonatomic,retain)ASIHTTPRequest *request;
@property (nonatomic,retain)UIView *subview;
@property (nonatomic,retain)IBOutlet UIImageView *imageView;
@property (nonatomic,retain)UIBarButtonItem *leftBarButtonItem;
@property (nonatomic,assign)IBOutlet UIToolbar *m_pToolBar;
@property (assign,nonatomic)IBOutlet UIScrollView *scrollImages;
@property (assign,nonatomic)IBOutlet UIPageControl *pagecontrol;
@property (assign,nonatomic)IBOutlet UIView *imagesBack;
@property (nonatomic,retain)UIButton *m_pButtonAdd;
@property (nonatomic,retain)UIButton *m_pButtonAdd2;
@property (nonatomic,retain)UIButton *m_pButtonAdd3;
@property (nonatomic,assign)BOOL b_myinfo;
@property (nonatomic,retain)EditItemsViewController *vcEdit;
@property (nonatomic,retain)MyRoadVC *vcRoad;
@property (nonatomic,retain)SendMessageVC *vcMessage;

-(IBAction)chagepage:(id)sender;
-(IBAction)sendMsg:(id)sender;
-(IBAction)FollowTA:(id)sender;
-(int)getMemberInfo;

//- (IBAction)getCameraPicture:(id)sender;
//- (IBAction)getExistintPicture:(id)sender;
//- (void)openAuthenticateView;



-(void)getMyPic;
@end
