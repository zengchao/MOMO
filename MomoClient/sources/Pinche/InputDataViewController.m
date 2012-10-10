//
//  InputDataViewController.m
//  MOMO
//
//  Created by 超 曾 on 12-5-23.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "InputDataViewController.h"
#import "ClientConnection.h"

@implementation InputDataViewController
@synthesize flag;
@synthesize btnStartpos,btnEndpos,btnAdd,btnTime,btnDecrease;
@synthesize segSex,segFee,segSmoke;
@synthesize txtPeoples;
@synthesize labelStartpos,labelEndpos;
@synthesize btnRoute;
@synthesize mydict;
@synthesize request;
@synthesize vcLoc;
@synthesize vcSelect;
@synthesize vcNear;
@synthesize vcMapD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
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

-(IBAction)queryRoute:(id)sender
{
    vcMapD = [[MapDirectionsViewController alloc] init];
    
    vcMapD.startPoint = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"s_ann_subtitle"]];
    vcMapD.endPoint = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"e_ann_subtitle"]];
    
    vcMapD.travelMode = UICGTravelModeDriving;

    [self.navigationController pushViewController:vcMapD animated:YES];

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
    
    mydict = [[NSMutableDictionary alloc] init];
    
    if([flag isEqualToString:@"0"]){
        self.navigationItem.title=@"我有车";
    }else if([flag isEqualToString:@"1"]){
        self.navigationItem.title=@"我要搭车";
    }else if([flag isEqualToString:@"2"]){
        self.navigationItem.title=@"我要拼车";
    }
    
//    UIBarButtonItem *rightBarButtonItem= [[UIBarButtonItem alloc]
//                          initWithTitle:@"保存"
//                          style:UIBarButtonItemStyleBordered
//                          target:self
//                          action:@selector(savePinche)];
//    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
//    [rightBarButtonItem release];
    
    NSString *login_user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"login_user_id"];
    ClientConnection *client = [[ClientConnection alloc] init];
    mydict = [client getMyinfo:login_user_id loginUserId:login_user_id];
    [client release];
    
    [self.btnStartpos setTitle:[mydict objectForKey:@"startposname"] forState:UIControlStateNormal];
    [self.btnEndpos setTitle:[mydict objectForKey:@"endposname"] forState:UIControlStateNormal];
    NSString *strtime = [NSString stringWithFormat:@"上班%@,下班%@",[mydict objectForKey:@"startoff_time"],[mydict objectForKey:@"backoff_time"]];
    [self.btnTime setTitle:strtime forState:UIControlStateNormal];
    self.segSex.selectedSegmentIndex = [[NSString stringWithFormat:@"%@",[mydict objectForKey:@"req_sex"]] intValue];
    self.segSmoke.selectedSegmentIndex = [[NSString stringWithFormat:@"%@",[mydict objectForKey:@"req_smoke"]] intValue];
    self.segSex.selectedSegmentIndex = [[NSString stringWithFormat:@"%@",[mydict objectForKey:@"req_fee"]] intValue];
    self.txtPeoples.text= [NSString stringWithFormat:@"%@",[mydict objectForKey:@"req_peoples"]];
    if([self.txtPeoples.text isEqualToString:@"(null)"]){
        self.txtPeoples.text=@"3";
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[mydict objectForKey:@"startposname"] forKey:@"s_ann_subtitle"];
    [[NSUserDefaults standardUserDefaults] setObject:[mydict objectForKey:@"endposname"] forKey:@"e_ann_subtitle"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[mydict objectForKey:@"startposx"] forKey:@"s_latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[mydict objectForKey:@"endposx"] forKey:@"e_latitude"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[mydict objectForKey:@"startposy"] forKey:@"s_longitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[mydict objectForKey:@"endposy"] forKey:@"e_longitude"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[mydict objectForKey:@"startoff_time"] forKey:@"starttime"];
    [[NSUserDefaults standardUserDefaults] setObject:[mydict objectForKey:@"backoff_time"] forKey:@"endtime"];
    [[NSUserDefaults standardUserDefaults] setObject:[mydict objectForKey:@"req_sex"] forKey:@"req_sex"];
    [[NSUserDefaults standardUserDefaults] setObject:[mydict objectForKey:@"req_smoke"] forKey:@"req_smoke"];
    [[NSUserDefaults standardUserDefaults] setObject:[mydict objectForKey:@"req_fee"] forKey:@"req_fee"];
    [[NSUserDefaults standardUserDefaults] setObject:[mydict objectForKey:@"req_peoples"] forKey:@"req_peoples"];
 
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 37)];
    [btnBack setBackgroundColor:[UIColor clearColor]];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    
    
    UIBarButtonItem *barButtonIteLeft = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = barButtonIteLeft;
    
    UIButton *btnDone = [[UIButton alloc] initWithFrame:CGRectMake(260, 0, 55, 37)];
    [btnDone setBackgroundColor:[UIColor clearColor]];
    [btnDone setBackgroundImage:[UIImage imageNamed:@"wancheng.png"] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(savePinche) forControlEvents:UIControlEventTouchDown];
    
    
    UIBarButtonItem *barButtonIteRight = [[UIBarButtonItem alloc] initWithCustomView:btnDone];
    self.navigationItem.rightBarButtonItem = barButtonIteRight;
    
    [btnBack release];
    [barButtonIteLeft release];
    [btnDone release];
    [barButtonIteRight release];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:TRUE];
}




