//
//  PicFrame.m
//  PhotosBrowse
//
//  Created by bupo Jung on 12-5-11.
//  Copyright (c) 2012年 Wuxi Smart Sencing Star. All rights reserved.
//

#import "PicFrame.h"

@implementation PicFrame

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddRect(path, nil, self.bounds);
    CGContextAddPath(context, path);
    //[[UIColor colorWithWhite:1.0f alpha:0.0f]setFill];
    [[UIColor colorWithWhite:1 alpha:1.0f] setStroke];
    CGContextSetLineWidth(context, 7.0f);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
}


@end
