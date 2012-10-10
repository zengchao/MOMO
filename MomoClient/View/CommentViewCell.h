//
//  CommentViewCell.h
//  ShanZaiQB
//
//  Created by Chua Ivan on 12-1-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewCell : UITableViewCell
{
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *contentLabel;
}

@property (nonatomic,retain) UILabel *nameLabel;
@property (nonatomic,retain) UILabel *contentLabel;

@end
