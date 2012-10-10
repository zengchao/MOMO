//
//  ROGetFriendsInfoRequestParam.m
//  RenrenSDKDemo
//
//  Created by xiawenhai on 11-8-31.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//
#import "ROGetFriendsInfoRequestParam.h"
#import "ROFriendResponseItem.h"

@implementation ROGetFriendsInfoRequestParam
@synthesize page = _page;
@synthesize count = _count;
@synthesize fields = _fields;

-(id)init
{
	if (self = [super init]) {
		self.method = [NSString stringWithFormat:@"friends.getFriends"];
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
    
    if (self.fields != nil && ![self.fields isEqualToString:@""]) {
		[dictionary setObject:self.fields forKey:@"fields"];
	}
}

-(ROResponse*)requestResultToResponse:(id)result
{
	id responseObject = nil;
	if ([result isKindOfClass:[NSArray class]]) {
        responseObject = [[[NSMutableArray alloc] init] autorelease];
		
		for (NSDictionary *item in result) {
			ROFriendResponseItem *responseItem = [[[ROFriendResponseItem alloc] initWithDictionary:item] autorelease];
			[(NSMutableArray*)responseObject addObject:responseItem];
		}
		
		return [ROResponse responseWithRootObject:responseObject];
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
    self.fields = nil;
	[super dealloc];
}

@end
