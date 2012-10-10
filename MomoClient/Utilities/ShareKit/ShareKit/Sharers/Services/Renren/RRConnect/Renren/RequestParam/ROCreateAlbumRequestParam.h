//  ROCreateAlbumRequestParam.h
//  Renren Open-platform
//
//  Created by xiawenhai on 11-8-12.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//
#import <Foundation/Foundation.h>
#import "RORequestParam.h"

/**
 *封装了创建相册请求参数的类
 */
@interface ROCreateAlbumRequestParam : RORequestParam {
	NSString *_name;
	NSString *_location;
	NSString *_description;
	NSString *_visible;
	NSString *_password;
}

/**
 *相册的名称
 */
@property (copy,nonatomic)NSString *name;

/**
 *相册的地点
 */
@property (copy,nonatomic)NSString *location;

/**
 *相册的描述
 */
@property (copy,nonatomic)NSString *description;

/**
 *相册的隐私
 */
@property (copy,nonatomic)NSString *visible;

/**
 *相册的密码
 */
@property (copy,nonatomic)NSString *password;

@end
