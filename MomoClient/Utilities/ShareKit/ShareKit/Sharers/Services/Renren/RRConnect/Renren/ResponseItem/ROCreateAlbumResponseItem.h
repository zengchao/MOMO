//
//  ROCreateAlbumResponseItem.h
//  SimpleDemo
//
//  Created by Winston on 11-8-15.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "ROResponseItem.h"

@interface ROCreateAlbumResponseItem : ROResponseItem
{
    NSString* _albumId;
}

//注释解释：属性描述;JSON字段名;个别属性值含义
/**
 *表示刚创建的相册id;aid 
 */
@property(nonatomic,readonly)NSString *albumId;

@end
