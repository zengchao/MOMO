//
//  SHKTencentWeibo.m
//  ShareKit
//
//  Created by icyleaf on 12-5-3.
//  Copyright (c) 2012年 icyleaf.com. All rights reserved.
//

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

#include <ifaddrs.h>
#include <arpa/inet.h>

#import "SHKTencentWeibo.h"
#import "SHKConfiguration.h"
#import "NSMutableDictionary+NSNullsToEmptyStrings.h"
#import "TencentOAMutableURLRequest.h"
#import "TencentOAuthView.h"
#import "JSONKit.h"

static NSString *const kSHKTencentWeiboUserInfo = @"kSHKTencentWeiboUserInfo";


@interface SHKTencentWeibo (Private)
- (NSString *)getIPAddress;
- (void)handleUnsuccessfulTicket:(NSData *)data;
@end


@implementation SHKTencentWeibo

- (id)init 
{    
    if ((self = [super init]))
	{		
		// OAuth
		self.consumerKey = SHKCONFIG(tencentWeiboConsumerKey);		
		self.secretKey = SHKCONFIG(tencentWeiboConsumerSecret);
 		self.authorizeCallbackURL = [NSURL URLWithString:SHKCONFIG(tencentWeiboCallbackUrl)];
		
		// -- //
		
		// You do not need to edit these, they are the same for everyone
		self.authorizeURL = [NSURL URLWithString:@"https://open.t.qq.com/cgi-bin/authorize"];
		self.requestURL = [NSURL URLWithString:@"https://open.t.qq.com/cgi-bin/request_token"];
		self.accessURL = [NSURL URLWithString:@"https://open.t.qq.com/cgi-bin/access_token"];
	}	
	return self;
}

#pragma mark -
#pragma mark Configuration : Service Defination

+ (NSString *)sharerTitle 
{
	return @"腾讯微博";
}

+ (BOOL)canShareURL 
{
	return YES;
}

+ (BOOL)canShareText 
{
	return YES;
}

+ (BOOL)canShareImage 
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
#pragma mark Commit Share

- (void)share 
{
	BOOL itemPrepared = [self prepareItem];
	
	//the only case item is not prepared is when we wait for URL to be shortened on background thread. In this case [super share] is called in callback method
	if (itemPrepared) {
		[super share];
	}
}


#pragma mark -

- (BOOL)prepareItem 
{
	BOOL result = YES;
	
	if (item.shareType == SHKShareTypeURL)
	{
		BOOL isURLAlreadyShortened = [self shortenURL];
		result = isURLAlreadyShortened;
	}
	
	else if (item.shareType == SHKShareTypeImage)
	{
		[item setCustomValue:item.title forKey:@"status"];
	}
	
	else if (item.shareType == SHKShareTypeText)
    {		
		[item setCustomValue:item.text forKey:@"status"];
	}
	
	return result;
}


#pragma mark -
#pragma mark Authorization

+ (void)logout {
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kSHKTencentWeiboUserInfo];
	[super logout];    
}

#pragma mark -
#pragma mark UI Implementation

- (void)show
{
    if (item.shareType == SHKShareTypeURL)
	{
		[self showTencentWeiboForm];
	}
	
    else if (item.shareType == SHKShareTypeImage)
	{
		[self showTencentWeiboForm];
	}
	
	else if (item.shareType == SHKShareTypeText)
	{
		[self showTencentWeiboForm];
	}
    
    else if (item.shareType == SHKShareTypeUserInfo)
	{
		[self setQuiet:YES];
		[self tryToSend];
	}
}

