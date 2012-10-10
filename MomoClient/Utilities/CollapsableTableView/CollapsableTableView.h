//
//  CollapsableTableView.h
//  CollapsableTableView
//
//  Created by Bernhard Häussermann on 2011/03/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TapDelegate.h"

#define COLLAPSED_INDICATOR_LABEL_TAG 36
#define COLLAPSED_INDICATOR_IMAGE_TAG 37

@interface CollapsableTableView : UITableView <UITableViewDelegate,UITableViewDataSource,TapDelegate>
{
    id<UITableViewDelegate> realDelegate;
    id<UITableViewDataSource> realDataSource;
    
    int toggleHeaderIdx;
    
    NSMutableDictionary *headerTitleToIsCollapsedMap,*headerTitleToSectionIdxMap,*sectionIdxToHeaderTitleMap;
}

@property (nonatomic,readonly) NSDictionary* headerTitleToIsCollapsedMap;

- (void) setIsCollapsed:(BOOL) isCollapsed forHeaderWithTitle:(NSString*) headerTitle;
- (void) setIsCollapsed:(BOOL) isCollapsed forHeaderWithTitle:(NSString*) headerTitle andView:(UIView*) headerView;
- (void) setIsCollapsed:(BOOL) isCollapsed forHeaderWithTitle:(NSString*) headerTitle withRowAnimation:(UITableViewRowAnimation) rowAnimation;
- (void) setIsCollapsed:(BOOL) isCollapsed forHeaderWithTitle:(NSString*) headerTitle andView:(UIView*) headerView withRowAnimation:(UITableViewRowAnimation) rowAnimation;

@end
