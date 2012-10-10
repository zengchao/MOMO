//
//  RegAgreement.m
//  dache
//
//  Created by apple on 12-7-16.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "RegAgreement.h"

@implementation RegAgreement

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"用户协议";
    textView=[[UITextView alloc] init];
    textView.frame=self.view.bounds;
	//textView.backgroundColor=[UIColor clearColor];
	textView.editable=NO;
	textView.textColor=[UIColor blackColor];
    textView.font=[UIFont systemFontOfSize:14];
	[self.view addSubview:textView];
    [self read];	
}

-(void)read{
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
        textView.text=str;
        [putStream release];
    }
}

-(void)dealloc{
    [super dealloc];
    [textView release];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
