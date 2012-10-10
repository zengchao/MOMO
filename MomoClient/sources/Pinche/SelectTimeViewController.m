//
//  SelectTimeViewController.m
//  MOMO
//
//  Created by 超 曾 on 12-5-23.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "SelectTimeViewController.h"

@implementation SelectTimeViewController
@synthesize myTableView,myDatePicker,list;

- (void)viewDidUnload
{
    [super viewDidUnload];
    [myTableView release];
    [myDatePicker release];
    [list release];
}

- (void)dealloc
{
    [super dealloc];
    [myTableView release];
    [myDatePicker release];
    [list release];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"选择时间";
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
    
    CGRect tableViewFrame = self.view.bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    myTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    myTableView.scrollEnabled=YES;
    [self.view addSubview:myTableView];
    
    
    myDatePicker = [[UIDatePicker alloc] init]; 
    myDatePicker.frame = CGRectMake(0,100,320,216);
    [self.view addSubview:self.myDatePicker];
    
    [myDatePicker setDatePickerMode:UIDatePickerModeTime];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [self.myDatePicker setLocale:locale];
    [locale release];
    [self.myDatePicker addTarget:self action:@selector(datePickerDateChanged:) forControlEvents:UIControlEventValueChanged];
    
    list = [[NSMutableArray alloc] init];
    [list addObject:@"07:30"];
    [list addObject:@"18:00"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[list objectAtIndex:0] forKey:@"starttime"];
    [[NSUserDefaults standardUserDefaults] setObject:[list objectAtIndex:1] forKey:@"endtime"];
    
    currow=0;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    [myDatePicker setDate:[dateFormat dateFromString:[list objectAtIndex:currow]]];
    [dateFormat release];
    
    
}

- (void) datePickerDateChanged:(UIDatePicker *)paramDatePicker{
    if ([paramDatePicker isEqual:self.myDatePicker]){
        NSDate *selected = [myDatePicker date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"HH:mm"];
        NSString *theDate = [dateFormat stringFromDate:selected];
        [dateFormat release];
        
        //修改时间
        [list replaceObjectAtIndex:currow withObject:[NSString stringWithFormat:@"%@",theDate]];
        //存入
        [[NSUserDefaults standardUserDefaults] setObject:[list objectAtIndex:0] forKey:@"starttime"];
        [[NSUserDefaults standardUserDefaults] setObject:[list objectAtIndex:1] forKey:@"endtime"];
        
        //刷新列表 
        [myTableView reloadData];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{  
    return [list count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void) unselectCurrentRow
{
    [myTableView deselectRowAtIndexPath:[myTableView indexPathForSelectedRow] animated:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
    currow = newIndexPath.row;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    [myDatePicker setDate:[dateFormat dateFromString:[list objectAtIndex:currow]]];
    [dateFormat release];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    if(indexPath.row==0){
        cell.textLabel.text=[NSString stringWithFormat:@"上班出发时间  %@",[list objectAtIndex:indexPath.row]];
    }else if(indexPath.row==1){
        cell.textLabel.text=[NSString stringWithFormat:@"下班出发时间  %@",[list objectAtIndex:indexPath.row]];
    }
    return cell;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
