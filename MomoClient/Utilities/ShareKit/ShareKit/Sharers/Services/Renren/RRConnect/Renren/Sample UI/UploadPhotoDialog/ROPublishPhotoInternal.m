//
//  ROPublishPhotoInternal.m
//  SimpleDemo
//
//  Created by Winston on 11-8-18.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "ROPublishPhotoInternal.h"

@implementation ROPublishPhotoInternal

@synthesize dialogModel = _dialogModel;
@synthesize userNameLabel = _userNameLabel;
@synthesize headImageView = _headImageView;
@synthesize photoImageView = _photoImageView;
@synthesize captionTextView = _captionTextView;
@synthesize captionLimitLabel = _captionLimitLabel;
- (void)dealloc
{
    self.dialogModel = nil;
    [_userNameLabel release];
    [_headImageView release];
    [_photoImageView release];
    [_captionTextView release];
    [_cancelButton release];
    [_uploadButton release];
    [_captionLimitLabel release];
    [_photoBackgroundView release];
    [_captionBackgroundView release];
    [_headBackgroundView release];
    [_optionBackgroundView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentMode = UIViewContentModeRedraw;
        self.backgroundColor = [ROGlobalStyle renrenPageColor];
        
        _optionBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bottom-bar.png"]stretchableImageWithLeftCapWidth:1 topCapHeight:5]];
        [self addSubview:_optionBackgroundView];
        
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = [UIFont systemFontOfSize:18.0];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_userNameLabel];
        
        _headImageView = [[ROImageView alloc] init];
        [self addSubview:_headImageView];
        
        _photoBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"photo-frame.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:4]];
        _photoBackgroundView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_photoBackgroundView];
        _photoImageView = [[UIImageView alloc] init];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_photoImageView];
        
        _captionBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"input-frame.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
        _captionBackgroundView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_captionBackgroundView];
        _captionTextView = [[UITextView alloc] init];
        _captionTextView.delegate = self;
        _captionTextView.backgroundColor = [UIColor clearColor];
        _captionTextView.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_captionTextView];
        
        _uploadButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_uploadButton setTitle:@"上传" forState:UIControlStateNormal];
        [_uploadButton addTarget:self action:@selector(doUpload:) forControlEvents:UIControlEventTouchUpInside];
        _uploadButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_uploadButton setBackgroundImage:[UIImage imageNamed:@"small-button-normal.png"] forState:UIControlStateNormal];
        [self addSubview:_uploadButton];
        _cancelButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(doCancel:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"small-button-normal.png"] forState:UIControlStateNormal];
        [self addSubview:_cancelButton];
        
        _captionLimitLabel = [[UILabel alloc] init];
        _captionLimitLabel.backgroundColor = [UIColor clearColor];
        _captionLimitLabel.font = [UIFont systemFontOfSize:12];
        _captionLimitLabel.textColor = [UIColor darkGrayColor];
        _captionLimitLabel.textAlignment = UITextAlignmentRight;
        [self addSubview:_captionLimitLabel];
        
        _headBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head-frame.png"]];
        _headBackgroundView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_headBackgroundView];
        
       
        
        
    }
    return self;
}

#pragma mark UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView 
{
    _isKeywordHidden = NO;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    [_captionTextView resignFirstResponder];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self setCaptionLimitTips];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _isKeywordHidden = NO;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _isKeywordHidden = YES;
    [textView scrollRangeToVisible:NSMakeRange(0, 0)];
}

- (void)setCaptionLimitTips
{
    int captionLen = 0;
    if (_captionTextView.text) {
       captionLen = _captionTextView.text.length;
    }
    _captionLimitLabel.text = [NSString stringWithFormat:@"%d/140",captionLen];
    _captionLimitLabel.textColor = [UIColor darkGrayColor];
    if (captionLen > 140) {
        _captionLimitLabel.textColor = [UIColor redColor];
    }
}

- (void)setDialogModel:(ROPublishPhotoDialogModel *)dialogModel
{
    _dialogModel = dialogModel;
    self.captionTextView.text = dialogModel.caption;
    self.photoImageView.image = dialogModel.photo;
    [self setCaptionLimitTips];
}

- (void)doUpload:(id)sender
{
    [self.dialogModel upload];
}

- (void)doCancel:(id)sender
{
    [self.dialogModel cancel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        //设置横屏时布局
        [self setHorizontalFrame]; 
    } else {
        //设置竖屏时布局
        [self setVerticalFrame]; 
    }
}
 //设置竖屏时布局
-(void)setVerticalFrame
{
    _userNameLabel.frame = CGRectMake(70, 10, 200, 23);
    
    _headImageView.frame = CGRectMake(10,10, 50, 50);
    _headBackgroundView.frame = CGRectInset(_headImageView.frame, -8, -8);
    
    
    _captionBackgroundView.frame = CGRectMake(10, 70, 260, 120);
    _captionTextView.frame = CGRectInset(_captionBackgroundView.frame, 2, 2);
    _captionTextView.contentSize = _captionTextView.bounds.size;
    
    _photoBackgroundView.frame = CGRectMake(10, 202.5, 260, 130);
    _photoImageView.frame = CGRectInset(_photoBackgroundView.frame, 4, 4);
    
    _uploadButton.frame = CGRectMake(140, 355, 60, 30);
    _cancelButton.frame = CGRectMake(210, 355, 60, 30);
    _captionLimitLabel.frame = CGRectMake(190, 50, 80, 20);
    _optionBackgroundView.frame = CGRectMake(0, self.frame.size.height-50, self.frame.size.width, 50);
}
  //设置横屏时布局
-(void)setHorizontalFrame
{
    _userNameLabel.frame = CGRectMake(70, 0, 340, 23);
    
    _headImageView.frame = CGRectMake(10,5, 50, 50);
    _headBackgroundView.frame = CGRectInset(_headImageView.frame, -8, -8);
    
    _captionBackgroundView.frame = CGRectMake(70, 25, 355, 55);
    _captionTextView.frame = CGRectInset(_captionBackgroundView.frame, 4, 4);
    _captionTextView.contentSize = _captionTextView.bounds.size;
   
    _photoBackgroundView.frame = CGRectMake(70, 87.5, 200, 100);
    _photoImageView.frame = CGRectInset(_photoBackgroundView.frame, 4, 4);
   
    _uploadButton.frame = CGRectMake(290, 200, 60, 30);
    _cancelButton.frame = CGRectMake(360, 200, 60, 30);
    _captionLimitLabel.frame = CGRectMake(345, 5, 80, 20);
    _optionBackgroundView.frame = CGRectMake(0, self.frame.size.height-40, self.frame.size.width, 40);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (!CGRectContainsPoint(_captionTextView.frame,[touch locationInView:self])) {
        if (!_isKeywordHidden) {
            [self textViewShouldEndEditing:_captionTextView];
        }
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

@end
