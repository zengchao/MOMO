//
//  ROFriendResponseItem.m
//  SimpleDemo
//
//  Created by Winston on 11-8-18.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "ROFriendResponseItem.h"

@implementation ROFriendResponseItem

@synthesize userId = _userId;
@synthesize name = _name;
@synthesize headUrl = _headUrl;
@synthesize tinyUrl = _tinyUrl;
@synthesize headLogoUrl = _headLogoUrl;
@synthesize tinyLogoUrl = _tinyLogoUrl;

-(id)initWithDictionary:(NSDictionary*)responseDictionary
{
    self = [super initWithDictionary:responseDictionary];
    if (self) {
        _userId = [self valueForItemKey:@"id"];
        _name = [self valueForItemKey:@"name"];
        _headUrl = [self valueForItemKey:@"headurl"];
        _tinyUrl = [self valueForItemKey:@"tinyurl"];
        _headLogoUrl = [self valueForItemKey:@"headurl_with_logo"];
        _tinyLogoUrl = [self valueForItemKey:@"tinyurl_with_logo"];
    }
    return self;
}

@end
