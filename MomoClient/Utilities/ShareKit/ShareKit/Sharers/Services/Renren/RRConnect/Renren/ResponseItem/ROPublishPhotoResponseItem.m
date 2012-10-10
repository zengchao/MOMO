//
//  ROPublishPhotoResponseItem.m
//  SimpleDemo
//
//  Created by Winston on 11-8-15.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "ROPublishPhotoResponseItem.h"

@implementation ROPublishPhotoResponseItem


@synthesize photoId = _photoId;
@synthesize albumId = _albumId;
@synthesize userId = _userId;
@synthesize srcUrl = _srcUrl;
@synthesize srcSmallUrl = _srcSmallUrl;
@synthesize srcBigUrl = _srcBigUrl;
@synthesize caption = _caption;

-(id)initWithDictionary:(NSDictionary*)responseDictionary
{
    self = [super initWithDictionary:responseDictionary];
    if (self) {
        _photoId = [self valueForItemKey:@"pid"];
        _albumId = [self valueForItemKey:@"aid"];
        _userId = [self valueForItemKey:@"uid"];
        _srcUrl = [self valueForItemKey:@"src"];
        _srcSmallUrl = [self valueForItemKey:@"src_small"];
        _srcBigUrl = [self valueForItemKey:@"src_big"];
        _caption = [self valueForItemKey:@"caption"];
    }
    return self;
}

@end
