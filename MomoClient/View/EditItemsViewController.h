//
//  EditItemsViewController.h
//  MOMO
//
//  Created by 超 曾 on 12-5-16.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Global.h"
#import "UIPlaceHolderTextView.h"

@interface EditItemsViewController : UIViewController<UITextFieldDelegate>
{
    int tag;
    NSString *textValue;
    NSMutableDictionary *mydict;
}

@property(nonatomic,assign)int tag;
@property(nonatomic,retain)UILabel *label;
@property(nonatomic,retain)UITextField *textField;
@property(nonatomic,retain)NSString *textValue;
@property(nonatomic,retain)NSMutableDictionary *mydict;
@property(nonatomic,strong)UISegmentedControl *mySegmentedControl;
@property(nonatomic,strong)UIDatePicker *myDatePicker;

@property (strong, nonatomic) UIPlaceHolderTextView *textView;
@property (assign, nonatomic) CGRect textRect;

@end
