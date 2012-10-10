//
//  QVerifyWebViewController.m
//  QWeiboSDK4iOSDemo
//
//  Created   on 11-1-14.
//   
//

#import "QVerifyWebViewController.h"
#import "QWeiboSyncApi.h"
#import "QWeiboDemoViewController.h"
#import "Global.h"
#import "NSObject+SBJson.h"

#define tencentAppKey @"27d1186230a443d1ac7f514a96376ada"
#define tencentAppSecret @"eff11cc20a1d582b81f1affe3e754889"
#define VERIFY_URL @"http://open.t.qq.com/cgi-bin/authorize?oauth_token="

@implementation QVerifyWebViewController
@synthesize tokenKey,tokenSecret;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navBar = [[[UINavigationBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)] autorelease];
	_navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview: _navBar];
    
    UINavigationItem *navItem = [[[UINavigationItem alloc] initWithTitle: NSLocalizedString(@"腾讯微博登陆", nil)] autorelease];
	navItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target: self action: @selector(cancel:)] autorelease];
	
	[_navBar pushNavigationItem: navItem animated: NO];

	mWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, 1024.0f, 724.0f)];
	mWebView.delegate = self;
	[self.view addSubview:mWebView];
    
	NSString *url = [NSString stringWithFormat:@"%@%@", VERIFY_URL, tokenKey];
	NSURL *requestUrl = [NSURL URLWithString:url];
	NSURLRequest *req = [NSURLRequest requestWithURL:requestUrl];
	[mWebView loadRequest:req];
}

-(void)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}


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
    [super dealloc];
}

#pragma mark -
#pragma mark private methods

-(NSString*) valueForKey:(NSString *)key ofQuery:(NSString*)query
{
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	for(NSString *aPair in pairs){
		NSArray *keyAndValue = [aPair componentsSeparatedByString:@"="];
		if([keyAndValue count] != 2) continue;
		if([[keyAndValue objectAtIndex:0] isEqualToString:key]){
			return [keyAndValue objectAtIndex:1];
		}
	}
	return nil;
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	
	NSString *query = [[request URL] query];
	NSString *verifier = [self valueForKey:@"oauth_verifier" ofQuery:query];
	
	if (verifier && ![verifier isEqualToString:@""]) {
		
		QWeiboSyncApi *api = [[[QWeiboSyncApi alloc] init] autorelease];
		NSString *responseBody = [api getAccessTokenWithConsumerKey:tencentAppKey 
												  consumerSecret:tencentAppSecret 
												 requestTokenKey:tokenKey 
											  requestTokenSecret:tokenSecret 
														  verify:verifier];
		//NSLog(@"\nget access token:%@", responseBody);
        //oauth_token=9460b0d9264748e4b5b3d52492342281&oauth_token_secret=49dda09135c2dab654b5a2c677923a73&name=shanpai
        
        [[NSUserDefaults standardUserDefaults] setValue:tencentAppKey forKey:@"appkey"];
        [[NSUserDefaults standardUserDefaults] setValue:tencentAppSecret forKey:@"appsecret"];
        [[NSUserDefaults standardUserDefaults] setValue:tokenKey forKey:@"tokenKey"];
        [[NSUserDefaults standardUserDefaults] setValue:tokenSecret forKey:@"AppTokenSecret"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSArray * parts = [responseBody componentsSeparatedByString:@"&"]; 
        //NSLog(@"parts = %@",parts);
        NSString *oauth_token = [[[parts objectAtIndex:0] componentsSeparatedByString:@"="] objectAtIndex:1];
        NSString *oauth_token_secret = [[[parts objectAtIndex:1] componentsSeparatedByString:@"="] objectAtIndex:1];
        
        NSString *user_id = [[[parts objectAtIndex:2] componentsSeparatedByString:@"="] objectAtIndex:1];
        
        //NSLog(@"oauth_token=%@,oauth_token_secret=%@,user_id=%@",oauth_token,oauth_token_secret,user_id);
        //[info setValue:user_id forKey:@"tencent_user_id"];
        [[NSUserDefaults standardUserDefaults] setObject:user_id forKey:@"tencent_user_id"];
        
        [self txSuccess];
        
		return NO;
	}
	
	return YES;
}


- (void) txSuccess
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *userid = [info objectForKey:@"tencent_user_id"];
    
}


@end
