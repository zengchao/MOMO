//
//  ROGetFriendsRequestParam.m
//  Renren Open-platform
//
//  Created by xiawenhai on 11-8-17.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "ROGetFriendsRequestParam.h"
#import "ROResponse.h"
#import "ROError.h"


@implementation ROGetFriendsRequestParam
@synthesize page = _page;
@synthesize count = _count;

-(id)init
{
	if (self = [super init]) {
		self.method = [NSString stringWithFormat:@"friends.get"];
		self.page = [NSString stringWithFormat:@"1"];
		self.count = [NSString stringWithFormat:@"10"];
	}
	
	return self;
}

-(void)addParamToDictionary:(NSMutableDictionary*)dictionary
{
	if (dictionary == nil) {
		return;
	}
	
	if (self.count != nil && ![self.count isEqualToString:@""]) {
		[dictionary setObject:self.count forKey:@"count"];
	}
	
	if (self.page != nil && ![self.page isEqualToString:@""]) {
		[dictionary setObject:self.page forKey:@"page"];
	}
}

-(ROResponse*)requestResultToResponse:(id)result
{
	id responseObject = nil;
	if ([result isKindOfClass:[NSArray class]]) {
		return [ROResponse responseWithRootObject:result];
	} else {
		if ([result objectForKey:@"error_code"] != nil) {
			responseObject = [ROError errorWithRestInfo:result];
			return [ROResponse responseWithError:responseObject];
		}
		
		return [ROResponse responseWithRootObject:responseObject];
	}
}

-(void)dealloc
{
	self.page = nil;
	self.count = nil;
	[super dealloc];
}

@end
