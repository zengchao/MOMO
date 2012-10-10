//  ROCreateAlbumRequestParam.m
//  Renren Open-platform
//
//  Created by xiawenhai on 11-8-12.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//
#import "ROCreateAlbumRequestParam.h"
#import "ROCreateAlbumResponseItem.h"
#import "ROError.h"


@implementation ROCreateAlbumRequestParam
@synthesize name = _name;
@synthesize location = _location;
@synthesize description = _description;
@synthesize visible = _visible;
@synthesize password = _password;

-(id)init
{
	if (self = [super init]) {
		self.method = [NSString stringWithFormat:@"photos.createAlbum"];
	}
	
	return self;
}

-(void)addParamToDictionary:(NSMutableDictionary*)dictionary
{
	if (dictionary == nil) {
		return;
	}
	
	if (self.name != nil && ![self.name isEqualToString:@""]) {
		[dictionary setObject:self.name forKey:@"name"];
	}
	
	if (self.location != nil && ![self.location isEqualToString:@""]) {
		[dictionary setObject:self.location forKey:@"location"];
	}
	
	if (self.description != nil && ![self.description isEqualToString:@""]) {
		[dictionary setObject:self.description forKey:@"description"];
	}
	
	if (self.visible != nil && ![self.visible isEqualToString:@""]) {
		[dictionary setObject:self.visible forKey:@"visible"];
	}
	
	if (self.password != nil && ![self.password isEqualToString:@""]) {
		[dictionary setObject:self.password forKey:@"password"];
	}
}

-(ROResponse*)requestResultToResponse:(id)result
{
	id responseObject = nil;
	if (![result isKindOfClass:[NSArray class]]) {
		if ([result objectForKey:@"error_code"] != nil) {
			responseObject = [ROError errorWithRestInfo:result];
			return [ROResponse responseWithError:responseObject];
		} else {
			responseObject = [[[ROCreateAlbumResponseItem alloc] initWithDictionary:result] autorelease];
		
			return [ROResponse responseWithRootObject:responseObject];
		}
	}
	
	return [ROResponse responseWithRootObject:responseObject];
}

-(void)dealloc
{
	self.name = nil;
	self.location = nil;
	self.description = nil;
	self.visible = nil;
	self.password = nil;
	[super dealloc];
}

@end
