//
//  RODialogModel.m
//  SimpleDemo
//
//  Created by Winston on 11-8-18.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//
#import "RODialogModel.h"
#import "RODialogView.h"

@implementation RODialogModel

@synthesize renren = _renren;
@synthesize dialogView = _dialogView;
@synthesize wasLoaded = _wasLoaded;
@synthesize isLoading = _isLoading;
@synthesize tips = _tips;
@synthesize title = _title;
@synthesize closeEnable = _closeEnable;

- (void)dealloc
{
    [_renren release];
    [_title release];
    [_tips release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    return self;
}


+(id)modelWithRenren:(Renren *)renren
{
    return [[[self alloc] initWithRenren:renren] autorelease];
}

-(id)initWithRenren:(Renren *)renren
{
    self = [self init];
    if (self) {
        self.renren = renren;
    }
    return self;
}



-(UIView *)dialogInternal
{   
    //子类必须实现这个方法
    return nil;
}
#pragma mark --protocol RODialogModel 

-(void)dialogShowLoadingView
{
    BOOL autoHidden = self.wasLoaded;
    BOOL animated = self.isLoading;
    NSString *tipsText = self.tips;
    if (tipsText && tipsText.length > 0) {
        if (autoHidden) {
            [self.dialogView loadingViewShowAndAutoHideWithTips:tipsText];
        }else {
            [self.dialogView loadingViewShow:animated tips:tipsText];
        }
    }
}

-(void)dialogHideLoadingView
{
    [self.dialogView loadingViewHide];
}

-(void)dialogLoadingViewWasHidden:(RODialogView *)dialogView
{
    
}

- (void)dialogViewWillAppear
{
   
}

- (void)dialogViewDidAppear
{
   
}

- (void)dialogViewWillDisappear
{
    
}


@end
