//
//  SHKDouban.m
//  ShareKit
//
//  Created by icyleaf on 12-03-16.
//  Copyright 2012 icyleaf.com. All rights reserved.

//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//


#import "SHKDouban.h"
#import "SHKConfiguration.h"
#import "JSONKit.h"
#import "SHKXMLResponseParser.h"
#import "NSMutableDictionary+NSNullsToEmptyStrings.h"

static NSString *const kSHKDoubanUserInfo = @"kSHKDoubanUserInfo";

@interface SHKDouban ()

- (BOOL)shortenURL;
- (void)shortenURLFinished:(SHKRequest *)aRequest;
- (BOOL)validateItemAfterUserEdit;
- (void)handleUnsuccessfulTicket:(NSData *)data;

@end

@implementation SHKDouban

- (id)init
{
	if (self = [super init])
	{	
		// OAUTH				
		self.consumerKey = SHKCONFIG(doubanConsumerKey);		
		self.secretKey = SHKCONFIG(doubanConsumerSecret);
 		self.authorizeCallbackURL = [NSURL URLWithString:SHKCONFIG(doubanCallbackUrl)];

        // -- //
        
		// You do not need to edit these, they are the same for everyone
	    self.authorizeURL = [NSURL URLWithString:@"http://www.douban.com/service/auth/authorize"];
	    self.requestURL = [NSURL URLWithString:@"http://www.douban.com/service/auth/request_token"];
	    self.accessURL = [NSURL URLWithString:@"http://www.douban.com/service/auth/access_token"]; 
	}	
	return self;
}


#pragma mark -
#pragma mark Configuration : Service Defination

+ (NSString *)sharerTitle
{
	return @"豆瓣";
}

+ (BOOL)canShareURL
{
	return YES;
}

+ (BOOL)canShareText
{
	return YES;
}

+ (BOOL)canGetUserInfo
{
	return YES;
}

#pragma mark -
#pragma mark Configuration : Dynamic Enable

- (BOOL)shouldAutoShare
{
	return NO;
}

#pragma mark -
#pragma mark Authorization

+ (void)logout 
{
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kSHKDoubanUserInfo];
	[super logout];    
}

#pragma mark -
#pragma mark UI Implementation

- (void)show
{
	if (item.shareType == SHKShareTypeURL)
	{
		[self shortenURL];
	}
	
	else if (item.shareType == SHKShareTypeImage)
	{
		[item setCustomValue:item.title forKey:@"status"];
		[self showDoubanForm];
	}
	
	else if (item.shareType == SHKShareTypeText)
	{
		[item setCustomValue:item.text forKey:@"status"];
		[self showDoubanForm];
	}
    
    else if (item.shareType == SHKShareTypeUserInfo)
	{
		[self setQuiet:YES];
		[self tryToSend];
	}
}

- (void) doubanLoginSuccess
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    NSString *douban_userid = [info objectForKey:@"bind_user_id"];
    
    
    NSString *host = [NSString stringWithFormat:@"%@%@", host_url, @"updateMemberInfo.php"];
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *email = [userDefault objectForKey:@"login_user"];
    NSMutableURLRequest *req = [[NSMutableURLRequest new] autorelease]; 
    NSString *tmp=@"";
    
    tmp=[NSString stringWithFormat:@"%@?email=%@&douban=%@",host,email,douban_userid];
    
    NSLog(@"%@",tmp);
    [req setURL:[NSURL URLWithString:tmp]];
    [req setHTTPMethod:@"GET"];     
    [req addValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [req setTimeoutInterval:10.0f];
    
    NSHTTPURLResponse* urlResponse = nil;  
    NSError *error = [[NSError alloc] init]; 
    NSData *responseData = [NSURLConnection sendSynchronousRequest:req returningResponse:&urlResponse error:&error];  
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",result); 
    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
        NSDictionary *dict = [result JSONValue];
        if([[dict objectForKey: @"regTag"] isEqualToNumber:[NSNumber numberWithInt:1]]){  
            
        }else{
            
        }
    }
}

