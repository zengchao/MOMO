//
//  TestViewController.m
//  MOMO
//
//  Created by 超 曾 on 12-6-12.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "TestViewController.h"

@implementation TestViewController
@synthesize itemView,list;

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
    
    UITableView *contentView_ = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,416) style:UITableViewStyleGrouped];
    
    contentView_.delegate = self;
    contentView_.dataSource = self;
    contentView_.separatorStyle = UITableViewCellSeparatorStyleNone;
    contentView_.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background"]];
    [self.view addSubview:contentView_];
    
    
    list = [[NSMutableArray alloc] init];
    [list addObject:@"中华人工合同1"];
    [list addObject:@"中华人工合同2"];
    [list addObject:@"中华人工合同3"];
    [list addObject:@"中华人工合同4"];
    [list addObject:@"中华人工合同5"];
    [list addObject:@"中华人工合同6"];
    [list addObject:@"中华人工合同7"];
    [list addObject:@"中华人工合同8"];
    [list addObject:@"中华人工合同9"];
    [list addObject:@"中华人工合同10"];
    [list addObject:@"中华人工合同11"];
    [list addObject:@"中华人工合同12"];
    [list addObject:@"中华人工合同13"];
    [list addObject:@"中华人工合同14"];
    [list addObject:@"中华人工合同15"];
    [list addObject:@"中华人工合同16"];
    [list addObject:@"中华人工合同17"];
    [list addObject:@"39847923874923749237493984792387492374923749398479238749237492374939847923874923749237493984792387492374923749"];
    [list addObject:@"中华人工合同18"];
    [list addObject:@"23234234"];
    [list addObject:@"中华人工合同19"];
    [list addObject:@"中华人工合同20"];
    [list addObject:@"中华人工合同21"];
    [list addObject:@"中华人工合同22"];
    [list addObject:@"中华人工合同23"];
    [list addObject:@"中华人工合同24"];
    [list addObject:@"中华人工合同25"];
    [list addObject:@"中华人工合同26"];
    [list addObject:@"中华人工合同27"];
    [list addObject:@"中华人工合同28"];
    [list addObject:@"中华人工合同29"];
    [list addObject:@"中华人工合同30"];
    [list addObject:@"中华人工合同31"];
    [list addObject:@"中华人工合同32"];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [itemView release];
    [list release];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommentViewCell";
    
    CommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CommentViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    // Configure the cell...
    
    cell.nameLabel.text = @"1234";
    
    cell.contentLabel.text = @"test";
    [cell.contentLabel sizeToFit];
    double height = 30 + cell.contentLabel.frame.size.height;
    cell.frame = CGRectMake(0, 0, 320, height);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
