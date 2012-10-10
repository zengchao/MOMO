//
//  MapViewOverly.h
//  sendLoc
//
//  Created by Gao Semaus on 11-9-20.
//  Copyright 2011年 Chlova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewOverly : UIView
{
    id delegate;
    BOOL canTouch;
    CGPoint touchPoint;
    
    UIImageView *imageview;
}
- (void)setDelegate:(id)_delegate;
@end
