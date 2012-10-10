//
//  ZYSearchBar.m
//  TicketSystem
//
//  Created by ZYVincent  on 12-2-22.
//  Copyright (c) 2012年 __ZYProSoft__. All rights reserved.
//  支持:http://www.ruyijian.com
//    团队QQ群号：219357847
//    团队主题：奋斗路上携手相伴！

#import "ZYSearchBar.h"

#define SEARCH_BAR_HEIGHT 40
#define SEARCH_BAR_WEIGHT 160
#define TYPESELECT_BUTTON_WEIGHT 90

@implementation ZYSearchBar
@synthesize searchField;
@synthesize delegate;
@synthesize searchButton;
@synthesize typeSelectButton;
@synthesize backgroundImgView;

//点击搜索按钮执行得事件
- (void)tapOnSearchButton:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(searchResultWithKeyWord:)]) {
        [searchField resignFirstResponder];
        
        [delegate searchResultWithKeyWord:searchField.text];
        
    }
}
//点击类型选择按钮
- (void)tapOnTypeSelectButton:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(beginChooseType:)]) {
        [delegate beginChooseType:sender];
    }
}

- (void)enableSearchBar
{
    self.searchButton.enabled = YES;
    self.searchField.enabled = YES;
    typeSelectButton.enabled = YES;
    
}
- (void)unEnableSearchBar 
{
    self.searchField.enabled = FALSE;
    self.searchButton.enabled = FALSE;
    typeSelectButton.enabled = FALSE;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //背景图片 
        self.backgroundImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, SEARCH_BAR_HEIGHT)];
        [self addSubview:backgroundImgView];
        [backgroundImgView release];
        
        //摆放位置
        searchField = [[UITextField alloc]initWithFrame:CGRectMake(TYPESELECT_BUTTON_WEIGHT+3, 2, SEARCH_BAR_WEIGHT, SEARCH_BAR_HEIGHT-5)];
        searchField.borderStyle = UITextBorderStyleRoundedRect;
        searchField.adjustsFontSizeToFitWidth = YES;
        searchField.delegate = self;
        
        //按钮
        searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        searchButton.frame = CGRectMake(SEARCH_BAR_WEIGHT+TYPESELECT_BUTTON_WEIGHT+3+3, 2, 320-SEARCH_BAR_WEIGHT-TYPESELECT_BUTTON_WEIGHT-3-3, SEARCH_BAR_HEIGHT-5);
        [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [searchButton addTarget:self action:@selector(tapOnSearchButton:) forControlEvents:UIControlEventTouchUpInside];
        
        //选择查询类型得按钮
        typeSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        typeSelectButton.frame = CGRectMake(0, 2, TYPESELECT_BUTTON_WEIGHT, SEARCH_BAR_HEIGHT-5);
        [typeSelectButton setTitle:@"查询类型" forState:UIControlStateNormal];
        [typeSelectButton addTarget:self action:@selector(tapOnTypeSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:typeSelectButton];
        [self addSubview:searchField];
        [self addSubview:searchButton];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)dealloc{
    [searchField release];
    [searchButton release];
    [super dealloc];
}
@end
