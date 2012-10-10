//
//  QWeiboSDK4iOSDemoViewController.m
//  QWeiboSDK4iOSDemo
//
//  Created on 11-1-13.
//   
//

#import "QWeiboSDK4iOSDemoViewController.h"
#import "QWeiboSyncApi.h"
#import "QWeiboSDK4iOSDemoAppDelegate.h"
#import "QVerifyWebViewController.h"
#import	"QWeiboDemoViewController.h"

@implementation QWeiboSDK4iOSDemoViewController

//@synthesize textView;
@synthesize textFieldAppKey;
@synthesize textFieldAppSecret;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"SDK Demo";
	QWeiboSDK4iOSDemoAppDelegate *appDelegate = 
		(QWeiboSDK4iOSDemoAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.textFieldAppKey.text = appDelegate.appKey;
	self.textFieldAppSecret.secureTextEntry = YES;
	self.textFieldAppSecret.text = appDelegate.appSecret;
		
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[textFieldAppKey release];
	[textFieldAppSecret release];
		
    [super dealloc];
}

#pragma mark -
#pragma mark IBAction

- (IBAction)continueClicked:(id)sender {
	
	NSString *consumerKey = self.textFieldAppKey.text;
	NSString *consumerSecret = self.textFieldAppSecret.text;
	
	if (![consumerKey isEqualToString:@""] && ![consumerSecret isEqualToString:@""]) {
				
		QWeiboSDK4iOSDemoAppDelegate *appDelegate = 
			(QWeiboSDK4iOSDemoAppDelegate *)[[UIApplication sharedApplication] delegate];
		
		if (![consumerKey isEqualToString:appDelegate.appKey] || 
			![consumerSecret isEqualToString:appDelegate.appSecret]) {
			appDelegate.appKey = consumerKey;
			appDelegate.appSecret = consumerSecret;
			appDelegate.tokenKey = nil;
			appDelegate.tokenSecret = nil;
		}
		
		
		if (appDelegate.tokenKey && ![appDelegate.tokenKey isEqualToString:@""] && 
			appDelegate.tokenSecret && ![appDelegate.tokenSecret isEqualToString:@""]) {
			
			QWeiboDemoViewController *mainView = [[QWeiboDemoViewController alloc] init];
			[appDelegate.navigationController pushViewController:mainView animated:YES];
			[mainView release];
			
		} else {
			
			QWeiboSyncApi *api = [[[QWeiboSyncApi alloc] init] autorelease];
			NSString *retString = [api getRequestTokenWithConsumerKey:consumerKey consumerSecret:consumerSecret];
			//NSLog(@"Get requestToken:%@", retString);
			
			[appDelegate parseTokenKeyWithResponse:retString];
			
			QVerifyWebViewController *verifyController = 
				[[QVerifyWebViewController alloc] init];
			
			[appDelegate.navigationController pushViewController:verifyController animated:YES];
			[verifyController release];
		}
		
	}
	
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	
	if (theTextField == textFieldAppKey || theTextField == textFieldAppSecret) {
		[theTextField resignFirstResponder];
	}
	
	return YES;
}

@end
