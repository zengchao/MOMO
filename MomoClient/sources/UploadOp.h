//
//  PicOperation.h
//  PhotoNotes
//
//  Created by Avid Audio on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//  QQ:1490724

#import <Foundation/Foundation.h>
#import "Global.h"

@interface UploadOp : NSOperation
{
    UIImage *imageToSend;
    NSString *notesToSend;
    NSString *email;
}

@property (retain) UIImage *imageToSend;
@property (copy) NSString *notesToSend;
@property (retain) NSString *email;

- (NSString *)uploading;

@end
