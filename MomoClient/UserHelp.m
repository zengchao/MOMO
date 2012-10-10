//
//  UserHelp.m
//  MOMO
//
//  Created by apple on 12-6-18.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "UserHelp.h"

@implementation UserHelp
@synthesize textView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"关于";
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
    
    UITextView *tv=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320 , 360)];
	tv.backgroundColor=[UIColor clearColor];
	tv.editable=NO;
	tv.textColor=[UIColor blackColor];
	tv.font=[UIFont systemFontOfSize:18];
    self.textView=tv;
    textView.font=[UIFont systemFontOfSize:14];
	[tv release];	
	[self.view addSubview:self.textView];
    [self.view addSubview:aboutView];
    UIImageView *footView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner"]];
    footView.frame=CGRectMake(0, 360, 320, 60);
    footView.UserInteractionEnabled=YES;
    [self.view addSubview:footView];
    NSArray *segmentedArray=[[NSArray alloc] initWithObjects:@"关于我们",@"用户帮助",@"用户协议",nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
	[segmentedArray release];
	segmentedControl.segmentedControlStyle =  UISegmentedControlStylePlain;
	[segmentedControl addTarget:self action:@selector(segmentedClicked:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.frame=CGRectMake(10, 10, 300, 40);
	//segmentedControl.momentary=YES;
    segmentedControl.selectedSegmentIndex=0;
	segmentedControl.tintColor=[UIColor	blackColor];
	[footView addSubview:segmentedControl];
    [segmentedControl release];
    [footView release];
}
-(void)read{
    aboutView.hidden=YES;
    NSString *filePath = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"agreement.txt"];
    if (filePath) {
        NSInputStream *putStream=[[NSInputStream alloc] initWithFileAtPath:filePath];
        NSFileManager *manage=[NSFileManager defaultManager];
        [putStream open];
        NSDictionary *dic=[manage attributesOfItemAtPath:filePath error:nil];
        NSNumber *num=[dic objectForKey:NSFileSize];
        long long length=[num longLongValue];
        uint8_t buf [length];
        int m=[putStream read:buf maxLength:length];
        NSLog(@"往数组里写了%d字节",m);
        NSString *str=[[NSString alloc] initWithBytes:buf length:sizeof(buf) encoding:NSUTF8StringEncoding];
        self.textView.text=str;
        [putStream release];
    }
}

-(void)segmentedClicked:(id)sender{
    UISegmentedControl *segmentedControl=(UISegmentedControl *)sender;
	int selectIndex = segmentedControl.selectedSegmentIndex;
	switch(selectIndex){
		case 0://关于
            aboutView.hidden=NO;
			break;
		case 1://用户帮助
            aboutView.hidden=YES;
            self.textView.text=@"用户帮助";
			break;
		case 2://协议
            [self read];
			break;			
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc{
    [super dealloc];
    [textView release];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
