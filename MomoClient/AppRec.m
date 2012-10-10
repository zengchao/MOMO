//
//  AppRec.m
//  MOMO
//
//  Created by apple on 12-7-2.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "AppRec.h"
#import "Appxmlparser.h"

@implementation AppRec
@synthesize array,request;
@synthesize tableview;
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
-(void)addHUD{
//    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:HUD];	
//    HUD.dimBackground = YES;
//    HUD.delegate = self;
//    HUD.labelText = @"";
//    [HUD showWhileExecuting:@selector(loadBlackList) onTarget:self withObject:nil animated:YES];
    [self loadBlackList];
    
}
-(void)loadBlackList{
    NSURL *url=[NSURL URLWithString:@"http://itunes.apple.com/cn/rss/topfreeapplications/limit=25/xml"];
	[self setRequest:[ASIHTTPRequest requestWithURL:url]];
	//[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
	[request startSynchronous];
    if (request) {
        if ([request error]) {
            NSString *result = [[request error] localizedDescription];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            
        } else if ([request responseData]){
            NSData *data=[request responseData];
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //NSLog(@"%@",result);
            Appxmlparser *appxml=[[Appxmlparser alloc] init];
            [appxml parserXmlForString:result];
            self.array=appxml.array;
            [appxml release];
            [result release];
            [tableview reloadData];
        }
    }
}

- (void)viewDidLoad
{
    [self addHUD];
    [super viewDidLoad];
    
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
    
    self.title = @"精品APP推荐";
    array=[[NSMutableArray alloc] init];
    queue=[[NSOperationQueue alloc] init];
    dict=[[NSMutableDictionary alloc] init];
    tableview=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableview.delegate=self;
    tableview.dataSource=self;
    [self.view addSubview:tableview];
}
-(void)dealloc{
    [super dealloc];
    [queue release];
    [array release];
    [dict release];
    [tableview release];
    [HUD release];
    [request cancel];
	[request release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{  
    return [array count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{        
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
    }
    //删除cell.contentView中所有内容，避免以下建立新的重复
    int i = [[cell.contentView subviews] count] - 1;
    for(;i >= 0 ; i--)
    {
        [[[cell.contentView subviews] objectAtIndex:i] removeFromSuperview];
    }
    
    NSUInteger row = [indexPath row];
    Entry *entry=[array objectAtIndex:row];
    //标题
    CGRect nameLabelRect = CGRectMake(70, 0, 240, 20);
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameLabelRect];
    nameLabel.textAlignment = UITextAlignmentCenter;
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    nameLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:14];
    nameLabel.text=entry.title; 
    [cell.contentView addSubview: nameLabel];
    [nameLabel release];
    //简介
    CGRect infoLabelRect = CGRectMake(70,20, 230, 30);
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:infoLabelRect];
    infoLabel.textAlignment = UITextAlignmentLeft;
    infoLabel.font = [UIFont boldSystemFontOfSize:12];
    infoLabel.numberOfLines=2;
    infoLabel.text=[entry.summary stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [cell.contentView addSubview: infoLabel];
    [infoLabel release];
    //更新时间
    CGRect updateRect = CGRectMake(70, 50, 240, 20);
    UILabel *updateLabel = [[UILabel alloc] initWithFrame:updateRect];
    updateLabel.textAlignment = UITextAlignmentLeft;
    updateLabel.font = [UIFont boldSystemFontOfSize:12];
    updateLabel.text=[NSString stringWithFormat:@"更新时间:%@",entry.updated];
    [cell.contentView addSubview: updateLabel];
    [updateLabel release];
    
    CGRect imgRect = CGRectMake(5, 5, 60, 60);
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:imgRect];
    imgView.tag = 4;
    [cell.contentView addSubview:imgView];
    
    NSString *currRow=[NSString stringWithFormat:@"%d",row];
	NSString *fullPath=[dict objectForKey:currRow];
   	if (fullPath) {
		UIImage *img=[UIImage imageWithContentsOfFile:fullPath];
		imgView.image=img;
	}else {//没有就下载
		ImageLoader *imgLoader=[[ImageLoader alloc] initWithInfo:entry.image view:cell.contentView dict:dict row:currRow];
		[queue addOperation:imgLoader];
	} 
    [imgView release];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath{
    int row=[newIndexPath row];
    Entry *entry=[array objectAtIndex:row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:entry.appid]];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
