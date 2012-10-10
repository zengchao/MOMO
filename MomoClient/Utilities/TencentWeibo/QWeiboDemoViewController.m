//
//  QWeiboDemoViewController.m
//  QWeiboSDK4iOSDemo
//
//  Created   on 11-1-17.
//   
//

#import "QWeiboDemoViewController.h"
#import "QWeiboSDK4iOSDemoAppDelegate.h"
#import "QWeiboSyncApi.h"
//#import "QWeiboResultViewController.h"
#import "NSString+QEncoding.h"
#import "QWeiboAsyncApi.h"
#import "QLoadingView.h"

@interface QWeiboDemoViewController () 

@property (nonatomic, retain) NSURLConnection	*connection;
@property (nonatomic, retain) NSMutableData		*responseData;

@end


@implementation QWeiboDemoViewController

@synthesize connection;
@synthesize responseData;

@synthesize textViewContent;
@synthesize switchImage;
@synthesize fileUrl;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 nibNameOrNil = @"QWeiboMainViewController.xib";
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Demo";
	textViewContent.text = @"";
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[textViewContent release];
	[switchImage release];
	[connection release];
	[responseData release];
    [super dealloc];
}


#pragma mark -
#pragma mark UI actions

- (void)getHomePage:(id)sender {
		
	QWeiboSDK4iOSDemoAppDelegate *appDelegate = 
		(QWeiboSDK4iOSDemoAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	//synchronous http request
	
//	QWeiboSyncApi *api = [[QWeiboSyncApi alloc] init];
//	appDelegate.response = [api getHomeMsgWithConsumerKey:appDelegate.appKey 
//										   consumerSecret:appDelegate.appSecret 
//										   accessTokenKey:appDelegate.tokenKey 
//										accessTokenSecret:appDelegate.tokenSecret 
//											   resultType: RESULTTYPE_JSON 
//												pageFlage:PAGEFLAG_FIRST 
//												  nReqNum:20];
	
//	QWeiboResultViewController *resultView = [[QWeiboResultViewController alloc] init];
//	
//	[appDelegate.navigationController pushViewController:resultView animated:YES];
//	
//	[resultView release];
//	[api release];
	
	//asynchronous http request
	
	QWeiboAsyncApi *api = [[[QWeiboAsyncApi alloc] init] autorelease];
	
	self.connection = [api getHomeMsgWithConsumerKey:appDelegate.appKey 
									  consumerSecret:appDelegate.appSecret 
									  accessTokenKey:appDelegate.tokenKey 
								   accessTokenSecret:appDelegate.tokenSecret 
										  resultType: RESULTTYPE_JSON 
										   pageFlage:PAGEFLAG_FIRST 
											 nReqNum:20 
											delegate:self];
	
	[QLoadingView showDefaultLoadingView];
}

- (void)insertImage:(UISwitch *)sender {
	
	if (sender == switchImage) {
		BOOL isOn = switchImage.on;
		if (isOn) {
			UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
			imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			imagePickerController.delegate = self;
			[self presentModalViewController:imagePickerController animated:YES];
			[imagePickerController release];
		}

	}

}

- (void)publishMsg:(id)sender {
	
	QWeiboSDK4iOSDemoAppDelegate *appDelegate = 
		(QWeiboSDK4iOSDemoAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *content = textViewContent.text;
	if ([content isEqualToString:@""]) {
		return;
	}
	BOOL hasImage = switchImage.on;
	
	//synchronous http request
//	QWeiboSyncApi *api = [[QWeiboSyncApi alloc] init];
	
//	appDelegate.response = [api publishMsgWithConsumerKey:appDelegate.appKey 
//										   consumerSecret:appDelegate.appSecret 
//										   accessTokenKey:appDelegate.tokenKey 
//										accessTokenSecret:appDelegate.tokenSecret 
//												  content:content 
//												imageFile:hasImage ? self.fileUrl : nil 
//											   resultType:RESULTTYPE_JSON];
	
//	QWeiboResultViewController *resultView = [[QWeiboResultViewController alloc] init];
//	
//	[appDelegate.navigationController pushViewController:resultView animated:YES];
//	
//	[resultView release];
//	[api release];
	
	//asynchronous http request
	QWeiboAsyncApi *api = [[[QWeiboAsyncApi alloc] init] autorelease];
	
	self.connection	= [api publishMsgWithConsumerKey:appDelegate.appKey 
									  consumerSecret:appDelegate.appSecret 
									  accessTokenKey:appDelegate.tokenKey 
								   accessTokenSecret:appDelegate.tokenSecret 
											 content:content 
										   imageFile:hasImage ? self.fileUrl : nil 
										  resultType:RESULTTYPE_JSON 
											delegate:self];
	
	[QLoadingView showDefaultLoadingView];
	
}

#pragma mark -
#pragma mark UITextViewDelegate

- (void)doneEditting:(id)sender {
	
	[textViewContent resignFirstResponder];
	self.navigationItem.rightBarButtonItem = nil;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											  initWithTitle:@"Done" 
											  style:UIBarButtonItemStyleDone 
											  target:self 
											   action:@selector(doneEditting:)] 
											  autorelease];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
		
	[picker dismissModalViewControllerAnimated:YES];
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
	NSString *filePath = [NSTemporaryDirectory() stringByAppendingFormat:@"temp.png"];
	[UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
	self.fileUrl = filePath;
	
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	
	[picker dismissModalViewControllerAnimated:YES];
	[switchImage setOn:NO animated:YES];
}

#pragma mark -
#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
	self.responseData = [NSMutableData data];
	//NSLog(@"total = %d", [response expectedContentLength]);
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	
//	QWeiboSDK4iOSDemoAppDelegate *appDelegate = 
//		(QWeiboSDK4iOSDemoAppDelegate *)[[UIApplication sharedApplication] delegate];
//	
//	appDelegate.response = [[[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding] autorelease];
	
//	QWeiboResultViewController *resultView = [[QWeiboResultViewController alloc] init];
//	
//	[appDelegate.navigationController pushViewController:resultView animated:YES];
	
	[QLoadingView hideWithAnimated:YES];
	
//	[resultView release];
	self.connection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
//	QWeiboSDK4iOSDemoAppDelegate *appDelegate = 
//	(QWeiboSDK4iOSDemoAppDelegate *)[[UIApplication sharedApplication] delegate];
//	
//	appDelegate.response = [NSString stringWithFormat:@"connection error:%@", error];
//	
//	QWeiboResultViewController *resultView = [[QWeiboResultViewController alloc] init];
//	
//	[appDelegate.navigationController pushViewController:resultView animated:YES];
//	
//	[QLoadingView hideWithAnimated:YES];
//	
//	[resultView release];
//	self.connection = nil;
}

@end
