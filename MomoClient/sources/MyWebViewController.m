//
//  MyWebViewController.m
//  Blank
//
//  Created by 超 曾 on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  QQ:1490724

#import "MyWebViewController.h"

@interface MyWebViewController ()

@end

@implementation MyWebViewController
@synthesize mywebview;
@synthesize activityIndicator;
@synthesize timer;
@synthesize a_content;

-(void)dealloc
{
    [mywebview release];
    [activityIndicator release];
    [timer release];
    [a_content release];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.mywebview=nil;
    self.activityIndicator=nil;
    self.timer=nil;
    self.a_content=nil;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
    
    
    NSURL *url =[NSURL URLWithString:self.a_content];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.mywebview loadRequest:request];
    
    
        
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];  
    [view setTag:103];  
    [view setBackgroundColor:[UIColor blackColor]];  
    [view setAlpha:0.8];  
    [self.view addSubview:view];  
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicator setCenter:view.center];  
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];  
    [view addSubview:activityIndicator];  
    
    [view release];
    
    self.mywebview.delegate=self; 
}

- (void) gowebsite_163:(id)sender
{
    
}

- (void) gowebsite_sina:(id)sender
{

}


- (void)backButtonClick:(id)sender 
{ 
    [self.navigationController popViewControllerAnimated:TRUE]; 
} 




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) setNavigationBackground:(UINavigationBar *)nav GetImage:(UIImage *)image
{
    [nav addSubview:[[[UIImageView alloc] initWithImage:image] autorelease]];
}


//开始加载数据  
- (void)webViewDidStartLoad:(UIWebView *)webView {  
    [activityIndicator startAnimating];           
}  

//数据加载完  
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityIndicator stopAnimating];      
    UIView *view = (UIView *)[self.view viewWithTag:103];  
    [view removeFromSuperview];  
}  

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    NSLog(@"访问网页超时");
    [activityIndicator stopAnimating];      
    UIView *view = (UIView *)[self.view viewWithTag:103];  
    [view removeFromSuperview];  
    
    
}
@end