- (void)showDoubanForm
{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"bind"] isEqualToString:@"douban"]){
        //新浪微博绑定
        NSLog(@"%@", accessToken.user_id);
        //保存user_id
        [self doubanLoginSuccess];
    }else{
        SHKFormControllerLargeTextField *rootView = [[SHKFormControllerLargeTextField alloc] initWithNibName:nil bundle:nil delegate:self];	
        
        rootView.text = [item customValueForKey:@"status"];
        rootView.maxTextLength = 140;
        rootView.image = item.image;
        rootView.imageTextLength = 25;
        
        self.navigationBar.tintColor = SHKCONFIG_WITH_ARGUMENT(barTintForView:,self);
        
        [self pushViewController:rootView animated:NO];
        [rootView release];
        
        [[SHK currentHelper] showViewController:self];
    }
}

- (void)sendForm:(SHKFormControllerLargeTextField *)form
{	
	[item setCustomValue:form.textView.text forKey:@"status"];
	[self tryToSend];
}

#pragma mark -

- (BOOL)shortenURL
{
    if ([SHKCONFIG(sinaWeiboConsumerKey) isEqualToString:@""] || SHKCONFIG(sinaWeiboConsumerKey) == nil)
        NSAssert(NO, @"ShareKit: Could not shorting url with empty sina weibo consumer key.");
    
	if (![SHK connected])
	{
		[item setCustomValue:[NSString stringWithFormat:@"%@: %@", item.title, [item.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forKey:@"status"];
		[self showDoubanForm];		
		return NO;
	}
    
	if (!quiet)
		[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Shortening URL...")];
	
	self.request = [[[SHKRequest alloc] initWithURL:[NSURL URLWithString:[NSMutableString stringWithFormat:@"http://api.t.sina.com.cn/short_url/shorten.json?source=%@&url_long=%@",
																		  SHKCONFIG(sinaWeiboConsumerKey),						  
																		  SHKEncodeURL(item.URL)
																		  ]]
											 params:nil
										   delegate:self
								 isFinishedSelector:@selector(shortenURLFinished:)
											 method:@"GET"
										  autostart:YES] autorelease];
    
    return YES;
}

- (void)shortenURLFinished:(SHKRequest *)aRequest
{
	[[SHKActivityIndicator currentIndicator] hide];
    
    @try 
    {
        NSArray *result = [[aRequest getResult] objectFromJSONString];
        item.URL = [NSURL URLWithString:[[result objectAtIndex:0] objectForKey:@"url_short"]];
    }
    @catch (NSException *exception) 
    {
        // TODO - better error message
		[[[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Shorten URL Error")
									 message:SHKLocalizedString(@"We could not shorten the URL.")
									delegate:nil
						   cancelButtonTitle:SHKLocalizedString(@"Continue")
						   otherButtonTitles:nil] autorelease] show];
    }
    
    [item setCustomValue:[NSString stringWithFormat:@"%@: %@", item.title, item.URL.absoluteString] 
                  forKey:@"status"];
    
	[self showDoubanForm];
}


#pragma mark -
#pragma mark Share API Methods

- (BOOL)validateItem
{
	if (self.item.shareType == SHKShareTypeUserInfo) {
		return YES;
	}
	
	NSString *status = [item customValueForKey:@"status"];
	return status != nil;
}

- (BOOL)validateItemAfterUserEdit 
{
	BOOL result = NO;
	
	BOOL isValid = [self validateItem];    
	NSString *status = [item customValueForKey:@"status"];
	
	if (isValid && status.length <= 140) {
		result = YES;
	}
	
	return result;
}

- (BOOL)send
{	
	if ( ! [self validateItemAfterUserEdit])
		return NO;
	
    switch (item.shareType) 
    {
//		case SHKShareTypeUserInfo:            
//			[self sendUserInfo];
//			break;
//			
		default:
			[self sendStatus];
			break;
	}
	
	// Notify delegate
	[self sendDidStart];	
	
	return YES;
}

- (void)sendStatus
{
	OAMutableURLRequest *oRequest = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.douban.com/miniblog/saying"]
																	consumer:consumer
																	   token:accessToken
																	   realm:nil
														   signatureProvider:nil];
	
	[oRequest setHTTPMethod:@"POST"];
	[oRequest addValue:@"application/atom+xml" forHTTPHeaderField:@"Content-Type"];
    
	NSMutableString *body = [NSMutableString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8'?>"];
    [body appendFormat:@"<entry xmlns:ns0=\"http://www.w3.org/2005/Atom\" xmlns:db=\"http://www.douban.com/xmlns/\">"];
    [body appendFormat:@"<content><![CDATA[%@]]></content>", [item customValueForKey:@"status"]];
    [body appendFormat:@"</entry>"];
    
    [oRequest setHTTPBody:[body dataUsingEncoding:NSUnicodeStringEncoding allowLossyConversion:YES]];
	
	OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
																						  delegate:self
																				 didFinishSelector:@selector(sendStatusTicket:didFinishWithData:)
																				   didFailSelector:@selector(sendStatusTicket:didFailWithError:)];	
	
	[fetcher start];
	[oRequest release];
}

- (void)sendStatusTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data 
{	
	// TODO better error handling here
	
	if (ticket.didSucceed) 
		[self sendDidFinish];
	
	else
	{		
		[self handleUnsuccessfulTicket:data];
	}
}

- (void)sendStatusTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error
{
	[self sendDidFailWithError:error];
}

#pragma mark - Overrewrite parent method
- (void)tokenAuthorize
{	
    NSString *urlString = [NSString stringWithFormat:@"%@?oauth_token=%@&p=1", authorizeURL.absoluteString, requestToken.key];
    
    if ( ! [[authorizeCallbackURL absoluteString] isEqualToString:@""]) {
        urlString = [NSString stringWithFormat:@"%@&oauth_callback=%@&p=1", 
                     urlString, 
                     [authorizeCallbackURL absoluteString]];
    }

	SHKOAuthView *auth = [[SHKOAuthView alloc] initWithURL:[NSURL URLWithString:urlString] delegate:self];
	[[SHK currentHelper] showViewController:auth];	
	[auth release];
}

#pragma mark -

- (void)handleUnsuccessfulTicket:(NSData *)data
{
	if (SHKDebugShowLogs)
		SHKLog(@"Sina Weibo Send Status Error: %@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
	
	// CREDIT: Oliver Drobnik
	
	NSString *string = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];		
	
	// in case our makeshift parsing does not yield an error message
	NSString *errorMessage = @"Unknown Error";		
	
	NSScanner *scanner = [NSScanner scannerWithString:string];
	
	// skip until error message
	[scanner scanUpToString:@"\"error\":\"" intoString:nil];
	
	
	if ([scanner scanString:@"\"error\":\"" intoString:nil])
	{
		// get the message until the closing double quotes
		[scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\""] intoString:&errorMessage];
	}
	
	
	// this is the error message for revoked access ...?... || removed app from Twitter
	if ([errorMessage isEqualToString:@"Invalid / used nonce"] || [errorMessage isEqualToString:@"Could not authenticate with OAuth."]) {
		
		[self shouldReloginWithPendingAction:SHKPendingSend];
		
	} else {
		
		//when sharing image, and the user removed app permissions there is no JSON response expected above, but XML, which we need to parse. 401 is obsolete credentials -> need to relogin
		if ([[SHKXMLResponseParser getValueForElement:@"code" fromResponse:data] isEqualToString:@"401"]) {
			
			[self shouldReloginWithPendingAction:SHKPendingSend];
			return;
		}
	}
	
	NSError *error = [NSError errorWithDomain:@"SinaWeibo" code:2 userInfo:[NSDictionary dictionaryWithObject:errorMessage forKey:NSLocalizedDescriptionKey]];
	[self sendDidFailWithError:error];
}

@end
