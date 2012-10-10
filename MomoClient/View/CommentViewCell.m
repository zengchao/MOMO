//
//  CommentViewCell.m
//  ShanZaiQB
//
//  Created by Chua Ivan on 12-1-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentViewCell.h"

@implementation CommentViewCell

@synthesize contentLabel;
@synthesize nameLabel;

- (void)dealloc 
{
    self.contentLabel = nil;
    self.nameLabel = nil;
    [super dealloc];
}

@end
