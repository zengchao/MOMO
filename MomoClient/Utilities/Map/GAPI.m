//
//  GAPI.m
//  sendLoc
//
//  Created by Gao Semaus on 11-9-21.
//  Copyright 2011年 Chlova. All rights reserved.
//

#import "GAPI.h"

@implementation GAPI

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        myData = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    if (delegate) {
        [delegate release];
        delegate = nil;
    }
    [myData release];
    myData = nil;
    [super dealloc];
}

- (void)setDelegate:(id)_delegate
{
    delegate = [_delegate retain];
}

- (void)requestURL:(NSString *)_url withSuccessSEL:(SEL)_suc errorSEL:(SEL)_err
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_url]];
    [NSURLConnection connectionWithRequest:request delegate:self];
    [request release];
    
    successSEL = _suc;
    errorSEL = _err;
}

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)aResponse
{
    [myData setLength:0];
}
- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data
{
	[myData appendData:data];
}
- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error
{
    [delegate performSelector:errorSEL withObject:error];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection
{
    NSString *str = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
    [delegate performSelector:successSEL withObject:str];
    [str release];
}

@end
