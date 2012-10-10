//
//  ROGetFriendsRequestParam.h
//  Renren Open-platform
//
//  Created by xiawenhai on 11-8-17.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import <Foundation/Foundation.h>
#import "RORequestParam.h"


@interface ROGetFriendsRequestParam : RORequestParam {
	NSString *_page;
	NSString *_count;
}

/**
 *分页的页数
 */
@property (copy,nonatomic)NSString *page;

/**
 *分页后每页的个数
 */
@property (copy,nonatomic)NSString *count;

@end