-(void)savePinche
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *email = [userDefault objectForKey:@"login_user"];
    NSString *startposx = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"s_latitude"]];
    NSString *startposy = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"s_longitude"]];
    NSString *endposx = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"e_latitude"]];
    NSString *endposy = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"e_longitude"]];
    NSString *startposname = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"s_ann_subtitle"]];
    NSString *endposname = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"e_ann_subtitle"]];
    NSString *starttime = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"starttime"]];
    NSString *endtime = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"endtime"]];
    NSString *req_sex = [NSString stringWithFormat:@"%d",segSex.selectedSegmentIndex];
    NSString *req_smoke = [NSString stringWithFormat:@"%d",segSmoke.selectedSegmentIndex];
    NSString *req_fee = [NSString stringWithFormat:@"%d",segFee.selectedSegmentIndex];
    NSString *req_peoples = [NSString stringWithFormat:@"%@",txtPeoples.text];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:email forKey:@"email"];
    [params setObject:startposx forKey:@"spx"];
    [params setObject:startposy forKey:@"spy"];
    [params setObject:endposx forKey:@"epx"];
    [params setObject:endposy forKey:@"epy"];
    [params setObject:starttime forKey:@"st"];
    [params setObject:endtime forKey:@"bt"];
    [params setObject:req_sex forKey:@"rse"];
    [params setObject:req_smoke forKey:@"rsm"];
    [params setObject:req_fee forKey:@"rf"];
    [params setObject:req_peoples forKey:@"rp"];
    [params setObject:startposname forKey:@"spn"];
    [params setObject:endposname forKey:@"epn"];
    [params setObject:flag forKey:@"flag"];
    
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    NSString *baseurl=@"updateMemberInfo.php";
    NSString *tmp = [NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL];
    tmp = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)tmp,
                                                              NULL,
                                                              NULL,
                                                              kCFStringEncodingUTF8);
    
    NSURL *url = [NSURL URLWithString:tmp];
    [tmp release];
	[self setRequest:[ASIHTTPRequest requestWithURL:url]];
	[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
	[request startSynchronous];
    
    if (request) {
        if ([request error]) {
            NSString *result = [[request error] localizedDescription];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            
        } else if ([request responseString]) {
            NSString *result = [request responseString];
            NSDictionary *dict = [result JSONValue];
            if([[dict objectForKey: @"regTag"] isEqualToNumber:[NSNumber numberWithInt:1]]){            
                [self.navigationController popViewControllerAnimated:TRUE];
            }else{
                
            }
            
        }
    }else{
        
    }

    vcNear = [[NearbyMemberVC alloc] initWithNibName:@"NearbyMemberVC" bundle:nil];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];
    [self.navigationController pushViewController:vcNear animated:YES];
}


-(void)writeFile:(NSString *)file
{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];

    //获取路径
    //1、参数NSDocumentDirectory要获取的那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    //2、得到相应的Documents的路径
    NSString* DocumentDirectory = [paths objectAtIndex:0];
    //3、更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[DocumentDirectory stringByExpandingTildeInPath]];
     
    //4、创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
    [fileManager removeItemAtPath:@"log.txt" error:nil];
    NSString *path = [DocumentDirectory stringByAppendingPathComponent:@"log.txt"];
    //NSLog(@"path=%@",path);
    //5、创建数据缓冲区
    NSMutableData  *writer = [[NSMutableData alloc] init];
    //6、将字符串添加到缓冲中
    [writer appendData:[file dataUsingEncoding:NSUTF8StringEncoding]];
    //7、将其他数据添加到缓冲中
    //将缓冲的数据写入到文件中
    [writer writeToFile:path atomically:YES];
    [writer release];
}

