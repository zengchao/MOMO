//
//  MemberDAO.m
//  MOMO
//
//  Created by 超 曾 on 12-6-8.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "MemberDAO.h"


@implementation MemberDAO

- (NSMutableArray *)getMemberList
{
    NSMutableArray * retArray = [[NSMutableArray alloc] init]; 
    NSString *theDBPath = [DB getDBPath];
    NSString *login_user_id =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"login_user_id"]];
    
    NSString *sql= [[[NSString alloc] initWithFormat:@"select * from lbs_member where userid!='%@' limit 0,20 ",login_user_id] autorelease];
    
    // 连接DB
    db = [FMDatabase databaseWithPath:theDBPath]; 
    if ([db open]) //打开
    {
        [db setShouldCacheStatements:YES];
        rs = [db executeQuery:sql]; //执行查询
        while ([rs next]) 
        {
            LBS_Member *member = [[LBS_Member alloc] init]; 
            member.userid = [rs stringForColumn:@"userid"];
            member.username = [rs stringForColumn:@"username"];
            member.xpos=[rs stringForColumn:@"xpos"];
            member.ypos=[rs stringForColumn:@"ypos"];
            member.password=[rs stringForColumn:@"password"];
            member.qianming=[rs stringForColumn:@"qianming"];
            member.sex=[rs stringForColumn:@"sex"];
            member.b_date=[rs stringForColumn:@"b_date"];
            member.regdate=[rs stringForColumn:@"regdate"];
            member.aihao=[rs stringForColumn:@"aihao"];
            member.zhiye=[rs stringForColumn:@"zhiye"];
            member.gongsi=[rs stringForColumn:@"gongsi"];
            member.difang=[rs stringForColumn:@"difang"];
            member.zhuye=[rs stringForColumn:@"zhuye"];
            member.xuexiao=[rs stringForColumn:@"xuexiao"];
            member.email=[rs stringForColumn:@"email"];
            member.update_time=[rs stringForColumn:@"update_time"];
            member.status=[rs stringForColumn:@"status"];
            member.pic=[rs stringForColumn:@"pic"];
            member.startposx=[rs stringForColumn:@"startposx"];
            member.startposy=[rs stringForColumn:@"startposy"];
            member.endposx=[rs stringForColumn:@"endposx"];
            member.endposy=[rs stringForColumn:@"endposy"];
            member.startposname=[rs stringForColumn:@"startposname"];
            member.endposname=[rs stringForColumn:@"endposname"];
            member.startoff_time=[rs stringForColumn:@"startoff_time"];
            member.backoff_time=[rs stringForColumn:@"backoff_time"];
            member.restday=[rs stringForColumn:@"restday"];
            member.req_sex=[rs stringForColumn:@"req_sex"];
            member.req_smoke=[rs stringForColumn:@"req_smoke"];
            member.req_fee=[rs stringForColumn:@"req_fee"];
            member.req_peoples=[rs stringForColumn:@"req_peoples"];
            member.sina_weibo_id=[rs stringForColumn:@"sina_weibo_id"];
            member.renren_id=[rs stringForColumn:@"renren_id"];
            member.douban_id=[rs stringForColumn:@"douban_id"];
            member.zuojia=[rs stringForColumn:@"zuojia"];
            member.jialing=[rs stringForColumn:@"jialing"];
            member.weihao=[rs stringForColumn:@"weihao"];
            member.distance=[rs stringForColumn:@"distance"];
            member.membertype=[rs stringForColumn:@"membertype"];
            member.state=[rs stringForColumn:@"state"];
            
            [retArray addObject:member];
            [member release];
        }
        [rs close];
        [db close];
    }      
    else
    {
        //NSLog(@"连接打开数据库失败！");
        return nil;
    }
    return retArray;
}

