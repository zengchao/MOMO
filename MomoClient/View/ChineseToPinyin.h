//
//  ChineseToPinyin.h
//  LianPu
//
//  Created by shawnlee on 10-12-16.
//  Copyright 2010 lianpu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ALPHA	@"ABCDEFGHIJKLMNOPQRSTUVWXYZ#"

@interface ChineseToPinyin : NSObject {

}

+ (NSString *) pinyinFromChiniseString:(NSString *)string;
+ (char) sortSectionTitle:(NSString *)string; 
@end
