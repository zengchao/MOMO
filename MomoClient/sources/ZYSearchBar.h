//
//  ZYSearchBar.h
//  TicketSystem
//
//  Created by ZYVincent  on 12-2-22. 
//---------------------------------
//    文件作用：自定义搜索栏，作为带搜索栏得tableview得一部分使用，
//            也可以单独使用
//    作者：胡涛
//    支持:http://www.ruyijian.com
//    团队QQ群号：219357847
//    团队主题：奋斗路上携手相伴！
//---------------------------------
//  Copyright (c) 2012年 __ZYProSoft__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZYSearchBarDelegate <NSObject>
- (void)searchResultWithKeyWord:(NSString *)keyword;
- (void)beginChooseType:(id)sender;
@end
@interface ZYSearchBar : UIView<UITextFieldDelegate>
{
    UIImageView *backgroundImgView;
    
    UITextField *searchField;
    id<ZYSearchBarDelegate> delegate;
    UIButton *searchButton;

    UIButton *typeSelectButton;
    
}
@property (nonatomic,retain)UITextField *searchField;
@property (nonatomic,retain)UIButton *searchButton;
@property (nonatomic,assign)id<ZYSearchBarDelegate> delegate;
@property (nonatomic,retain)UIButton *typeSelectButton;
@property (nonatomic,retain)UIImageView *backgroundImgView;

- (void)enableSearchBar;
- (void)unEnableSearchBar;

@end
