//
//  DB.m
//  tabtest
//
//  Created by clspace on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DB.h"

@implementation DB

+ (NSString*) getDBPath
{
    NSString *dbPath  = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
                         stringByAppendingPathComponent:@"pinche.db"];
    //NSLog(@"path=%@",dbPath);
    return dbPath;	
}

@end
