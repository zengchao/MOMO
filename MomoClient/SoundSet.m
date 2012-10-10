//
//  SoundSet.m
//  MOMO
//
//  Created by apple on 12-6-13.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "SoundSet.h"

@implementation SoundSet
@synthesize swit,lable1,lable2;
@synthesize soundTime;
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
- (void)dealloc {
    [super dealloc];
    [tableview release];
    [swit release];
    [array release];
    [soundTime release];
}

-(void)readDB{
    PincheAppDelegate *appDelegate= [PincheAppDelegate getAppDelegate];
    FMResultSet *rs=[appDelegate.db executeQuery:@"SELECT *FROM PersonSet WHERE id = ?",@"1"]; 
    while ([rs next]){  
        self.soundTime=[rs stringForColumn:@"soundTime"];
        self.lable1.text=[rs stringForColumn:@"startTime"];
        self.lable2.text=[rs stringForColumn:@"endTime"];
    }
    [rs close];
    [picker selectRow:[self.lable1.text intValue] inComponent:0 animated:YES];
    [picker selectRow:[self.lable2.text intValue] inComponent:1 animated:YES];
    if ([soundTime isEqualToString:@"NO"]) {
        picker.hidden=YES;
        lable1.hidden=YES;
        lable2.hidden=YES;
        tolable.hidden=YES;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"静音设置";
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem=saveItem;
    [saveItem release];
    array=[[NSMutableArray alloc] init];
    for (int i=0; i<24; i++) {
        NSString *s=@"";
        if (i<10) {
            s=[NSString stringWithFormat:@"0%d:00",i];
        }
        else
            s=[NSString stringWithFormat:@"%d:00",i];
        [array addObject:s];
    }
    [self readDB];
    
    tableview=[[UITableView alloc] initWithFrame:CGRectMake(3, 3, 314, 120) style:UITableViewStyleGrouped];
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.scrollEnabled=NO;
    [self.view addSubview:tableview];
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
-(void)save{
    BOOL state=swit.on;
    PincheAppDelegate *appDelegate= [PincheAppDelegate getAppDelegate];
    if (state) {
        if ([lable1.text intValue]>=[lable2.text intValue]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"没有该时间段，请重新设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            return;
        }
    [appDelegate.db executeUpdate:@"update PersonSet set soundTime =?,startTime=?,endTime=? WHERE id = ?",@"YES",lable1.text,lable2.text,@"1"]; 
        appDelegate.isSound=YES;
        appDelegate.startTime=lable1.text;
        appDelegate.endTime=lable2.text;
    }
    else{
    [appDelegate.db executeUpdate:@"update PersonSet set soundTime =? WHERE id = ?",@"NO",@"1"];
        appDelegate.isSound=NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)switHandle{
    BOOL state=swit.on;
    if (state) {
        picker.hidden=NO;
        lable1.hidden=NO;
        lable2.hidden=NO;
        tolable.hidden=NO;
    }
    if (!state) {
        picker.hidden=YES;
        lable1.hidden=YES;
        lable2.hidden=YES;
        tolable.hidden=YES;
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [array count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
        return [array objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	if (component==0) {
		lable1.text=[array objectAtIndex:row];
	}else {
        lable2.text=[array objectAtIndex:row];
	}
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{  
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *retStr=@"打开静音时段功能后，手机在这个时间段收到的消息不会有声音和振动";
    
    return retStr;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{        
    
    static NSString *CellIdentifier = @"Cell2";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        swit=[[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 100, 30)];
        swit.clearsContextBeforeDrawing=YES;
        [swit addTarget:self action:@selector(switHandle) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:swit];
        cell.textLabel.backgroundColor=[UIColor clearColor];
        if ([soundTime isEqualToString:@"YES"]){
            swit.on=YES;
        }
    }
    cell.textLabel.text=@"静音设置";
    return cell;
}
@end
