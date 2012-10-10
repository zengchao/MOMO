//
//  CollapsableTableViewTapRecognizer.m
//  CollapsableTableView
//
//  Created by Bernhard Häussermann on 2011/11/20.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CollapsableTableViewTapRecognizer.h"


@implementation CollapsableTableViewTapRecognizer

@synthesize tapDelegate,fullTitle,tappedView;


- (id) initWithTitle:(NSString*) theFullTitle andTappedView:(UIView*) theTappedView andTapDelegate:(id<TapDelegate>) theTapDelegate
{
    self = [super initWithTarget:theFullTitle action:@selector(temp)];
    if (self)
    {
        [self removeTarget:theFullTitle action:@selector(temp)];
        [self addTarget:self action:@selector(headerTapped)];
        self.fullTitle = theFullTitle;
        tappedView = theTappedView;
        tapDelegate = theTapDelegate;
    }
    return self;
}


- (void) headerTapped
{
    [tapDelegate view:tappedView tappedWithIdentifier:fullTitle];
}


- (void)dealloc 
{
    self.fullTitle = nil;
    
    [super dealloc];
}

@end
