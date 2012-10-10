//
//  RegInputNickVC.m
//  MOMO
//
//  Created by 超 曾 on 12-4-19.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "RegInputNickVC.h"

@implementation RegInputNickVC
@synthesize myTableView,tfNickname,mySeg;
@synthesize lbsMember;
@synthesize vcBirth;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"名字与性别";
        UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
        if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
        {
            [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect tableViewFrame = self.view.bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    self.myTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.myTableView.scrollEnabled=YES;
    [self.view addSubview:self.myTableView];
    
    UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(doNext)];
    self.navigationItem.rightBarButtonItem = nextBarItem;
    
    UILabel *lblTitle = [[[UILabel alloc] initWithFrame:CGRectMake(20,55,300,30)] autorelease];
    lblTitle.opaque = YES;
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.font = [UIFont systemFontOfSize:15];
    lblTitle.numberOfLines = 1;
    [self.view addSubview:lblTitle];
    lblTitle.text=@"使用真实名字让人更快的找到和联系你";
    
    NSArray *segments = [[NSArray alloc] initWithObjects: @"男♂",@"女♀", nil];
    self.mySeg = [[UISegmentedControl alloc] initWithItems:segments];
    self.mySeg.frame = CGRectMake(20, 92, 280, 44);
    [self.view addSubview:self.mySeg];
    [self.mySeg addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    mySeg.selectedSegmentIndex=0;
    
}

- (void) segmentChanged:(UISegmentedControl *)paramSender
{ 
    if ([paramSender isEqual:self.mySeg])
    {
        //NSInteger selectedSegmentIndex = [paramSender selectedSegmentIndex];
        //NSString *selectedSegmentText = [paramSender titleForSegmentAtIndex:selectedSegmentIndex];
//        NSLog(@"Segment %ld with %@ text is selected", (long)selectedSegmentIndex, selectedSegmentText);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"确认提交后性别将不能修改" delegate:self cancelButtonTitle:nil otherButtonTitles:@"是", nil];
        [alertView show];
        [alertView release];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [myTableView release];
    [tfNickname release];
    [mySeg release];
    [lbsMember release];
    [vcBirth release];
    
}

- (void)dealloc
{
    [super dealloc];
    [myTableView release];
    [tfNickname release];
    [mySeg release];
    [lbsMember release];
    [vcBirth release];
}

-(void)doNext
{
    if([tfNickname.text length]<=0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入您的名字" delegate:self cancelButtonTitle:nil otherButtonTitles:@"是", nil];
        [alertView show];
        [alertView release];
    }else{
        //更新名字和性别
        lbsMember.username = tfNickname.text;
        if(mySeg.selectedSegmentIndex==0){
            lbsMember.sex=@"0";
        }else{
            lbsMember.sex=@"1";
        }
//        NSLog(@"email=%@,password=%@,username=%@,sex=%@",lbsMember.email,lbsMember.password,lbsMember.username,lbsMember.sex);
        
        vcBirth = [[RegInputBirthVC alloc] initWithNibName:@"RegInputBirthVC" bundle:nil];
        vcBirth.lbsMember=lbsMember;
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"名字与性别" 
                                                                     style:UIBarButtonItemStyleBordered 
                                                                    target:nil 
                                                                    action:nil];
        self.navigationItem.backBarButtonItem = backItem;
        
        [self.navigationController pushViewController:vcBirth animated:YES];
    }
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
    [self doNext];
	return YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell2";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if(indexPath.row==0){
        UILabel *lblTitle = [[[UILabel alloc] initWithFrame:CGRectMake(8,5,100,30)] autorelease];
        lblTitle.opaque = YES;
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textColor = [UIColor blackColor];
        lblTitle.font = [UIFont systemFontOfSize:17];
        lblTitle.numberOfLines = 1;
        [cell.contentView addSubview:lblTitle];
        lblTitle.text=@"名字";
        
        tfNickname = [[UITextField alloc] initWithFrame:CGRectMake(95, 8, 200, 30)];
        tfNickname.borderStyle = UITextBorderStyleNone;
        tfNickname.textColor = [UIColor blackColor];
        tfNickname.font = [UIFont systemFontOfSize:17];
        tfNickname.placeholder = @"请输入您的姓名";
        tfNickname.backgroundColor = [UIColor clearColor];
        tfNickname.keyboardType = UIKeyboardTypeEmailAddress;
        tfNickname.returnKeyType = UIReturnKeyDefault;
        tfNickname.delegate=self;
        tfNickname.clearButtonMode = UITextFieldViewModeWhileEditing;
        [cell.contentView addSubview:tfNickname];
        
    }
    
    return cell;
}

- (void) unselectCurrentRow
{
    [self.myTableView deselectRowAtIndexPath:
    [self.myTableView indexPathForSelectedRow] animated:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
    [self performSelector:@selector(unselectCurrentRow) withObject:nil];
    tableView.allowsSelection=FALSE;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
