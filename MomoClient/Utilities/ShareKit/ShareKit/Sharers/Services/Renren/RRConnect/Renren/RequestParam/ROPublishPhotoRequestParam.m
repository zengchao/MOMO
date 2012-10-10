//
//  ROPublishPhotoRequestParam.m
//  Renren Open-platform
//
//  Created by xiawenhai on 11-8-17.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "ROPublishPhotoRequestParam.h"
#import "ROPublishPhotoResponseItem.h"
#import "ROResponse.h"
#import "ROError.h"


@implementation ROPublishPhotoRequestParam
@synthesize imageFile = _imageFile;
@synthesize caption = _caption;
@synthesize albumID = _albumID;
@synthesize placeID = _placeID;

-(id)init
{
	if (self = [super init]) {
		self.method = [NSString stringWithFormat:@"photos.upload"];
	}
	
	return self;
}

-(void)addParamToDictionary:(NSMutableDictionary*)dictionary
{
	if (dictionary == nil) {
		return;
	}
	
	if (self.imageFile != nil) {
		[dictionary setObject:self.imageFile forKey:@"upload"];
	}
	
	if (self.caption != nil && ![self.caption isEqualToString:@""]) {
		[dictionary setObject:self.caption forKey:@"caption"];
	}
	
	if (self.albumID != nil && ![self.albumID isEqualToString:@""]) {
		[dictionary setObject:self.albumID forKey:@"aid"];
	}
	
	if (self.placeID != nil && ![self.placeID isEqualToString:@""]) {
		[dictionary setObject:self.placeID forKey:@"place_id"];
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
			ROPublishPhotoResponseItem *responseItem = [[[ROPublishPhotoResponseItem alloc] initWithDictionary:result] autorelease];
			return [ROResponse responseWithRootObject:responseItem];
		}
	} 
		
	return [ROResponse responseWithRootObject:responseObject];
}


-(void)dealloc
{
	self.imageFile = nil;
	self.caption = nil;
	self.albumID = nil;
	self.placeID = nil;
	[super dealloc];
}

@end
