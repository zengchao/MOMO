//
//  RODialogView.m
//  SimpleDemo
//
//  Created by Winston on 11-8-18.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "RODialogView.h"
#import "RODialogModel.h"


#define kTransitionDuration 0.3
#define kPadding 10.0
#define kBorderWidth 10.0


#define kTagBarLogoImageView 901
#define kTagBarTitleLabel 902

@interface RODialogView() 

- (void)setVerticalFrame;
- (void)setHorizontalFrame;


- (CGAffineTransform)transformForOrientation;
- (void)bounce1AnimationStopped;
- (void)bounce2AnimationStopped;

@end

@implementation RODialogView


@synthesize internalView = _internalView;
@synthesize backgroundView = _backgroundView;
@synthesize logoBarView = _logoBarView;
@synthesize loadingView = _loadingView;
@synthesize closeButton = _closeButton;
@synthesize dialogModel = _dialogModel;

- (void)dealloc
{
    [_internalView release];
    [_backgroundView release];
    [_logoBarView release];
    [self loadingViewHide];
    [_closeButton release];
    [_dialogModel release];
    [_dialogBackgroundView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init {
    if (self = [self initWithFrame:CGRectZero]) {

        _orientation = UIDeviceOrientationUnknown;
        self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentMode = UIViewContentModeRedraw;
        _dialogBackgroundView = [[UIView alloc] init];
    }
    return self;
}

+(RODialogView *)dialogViewWithModel:(RODialogModel *)model
{
    RODialogView *dialogView = [[RODialogView alloc] initWithInternalView:[model dialogInternal]
                                                              closeButton:model.closeEnable 
                                                             logoBarTitle:model.title];
    dialogView.dialogModel = model;
    model.dialogView = dialogView;
    return [dialogView autorelease];
}

-(id)initWithInternalView:(UIView *)internalView 
              closeButton:(BOOL)visible
             logoBarTitle:(NSString *)title
{
    self = [self init];
    if (self) {
        self.internalView = internalView;
        if (visible) {
            [self.closeButton addTarget:self action:@selector(touchCloseButton:) forControlEvents:UIControlEventTouchDown];
        }
        if (title) {
            self.logoBarView = [self logoBarViewWithTitle:title];
        }
    }
    return self;
}

-(void)touchCloseButton:(id)sender
{
    [self dismiss:YES];
}
            
-(UIButton *)closeButton
{
    if(!_closeButton) {
        _closeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeButton setBackgroundColor:[ROGlobalStyle renrenBlueColor]];
    }
    return _closeButton;
}

-(UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [ROGlobalStyle borderBlackColor];
        _backgroundView.alpha = 0.8;
        _backgroundView.layer.cornerRadius = 10.0;
    }
    return _backgroundView;
}

-(UIView *)logoBarViewWithTitle:(NSString *)title
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [ROGlobalStyle renrenBlueColor];
    view.autoresizesSubviews = YES;
    view.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
    | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"renren-logo-top-bar.png"]];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    logoImageView.tag = kTagBarLogoImageView;
    [view addSubview:logoImageView];
    [logoImageView release];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = view.backgroundColor;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = title;
    titleLabel.tag = kTagBarTitleLabel;
    [view addSubview:titleLabel];
    [titleLabel release];
    
    return [view autorelease];
}

-(void)loadingViewShow:(BOOL)animated tips:(NSString *)tipsText
{
    [self loadingViewHide];
    _closeButton.hidden = YES;
    _logoBarView.hidden = YES;
    _internalView.hidden = YES;
    _backgroundView.hidden = YES;
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    [view setAutoresizingMask : UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.8;
    view.layer.cornerRadius = 10.0;
    
    UILabel *tipsLabel = nil;
    if (tipsText && tipsText.length != 0) {
        tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
        tipsLabel.font = [UIFont boldSystemFontOfSize:18];
        tipsLabel.backgroundColor = [UIColor clearColor];
        tipsLabel.textColor = [UIColor whiteColor];
        tipsLabel.textAlignment = UITextAlignmentCenter;
        tipsLabel.text = tipsText;
    }
    UIActivityIndicatorView *activity = nil;
    if (animated) {
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activity startAnimating];
    }
     CGPoint c = CGPointMake(view.frame.size.width*0.5, view.frame.size.height*0.5);
    if (tipsLabel && activity) {
        activity.center = CGPointMake(c.x,c.y*0.6);
        tipsLabel.center = CGPointMake(c.x, c.y+activity.frame.size.width*0.5+tipsLabel.frame.size.height*0.5);
        [view addSubview:activity];
        [view addSubview:tipsLabel];
    }else if (activity) {
        activity.center = c;
        [view addSubview:activity];
    }
    if (activity) {
        [activity release];
        activity = nil;
    }
    if (tipsLabel) {
        [tipsLabel release];
        tipsLabel = nil;
    }
    self.loadingView = view;
    [view release];
    self.loadingView.center =  CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
    [self addSubview:self.loadingView];
}

