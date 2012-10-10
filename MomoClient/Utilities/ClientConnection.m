//
//  ClientConnection.m
//  MOMO
//
//  Created by 超 曾 on 12-6-14.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "ClientConnection.h"
#import "ASIHTTPRequest.h"

@implementation ClientConnection
@synthesize request;

- (void)dealloc
{
    [super dealloc];
    //[request cancel];
    //[request release];
    
}

- (NSMutableDictionary *)getMyinfo:(NSString *)memberId loginUserId:(NSString *)loginUserId
{
    NSMutableDictionary *retDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:memberId forKey:@"u"];
    [params setObject:loginUserId forKey:@"myid"];
    
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    NSString *baseurl=@"getMemberInfo.php";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL]];
	[self setRequest:[ASIHTTPRequest requestWithURL:url]];
	[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
	[request startSynchronous];
    //显示网络请求信息在status bar上
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
    
    if (request) {
         if ([request responseString]) {
            NSString *result = [request responseString];
            //NSLog(@"%@",result);
            NSMutableDictionary *dict = [result JSONValue];
            if ([dict count]==0) {
                return dict;
            }
            if([dict count]>0)
            {
                NSArray *resultArr = (NSArray *)dict;
                for (NSDictionary *item in resultArr) 
                {
                    retDict = [[NSMutableDictionary alloc] init];
                    [retDict setValue:[item objectForKey: @"userid"] forKey:@"userid"];
                    [retDict setValue:[item objectForKey: @"username"] forKey:@"username"];
                    [retDict setValue:[item objectForKey: @"sex"] forKey:@"sex"];
                    [retDict setValue:[item objectForKey: @"zhiye"] forKey:@"zhiye"];
                    [retDict setValue:[item objectForKey: @"qianming"] forKey:@"qianming"];
                    [retDict setValue:[item objectForKey: @"regdate"] forKey:@"regdate"];
                    [retDict setValue:[item objectForKey: @"aihao"] forKey:@"aihao"];
                    [retDict setValue:[item objectForKey: @"gongsi"] forKey:@"gongsi"];
                    [retDict setValue:[item objectForKey: @"regdate"] forKey:@"regdate"];
                    [retDict setValue:[item objectForKey: @"xuexiao"] forKey:@"xuexiao"];
                    [retDict setValue:[item objectForKey: @"difang"] forKey:@"difang"];      
                    [retDict setValue:[item objectForKey: @"zhuye"] forKey:@"zhuye"];
                    [retDict setValue:[item objectForKey: @"email"] forKey:@"email"];
                    [retDict setValue:[item objectForKey: @"status"] forKey:@"status"];
                    [retDict setValue:[item objectForKey: @"update_time"] forKey:@"update_time"];
                    [retDict setValue:[item objectForKey: @"pic"] forKey:@"pic"];
                    [retDict setValue:[item objectForKey: @"distance"] forKey:@"distance"];
                    [retDict setValue:[item objectForKey: @"sina_weibo_id"] forKey:@"sina_weibo_id"];
                    [retDict setValue:[item objectForKey: @"renren_id"] forKey:@"renren_id"];
                    [retDict setValue:[item objectForKey: @"douban_id"] forKey:@"douban_id"];
                    
                    [retDict setValue:[item objectForKey: @"startposx"] forKey:@"startposx"];
                    [retDict setValue:[item objectForKey: @"startposy"] forKey:@"startposy"];
                    [retDict setValue:[item objectForKey: @"endposx"] forKey:@"endposx"];
                    [retDict setValue:[item objectForKey: @"endposy"] forKey:@"endposy"];
                    [retDict setValue:[item objectForKey: @"startposname"] forKey:@"startposname"];
                    [retDict setValue:[item objectForKey: @"endposname"] forKey:@"endposname"];
                    [retDict setValue:[item objectForKey: @"startoff_time"] forKey:@"startoff_time"];
                    [retDict setValue:[item objectForKey: @"backoff_time"] forKey:@"backoff_time"];
                    [retDict setValue:[item objectForKey: @"restday"] forKey:@"restday"];
                    [retDict setValue:[item objectForKey: @"req_sex"] forKey:@"req_sex"];
                    [retDict setValue:[item objectForKey: @"req_smoke"] forKey:@"req_smoke"];
                    [retDict setValue:[item objectForKey: @"req_fee"] forKey:@"req_fee"];
                    [retDict setValue:[item objectForKey: @"req_peoples"] forKey:@"req_peoples"];
                    
                    [retDict setValue:[item objectForKey: @"zuojia"] forKey:@"zuojia"];
                    [retDict setValue:[item objectForKey: @"jialing"] forKey:@"jialing"];
                    [retDict setValue:[item objectForKey: @"weihao"] forKey:@"weihao"];
                    [retDict setValue:[item objectForKey: @"distance"] forKey:@"distance"];
                    
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd"];
                    NSTimeInterval dateDiff = [[dateFormat dateFromString:[item objectForKey: @"b_date"]] timeIntervalSinceNow];
                    
                    int age=-1 * trunc(dateDiff/(60*60*24))/365;
                    [retDict setValue:[item objectForKey: @"b_date"] forKey:@"b_date"];
                    if(age==0){
                        [retDict setValue:@"未知" forKey:@"age"];   
                    }else{
                        [retDict setValue:[NSString stringWithFormat:@"%d",age] forKey:@"age"];
                    }
                    
                    NSDate *tmpDate = [dateFormat dateFromString:[item objectForKey:@"b_date"]];
                    [retDict setValue:[self getXingzuo:tmpDate] forKey:@"xingzuo"];
                    [retDict setValue:[item objectForKey:@"relation"] forKey:@"relation"];   
                    [dateFormat release];
                    
                }
            }
        }
    }else{
        
    }
    return retDict;
}


