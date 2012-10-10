//
//  ConversationVC.m
//  MOMO
//
//  Created by 超 曾 on 12-4-29.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "ConversationVC.h"

@implementation ConversationVC
@synthesize myTableView,list,titleLabel;
@synthesize request;
@synthesize vcMessage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.title=@"对话";
    }
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.myTableView =nil;
    self.list =nil;
    self.titleLabel =nil;
    self.request =nil;
    self.vcMessage=nil;
    
}

- (void)dealloc
{
    [super dealloc];
    [myTableView release];
    [list release];
    [titleLabel release];
    [request cancel];
    [request release];
    [vcMessage release];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
    
    self.navigationItem.title = @"对话";
    
    CGRect tableViewFrame = self.view.bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    myTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    myTableView.scrollEnabled=YES;
    [self.view addSubview:myTableView];
    
    [self loadList];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:TRUE];
    [self loadList];
    [myTableView reloadData];
}

-(void)dismissWin
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)loadList
{
    [list removeAllObjects];
    list = [[NSMutableArray alloc] init];
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *login_user_id = [userDefault objectForKey:@"login_user_id"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:login_user_id forKey:@"u"];
    
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    NSString *baseurl=@"getChatList.php";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL]];
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
            NSLog(@"%@",result);
            
            if([result isEqualToString:@"40023"] || [result isEqualToString:@"40024"]){
                
            }else{
                NSDictionary *mydict = [result JSONValue];
                NSMutableDictionary *tmpDict;
                NSArray *resultArr = (NSArray *)mydict;
                for (NSDictionary *item in resultArr) {
                    tmpDict = [[NSMutableDictionary alloc] init];
                    [tmpDict setValue:[item objectForKey: @"id"] forKey:@"id"];
                    [tmpDict setValue:[item objectForKey: @"sender_id"] forKey:@"sender_id"];
                    [tmpDict setValue:[item objectForKey: @"recver_id"] forKey:@"recver_id"];
                    [tmpDict setValue:[item objectForKey: @"update_time"] forKey:@"update_time"];
                    [tmpDict setValue:[item objectForKey: @"sender_name"] forKey:@"sender_name"]; 
                    [tmpDict setValue:[item objectForKey: @"recver_name"] forKey:@"recver_name"]; 
                    [tmpDict setValue:[item objectForKey: @"content"] forKey:@"content"]; 
                    [tmpDict setValue:[item objectForKey: @"sender_pic"] forKey:@"sender_pic"]; 
                    [tmpDict setValue:[item objectForKey: @"recver_pic"] forKey:@"recver_pic"];
                    [tmpDict setValue:[item objectForKey: @"distance"] forKey:@"distance"];
                    
                    [tmpDict setValue:[item objectForKey: @"sender_membertype"] forKey:@"sender_membertype"];
                    //[tmpDict setValue:[item objectForKey: @"sender_state"] forKey:@"sender_state"];
                    [tmpDict setValue:[item objectForKey: @"recver_membertype"] forKey:@"recver_membertype"];
                    //[tmpDict setValue:[item objectForKey: @"recver_state"] forKey:@"recver_state"];
                    [tmpDict setValue:[item objectForKey: @"sender_black"] forKey:@"sender_black"];
                    [tmpDict setValue:[item objectForKey: @"recver_black"] forKey:@"recver_black"];
                    //[tmpDict setValue:[item objectForKey: @"sender_friend"] forKey:@"sender_friend"];
                    NSString *sender_black=[tmpDict objectForKey:@"sender_black"];
                    NSString *recver_black=[tmpDict objectForKey:@"recver_black"];
                    if ([sender_black intValue]==0 && [recver_black intValue]==0) {
                        [list addObject:tmpDict];
                    }
                    [tmpDict release];
                    
                }
            }
        }
    }else{
        
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"count=%d",[list count]);
    return [list count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell2";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    //删除cell.contentView中所有内容，避免以下建立新的重复
    int i = [[cell.contentView subviews] count] - 1;
    for(;i >= 0 ; i--)
    {
        [[[cell.contentView subviews] objectAtIndex:i] removeFromSuperview];
    }

    thumbnail = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"no.jpg"]];
    thumbnail.frame = CGRectMake(40,5,75,75);
    
    [cell.contentView addSubview:thumbnail];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCellWidth - kArticleCellHorizontalInnerPadding * 2 +40, 10,250, 20)];
    titleLabel.opaque=YES;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.numberOfLines = 1;
    [cell.contentView addSubview:titleLabel];
    NSLog(@"recver=%@",[[list objectAtIndex:indexPath.row] objectForKey:@"recver_name"]);
    NSLog(@"sender=%@",[[list objectAtIndex:indexPath.row] objectForKey:@"sender_name"]);
    
    int indexs=0;
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"login_user_id"] isEqualToString:[[list objectAtIndex:indexPath.row] objectForKey:@"sender_id"]]){
        titleLabel.text = [NSString stringWithFormat:@"%@",[[list objectAtIndex:indexPath.row] objectForKey:@"recver_name"]];
        thumbnail.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host_url,[[list objectAtIndex:indexPath.row] objectForKey:@"recver_pic"]]];
        indexs=[[[list objectAtIndex:indexPath.row] objectForKey:@"recver_membertype"] intValue];
    }else{
        titleLabel.text = [NSString stringWithFormat:@"%@",[[list objectAtIndex:indexPath.row] objectForKey:@"sender_name"]];
        thumbnail.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host_url,[[list objectAtIndex:indexPath.row] objectForKey:@"sender_pic"]]];
        indexs=[[[list objectAtIndex:indexPath.row] objectForKey:@"sender_membertype"] intValue];
    }
    [titleLabel release];
    
    UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 27, 31, 31)];
    switch (indexs) {
        case 0:
            cellImageView.image=[UIImage imageNamed:@"leifeng.png"];
            break;
        case 1:
            cellImageView.image=[UIImage imageNamed:@"dache.png"];
            break;
        case 2:
            cellImageView.image=[UIImage imageNamed:@"pinche.png"];
            break;
        default:
            break;
    }
    [cell.contentView addSubview:cellImageView];
    [cellImageView release];
    
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCellWidth - kArticleCellHorizontalInnerPadding * 2 +130 , 10,200, 20)];
    //titleLabel.frame = CGRectMake(kCellWidth - kArticleCellHorizontalInnerPadding * 2 +100 , 10,200, 20);
    titleLabel.opaque=YES;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.numberOfLines = 1;
    [cell.contentView addSubview:titleLabel];
    NSString *send_date = [[list objectAtIndex:indexPath.row] objectForKey:@"update_time"];
    titleLabel.text = [NSString stringWithFormat:@"%@",send_date];
    [titleLabel release];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCellWidth - kArticleCellHorizontalInnerPadding * 2 +45 , 30,250, 20)];
    //titleLabel.frame = CGRectMake(kCellWidth - kArticleCellHorizontalInnerPadding * 2 +10 , 30,250, 20);
    titleLabel.opaque=YES;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.numberOfLines = 1;
    [cell.contentView addSubview:titleLabel];
    titleLabel.text = [NSString stringWithFormat:@"%@",@"送达"];
    [titleLabel release];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCellWidth - kArticleCellHorizontalInnerPadding * 2 +45 , 50,250, 20)];
    //titleLabel.frame = CGRectMake(kCellWidth - kArticleCellHorizontalInnerPadding * 2 +10 , 50,250, 20);
    titleLabel.opaque=YES;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.numberOfLines = 1;
    [cell.contentView addSubview:titleLabel];
    float distance = [[[list objectAtIndex:indexPath.row] objectForKey:@"distance"] floatValue]/1000;
    if(distance>=10000)titleLabel.text = [NSString stringWithFormat:@"[遥远] %@",[[list objectAtIndex:indexPath.row] objectForKey:@"content"]];
    else
    titleLabel.text = [NSString stringWithFormat:@"[%.2fkm] %@",distance,[[list objectAtIndex:indexPath.row] objectForKey:@"content"]];
    [titleLabel release];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    vcMessage = [[SendMessageVC alloc] initWithNibName:@"SendMessageVC" bundle:nil];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"login_user_id"] isEqualToString:[[list objectAtIndex:indexPath.row] objectForKey:@"sender_id"]]){
        vcMessage.t_userid = [[list objectAtIndex:indexPath.row] objectForKey:@"recver_id"];
    }else{
        vcMessage.t_userid = [[list objectAtIndex:indexPath.row] objectForKey:@"sender_id"];
    }
    
    UINavigationController* nav = [[[UINavigationController alloc] initWithRootViewController:vcMessage] autorelease];
    [self.navigationController presentModalViewController:nav animated:YES];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