-(void)loadingViewShowAndAutoHideWithTips:(NSString *)tipsText
{
    [self loadingViewHide];
    _closeButton.hidden = YES;
    _logoBarView.hidden = YES;
    _internalView.hidden = YES;
    _backgroundView.hidden = YES;
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    [view setAutoresizingMask : UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.8;
    view.layer.cornerRadius = 10.0;
    
    UILabel *tipsLabel = nil;
    if (tipsText && tipsText.length != 0) {
        tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 80, 20)];
        tipsLabel.backgroundColor = [UIColor clearColor];
        tipsLabel.numberOfLines = 0;
       // tipsLabel.minimumFontSize = 10.0;
       // tipsLabel.adjustsFontSizeToFitWidth = YES;
        tipsLabel.font = [UIFont boldSystemFontOfSize:18];
        tipsLabel.textColor = [UIColor whiteColor];
        tipsLabel.textAlignment = UITextAlignmentCenter;
        tipsLabel.text = tipsText;
    }
     CGPoint c = CGPointMake(view.frame.size.width*0.5, view.frame.size.height*0.5);
    if (tipsLabel) {
        tipsLabel.center = c;
        [view addSubview:tipsLabel];
        [tipsLabel release];
    }
    self.loadingView = view;
    [view release];
    self.loadingView.center =  CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
    [self addSubview:self.loadingView];
    //自动延时消失
    
    [UIView beginAnimations:@"lodeHidden" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.8];
    [UIView setAnimationDidStopSelector:@selector(loadingViewAutoHide:)];
    self.loadingView.alpha = 0.1;
    [UIView commitAnimations];
    
  //  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(loadingViewAutoHide:) userInfo:nil repeats:NO];
}

-(void)loadingViewAutoHide:(void *)object
{
   // [timer invalidate];
   // [self loadingViewHide];
    if ([_dialogModel respondsToSelector:@selector(dialogLoadingViewWasHidden:)]) {
        [_dialogModel performSelector:@selector(dialogLoadingViewWasHidden:) withObject:self];
    }
}
                      
                      
-(void)loadingViewHide
{
    if (_loadingView != nil) {
        if (_loadingView.superview) {
            [_loadingView removeFromSuperview];
        }
        self.loadingView = nil;
    }
    _closeButton.hidden = NO;
    _logoBarView.hidden = NO;
    _internalView.hidden = NO;
    _backgroundView.hidden = NO;
}

-(void)show:(BOOL)animated
{
    [self sizeToFitOrientation:NO];
    [self addSubview:self.backgroundView];
    if (self.logoBarView) {
        [self addSubview:self.logoBarView];
    }
    if (_closeButton) {
        [self addSubview:self.closeButton];
    }
    [self addSubview:self.internalView];
    
    [_dialogModel performSelector:@selector(dialogViewWillAppear)];
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    _dialogBackgroundView.frame = window.frame;
    [window addSubview:_dialogBackgroundView];
    [window addSubview:self];
    if (animated) {
        self.transform = CGAffineTransformScale([self transformForOrientation], 0.001, 0.001);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kTransitionDuration/1.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
        self.transform = CGAffineTransformScale([self transformForOrientation], 1.1, 1.1);
        [UIView commitAnimations];
    }
    [_dialogModel performSelector:@selector(dialogViewDidAppear)];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:@"UIDeviceOrientationDidChangeNotification" 
                                               object:nil];
}

- (void)deviceOrientationDidChange:(NSNotification*)notifition {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if ([self shouldRotateToOrientation:orientation]) {
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
        [self sizeToFitOrientation:YES];
        [self setInternalOrientaion];
        [UIView commitAnimations];
    }
}

-(void)dismiss:(BOOL)animated;
{
    if ([_dialogModel respondsToSelector:@selector(dialogViewWillDisappear)]) {
         [_dialogModel performSelector:@selector(dialogViewWillDisappear)];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kTransitionDuration];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
        self.alpha = 0;
        [UIView commitAnimations];
    } else {
        [self removeFromSuperview];
    }    
}

