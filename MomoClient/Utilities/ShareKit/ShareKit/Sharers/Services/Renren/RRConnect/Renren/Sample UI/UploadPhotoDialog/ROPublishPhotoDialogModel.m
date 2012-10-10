//
//  ROPublishPhotoDialogModal.m
//  SimpleDemo
//
//  Created by Winston on 11-8-18.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "ROConnect.h"
#import "Renren.h"
#import "ROPublishPhotoDialogModel.h"

@interface ROPublishPhotoDialogModel ()

- (void)setInteralUserInfo;
- (void)requestUserInfo;
- (void)uploadSuccess;
- (void)uploadFail;
- (void)dealWithError:(ROError *)error;


@end

@implementation ROPublishPhotoDialogModel

@synthesize photo = _photo;
@synthesize userName = _userName;
@synthesize headUrl = _headUrl;
@synthesize caption = _caption;

- (void)dealloc
{
    [_photo release];
    [_userName release];
    [_headUrl release];
    [_caption release];
    [_internal release];
    [super dealloc];
}

-(id)initWithRenren:(Renren *)renren
{
    self = [super initWithRenren:renren];
    if (self) {
        self.title = @"上传照片至人人";
        self.closeEnable = YES;
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(UIView *)dialogInternal
{   
    if(_internal == nil){
        _internal = [[ROPublishPhotoInternal alloc] initWithFrame:CGRectZero];
        _internal.dialogModel = self;
        [self setInteralUserInfo];
    }
    return _internal;
}

-(void)dialogLoadingViewWasHidden:(RODialogView *)dialogView
{
    if (self.dialogView == dialogView) {
        //还可以做一些其他的操作
        [self.dialogView dismiss:YES]; 
    }
}

- (void)setInteralUserInfo
{
    if (!_headUrl || !_userName) {
        [self requestUserInfo];
    }else {
        _internal.userNameLabel.text = self.userName;
        _internal.headImageView.imageUrl = self.headUrl;
    }
}

- (void)requestUserInfo
{
    ROUserInfoRequestParam *param = [[ROUserInfoRequestParam alloc] init];
    [_renren getUsersInfo:param andDelegate:self];
    [param release];
}

- (void)upload
{
    self.caption = _internal.captionTextView.text;
    if (self.caption.length > 140) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"照片描述不能超过140字符" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    self.tips = @"上传中...";
    self.isLoading = YES;
    self.wasLoaded = NO;
    [self dialogShowLoadingView];
    ROPublishPhotoRequestParam *param = [[ROPublishPhotoRequestParam alloc] init];
    param.caption = _caption;
    param.imageFile = _photo;
    [_renren publishPhoto:param andDelegate:self];
    [param release];
}

- (void)cancel
{
    [self.dialogView dismiss:YES];
}

- (void)uploadSuccess
{
    self.tips = @"上传成功";
    self.wasLoaded = YES;
    [self dialogShowLoadingView];
}

- (void)uploadFail
{
    self.tips = @"上传失败";
    self.wasLoaded = YES;
    [self dialogShowLoadingView];
}

- (void)dialogViewWillAppear
{
    [super dialogViewWillAppear];
    [self setInteralUserInfo];
}

- (void)dealWithError:(ROError *)error
{
    int errorCode = error.code;
    NSString *errorAlertString = error.localizedDescription;
    switch (errorCode) {
        case 20100:
            errorAlertString = @"您所选择的相册已删除，请重新选择相册";
            break;
        case 20101:
            errorAlertString = @"上传照片失败，请稍后重试";
            break;
        case 20102:
            errorAlertString = @"暂不支持此格式照片，请重新选择（20102）";
            break;
        case 20103:
            errorAlertString = @"暂不支持此格式照片，请重新选择（20103）";
            break;
        case 20105:
            errorAlertString = @"请输入相册密码";
            break;
        default:
            break;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:errorAlertString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark -- RenrenDelegate Method
/**
 * 接口请求成功，第三方开发者实现这个方法
 */
- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response
{
    
    if (response.error) {
        if ([response.param isKindOfClass:[ROPublishPhotoRequestParam class]]) {
           [self renren:renren requestFailWithError:response.error]; 
        }
        return;
    }
    if ([response.rootObject isKindOfClass:[NSArray class]]) {
        if ([(NSArray *)response.rootObject count] == 0) {
            return;
        }
        ROUserResponseItem *item = [(NSArray *)response.rootObject objectAtIndex:0];
        self.userName = item.name;
        self.headUrl = item.tinyUrl;
        [self setInteralUserInfo];
    }
    if ([response.rootObject isKindOfClass:[ROPublishPhotoResponseItem class]]) {
        ROPublishPhotoResponseItem *item = (ROPublishPhotoResponseItem *)response.rootObject;
        NSLog(@"%@",item.responseDictionary);
        [self uploadSuccess];
    }
    
}

/**
 * 接口请求失败，第三方开发者实现这个方法
 */
- (void)renren:(Renren *)renren requestFailWithError:(ROError*)error
{
    /*
    self.tips = [error localizedDescription];
    self.wasLoaded = YES;
     */
    if (renren == self.renren) {
        if ([error.domain isEqualToString:kROErrorDomain]) {
            NSString* apiMethod = [error methodForRestApi];
            if ([apiMethod isEqualToString:@"photos.upload"]) {
                [self dialogHideLoadingView];
                [self dealWithError:error]; 
            }
        }
        else
        {
            [self dialogHideLoadingView];
            [self dealWithError:error];  
        }
    }
    NSLog(@"Upload Photo Dialog View Error:%@",[error localizedDescription]);
    
 
    
}



/**
 * 授权登录成功，第三方开发者实现这个方法
 */
- (void)renrenDidLogin:(Renren *)renren
{
    if (renren == self.renren) {
        //登陆成功了
        [self.dialogView didRenrenAuthorizeSuccess:YES];
    }
  
}
/**
 * renren取消Dialog时调用，第三方开发者实现这个方法
 */
- (void)renrenDialogDidCancel:(Renren *)renren
{
    if (renren == self.renren) {
        //登陆失败
        [self.dialogView didRenrenAuthorizeSuccess:NO];
    }
  
}

/**
 * 授权登录失败，第三方开发者实现这个方法
 */
- (void)renren:(Renren *)renren loginFailWithError:(ROError*)error

{
    if (renren == self.renren) {
        //登陆失败
        [self.dialogView didRenrenAuthorizeSuccess:NO];
        NSLog(@"%@",error.localizedDescription);
    }
   
}

@end
