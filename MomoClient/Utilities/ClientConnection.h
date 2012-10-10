//
//  ClientConnection.h
//  MOMO
//
//  Created by 超 曾 on 12-6-14.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <Foundation/Foundation.h>
#import "Global.h"

@class ASIHTTPRequest;

@interface ClientConnection : NSObject
{
    ASIHTTPRequest *request;
}
@property(nonatomic,retain)ASIHTTPRequest *request;

- (NSMutableDictionary *)getMyinfo:(NSString *)memberId loginUserId:(NSString *)loginUserId;
- (NSString *)getXingzuo:(NSDate *)in_date;

@end
