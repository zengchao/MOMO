//
//  GAPI.h
//  sendLoc
//
//  Created by Gao Semaus on 11-9-21.
//  Copyright 2011年 Chlova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
@interface GAPI : NSObject
{
    NSMutableData *myData;
    SEL successSEL;
    SEL errorSEL;
    id delegate;
}
- (void)setDelegate:(id)_delegate;
- (void)requestURL:(NSString *)_url withSuccessSEL:(SEL)_suc errorSEL:(SEL)_err;
@end
