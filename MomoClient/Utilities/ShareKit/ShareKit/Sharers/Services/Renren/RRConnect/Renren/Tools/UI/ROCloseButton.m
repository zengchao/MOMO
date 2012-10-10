//
//  ROCloseButton.m
//  RenrenSDKDemo
//
//  Created by Winston on 11-8-24.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "ROCloseButton.h"

@implementation ROCloseButton

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+(ROCloseButton *)closeButtonForRODialog
{
    return [[[ROCloseButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)] autorelease];
}

-(void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(context, 2.0);
    CGContextStrokeEllipseInRect(context, CGRectMake(2.5, 2.5, 25.0, 25.0));
    CGContextFillEllipseInRect(context, CGRectMake(2.5+0.5, 2.5+0.5, 24.0, 24.0));
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextMoveToPoint(context, 2.5+3.5,2.5+3.5);
	CGContextAddLineToPoint(context, 2.5+21.5, 2.5+21.5);
	CGContextStrokePath(context);
    CGContextMoveToPoint(context, 2.5+3.5, 2.5+21.5);
	CGContextAddLineToPoint(context,2.5+ 21.5,2.5+ 3.5);
	CGContextStrokePath(context);
	
}

@end
