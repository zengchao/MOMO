//
//  QLoadingView.h
//  QWeiboSDK4iOSDemo
//
//  Created   on 11-1-18.
//   
//

#import <Foundation/Foundation.h>


@interface QLoadingView : UIView {

	UIView *backgroundView;
	UIImageView *imageView;
	UILabel *labelInfo;
	UIImageView *boardView;
	UIActivityIndicatorView *activityView;
}

- (void)autoHide;

- (void)setImage:(UIImage *)image;

- (void)setModelInView:(BOOL)value;

- (void)setInfo:(NSString *)info;

+ (void)showInView:(UIView *)view image:(UIImage *)image info:(NSString *)info 
		  animated:(BOOL)animated modeled:(BOOL)modeled autoHide:(BOOL)autoHide;

+ (void)hideWithAnimated:(BOOL)animated;

+ (void)showImage:(UIImage *)image info:(NSString *)info autoHide:(BOOL)autoHide;

+ (void)showDefaultLoadingView;

+ (id)shareInstance;

@end
