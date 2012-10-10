//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum {
    RODialogOperateSuccess,
    RODialogOperateFailure,
    RODialogOperateCancel
};
typedef NSUInteger RODialogOperateType;     //Dialog操作类型

@protocol RODialogDelegate;

@class ROResponse;
@interface RODialog : UIView <UIWebViewDelegate> {
    id<RODialogDelegate> _delegate;
    NSMutableDictionary *_params;
    NSString * _serverURL;
    NSURL* _loadingURL;
    UIWebView* _webView;
    UIActivityIndicatorView* _spinner;
    UIImageView* _iconView;
    UIDeviceOrientation _orientation;
    BOOL _showingKeyboard;
    UIView* _modalBackgroundView;
    UIButton* _cancelButton;
    ROResponse* _response;
    BOOL _webScaleEnlarge;
}

@property(nonatomic, assign) id<RODialogDelegate> delegate;

@property(nonatomic, retain) NSMutableDictionary *params;

@property(nonatomic, retain) ROResponse *response;

- (id)initWithURL:(NSString *)loadingURL params:(NSMutableDictionary *)params delegate:(id<RODialogDelegate>)delegate;

-(void)errormsg:(NSString *)errorReason;

- (void)show;

- (void)load;

- (void)loadURL:(NSString*)url get:(NSDictionary*)getParams;

- (BOOL)isAuthDialog;

////隐藏视图并通知委托成功或者取消
//- (void)dismissWithSuccess:(BOOL)success animated:(BOOL)animated;

//隐藏视图并通知委托出现错误
- (void)dismissWithError:(NSError*)error animated:(BOOL)animated;

//子类重载并在显示对话前执行
- (void)dialogWillAppear;

//子类重载并在隐藏对话前执行
- (void)dialogWillDisappear;


- (void)dialogDidSucceed:(NSURL *)url;


- (void)dialogDidCancel:(NSURL *)url;
@end

///////////////////////////////////////////////////////////////////////////////////////////////////

/*
 * 你的应用要实现以下委托
 */
@protocol RODialogDelegate <NSObject>

@optional

- (void)authDialog:(RODialog *)dialog withOperateType:(RODialogOperateType )operateType;

- (void)widgetDialog:(RODialog *)dialog withOperateType:(RODialogOperateType )operateType;

- (BOOL)dialog:(RODialog *)dialog shouldOpenURLInExternalBrowser:(NSURL *)url;


///**
// * dialog 成功调用.
// */
//- (void)dialogDidComplete:(RODialog *)dialog;
//
///**
// * 
// * 当dialog成功调用返回一个url时调用
// */
//- (void)dialogCompleteWithUrl:(NSURL *)url;
//
///**
// * 
// * 当dialog 让用户取消时调用
// */
//- (void)dialogDidNotCompleteWithUrl:(NSURL *)url;
//
//- (void)dialogDidNotComplete:(RODialog *)dialog;
//
///**
// * 当dialog 加载时遇到错误时调用.
// */
//- (void)dialog:(RODialog*)dialog didFailWithError:(NSError *)error;
//
//
//
//- (void)widgetDialogCompleteWithDict:(NSDictionary*)params;
//
///**
// * dialog登录授权成功执行
// */
//- (void)rrDialogLogin:(NSString *)token expirationDate:(NSDate *)expirationDate;
///**
// * 取消登录时执行
// */
//- (void)rrDialogNotLogin:(BOOL)cancelled;


@end
