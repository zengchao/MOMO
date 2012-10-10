//
//  MyRoadVC.m
//  MOMO
//
//  Created by 超 曾 on 12-6-8.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "MyRoadVC.h"
#import "ClientConnection.h"

@implementation MyRoadVC
@synthesize btnTime,btnStartpos,btnEndpos,btnRoute,mydict;
@synthesize member_id;
@synthesize username;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
        if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
        {
            [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:TRUE];
    
    if([member_id isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"login_user_id"]])
    {
        NSString *startposName=@"";
        
        NSString *s_ann_subtitle = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"s_ann_subtitle"]];
        
        if([s_ann_subtitle isEqualToString:@"(null)"]){
            [btnStartpos setTitle:@"" forState:UIControlStateNormal];
        }else{
            startposName = [NSString stringWithFormat:@"%@",s_ann_subtitle];
            [btnStartpos setTitle:startposName forState:UIControlStateNormal];
        }
        
        NSString *endposName=@"";
        NSString *e_ann_subtitle = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"e_ann_subtitle"]];
        if([e_ann_subtitle isEqualToString:@"(null)"]){
            [btnEndpos setTitle:@"" forState:UIControlStateNormal];
        }else{
            endposName = [NSString stringWithFormat:@"%@",e_ann_subtitle];
            [btnEndpos setTitle:endposName forState:UIControlStateNormal];
        }
        
        NSString *starttime = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"starttime"]];
        NSString *endtime = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"endtime"]];

        if([starttime isEqualToString:@"(null)"]){
            [btnTime setTitle:@"" forState:UIControlStateNormal];
        }else{
            [btnTime setTitle:[NSString stringWithFormat:@"上班%@,下班%@",starttime,endtime] forState:UIControlStateNormal]; 
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.navigationItem.title=self.username;
    UIBarButtonItem *rightBarButtonItem= [[UIBarButtonItem alloc]
                                          initWithTitle:@"保存"
                                          style:UIBarButtonItemStyleBordered
                                          target:self
                                          action:@selector(savePinche)];
    
    
    NSString *userid = self.member_id;
    NSString *login_user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"login_user_id"];
    if([userid isEqualToString:login_user_id]){
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
    [rightBarButtonItem release];
    
    mydict = [[NSMutableDictionary alloc] init];
    ClientConnection *client = [[ClientConnection alloc] init];
    mydict = [client getMyinfo:userid loginUserId:login_user_id];
    [client release];
    
    if([mydict objectForKey:@"startposname"]!=nil){
        [self.btnStartpos setTitle:[mydict objectForKey:@"startposname"] forState:UIControlStateNormal];
    }
    if([mydict objectForKey:@"endposname"]!=nil){
        [self.btnEndpos setTitle:[mydict objectForKey:@"endposname"] forState:UIControlStateNormal];
    }
    if([mydict objectForKey:@"startoff_time"]!=nil){
        NSString *strtime = [NSString stringWithFormat:@"上班%@,下班%@",[mydict objectForKey:@"startoff_time"],[mydict objectForKey:@"backoff_time"]];
        [self.btnTime setTitle:strtime forState:UIControlStateNormal];
    }
    
    if([mydict objectForKey:@"startposname"]!=nil){
        [[NSUserDefaults standardUserDefaults] setObject:[mydict objectForKey:@"startposname"] forKey:@"s_ann_subtitle"];
    }
    if([mydict objectForKey:@"endposname"]!=nil){
        [[NSUserDefaults standardUserDefaults] setObject:[mydict objectForKey:@"endposname"] forKey:@"e_ann_subtitle"];
    }
    if([mydict objectForKey:@"startposx"]!=nil){
        [[NSUserDefaults standardUserDefaults] setObject:[mydict objectForKey:@"startposx"] forKey:@"s_latitude"];
    }
    if([mydict objectForKey:@"endposx"]!=nil){
        [[NSUserDefaults standardUserDefaults] setObject:[mydict objectForKey:@"endposx"] forKey:@"e_latitude"];
    }
    if([mydict objectForKey:@"startposy"]!=nil){
        [[NSUserDefaults standardUserDefaults] setObject:[mydict objectForKey:@"startposy"] forKey:@"s_longitude"];
    }
    if([mydict objectForKey:@"endposy"]!=nil){
        [[NSUserDefaults standardUserDefaults] setObject:[mydict objectForKey:@"endposy"] forKey:@"e_longitude"];
    }
    if([mydict objectForKey:@"startoff_time"]!=nil){
        [[NSUserDefaults standardUserDefaults] setObject:[mydict objectForKey:@"startoff_time"] forKey:@"starttime"];
    }
    if([mydict objectForKey:@"backoff_time"]!=nil){
        [[NSUserDefaults standardUserDefaults] setObject:[mydict objectForKey:@"backoff_time"] forKey:@"endtime"];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [btnTime release];
    [btnStartpos release];
    [btnEndpos release];
    [btnRoute release];
    [mydict release];
    [member_id release];
    [username release];
    
}

- (void)dealloc
{
    [super dealloc];
    [btnTime release];
    [btnStartpos release];
    [btnEndpos release];
    [btnRoute release];
    [mydict release];
    [member_id release];
    [username release];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)OpenMapWin:(id)sender
{
    sendLocViewController *vc = [[sendLocViewController alloc] initWithNibName:@"sendLocViewController" bundle:nil];
    if([sender isEqual:btnStartpos]){
        vc.isStartpos=@"1";//起始点
        vc.in_latitude  = [[NSUserDefaults standardUserDefaults] objectForKey:@"s_latitude"];
        vc.in_longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"s_longitude"];
        vc.in_title     = [[NSUserDefaults standardUserDefaults] objectForKey:@"s_ann_title"];
        vc.in_subtitle  = [[NSUserDefaults standardUserDefaults] objectForKey:@"s_ann_subtitle"];
    }else{
        vc.isStartpos=@"2";//终止点
        vc.in_latitude  = [[NSUserDefaults standardUserDefaults] objectForKey:@"e_latitude"];
        vc.in_longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"e_longitude"];
        vc.in_title     = [[NSUserDefaults standardUserDefaults] objectForKey:@"e_ann_title"];
        vc.in_subtitle  = [[NSUserDefaults standardUserDefaults] objectForKey:@"e_ann_subtitle"];
    }
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentModalViewController:nav animated:YES];
    [vc release];
    [nav release];
}

