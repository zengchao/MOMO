//
//  MapViewOverly.m
//  sendLoc
//
//  Created by Gao Semaus on 11-9-20.
//  Copyright 2011年 Chlova. All rights reserved.
//

#import "MapViewOverly.h"

@implementation MapViewOverly

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        canTouch = YES;
        
        imageview = [[UIImageView alloc] initWithFrame:CGRectMake(280, 420, 40, 40)];
        imageview.backgroundColor = [UIColor redColor];
        [self addSubview:imageview];
    }
    return self;
}

- (void)setDelegate:(id)_delegate
{
    delegate = [_delegate retain];
}

- (void)resetCanTouch
{
    canTouch = YES;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(imageview.frame, point)) {
        return self;
    }
    
    
    

    return nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    imageview.backgroundColor = [UIColor greenColor];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    imageview.backgroundColor = [UIColor redColor];
    
    
    UITouch *touch = [touches anyObject];
    touchPoint = [touch locationInView:self];
    
    if (canTouch) {
//        NSLog(@"%@",event);
        canTouch = NO;
        [delegate performSelector:@selector(touchesDidClick:) withObject:NSStringFromCGPoint(touchPoint)];
        [self performSelector:@selector(resetCanTouch) withObject:nil afterDelay:0.1];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)dealloc
{
    [imageview release];
    imageview = nil;
    if (delegate) {
        [delegate release];
        delegate = nil;
    }
    [super dealloc];
}
@end
