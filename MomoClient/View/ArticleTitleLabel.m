//
//  ArticleTitleLabel.m
//  HorizontalTables
//
//  Created by Felipe Laso on 8/20/11.
//  Copyright 2011 Felipe Laso. All rights reserved.
//  QQ:1490724

#import "ArticleTitleLabel.h"
#import "Global.h"

@implementation ArticleTitleLabel

- (void)setPersistentBackgroundColor:(UIColor*)color 
{
    super.backgroundColor = color;
}

- (void)setBackgroundColor:(UIColor *)color 
{
    // do nothing - background color never changes
}

- (void)drawTextInRect:(CGRect)rect
{    
    CGFloat newWidth = rect.size.width - kArticleTitleLabelPadding;
    CGFloat newHeight = rect.size.height; 
    
    CGRect newRect = CGRectMake(kArticleTitleLabelPadding * 0.5, 0, newWidth, newHeight);
    
    [super drawTextInRect:newRect];
}

@end
