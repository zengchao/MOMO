//
//  QWeiboDemoViewController.h
//  QWeiboSDK4iOSDemo
//
//  Created   on 11-1-17.
//   
//

#import <UIKit/UIKit.h>


@interface QWeiboDemoViewController : 
	UIViewController<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {

		UITextView *textViewContent;
		UISwitch *switchImage;
		NSString *fileUrl;
		
		NSURLConnection *connection;
		NSMutableData *responseData;	
}

@property (nonatomic, retain) IBOutlet UITextView	*textViewContent;
@property (nonatomic, retain) IBOutlet UISwitch		*switchImage;
@property (nonatomic, copy) NSString				*fileUrl;


- (IBAction)getHomePage:(id)sender;

- (IBAction)insertImage:(UISwitch *)sender;

- (IBAction)publishMsg:(id)sender;

@end
