//
//  ROGetFriendsInfoRequestParam.h
//  RenrenSDKDemo
//
//  Created by xiawenhai on 11-8-31.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "RORequestParam.h"

@interface ROGetFriendsInfoRequestParam : RORequestParam {
    NSString *_page;
	NSString *_count;
    NSString *_fields;
}

/**
 *分页的页数
 */
@property (copy,nonatomic)NSString *page;

/**
 *分页后每页的个数
 */
@property (copy,nonatomic)NSString *count;

/**
 *查询字段
 */
@property (copy,nonatomic)NSString *fields;

@end
