//
//  SHKRenRen.m
//  ShareKit
//
//  Created by icyleaf on 11-11-15.
//  Copyright (c) 2011 icyleaf.com. All rights reserved.
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

#import "SHKRenRen.h"
#import "SHKConfiguration.h"
#import "NSMutableDictionary+NSNullsToEmptyStrings.h"

@implementation SHKRenRen
@synthesize renren = _renren;


static SHKRenRen *sharedRenRen = nil;

+ (SHKRenRen *)sharedSHKRenren 
{
    if ( ! sharedRenRen) 
    {
        sharedRenRen = [[SHKRenRen alloc] init];
    }
    
    return sharedRenRen;
}

- (id)init
{
	if ((self = [super init]))
	{		
        _renren = [Renren sharedRenren];
	}
    
	return self;
}


#pragma mark -
#pragma mark Configuration : Service Defination

+ (NSString *)sharerTitle
{
	return @"人人网";
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
#pragma mark Authentication

- (BOOL)isAuthorized
{	
	return [_renren isSessionValid];
}

- (void)promptAuthorization
{
    NSArray *permissions = [NSArray arrayWithObjects:@"status_update", @"photo_upload", nil];
    [_renren authorizationWithPermisson:permissions andDelegate:self];
}

+ (void)logout
{
    [[Renren sharedRenren] logout:[SHKRenRen sharedSHKRenren]];
}

#pragma mark -
#pragma mark UI Implementation

- (void)show
{
    if (item.shareType == SHKShareTypeURL)
	{
        [item setCustomValue:[item.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]  
                      forKey:@"status"];
        
		[self showRenRenForm];
	}
    
    else if (item.shareType == SHKShareTypeImage)
	{
		[self showRenRenPublishPhotoDialog];
	}
	
	else if (item.shareType == SHKShareTypeText)
	{
        [item setCustomValue:item.text forKey:@"status"];
		[self showRenRenForm];
	}
}

- (void) renrenLoginSuccess
{
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    //NSString *renren_userid = [info objectForKey:@"bind_user_id"];
    NSString *renren_userid = [info objectForKey:@"session_UserId"];
    NSLog(@"%@",renren_userid);
    
    
    NSString *host = [NSString stringWithFormat:@"%@%@", host_url, @"updateMemberInfo.php"];
    
    NSString *email = [info objectForKey:@"login_user"];
    NSMutableURLRequest *req = [[NSMutableURLRequest new] autorelease]; 
    NSString *tmp=@"";
    
    tmp=[NSString stringWithFormat:@"%@?email=%@&renren=%@",host,email,renren_userid];
    
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

- (void)showRenRenForm
{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"bind"] isEqualToString:@"renren"]){
        //新浪微博绑定
        //NSLog(@"%@", accessToken.user_id);
        //保存user_id
        [self renrenLoginSuccess];
    }else{
        SHKFormControllerLargeTextField *rootView = [[SHKFormControllerLargeTextField alloc] initWithNibName:nil 
                                                                                                      bundle:nil 
                                                                                                    delegate:self];	
        
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

- (void)showRenRenPublishPhotoDialog
{
    [_renren publishPhotoSimplyWithImage:item.image  
                                     caption:item.title];
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
	
	else
	{	
		if (item.shareType == SHKShareTypeImage) 
        {
			[self showRenRenPublishPhotoDialog];
		} 
        else 
        {
			NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:10];
            [params setObject:@"status.set" forKey:@"method"];
            [params setObject:[item customValueForKey:@"status"] forKey:@"status"];
            [_renren requestWithParams:params andDelegate:self];
		}
		
		// Notify delegate
		[self sendDidStart];	
		
		return YES;
	}
	
	return NO;
}

#pragma mark - RenrenDelegate methods

-(void)renrenDidLogin:(Renren *)renren
{
    [self show];
}

- (void)renren:(Renren *)renren loginFailWithError:(ROError*)error
{
	[self sendDidFailWithError:error];
}

- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response
{
	NSDictionary* params = (NSDictionary *)response.rootObject;
    if (params != nil && [params objectForKey:@"result"] != nil && [[params objectForKey:@"result"] intValue] == 1) 
    {
        [self sendDidFinish];
	}
    else
    {  
        [self sendDidFailWithError:[SHK error:SHKLocalizedString([params objectForKey:@"error_msg"])]];
    }
}

- (void)renren:(Renren *)renren requestFailWithError:(ROError*)error
{ 
    [self sendDidFailWithError:[SHK error:SHKLocalizedString([error localizedDescription])]];
}

@end
