//
//  QVerifyWebViewController.h
//  QWeiboSDK4iOSDemo
//
//  Created   on 11-1-14.
//   
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface QVerifyWebViewController : UIViewController<UIWebViewDelegate> {
	
    UINavigationBar *_navBar;
	UIWebView *mWebView;
    NSString *tokenKey;
    NSString *tokenSecret;
    ASIHTTPRequest *request;
}
@property(nonatomic,retain)NSString *tokenKey;
@property(nonatomic,retain)NSString *tokenSecret;

@end
