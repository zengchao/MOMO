//
//  ROFriendResponseItem.h
//  SimpleDemo
//
//  Created by Winston on 11-8-18.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "ROResponseItem.h"

@interface ROFriendResponseItem : ROResponseItem{
    
    NSString *_userId;
    NSString *_name;
    NSString *_headUrl;
    NSString *_tinyUrl;
    NSString *_headLogoUrl;
    NSString *_tinyLogoUrl;
}
//注释解释：属性描述;JSON字段名;个别属性值含义
/**
 *表示好友用户id;uid; 
 */
@property(nonatomic, readonly)NSString *userId;
/**
 *表示好友用户name;name; 
 */
@property(nonatomic, readonly)NSString *name;
/**
 *表示好友头像地址;headurl; 
 */
@property(nonatomic, readonly)NSString *headUrl;
/**
 *表示好友小头像地址;tinyurl; 
 */
@property(nonatomic, readonly)NSString *tinyUrl;
/**
 *表示好友带人人logo的头像地址;headurl_with_logo; 
 */
@property(nonatomic, readonly)NSString *headLogoUrl;
/**
 *表示好友带人人logo的小头像地址;tinyurl_with_logo; 
 */
@property(nonatomic, readonly)NSString *tinyLogoUrl;
@end
