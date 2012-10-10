//
//  ROGlobalStyle.m
//  SimpleDemo
//
//  Created by Winston on 11-8-19.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//
#import "ROGlobalStyle.h"

@implementation ROGlobalStyle

+(UIColor *)renrenBlueColor{
    return RGBCOLOR(0, 94, 172);
}

+(UIColor *)renrenPageColor{
    return RGBCOLOR(243, 250, 255);
}

+(UIColor *)borderGrayColor{
    return RGBACOLOR(76.5, 76.5, 76.5, 0.8);
}

+(UIColor *)borderBlackColor{
    return RGBCOLOR(76.5, 76.5, 76.5);
}

+(UIColor *)borderBlueColor{
    return RGBCOLOR(58.7, 89.3, 153.0);
}

+(BOOL)isPad{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
#endif
    return NO;
}
@end