-(void)removeFromSuperview{
    [_dialogBackgroundView removeFromSuperview];
    [super removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation {
    if (_orientation == (UIDeviceOrientation)orientation) {
        return NO;
    } else {
        return (UIDeviceOrientation)orientation == UIDeviceOrientationLandscapeLeft
        || (UIDeviceOrientation)orientation == UIDeviceOrientationLandscapeRight
        || (UIDeviceOrientation)orientation == UIDeviceOrientationPortrait
        || (UIDeviceOrientation)orientation == UIDeviceOrientationPortraitUpsideDown;
    }
}

- (CGAffineTransform)transformForOrientation {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(M_PI*1.5);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI/2);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}

- (void)sizeToFitOrientation:(BOOL)transform {
    if (transform) {
        self.transform = CGAffineTransformIdentity;
    }
    
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    CGPoint center = CGPointMake(
                                 frame.origin.x + frame.size.width/2.0,
                                 frame.origin.y + frame.size.height/2.0);
//    CGFloat scale_factor = 1.0f;
//    if ([ROGlobalStyle isPad]) {
//        // On the iPad the dialog's dimensions should only be 60% of the screen's
//        scale_factor = 0.6f;
//    }
//    
//    CGFloat width = floor(scale_factor * frame.size.width) - kPadding * 2;
//    CGFloat height = floor(scale_factor * frame.size.height) - kPadding * 2;

    CGFloat width,height;
    _orientation = (UIDeviceOrientation)([UIApplication sharedApplication].statusBarOrientation);
    if (UIInterfaceOrientationIsLandscape(_orientation)) {
        width = 460;
        height = 280;
        self.frame = CGRectMake(kPadding, kPadding, width,height);
    } else {
        width = 300;
        height = 440;
        self.frame = CGRectMake(kPadding, kPadding, width, height);
    }
    self.center = center;
    
    if (transform) {
        self.transform = [self transformForOrientation];
    }
}

- (void)bounce1AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    self.transform = CGAffineTransformScale([self transformForOrientation], 0.9, 0.9);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    self.transform = [self transformForOrientation];
    [UIView commitAnimations];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (UIInterfaceOrientationIsLandscape(_orientation)) {
        //设置横屏时布局
        [self setHorizontalFrame]; 
    } else {
        //设置竖屏时布局
        [self setVerticalFrame]; 
    }
     
}

-(void)setVerticalFrame
{
    CGRect viewFrame = self.bounds;
    if (self.loadingView) {
        self.loadingView.center = CGPointMake(viewFrame.size.width*0.5, viewFrame.size.height*0.5);
    }
    self.backgroundView.frame = viewFrame;
    CGRect logoBarFrame = CGRectZero;
    if (self.logoBarView) {
        _logoBarView.frame = CGRectMake(kPadding,
                                        kPadding,
                                        viewFrame.size.width-3*kPadding,
                                        25);
        UIImageView *logo = (UIImageView *)[_logoBarView viewWithTag:kTagBarLogoImageView];
        logo.frame = CGRectMake(0, 0,43,24);
        UILabel *title = (UILabel *)[_logoBarView viewWithTag:kTagBarTitleLabel];
        title.frame = CGRectMake(logo.frame.size.width+10, 
                                 0, 
                                 _logoBarView.frame.size.width - logo.frame.size.width,
                                 _logoBarView.frame.size.height);
        logoBarFrame = _logoBarView.frame;
        
    }
    if (_closeButton) {
       _closeButton.frame = CGRectMake(viewFrame.size.width - kPadding - 30, kPadding, 30, 25);
        [self bringSubviewToFront:_closeButton];
    }
    self.internalView.frame = CGRectMake(kPadding, 
                                         kPadding + logoBarFrame.size.height,
                                         viewFrame.size.width - 2*kPadding,
                                         viewFrame.size.height - 2*kPadding - logoBarFrame.size.height);
}

-(void)setHorizontalFrame
{
    CGRect viewFrame = self.bounds;
    self.backgroundView.frame = viewFrame;
    if (self.loadingView) {
        self.loadingView.center = CGPointMake(viewFrame.size.width*0.5, viewFrame.size.height*0.5);
    }
    CGRect logoBarFrame = CGRectZero;
    if (self.logoBarView) {
        _logoBarView.frame = CGRectMake(kPadding,
                                        kPadding,
                                        viewFrame.size.width-2*kPadding,
                                        25);
        UIImageView *logo = (UIImageView *)[_logoBarView viewWithTag:kTagBarLogoImageView];
        //logo.frame = CGRectMake(0, 0, logo.image.size.width, logo.image.size.height);
        logo.frame = CGRectMake(0, 0,43,24);
        UILabel *title = (UILabel *)[_logoBarView viewWithTag:kTagBarTitleLabel];
        title.frame = CGRectMake(logo.frame.size.width+10, 
                                 0, 
                                 _logoBarView.frame.size.width - logo.frame.size.width-10,
                                 _logoBarView.frame.size.height);
        logoBarFrame = _logoBarView.frame;
        
    }
    if (_closeButton) {
        _closeButton.frame = CGRectMake(viewFrame.size.width - kPadding - 30, kPadding, 30, 25);
        [self bringSubviewToFront:_closeButton];
    }
    self.internalView.frame = CGRectMake(kPadding, 
                                         kPadding + logoBarFrame.size.height,
                                         viewFrame.size.width - 2*kPadding,
                                         viewFrame.size.height - 2*kPadding - logoBarFrame.size.height);
}

- (void)setInternalOrientaion
{
    [self.internalView setNeedsLayout];
}

- (void)waitForRenrenAuthorize
{
    [self retain];//保证等待过程中不被release掉。
}

- (void)didRenrenAuthorizeSuccess:(BOOL)success
{
    [self autorelease];
    if (success) {
        [self show:YES];
    }
    else
    {
        //认证失败默认不做什么
    }
}

@end