- (void)showTencentWeiboForm
{
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
		[item setCustomValue:[NSString stringWithFormat:@"%@ %@", item.title, [item.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forKey:@"status"];
		return YES;
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
    
    return NO;
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
    
	[super share];
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
	if (![self validateItemAfterUserEdit])
		return NO;
	
	switch (item.shareType) {
			
		case SHKShareTypeImage:            
			[self sendImage];
			break;
			
		case SHKShareTypeUserInfo:            
            //			[self sendUserInfo];
			break;
			
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
    TencentOAMutableURLRequest *oRequest = [[TencentOAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://open.t.qq.com/api/t/add"] 
                                                                                  consumer:consumer
                                                                                     token:accessToken
                                                                                     realm:nil
                                                                         signatureProvider:signatureProvider];
    
    
	[oRequest setHTTPMethod:@"POST"];
    
    OARequestParameter *format = [[OARequestParameter alloc] initWithName:@"format"
                                                                    value:@"json"];
    
    OARequestParameter *clientip = [[OARequestParameter alloc] initWithName:@"clientip"
                                                                      value:[self getIPAddress]];
    
    OARequestParameter *content = [[OARequestParameter alloc] initWithName:@"content"
                                                                     value:[item customValueForKey:@"status"]];
    
	NSArray *params = [NSArray arrayWithObjects:format, clientip, content, nil];
	[oRequest setParameters:params];
	[format release];
    [clientip release];
    [content release];
	
	OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
                                                                                          delegate:self
                                                                                 didFinishSelector:@selector(sendStatusTicket:finishedWithData:)
                                                                                   didFailSelector:@selector(sendStatusTicket:failedWithError:)];	
    
	[fetcher start];
	[oRequest release];
}


- (void)sendStatusTicket:(OAServiceTicket *)ticket finishedWithData:(NSMutableData *)data 
{	
    if (SHKDebugShowLogs) // check so we don't have to alloc the string with the data if we aren't logging
		SHKLog(@"sendStatusTicket Response Body: %@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
    
	if (ticket.didSucceed) 
    {
        NSDictionary *result = [data objectFromJSONData];
        
        if ([[result valueForKey:@"ret"] intValue] == 0)
            [self sendDidFinish];
        else 
            [self handleUnsuccessfulTicket:data];
    }
	else
	{		
		[self handleUnsuccessfulTicket:data];
	}
}

- (void)sendStatusTicket:(OAServiceTicket *)ticket failedWithError:(NSError*)error
{
	[self sendDidFailWithError:error];
}


- (void)sendImage
{
    TencentOAMutableURLRequest *oRequest = [[TencentOAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://open.t.qq.com/api/t/add_pic"] 
                                                                                  consumer:consumer
                                                                                     token:accessToken
                                                                                     realm:nil
                                                                         signatureProvider:signatureProvider];
    
    
	[oRequest setHTTPMethod:@"POST"];
    
    OARequestParameter *format = [[OARequestParameter alloc] initWithName:@"format"
                                                                    value:@"json"];
    
    OARequestParameter *clientip = [[OARequestParameter alloc] initWithName:@"clientip"
                                                                      value:[self getIPAddress]];
    
    OARequestParameter *content = [[OARequestParameter alloc] initWithName:@"content"
                                                                     value:[item customValueForKey:@"status"]];
    
	NSArray *params = [NSArray arrayWithObjects:format, clientip, content, nil];
	[oRequest setParameters:params];
	[format release];
    [clientip release];
    [content release];
    
    [oRequest prepare];
    
    
    CGFloat compression = 0.9f;
	NSData *imageData = UIImageJPEGRepresentation([item image], compression);
	
	// TODO
	// Note from Nate to creator of sendImage method - This seems like it could be a source of sluggishness.
	// For example, if the image is large (say 3000px x 3000px for example), it would be better to resize the image
	// to an appropriate size (max of img.ly) and then start trying to compress.
	
	while ([imageData length] > 700000 && compression > 0.1) {
		// NSLog(@"Image size too big, compression more: current data size: %d bytes",[imageData length]);
		compression -= 0.1;
		imageData = UIImageJPEGRepresentation([item image], compression);
		
	}
	
	NSString *boundary = @"0xKhTmLbOuNdArY";
	NSString *contentType =[NSString stringWithFormat:@"multipart/form-data;  charset=utf-8; boundary=%@", boundary];
	[oRequest setValue: contentType forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *body =[NSMutableData data];
	NSString *dispKey = @"Content-Disposition: form-data; name=\"pic\"; filename=\"pic\"\r\n";
	
	[body appendData: [[NSString stringWithFormat: @"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData: [dispKey dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData: [@"Content-Type: image/jpg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:imageData];
	[body appendData: [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData: [[NSString stringWithFormat: @"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData: [@"Content-Disposition: form-data; name=\"content\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData: [[item customValueForKey:@"status"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData: [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData: [[NSString stringWithFormat: @"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[oRequest setHTTPBody:body];
    
    
	// Notify delegate
	[self sendDidStart];
    
	// Start the request
	OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
																						  delegate:self
																				 didFinishSelector:@selector(sendImageTicket:finishedWithData:)
																				   didFailSelector:@selector(sendImageTicket:failedWithError:)];
    
	[fetcher start];
	[oRequest release];
}

- (void)sendImageTicket:(OAServiceTicket *)ticket finishedWithData:(NSMutableData *)data
{
	// TODO better error handling here
    SHKLog(@"%@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
    
    if (ticket.didSucceed) 
    {
        NSDictionary *result = [data objectFromJSONData];
        
        if ([[result valueForKey:@"ret"] intValue] == 0)
            [self sendDidFinish];
        else 
            [self handleUnsuccessfulTicket:data];
    }
	else
	{		
		[self handleUnsuccessfulTicket:data];
	}
}

- (void)sendImageTicket:(OAServiceTicket *)ticket failedWithError:(NSError*)error 
{
	[self sendDidFailWithError:error];
}


#pragma mark -

- (void)handleUnsuccessfulTicket:(NSData *)data 
{
    if (SHKDebugShowLogs)
        SHKLog(@"%@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
    
    [self sendDidFailWithError:nil];
}


#pragma mark Request

- (void)tokenRequest
{
	[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Connecting...")];
      
    TencentOAMutableURLRequest *oRequest = [[TencentOAMutableURLRequest alloc] initWithURL:requestURL
                                                                                  consumer:consumer
                                                                                     token:nil
                                                                                     realm:nil
                                                                         signatureProvider:signatureProvider];
	

	[oRequest setHTTPMethod:@"GET"];
    
    OARequestParameter *callback = [[OARequestParameter alloc] initWithName:@"oauth_callback"
                                                                      value:[authorizeCallbackURL absoluteString]];
	NSArray *params = [NSArray arrayWithObjects:callback, nil];
	[oRequest setParameters:params];
	[callback release];
	
    OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
                                                                                          delegate:self
                                                                                 didFinishSelector:@selector(tokenRequestTicket:didFinishWithData:)
                                                                                   didFailSelector:@selector(tokenRequestTicket:didFailWithError:)];
	[fetcher start];	
	[oRequest release];
}

- (void)tokenAuthorize
{	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?oauth_token=%@", 
                                       authorizeURL.absoluteString, 
                                       requestToken.key]];
	
	TencentOAuthView *auth = [[TencentOAuthView alloc] initWithURL:url delegate:self];
	[[SHK currentHelper] showViewController:auth];	
	[auth release];
}

- (void)tokenAccess:(BOOL)refresh
{
	if (!refresh)
		[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Authenticating...")];
	
    TencentOAMutableURLRequest *oRequest = [[TencentOAMutableURLRequest alloc] initWithURL:accessURL
                                                                                  consumer:consumer
                                                                                     token:(refresh ? accessToken : requestToken)
                                                                                     realm:nil
                                                                         signatureProvider:signatureProvider];
    
    [oRequest setHTTPMethod:@"GET"];
    
    OARequestParameter *verifier = [[OARequestParameter alloc] initWithName:@"oauth_verifier"
                                                                      value:[authorizeResponseQueryVars valueForKey:@"v"]];
	NSArray *params = [NSArray arrayWithObjects:verifier, nil];
	[oRequest setParameters:params];
	[verifier release];
	
    OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:oRequest
                                                                                          delegate:self
                                                                                 didFinishSelector:@selector(tokenAccessTicket:didFinishWithData:)
                                                                                   didFailSelector:@selector(tokenAccessTicket:didFailWithError:)];
	[fetcher start];
	[oRequest release];
}


#pragma mark -
#pragma mark Hepler Functions

- (NSString *)getIPAddress 
{
	NSString *address = @"error";
	struct ifaddrs *interfaces = NULL;
	struct ifaddrs *temp_addr = NULL;
	int success = 0;

	//retrieve the current interfaces - returns 0 on success
	success = getifaddrs(&interfaces);
	if (success == 0) {
		//Loop through linked list of interfaces
		temp_addr = interfaces;
		while (temp_addr != NULL) {
			if (temp_addr->ifa_addr->sa_family == AF_INET) {
				//Check if interface is en0 which is the wifi connection on the iPhone
				if ([[NSString stringWithUTF8String: temp_addr->ifa_name] isEqualToString:@"en0"]) {
					//Get NSString from C String
					address =[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *) temp_addr->ifa_addr)->sin_addr)];
				}
			}
			temp_addr = temp_addr->ifa_next;
		}
	}
	//Free memory
	freeifaddrs(interfaces);
	SHKLog(@"current address: %@", address);
	return address;
}


@end
