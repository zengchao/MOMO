//
//  Appxmlparser.h
//  MOMO
//
//  Created by apple on 12-7-2.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <Foundation/Foundation.h>
@interface Entry : NSObject {
	NSString *updated;
	NSString *appid;
    NSString *summary;
    NSString *image;
    NSString *title;
}
@property(nonatomic,retain)NSString *updated,*appid;
@property(nonatomic,retain)NSString *summary,*image,*title;
@end

@interface Appxmlparser : NSObject<NSXMLParserDelegate>{
    NSMutableArray *array;
	NSMutableString *stringBuffer;
	Entry *entry;
}

@property(nonatomic,retain)NSMutableString *stringBuffer;
@property(nonatomic,retain)NSMutableArray *array;
@property(nonatomic,retain)Entry *entry;
-(void)parserXmlForString:(NSString *)xml;

@end
