//
//  CollapsableTableViewTapRecognizer.h
//  CollapsableTableView
//
//  Created by Bernhard Häussermann on 2011/11/20.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TapDelegate.h"


@interface CollapsableTableViewTapRecognizer : UITapGestureRecognizer
{
    id<TapDelegate> tapDelegate;
    
    NSString* fullTitle;
    UIView* tappedView;
}

@property (nonatomic, assign) id<TapDelegate> tapDelegate;
@property (nonatomic, retain) NSString* fullTitle;
@property (nonatomic, assign) UIView* tappedView;

- (id) initWithTitle:(NSString*) theFullTitle andTappedView:(UIView*) theTappedView andTapDelegate:(id<TapDelegate>) theTapDelegate;

@end
