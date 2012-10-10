//
//  MemberDAO.h
//  MOMO
//
//  Created by 超 曾 on 12-6-8.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <Foundation/Foundation.h>
#import "DB.h"
#import "FMDatabase.h"
#import "LBS_Member.h"

@interface MemberDAO : NSObject
{
    FMDatabase  *db;
    FMResultSet *rs;
}

- (NSMutableArray *)getMemberList;
- (BOOL)AddMember:(NSMutableArray *)inArray;
- (LBS_Member *)returnMember:(NSDictionary *)dict;

@end
