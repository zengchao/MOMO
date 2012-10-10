//
//  ROPublishPhotoResponseItem.h
//  SimpleDemo
//
//  Created by Winston on 11-8-15.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//
#import "ROResponseItem.h"

@interface ROPublishPhotoResponseItem : ROResponseItem{
    NSString* _photoId;
    NSString* _albumId;
    NSString* _userId;
    NSString* _srcUrl;
    NSString* _srcSmallUrl;
    NSString* _srcBigUrl;
    NSString* _caption;
    
}
//注释解释：属性描述;JSON字段名;个别属性值含义
/*
 *表示照片的ID;pid 
 */
@property(nonatomic,readonly)NSString* photoId;
/*
 *表示照片所在相册id;aid 
 */
@property(nonatomic,readonly)NSString* albumId;
/*
 *表示照片所有者的用户ID;uid 
 */
@property(nonatomic,readonly)NSString* userId;
/*
 *表示在相册列表的缩略图地址，100*150;src 
 */
@property(nonatomic,readonly)NSString* srcUrl;
/*
 *表示封面图地址，200*300;src_small 
 */
@property(nonatomic,readonly)NSString* srcSmallUrl;
/*
 *表示正常照片地址，600*900;src_big 
 */
@property(nonatomic,readonly)NSString* srcBigUrl;
/*
 *表示照片的描述信息;caption 
 */
@property(nonatomic,readonly)NSString* caption;

@end
