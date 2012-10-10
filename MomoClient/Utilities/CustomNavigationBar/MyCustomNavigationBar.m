//
//  MyCustomNavigationBar.m
//  Custom UINavigationBar Demo
//
//  Created by Ryan Twomey on 9/28/11.
//  Copyright 2011 Draconis Software. All rights reserved.
//

#import "MyCustomNavigationBar.h"

@implementation MyCustomNavigationBar

- (void)drawRect:(CGRect)rect {
	UIImage *image = [UIImage imageNamed:@"banner01.png"];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end
