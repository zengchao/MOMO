//
//  RODialogView.h
//  SimpleDemo
//
//  Created by Winston on 11-8-18.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import <UIKit/UIKit.h>
#import "ROGlobalStyle.h"

@class RODialogModel;
@protocol RODialogInternalDelegate;


@interface RODialogView : UIView {
    RODialogModel *_dialogModel;
    UIView *_internalView;
    UIView *_backgroundView;
    UIView *_logoBarView;
    UIView *_loadingView;
    UIButton *_closeButton;
    UIDeviceOrientation _orientation;
    UIView *_dialogBackgroundView;
}

/**
 * dialog视图业务model
 */
@property(nonatomic, retain)RODialogModel *dialogModel;
/**
 * dialog内部视图，对应不同业务model
 */
@property(nonatomic, retain)UIView *internalView;
/**
 * dialog的背景视图，圆角的灰黑色边框
 */
@property(nonatomic, retain)UIView *backgroundView;
/**
 * dialog需要执行加载的动画提示视图
 */
@property(nonatomic, retain)UIView *loadingView;
/**
 * dialog的关闭按钮
 */
@property(nonatomic, retain)UIButton *closeButton;
/**
 * dialog的带logo的标题栏视图，含renrenlogo，dialog标题，
 */
@property(nonatomic, retain)UIView *logoBarView;

/**
 * 便利构造一个dialogView
 * @param model 内部的业务Model。
 */
+(RODialogView *)dialogViewWithModel:(RODialogModel *)model;
/**
 * 初始化一个dialog
 * @param internalView 内部的业务视图。
 * @param visible :YES/NO ,显示/不显示关闭按钮
 * @param title: logoBar的标题
 */
-(id)initWithInternalView:(UIView *)internalView 
              closeButton:(BOOL)visible
             logoBarTitle:(NSString *)title;
/**
 * 返回一个标题为title的logoBarView
 * @param title: logoBar的标题
 */
-(UIView*)logoBarViewWithTitle:(NSString *)title;
/**
 * 显示dialog 
 * @param animated: 是否动画
 */
-(void)show:(BOOL)animated;
/**
 * 关闭dialog 
 * @param animated: 是否动画
 */
-(void)dismiss:(BOOL)animated;
/**
 * 显示loading视图
 * @param animated: 是否动画
 * @param tipsText: 文本提示，最好不要超过4个字
 */
-(void)loadingViewShow:(BOOL)animated tips:(NSString *)tipsText;
/**
 * 隐藏loading视图
 */
-(void)loadingViewHide;
/**
 * 显示loading视图，并再两秒后自动隐藏
 * @param tipsText: 文本提示，最好不要超过4个字
 */
-(void)loadingViewShowAndAutoHideWithTips:(NSString *)tipsText;
/**
 * 动画结束隐藏loading视图
 * @param tipsText: 文本提示，最好不要超过4个字
 */
-(void)loadingViewAutoHide:(void *)object;
/**
 * dialog是否要响应旋转
 */
- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation;
/**
 * dialog的size适配方向
 */
- (void)sizeToFitOrientation:(BOOL)transform;
/**
 * 设置dialog内部视图的方向，让视图适配新的方向
 */
- (void)setInternalOrientaion;
/**
 * 当dialogView未授权时，等待人人授权验证时
 */
- (void)waitForRenrenAuthorize;
/**
 * 当dialogView授权结束时后，执行相关操作。
 */
- (void)didRenrenAuthorizeSuccess:(BOOL)success;
@end

