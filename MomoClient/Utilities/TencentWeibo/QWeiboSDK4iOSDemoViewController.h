//
//  QWeiboSDK4iOSDemoViewController.h
//  QWeiboSDK4iOSDemo
//
//  Created on 11-1-13.
//   
//

#import <UIKit/UIKit.h>

@interface QWeiboSDK4iOSDemoViewController : UIViewController<UITextFieldDelegate> {

	//UITextView *textView;
	UITextField *textFieldAppKey;
	UITextField *textFieldAppSecret;
	
}

//@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UITextField *textFieldAppKey;
@property (nonatomic, retain) IBOutlet UITextField *textFieldAppSecret;

- (IBAction)continueClicked:(id)sender;

@end