/*
- (NSString *)readFile
{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    
    //获取文件路劲
    NSString* path = [documentsDirectory stringByAppendingPathComponent:@"log.txt"];
    NSData* reader = [NSData dataWithContentsOfFile:path];
    return [[NSString alloc] initWithData:reader encoding:NSUTF8StringEncoding];      
}
*/

-(IBAction)OpenMapWin:(id)sender
{
    vcLoc = [[sendLocViewController alloc] initWithNibName:@"sendLocViewController" bundle:nil];
    if([sender isEqual:btnStartpos]){
        vcLoc.isStartpos=@"1";//起始点
//        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"s_latitude"]);
//        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"s_longitude"]);
//        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"s_ann_title"]);
//        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"s_ann_subtitle"]);
        vcLoc.in_latitude  = [[NSUserDefaults standardUserDefaults] objectForKey:@"s_latitude"];
        vcLoc.in_longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"s_longitude"];
        vcLoc.in_title     = [[NSUserDefaults standardUserDefaults] objectForKey:@"s_ann_title"];
        vcLoc.in_subtitle  = [[NSUserDefaults standardUserDefaults] objectForKey:@"s_ann_subtitle"];
        
    }else{
        vcLoc.isStartpos=@"2";//终止点
//        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"e_latitude"]);
//        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"e_longitude"]);
//        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"e_ann_title"]);
//        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"e_ann_subtitle"]);
        
        vcLoc.in_latitude  = [[NSUserDefaults standardUserDefaults] objectForKey:@"e_latitude"];
        vcLoc.in_longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"e_longitude"];
        vcLoc.in_title     = [[NSUserDefaults standardUserDefaults] objectForKey:@"e_ann_title"];
        vcLoc.in_subtitle  = [[NSUserDefaults standardUserDefaults] objectForKey:@"e_ann_subtitle"];
        
        
    }
    //NSLog(@"%@,%@,%@,%@",vc.in_latitude,vc.in_longitude,vc.in_subtitle,vc.in_title);
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vcLoc];
    [self.navigationController presentModalViewController:nav animated:YES];
    [nav release];
}

-(IBAction)OpenDateWin:(id)sender
{
    vcSelect = [[SelectTimeViewController alloc] initWithNibName:@"SelectTimeViewController" bundle:nil];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [backItem release];
    [self.navigationController pushViewController:vcSelect animated:YES];
    
}

-(IBAction)ModifyPeoples:(id)sender
{
    int v = [txtPeoples.text intValue];
    if([sender isEqual:btnDecrease]){
        if(v>0){
            v=v-1;
            txtPeoples.text = [NSString stringWithFormat:@"%d",v];
        }
    }else if([sender isEqual:btnAdd]){
        if(v>=0)
        {
            v=v+1;
            txtPeoples.text = [NSString stringWithFormat:@"%d",v];
        }
    }
}

- (void) segmentChanged:(UISegmentedControl *)paramSender{ 
    if ([paramSender isEqual:self.segSex])
    {
        //NSInteger selectedSegmentIndex = [paramSender selectedSegmentIndex];
        //NSString *selectedSegmentText = [paramSender titleForSegmentAtIndex:selectedSegmentIndex];
        //NSLog(@"Segment %ld with %@ text is selected", (long)selectedSegmentIndex, selectedSegmentText);
    } 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [flag release];
    [btnStartpos release];
    [btnEndpos release];
    [btnAdd release];
    [btnDecrease release];
    [btnTime release];
    [txtPeoples release];
    [segFee release];
    [segSex release];
    [segSmoke release];
    [labelStartpos release];
    [labelEndpos release];
    [btnRoute release];
    [request cancel];
    [request release];
    [vcLoc release];
    [vcSelect release];
    [vcNear release];
    [vcMapD release];
}

- (void)dealloc
{
    [flag release];
    [btnStartpos release];
    [btnEndpos release];
    [btnAdd release];
    [btnDecrease release];
    [btnTime release];
    [txtPeoples release];
    [segFee release];
    [segSex release];
    [segSmoke release];
    [labelStartpos release];
    [labelEndpos release];
    [btnRoute release];
    [request cancel];
    [request release];
    [vcLoc release];
    [vcSelect release];
    [vcNear release];
    [vcMapD release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