-(NSString *)getXingzuo:(NSDate *)in_date
{
    //计算星座
    
    NSString *retStr=@"";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM"];
    int i_month=0;
    NSString *theMonth = [dateFormat stringFromDate:in_date];
    if([[theMonth substringToIndex:0] isEqualToString:@"0"]){
        i_month = [[theMonth substringFromIndex:1] intValue];
    }else{
        i_month = [theMonth intValue];
    }
    
    [dateFormat setDateFormat:@"dd"];
    int i_day=0;
    NSString *theDay = [dateFormat stringFromDate:in_date];
    if([[theDay substringToIndex:0] isEqualToString:@"0"]){
        i_day = [[theDay substringFromIndex:1] intValue];
    }else{
        i_day = [theDay intValue];
    }
    [dateFormat release];
    
    /*
     摩羯座 12月22日------1月19日
     水瓶座 1月20日-------2月18日  
     双鱼座 2月19日-------3月20日
     白羊座 3月21日-------4月19日  
     金牛座 4月20日-------5月20日  
     双子座 5月21日-------6月21日  
     巨蟹座 6月22日-------7月22日  
     狮子座 7月23日-------8月22日  
     处女座 8月23日-------9月22日 
     天秤座 9月23日------10月23日  
     天蝎座 10月24日-----11月21日  
     射手座 11月22日-----12月21日  
     */
    switch (i_month) {
        case 1:
            if(i_day>=20 && i_day<=31){
                retStr=@"水瓶座";
            }
            if(i_day>=1 && i_day<=19){
                retStr=@"摩羯座";
            }
            break;
        case 2:
            if(i_day>=1 && i_day<=18){
                retStr=@"水瓶座";
            }
            if(i_day>=19 && i_day<=31){
                retStr=@"双鱼座";
            }
            break;
        case 3:
            if(i_day>=1 && i_day<=20){
                retStr=@"双鱼座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"白羊座";
            }
            break;
        case 4:
            if(i_day>=1 && i_day<=19){
                retStr=@"白羊座";
            }
            if(i_day>=20 && i_day<=31){
                retStr=@"金牛座";
            }
            break;
        case 5:
            if(i_day>=1 && i_day<=20){
                retStr=@"金牛座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"双子座";
            }
            break;
        case 6:
            if(i_day>=1 && i_day<=21){
                retStr=@"双子座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"巨蟹座";
            }
            break;
        case 7:
            if(i_day>=1 && i_day<=22){
                retStr=@"巨蟹座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"狮子座";
            }
            break;
        case 8:
            if(i_day>=1 && i_day<=22){
                retStr=@"狮子座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"处女座";
            }
            break;
        case 9:
            if(i_day>=1 && i_day<=22){
                retStr=@"处女座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"天秤座";
            }
            break;
        case 10:
            if(i_day>=1 && i_day<=23){
                retStr=@"天秤座";
            }
            if(i_day>=24 && i_day<=31){
                retStr=@"天蝎座";
            }
            break;   
        case 11:
            if(i_day>=1 && i_day<=21){
                retStr=@"天蝎座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"射手座";
            }
            break;
        case 12:
            if(i_day>=1 && i_day<=21){
                retStr=@"射手座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"摩羯座";
            }
            break;
    }
    return retStr;
}


@end
