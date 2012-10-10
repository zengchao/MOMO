//
//  ROCreateAlbumResponseItem.m
//  SimpleDemo
//
//  Created by Winston on 11-8-15.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//
#import "ROCreateAlbumResponseItem.h"

@implementation ROCreateAlbumResponseItem
@synthesize albumId = _albumId;

-(id)initWithDictionary:(NSDictionary*)responseDictionary
{
    self = [super initWithDictionary:responseDictionary];
    if (self) {
        _albumId = [self valueForItemKey:@"aid"];
    }
    return self;
}

@end
