//
//  PicOperation.m
//  PhotoNotes
//
//  Created by Avid Audio on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//  QQ:1490724

#import "UploadOp.h"

//#define NOTIFY_AND_LEAVE(X) {[self cleanup:X]; return;}
#define NOTIFY_AND_LEAVE(X) {return nil;}
#define DATA(X)	[X dataUsingEncoding:NSUTF8StringEncoding]

// Posting constants
#define IMAGE_CONTENT @"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n"
#define STRING_CONTENT @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n"
#define MULTIPART @"multipart/form-data; boundary=------------0x0x0x0x0x0x0x0x"
#define BOUNDARY @"------------0x0x0x0x0x0x0x0x"

@implementation UploadOp

@synthesize imageToSend;
@synthesize notesToSend;
@synthesize email;

-(void)dealloc
{
    [imageToSend release];
    [notesToSend release];
    [email release];
    
    [super dealloc];
}

- (NSData*)generateFormDataFromPostParam:(NSDictionary*)dictParam
{
    NSMutableData* formData = [NSMutableData data];
	
    NSArray* keys = [dictParam allKeys];

    int index = 0;
    for (; index<[keys count]; ++index) 
    {
        NSString *boundaryString = [NSString stringWithFormat:@"--%@\r\n", BOUNDARY];
        [formData appendData:DATA(boundaryString)];
		
        id value = [dictParam valueForKey:[keys objectAtIndex:index]];
		if ([value isKindOfClass:[NSData class]]) 
		{
			// 处理图片数据
			NSString *formstring = [NSString stringWithFormat:IMAGE_CONTENT, [keys objectAtIndex:index]];
			[formData appendData:DATA(formstring)];
			[formData appendData:value];
		}
		else 
		{
			// 处理注释文本
			NSString *formstring = [NSString stringWithFormat:STRING_CONTENT, [keys objectAtIndex:index]];
			[formData appendData:DATA(formstring)];
			[formData appendData:DATA(value)];
		}
		
		NSString *formstring = @"\r\n";
        [formData appendData:DATA(formstring)];
    }
	
	NSString *formstring =[NSString stringWithFormat:@"--%@--\r\n", BOUNDARY];
    [formData appendData:DATA(formstring)];

    return formData;
}

- (NSString *)uploading
{
	if (!self.imageToSend)
	{
        NOTIFY_AND_LEAVE(@"Please set image before uploading.");
    }    
    
	NSMutableDictionary* postParam = [[[NSMutableDictionary alloc] init] autorelease];
    
    //设置 message 字段内容为“注释信息”
	//[postParam setObject:self.notesToSend forKey:@"message"];

    // 设置 media 字段内容为“照片数据”
    NSData *imageData = UIImageJPEGRepresentation(self.imageToSend, 0.75f);
	[postParam setObject:imageData forKey:@"uploaded"];
	[postParam setObject:self.email forKey:@"email"];
    
	NSData *postData = [self generateFormDataFromPostParam:postParam];
    NSString *postLength = [NSString stringWithFormat:@"%d", postData.length];

    NSString *urlString = [NSString stringWithFormat:@"%@%@",host_url, @"uploader.php"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    if (!urlRequest)
    {
        NOTIFY_AND_LEAVE(@"Error creating the URL Request");
    }
	
	[urlRequest addValue:MULTIPART forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:postLength forHTTPHeaderField:@"Content-Length"];

    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:postData];
	
	// Submit & retrieve results
    NSError *error;
    NSURLResponse *response;
	NSLog(@"send HTTP request to server ......");
    NSData* result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if (!result)
	{
		//[self cleanup:[NSString stringWithFormat:@"Submission error: %@", [error localizedDescription]]];
		return nil;
	}
	
	// Return results
    NSString *outstring = [[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] autorelease];
    return outstring;
}

@end
