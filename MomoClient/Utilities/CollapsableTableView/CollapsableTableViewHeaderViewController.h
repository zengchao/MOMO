//
//  CollapsableTableViewHeaderViewController.h
//  CollapsableTableView
//
//  Created by Bernhard Häussermann on 2011/04/01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapDelegate.h"
#import "CollapsableTableViewTapRecognizer.h"
#import "CollapsableTableView.h"


@interface CollapsableTableViewHeaderViewController : UIViewController 
{
    IBOutlet UILabel *collapsedIndicatorLabel,*titleLabel,*detailLabel;
    IBOutlet UIImageView *collapsedIndicatorImageView;
    CollapsableTableViewTapRecognizer* tapRecognizer;

    BOOL viewWasSet;
    id<TapDelegate> tapDelegate;

    NSString* fullTitle;
    BOOL isCollapsed;
}

@property (nonatomic, retain) NSString* fullTitle;
@property (nonatomic, readonly) UILabel* titleLabel;
@property (nonatomic, retain) NSString* titleText;
@property (nonatomic, readonly) UILabel* detailLabel;
@property (nonatomic, retain) NSString* detailText;
@property (nonatomic, assign) id<TapDelegate> tapDelegate;
@property (nonatomic, assign) BOOL isCollapsed;

@end