-(IBAction)OpenDateWin:(id)sender
{
    SelectTimeViewController *vc = [[SelectTimeViewController alloc] initWithNibName:@"SelectTimeViewController" bundle:nil];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
    
}


-(IBAction)queryRoute:(id)sender
{
    MapDirectionsViewController *controller = [[[MapDirectionsViewController alloc] init] autorelease];
    
    controller.startPoint = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"s_ann_subtitle"]];
    controller.endPoint = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"e_ann_subtitle"]];
    
    controller.travelMode = UICGTravelModeDriving;
    
    [self.navigationController pushViewController:controller animated:YES];
    
    
}

-(void)savePinche
{
    NSString *host = [NSString stringWithFormat:@"%@%@", host_url, @"updateMemberInfo.php"];
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *email = [userDefault objectForKey:@"login_user"];
    NSMutableURLRequest *req = [[NSMutableURLRequest new] autorelease]; 
    NSString *tmp=@"";
    NSString *startposx = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"s_latitude"]];
    NSString *startposy = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"s_longitude"]];
    NSString *endposx = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"e_latitude"]];
    NSString *endposy = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"e_longitude"]];
    NSString *startposname = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"s_ann_subtitle"]];
    NSString *endposname = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"e_ann_subtitle"]];
    NSString *starttime = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"starttime"]];
    NSString *endtime = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"endtime"]];
    
    tmp=[NSString stringWithFormat:@"%@?email=%@&spx=%@&spy=%@&epx=%@&epy=%@&st=%@&bt=%@&spn=%@&epn=%@",host,email,startposx,startposy,endposx,endposy,starttime,endtime,startposname,endposname];
    
    tmp = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)tmp,
                                                              NULL,
                                                              NULL,
                                                              kCFStringEncodingUTF8);
    
    [req setURL:[NSURL URLWithString:tmp]];
    [tmp release];
    [req setHTTPMethod:@"GET"];     
    [req addValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [req setTimeoutInterval:10.0f];
    
    NSHTTPURLResponse* urlResponse = nil;  
    NSError *error = [[NSError alloc] init]; 
    NSData *responseData = [NSURLConnection sendSynchronousRequest:req returningResponse:&urlResponse error:&error];  
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",result); 
    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
        NSDictionary *dict = [result JSONValue];
        if([[dict objectForKey: @"regTag"] isEqualToNumber:[NSNumber numberWithInt:1]]){            
            [self.navigationController popViewControllerAnimated:TRUE];
        }else{
            
        }
    }
    [result release];
    
    [self.navigationController popViewControllerAnimated:TRUE];
}


@end
