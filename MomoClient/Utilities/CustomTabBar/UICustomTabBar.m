//
//  UICustomTabBar.m
//  
//
//  Created by ZYVincent on 11-10-18.
//  Copyright 2011年 __ZYProSoft__. All rights reserved.
//  http://www.ruyijian.com
//    团队QQ群号：219357847
//    团队主题：奋斗路上携手相伴！

#import "UICustomTabBar.h"


@implementation UICustomTabBar


@synthesize delegate;
@synthesize tabBarTag;


-(id)initWithNormalStateImage:(UIImage*)normalStateImage 
         andClickedStateImage:(UIImage*)clickedStateImage

{
    self=[super init];
    if (self) {
        normalStateBGImage=normalStateImage;
        [normalStateBGImage retain];
        
        clickedStateBGImage=clickedStateImage;
        [clickedStateBGImage retain];
        
        bgImageView=[[UIImageView alloc]init];
        bgImageView.frame=CGRectMake(0, 0, 80, 44);
        
        bgImageView.image=normalStateBGImage;
        [self addSubview:bgImageView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(barTapped)];
        [self addGestureRecognizer:tapGesture];
        [tapGesture release];
    }
    
    return self;
}


-(void)barTapped{
    
    if (delegate&&[delegate respondsToSelector:@selector(tabBarDidTapped:)]) {
        [delegate tabBarDidTapped:self ];
    }
}

-(void)switchToNormalState{
    bgImageView.image=normalStateBGImage;
}

-(void)switchToClickedState{
    bgImageView.image=clickedStateBGImage;
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
    [bgImageView release];
    [normalStateBGImage release];
    [clickedStateBGImage release];
    
    [super dealloc];
}

@end
