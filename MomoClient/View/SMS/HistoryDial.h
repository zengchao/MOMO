//
//  HistoryDial.h
//  tabtest
//
//  Created by clspace on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryDial : NSObject
{
    NSString *card_id;
    NSString *mobile;
    NSString *name;
    NSString *email;
    NSString *last_calltime;
    NSString *callnum;
    NSString *callcity;
    
}
@property (nonatomic,retain) NSString *card_id;
@property (nonatomic,retain) NSString *mobile;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *email;
@property (nonatomic,retain) NSString *last_calltime;
@property (nonatomic,retain) NSString *callnum;
@property (nonatomic,retain) NSString *callcity;

@end
