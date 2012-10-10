//
//  SLMkMapView.m
//  sendLoc
//
//  Created by Gao Semaus on 11-9-21.
//  Copyright 2011年 Chlova. All rights reserved.
//

#import "SLMkMapView.h"

@implementation SLMkMapView

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
    }
    
    return self;
}

- (void)awakeFromNib
{
    gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:gestureRecognizer];
    //        [gestureRecognizer release];
}

- (void)longPress:(UILongPressGestureRecognizer *)_gestureRecognizer
{
//    NSLog(@"%d",_gestureRecognizer.state);
    if (_gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.delegate performSelector:@selector(touchesDidClick:) withObject:NSStringFromCGPoint([_gestureRecognizer locationInView:self])];
    }
}

- (void)dealloc
{
    [self removeGestureRecognizer:gestureRecognizer];
    [gestureRecognizer release];
    gestureRecognizer = nil;
    [super dealloc];
}

@end
