//
//  QLoadingView.m
//  QWeiboSDK4iOSDemo
//
//  Created   on 11-1-18.
//   
//

#import "QLoadingView.h"
#import "QWeiboSDK4iOSDemoAppDelegate.h"

#define AppDelegate 	((QWeiboSDK4iOSDemoAppDelegate*)[[UIApplication sharedApplication] delegate])
#define MainController [AppDelegate mainViewController]
#define MainView [MainController view]

#define LOADINGVIEW_SHOW_DURATION 2
#define LOADINGVIEW_ANIMATE_DURATION 1

@protocol QLoadingView
- (void)hideWithAnimate;
@end

static QLoadingView *sShareLoadingView;

@implementation QLoadingView

- (id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.backgroundColor = [UIColor clearColor];
		
		backgroundView = [[UIView alloc] initWithFrame:self.bounds];
		backgroundView.backgroundColor = [UIColor blackColor];
		backgroundView.alpha = 0.2;
		backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:backgroundView];
		
		UIViewAutoresizing viewAutoResizing = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |
		UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		
		boardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info_bkg.png"]];
		boardView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
		boardView.autoresizingMask = viewAutoResizing;
		[self addSubview:boardView];
		
		activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activityView.center = CGPointMake(boardView.bounds.size.width/2, 60);
		activityView.hidesWhenStopped = YES;
		[boardView addSubview:activityView];
		
		labelInfo = [[UILabel alloc] initWithFrame:CGRectMake(boardView.bounds.size.width/2 - 70,
															  90, 140, 60)];
		labelInfo.numberOfLines = 2;
		labelInfo.backgroundColor = [UIColor clearColor];
		labelInfo.textAlignment = UITextAlignmentCenter;
		labelInfo.textColor = [UIColor whiteColor];
		labelInfo.font = [UIFont systemFontOfSize:16];
		labelInfo.shadowColor = [UIColor blackColor]; 
		labelInfo.shadowOffset = CGSizeMake(0, 1.0);
		[boardView addSubview:labelInfo];
		
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(boardView.bounds.size.width/2 - 51, 
																  15, 102, 102)];
		[boardView addSubview:imageView];
		imageView.hidden = YES;
	}
	
	return self;
}

- (void)dealloc
{
	
	[backgroundView release];
	[boardView release];
	[imageView release];
	[labelInfo release];
	[activityView release];
	[super dealloc];
}

- (void)autoHide
{
	[self performSelector:@selector(hideWithAnimate) withObject:nil afterDelay:LOADINGVIEW_SHOW_DURATION];
}

- (void)hideWithAnimate
{
	if(self.superview !=nil)
	{
		self.alpha = 1.0f;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:LOADINGVIEW_ANIMATE_DURATION];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
		self.alpha = 0.0f;
		[UIView commitAnimations];
		
	}
}

- (void)setImage:(UIImage *)image
{
	if(image)
	{
		imageView.image = image;
		imageView.hidden = NO;
		[activityView stopAnimating];
	}else
	{
		imageView.hidden = YES;
		activityView.hidden = NO;
		[activityView startAnimating];
	}
}

- (void)setModelInView:(BOOL)value
{
	backgroundView.hidden = !value;
	if(value)
	{
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	}else
	{
		self.bounds = boardView.bounds;
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
		| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	}	
}


- (void)setInfo:(NSString *)info
{
	labelInfo.text = info;
}

#pragma mark -
#pragma mark class methods

+ (void)showInView:(UIView *)view image:(UIImage *)image info:(NSString *)info 
		  animated:(BOOL)animated modeled:(BOOL)modeled autoHide:(BOOL)autoHide
{
	sShareLoadingView = [QLoadingView shareInstance];
	[sShareLoadingView removeFromSuperview];
	sShareLoadingView.frame = view.bounds;
	
	// setImage
	[sShareLoadingView setImage:image];
	
	//setInfo
	[sShareLoadingView setInfo:info];
	//setModelInView
	[sShareLoadingView setModelInView:modeled];
	
	
	//setAnimated
	if(animated)
	{
		sShareLoadingView.alpha = 0.0f;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:LOADINGVIEW_ANIMATE_DURATION];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		sShareLoadingView.alpha = 1.0f;
		[UIView commitAnimations];
		
	}else
	{
		sShareLoadingView.alpha = 1.0f;
	}
	
	if(autoHide)
	{
		[sShareLoadingView autoHide];
	}
	
	[view addSubview:sShareLoadingView];
}

+ (void)hideWithAnimated:(BOOL)animated
{
	sShareLoadingView = [QLoadingView shareInstance];
	if(animated)
	{
		[sShareLoadingView hideWithAnimate];
	}else
	{
		[sShareLoadingView removeFromSuperview];
	}
	
	
}



+ (void)showImage:(UIImage *)image info:(NSString *)info autoHide:(BOOL)autoHide
{
	[QLoadingView showInView:MainView image:image 
					  info:info animated:NO modeled:NO autoHide:autoHide];
}


+ (void)showDefaultLoadingView
{
	[QLoadingView showInView:MainView 
					 image:nil 
					  info:@"Loading..." 
				  animated:YES modeled:YES autoHide:NO];
}


+ (id)shareInstance
{
	if(sShareLoadingView == nil)
	{
		sShareLoadingView = [[self alloc] initWithFrame:CGRectMake(200, 200, 200, 200)];
	}
	return sShareLoadingView;
}

@end
