//
//  ImageLoader.h
//  FromTable
//
//  Created by hu zhen on 12-3-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//  QQ:1490724

#import <Foundation/Foundation.h>


@interface ImageLoader : NSOperation {
	NSString *imgPath;
	UIView *toView;//将来下载的图片给哪个视图
	NSMutableDictionary *dictionary;
	NSString *rw;
	UIActivityIndicatorView *activity;
}
@property(nonatomic,copy)NSString *imgPath;
@property(nonatomic,retain)UIView *toView;
@property(nonatomic,retain)NSString *rw;
@property(nonatomic,retain)NSMutableDictionary *dictionary;
-(ImageLoader *)initWithInfo:(NSString *)path view:(UIView *)tv dict:(NSMutableDictionary *)dict row:(NSString *)row;
@end
