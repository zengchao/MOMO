//
//  TapDelegate.h
//  CollapsableTableView
//
//  Created by Bernhard Häussermann on 2011/04/03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TapDelegate

- (void) view:(UIView*) view tappedWithIdentifier:(NSString*) identifier;

@end
