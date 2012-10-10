//
//  MyWebViewController.h
//  Blank
//
//  Created by 超 曾 on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>

@interface MyWebViewController : UIViewController<UIWebViewDelegate>
{
    UIActivityIndicatorView *activityIndicator;
    NSTimer *timer;
    NSInteger i;
}
@property(nonatomic,strong)IBOutlet UIWebView *mywebview;
@property(nonatomic,assign)UIActivityIndicatorView *activityIndicator;
@property(nonatomic,assign)NSTimer *timer;
@property (strong, nonatomic) NSString *a_content;

- (void) setNavigationBackground:(UINavigationBar *)nav GetImage:(UIImage *)image;
- (void) gowebsite_163:(id)sender;
- (void) gowebsite_sina:(id)sender;
@end
