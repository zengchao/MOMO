//
//  ROImageView.m
//  SimpleDemo
//
//  Created by Winston on 11-8-18.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "ROImageView.h"

@implementation ROImageView

@synthesize imageUrl = _imageUrl;
@synthesize imageView = _imageView;
@synthesize activityIndcator = _activityIndcator;
@synthesize imageData = _imageData;
@synthesize imageResponse = _imageResponse;
@synthesize imageConnection = _imageConnection;

- (void)dealloc
{
    [_imageData release];
    [_imageUrl release];
    [_imageView release];
    [_activityIndcator release];
    [_imageResponse release];
    [_imageConnection release];
    [super dealloc];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clearsContextBeforeDrawing = YES;
        [self addSubview:_imageView];
        self.clearsContextBeforeDrawing = YES;
    }
    return self;
}

- (UIActivityIndicatorView *)activityIndcator
{
    if (!_activityIndcator) {
        _activityIndcator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndcator.hidesWhenStopped = YES;
        [self addSubview:_activityIndcator];
    }
    _activityIndcator.center = CGPointMake(self.bounds.size.width*0.5,self.bounds.size.height*0.5 );
    return _activityIndcator;
}

- (void)setImageUrl:(NSString *)imageUrl
{
    
    [_imageUrl release];
    _imageUrl = [imageUrl copy];
    [self.activityIndcator startAnimating];
    self.imageData = [NSMutableData dataWithCapacity:1000];
    NSURLRequest *request = [[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrl]] autorelease];
    self.imageConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    //保存接收到的响应对象，以便响应完毕后的状态。    
    self.imageResponse = response;
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
   //也可以从此委托中获取到图片加载的进度。 
   [self.imageData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //请求异常，在此可以进行出错后的操作，如给UIImageView设置一张默认的图片等。 
    [self.activityIndcator stopAnimating];
    self.imageData = nil;
    self.imageResponse = nil;
    self.imageConnection = nil;
    if (![self image]) {
        [self setImageUrl:_imageUrl];
    }
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self.activityIndcator stopAnimating];
    //加载成功，在此的加载成功并不代表图片加载成功，需要判断HTTP返回状态。
    if (_imageData && _imageData.length > 0) {
        UIImage *img=[UIImage imageWithData:_imageData];
        [self setImage:img];
    }else {
        if (![self image]) {
            [self setImageUrl:_imageUrl];
        }
    }
    self.imageData = nil;
    self.imageResponse = nil;
    self.imageConnection = nil;
}

- (void)setImage:(UIImage *)image
{
    _imageView.image = image;
    _imageView.frame = self.bounds;
    [_imageView setNeedsDisplay];
    [self setNeedsDisplay];
}

- (UIImage *)image
{
    return _imageView.image;
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
