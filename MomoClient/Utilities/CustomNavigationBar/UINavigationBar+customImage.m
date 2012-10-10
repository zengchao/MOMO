//
//  UINavigationBar+customImage.m
//  MOMO
//
//  Created by 超 曾 on 12-6-26.
//  Copyright (c) 2012年 My Company. All rights reserved.
//

#import "UINavigationBar+customImage.h"

@implementation UINavigationBar(customImage)

- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:@"banner01"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end


