//
//  SendMessageVC.h
//  MOMO
//
//  Created by 超 曾 on 12-5-12.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import "NearbyMemberVC.h"
#import "Global.h"
#import "EGOImageView.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"

@class ASIFormDataRequest;
@class ASIHTTPRequest;
@class ASINetworkQueue;
//@class MemberInfoVC;
@class UserinfoVC;

@interface SendMessageVC : UIViewController<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate, UINavigationControllerDelegate,/*NSXMLParserDelegate,*/UIActionSheetDelegate,UIImagePickerControllerDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate,MBProgressHUDDelegate> {
	NSMutableArray		*chatArray;
	NSString			*chatFile;
    
	NSMutableDictionary	*currentChatInfo;
	NSMutableString		*currentString;
    BOOL				storingCharacters;
	
	BOOL				isMySpeaking;
	BOOL				loadingLog;
    
    NSString *t_userid;
    NSString *t_username;
    
    UIImagePickerController *imagePicker;
    UIImage *imagePicture;
    ASIFormDataRequest *form_request;
    ASIHTTPRequest *request;
    NSString *mydistance;
    UIView *subview;
    int cur_tag;
    NSMutableDictionary *tag_dic;
    ASINetworkQueue *networkQueue;
    MBProgressHUD *HUD;
    BOOL failed;
    //MemberInfoVC *vcMember;
    UserinfoVC *vcUser;
    NSString *login_user_pic;
    NSString *user_pic; 
    NSTimer *timer;
}

@property(nonatomic,retain)NSMutableDictionary *tag_dic;
@property(nonatomic,retain)UIView *subview;
@property(nonatomic,retain)NSString *mydistance;
@property (nonatomic, strong)AVAudioRecorder *audioRecorder;
@property(nonatomic,strong)AVAudioPlayer *audioPlayer;
@property (retain, nonatomic)ASIFormDataRequest *form_request;
@property (retain, nonatomic)ASIHTTPRequest *request;
@property (nonatomic,retain)UIBarButtonItem *leftBarButtonItem;
@property (nonatomic,retain)UIBarButtonItem *rightBarButtonItem;
@property(nonatomic,assign)NSString *t_userid;//当前打开的会员的id
@property(nonatomic,assign)NSString *t_username;//当前打开的会员的name
//@property (nonatomic,retain)MemberInfoVC *vcMember;
@property (nonatomic,retain)UserinfoVC *vcUser;
@property (nonatomic,retain)NSString *login_user_pic;
@property (nonatomic,retain)NSString *user_pic;    

- (IBAction)getCameraPicture;
- (IBAction)getExistintPicture;

@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UIImage *imagePicture;
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
-(NSDictionary *)audioRecordingSettings;

@end
