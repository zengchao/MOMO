//
//  RODialogModel.h
//  SimpleDemo
//
//  Created by Winston on 11-8-18.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//
#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

@class RODialogView;
@protocol RODialogModel <NSObject>
@optional
/**
 * 由model调用,显示dialog的LoadingView
 */
-(void)dialogShowLoadingView;
/**
 * 由model调用,隐藏dialog的LoadingView
 */
-(void)dialogHideLoadingView;
/**
 *当dialog的loadingView隐藏的时候
 *
 */
-(void)dialogLoadingViewWasHidden:(RODialogView *)dialogView;

/**
 * dialogView的显示时机，可以做的一些操作，默认什么都不做。
 */
- (void)dialogViewWillAppear;
- (void)dialogViewDidAppear;
- (void)dialogViewWillDisappear;

@end

@class Renren;
@class RODialogViewController;

@interface RODialogModel : NSObject<RODialogModel>
{
    Renren *_renren;
    RODialogView *_dialogView;
    NSString *_title;
    NSString *_tips;
    BOOL _isLoading;
    BOOL _wasLoaded;
    BOOL _closeEnable;
}
/**
 * SDK的主接口Renren对象
 */
@property (nonatomic, retain)Renren *renren;
/**
 * dialog视图控制器
 */
@property (nonatomic, assign)RODialogView *dialogView;
/**
 * 显示在Dialog上 loading视图上的提示语句。
 */
@property (nonatomic, copy)NSString *tips;
/**
 * 显示在Dialog上 logoBar的标题语句。
 */
@property (nonatomic, copy)NSString *title;
/**
 * 表示是否在Dialog上的 loading视图上显示 动态提示符
 * YES:显示，NO，不显示
 */
@property (nonatomic) BOOL isLoading;
/**
 * 表示在Dialog上的loading视图是否两秒后自动消失
 * YES:显示，NO，不显示
 */
@property (nonatomic) BOOL wasLoaded;
/**
 * 表示在Dialog上的logobar上是否显示关闭按钮
 * YES:显示，NO，不显示
 */
@property (nonatomic) BOOL closeEnable;

/**
 *用renren生成一个dialogModel
 */
+(id)modelWithRenren:(Renren *)renren;

/**
 *用renren生成一个dialogModel
 */
-(id)initWithRenren:(Renren *)renren;

/**
 *返回每个model生成的Internal。
 *
 */
-(UIView *)dialogInternal;

@end
