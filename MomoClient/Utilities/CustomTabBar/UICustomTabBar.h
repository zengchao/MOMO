//
//  UICustomTabBar.h
//  
//
//  Created by ZYVincent on 11-10-18.
//---------------------------------
//    文件作用：自定义Tabbar
//            
//            
//    作者：胡涛
//    支持:http://www.ruyijian.com
//    团队QQ群号：219357847
//    团队主题：奋斗路上携手相伴！
//---------------------------------
//  Copyright 2011年 __ZYProSoft__. All rights reserved.
//  

#import <UIKit/UIKit.h>

@protocol UICustomTabBar<NSObject>
@optional
- (void)tabBarDidTapped:(id)sender;
@end

@interface UICustomTabBar : UIView {
    id delegate;
    int tabBarTag;
    
    UIImage *normalStateBGImage;
    UIImage *clickedStateBGImage;
    
    UIImageView *bgImageView;
}

@property(nonatomic,assign)id delegate;
@property(nonatomic,assign)int tabBarTag;


-(id)initWithNormalStateImage:(UIImage*)normalStateImage 
         andClickedStateImage:(UIImage*)clickedStateImage;


-(void)switchToClickedState;

-(void)switchToNormalState;

@end