- (BOOL)AddMember:(NSMutableArray *)inArray
{
    ///
    // 连接DB
    NSString *theDBPath = [DB getDBPath];
    db = [FMDatabase databaseWithPath:theDBPath]; 
    if ([db open]) //打开
    {
        int num=1;
        for (int i=0;i<[inArray count];i++)
        {
            LBS_Member *member = [inArray objectAtIndex:i];
            //NSLog(@"status=%@",member.status);
            NSString *sql=[[[NSString alloc] 
                            initWithFormat:@"insert or replace into lbs_member(userid,username,xpos,ypos,password,qianming,sex,b_date,regdate,aihao,zhiye,gongsi,difang,zhuye,xuexiao,email,update_time,status,pic,startposx,startposy,endposx,endposy,startposname,endposname,startoff_time,backoff_time,restday,req_sex,req_smoke,req_fee,req_peoples,sina_weibo_id,renren_id,douban_id,zuojia,jialing,weihao,distance,membertype,state) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',datetime('now'),'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')", 
                            member.userid,
                            member.username,
                            member.xpos,
                            member.ypos,
                            member.password,
                            member.qianming,
                            member.sex,
                            member.b_date,
                            member.regdate,
                            member.aihao,
                            member.zhiye,
                            member.gongsi,
                            member.difang,
                            member.zhuye,
                            member.xuexiao,
                            member.email,
                            member.status,
                            member.pic,
                            member.startposx,
                            member.startposy,
                            member.endposx,
                            member.endposy,
                            member.startposname,
                            member.endposname,
                            member.startoff_time,
                            member.backoff_time,
                            member.restday,
                            member.req_sex,
                            member.req_smoke,
                            member.req_fee,
                            member.req_peoples,
                            member.sina_weibo_id,
                            member.renren_id,
                            member.douban_id,
                            member.zuojia,
                            member.jialing,
                            member.weihao,
                            member.distance,
                            member.membertype,
                            member.state] autorelease];
            //NSLog(@"sql=%@",sql);
            
            if (![db executeUpdate:sql]) //执行查询
            {
                //NSLog(@"数据库执行失败:%@",sql);  
                return FALSE;
            }
            
            num++;
        }
        [rs close];
        [db close];
        
        //NSLog(@"共计:%d条",num);
    }      
    else
    {
        //NSLog(@"连接打开数据库失败！");
        return FALSE;
    }
    
    return TRUE;  
}


- (LBS_Member *)returnMember:(NSDictionary *)dict
{
    
    LBS_Member *member = [[LBS_Member alloc] init];
    member.userid = [dict objectForKey:@"userid"];
    member.username = [dict objectForKey:@"username"];
    member.xpos=[dict objectForKey:@"xpos"];
    member.ypos=[dict objectForKey:@"ypos"];
    member.password=[dict objectForKey:@"password"];
    member.qianming=[dict objectForKey:@"qianming"];
    member.sex=[dict objectForKey:@"sex"];
    member.b_date=[dict objectForKey:@"b_date"];
    member.regdate=[dict objectForKey:@"regdate"];
    member.aihao=[dict objectForKey:@"aihao"];
    member.zhiye=[dict objectForKey:@"zhiye"];
    member.gongsi=[dict objectForKey:@"gongsi"];
    member.difang=[dict objectForKey:@"difang"];
    member.zhuye=[dict objectForKey:@"zhuye"];
    member.xuexiao=[dict objectForKey:@"xuexiao"];
    member.email=[dict objectForKey:@"email"];
    member.update_time=[dict objectForKey:@"update_time"];
    member.status=[dict objectForKey:@"status"];
    member.pic=[dict objectForKey:@"pic"];
    member.startposx=[dict objectForKey:@"startposx"];
    member.startposy=[dict objectForKey:@"startposy"];
    member.endposx=[dict objectForKey:@"endposx"];
    member.endposy=[dict objectForKey:@"endposy"];
    member.startposname=[dict objectForKey:@"startposname"];
    member.endposname=[dict objectForKey:@"endposname"];
    member.startoff_time=[dict objectForKey:@"startoff_time"];
    member.backoff_time=[dict objectForKey:@"backoff_time"];
    member.restday=[dict objectForKey:@"restday"];
    member.req_sex=[dict objectForKey:@"req_sex"];
    member.req_smoke=[dict objectForKey:@"req_smoke"];
    member.req_fee=[dict objectForKey:@"req_fee"];
    member.req_peoples=[dict objectForKey:@"req_peoples"];
    member.sina_weibo_id=[dict objectForKey:@"sina_weibo_id"];
    member.renren_id=[dict objectForKey:@"renren_id"];
    member.douban_id=[dict objectForKey:@"douban_id"];
    member.zuojia=[dict objectForKey:@"zuojia"];
    member.jialing=[dict objectForKey:@"jialing"];
    member.weihao=[dict objectForKey:@"weihao"];
    member.membertype=[dict objectForKey:@"membertype"];
    member.state=[dict objectForKey:@"state"];
    
    return member;
}
@end
