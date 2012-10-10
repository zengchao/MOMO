//
//  ContactsCtrl.m
//  Phone
//
//  Created by angel li on 10-9-13.
//  Copyright 2010 Lixf. All rights reserved.
//

#import "ContactsCtrl.h"
#import "ContactData.h"
#import "AppDelegate.h"
#import "pinyin.h"

#define SETCOLOR(RED,GREEN,BLUE) [UIColor colorWithRed:RED/255 green:GREEN/255 blue:BLUE/255 alpha:1.0]

@implementation ContactsCtrl
@synthesize DataTable;
@synthesize contacts;
@synthesize filteredArray;
@synthesize contactNameArray;
@synthesize contactNameDic;
@synthesize sectionArray;
@synthesize searchBar;
@synthesize searchDC;
@synthesize aBPersonNav;
@synthesize aBNewPersonNav;
@synthesize dataArray;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	isGroup = NO;
	self.navigationItem.title=@"通讯录";
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]
               initWithTitle:@"返回"
               style:UIBarButtonItemStyleBordered
               target:self
               action:@selector(dismissWin)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn release];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]
                                initWithTitle:@"发送"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(toggleSelect:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [rightBtn release];
    
	// Create a search bar
	self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)] autorelease];
	self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.keyboardType = UIKeyboardTypeDefault;
	self.searchBar.delegate = self;
	self.DataTable.tableHeaderView = self.searchBar;
	
	// Create the search display controller
	self.searchDC = [[[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self] autorelease];
	self.searchDC.searchResultsDataSource = self;
	self.searchDC.searchResultsDelegate = self;	
	
	
	NSMutableArray *filterearray =  [[NSMutableArray alloc] init];
	self.filteredArray = filterearray;
	[filterearray release];
	
	NSMutableArray *namearray =  [[NSMutableArray alloc] init];
	self.contactNameArray = namearray;
	[namearray release];
	
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
	self.contactNameDic = dic;
	[dic release];
    
    self.DataTable.allowsMultipleSelectionDuringEditing = YES;
    [self.DataTable setEditing:YES animated:YES];
    
    dataArray = [[NSMutableArray alloc] init];
    
    
}

-(void)dismissWin
{
    //NSArray *selectedRows = [self.DataTable indexPathsForSelectedRows];
    [self dismissModalViewControllerAnimated:YES];
}

//点击保存返回方法按钮
-(void)toggleSelect:(id)sender 
{           
    CommSmsUtil *util=[[CommSmsUtil alloc]init];
    [util MultiSmsSend:self.dataArray withVC:self]; 
    [util release];    
}


- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	//[DataTable reloadData];
}


- (void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
}


-(void)initData{
	self.contacts = [ContactData contactsArray];
	if([contacts count] <1)
	{
		[contactNameArray removeAllObjects];
		[contactNameDic removeAllObjects];
		for (int i = 0; i < 27; i++) [self.sectionArray replaceObjectAtIndex:i withObject:[NSMutableArray array]];
		return;
	}
	[contactNameArray removeAllObjects];
	[contactNameDic removeAllObjects];
	for(ABContact *contact in contacts)
	{
		NSString *phone = [NSString stringWithFormat:@""];
		NSArray *phoneCount = [ContactData getPhoneNumberAndPhoneLabelArray:contact];
		if([phoneCount count] > 0)
		{
			NSDictionary *PhoneDic = [phoneCount objectAtIndex:0];
			phone = [ContactData getPhoneNumberFromDic:PhoneDic];
		}
		if([contact.contactName length] > 0)
			[contactNameArray addObject:contact.contactName];
		else
			[contactNameArray addObject:phone];
	}
	
	self.sectionArray = [NSMutableArray array];
	for (int i = 0; i < 27; i++)
        [self.sectionArray addObject:[NSMutableArray array]];
    
	for (NSString *string in contactNameArray) 
	{
		if([ContactData searchResult:string searchText:@"曾"])
			sectionName = @"Z";
		else if([ContactData searchResult:string searchText:@"解"])
			sectionName = @"X";
		else if([ContactData searchResult:string searchText:@"仇"])
			sectionName = @"Q";
		else if([ContactData searchResult:string searchText:@"朴"])
			sectionName = @"P";
		else if([ContactData searchResult:string searchText:@"查"])
			sectionName = @"Z";
		else if([ContactData searchResult:string searchText:@"能"])
			sectionName = @"N";
		else if([ContactData searchResult:string searchText:@"乐"])
			sectionName = @"Y";
		else if([ContactData searchResult:string searchText:@"单"])
			sectionName = @"S";
		else
			sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([string characterAtIndex:0])] uppercaseString];
        
		[self.contactNameDic setObject:string forKey:sectionName];
		NSUInteger firstLetter = [ALPHA rangeOfString:[sectionName substringToIndex:1]].location;
		if (firstLetter != NSNotFound) [[self.sectionArray objectAtIndex:firstLetter] addObject:string];
	}
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{ 
	if(aTableView == self.DataTable) return 27;
	return 1; 
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)aTableView 
{
	if (aTableView == self.DataTable)  // regular table
	{
		NSMutableArray *indices = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
		for (int i = 0; i < 27; i++) 
			if ([[self.sectionArray objectAtIndex:i] count])
				[indices addObject:[[ALPHA substringFromIndex:i] substringToIndex:1]];
		//[indices addObject:@"\ue057"]; // <-- using emoji
		return indices;
	}
	else return nil; // search table
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	if (title == UITableViewIndexSearch) 
	{
		[self.DataTable scrollRectToVisible:self.searchBar.frame animated:NO];
		return -1;
	}
	return [ALPHA rangeOfString:title].location;
}



- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
	if (aTableView == self.DataTable) 
	{
		if ([[self.sectionArray objectAtIndex:section] count] == 0) return nil;
		return [NSString stringWithFormat:@"%@", [[ALPHA substringFromIndex:section] substringToIndex:1]];
	}
	else return nil;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section 
{
	
    [self initData];
	// Normal table
	if (aTableView == self.DataTable) return [[self.sectionArray objectAtIndex:section] count];
	else
		[filteredArray removeAllObjects];
	// Search table
	for(NSString *string in contactNameArray)
	{
		NSString *name = @"";
		for (int i = 0; i < [string length]; i++)
		{
			if([name length] < 1)
				name = [NSString stringWithFormat:@"%c",pinyinFirstLetter([string characterAtIndex:i])];
			else
				name = [NSString stringWithFormat:@"%@%c",name,pinyinFirstLetter([string characterAtIndex:i])];
		}
		if ([ContactData searchResult:name searchText:self.searchBar.text])
			[filteredArray addObject:string];
		else 
		{
			if ([ContactData searchResult:string searchText:self.searchBar.text])
				[filteredArray addObject:string];
			else {
				ABContact *contact = [ContactData byNameToGetContact:string];
				NSArray *phoneArray = [ContactData getPhoneNumberAndPhoneLabelArray:contact];
				NSString *phone = @"";
				
				if([phoneArray count] == 1)
				{
					NSDictionary *PhoneDic = [phoneArray objectAtIndex:0];
					phone = [ContactData getPhoneNumberFromDic:PhoneDic];
					if([ContactData searchResult:phone searchText:self.searchBar.text])
						[filteredArray addObject:string];
				}else  if([phoneArray count] > 1)
				{
					for(NSDictionary *dic in phoneArray)
					{
						phone = [ContactData getPhoneNumberFromDic:dic];
						if([ContactData searchResult:phone searchText:self.searchBar.text])
						{
							[filteredArray addObject:string];	
							break;
						}
					}
				}
				
			}
		}
	}
	return self.filteredArray.count;
}



- (void)searchBarTextDidBeginEditing:(UISearchBar *)asearchBar{
	self.searchBar.prompt = @"输入字母、汉字或电话号码搜索";
}

// Via Jack Lucky
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[self.searchBar setText:@""]; 
	self.searchBar.prompt = nil;
	[self.searchBar setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
	self.DataTable.tableHeaderView = self.searchBar;	
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCellStyle style =  UITableViewCellStyleSubtitle;
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"ContactCell"];
	if (!cell) cell = [[[UITableViewCell alloc] initWithStyle:style reuseIdentifier:@"ContactCell"] autorelease];
	NSString *contactName;
	
	// Retrieve the crayon and its color
	if (aTableView == self.DataTable)
		contactName = [[self.sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	else
		contactName = [self.filteredArray objectAtIndex:indexPath.row];
	cell.textLabel.text = [NSString stringWithCString:[contactName UTF8String] encoding:NSUTF8StringEncoding];
	
	ABContact *contact = [ContactData byNameToGetContact:contactName];
	if(contact)
	{
		NSArray *phoneArray = [ContactData getPhoneNumberAndPhoneLabelArray:contact];
		if([phoneArray count] > 0)
		{
			NSDictionary *dic = [phoneArray objectAtIndex:0];
			NSString *phone = [ContactData getPhoneNumberFromDic:dic];
			cell.detailTextLabel.text = phone;
		}
	}
	else
		cell.detailTextLabel.text = @"";
	return cell;
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.DataTable.isEditing)
    {
        [aTableView deselectRowAtIndexPath:indexPath animated:NO];
        ABPersonViewController *pvc = [[[ABPersonViewController alloc] init] autorelease];
        pvc.navigationItem.leftBarButtonItem = BARBUTTON(@"取消", @selector(cancelBtnAction:));
        
        NSString *contactName = @"";
        if (aTableView == self.DataTable)
            contactName = [[self.sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        else
            contactName = [self.filteredArray objectAtIndex:indexPath.row];
        
        ABContact *contact = [ContactData byNameToGetContact:contactName];
        pvc.displayedPerson = contact.record;
        pvc.allowsEditing = YES;
        //[pvc setAllowsDeletion:YES];
        pvc.personViewDelegate = self;
        self.aBPersonNav = [[[UINavigationController alloc] initWithRootViewController:pvc] autorelease];
        self.aBPersonNav.navigationBar.tintColor = SETCOLOR(redcolor,greencolor,bluecolor);
        [self presentModalViewController:aBPersonNav animated:YES];
    }
    else
    {
        NSArray *selectedRows = [self.DataTable indexPathsForSelectedRows];
        //NSLog(@"%d",selectedRows.count);
        if (selectedRows.count > 0)
        {
            NSMutableArray *phonenumbersArray = [NSMutableArray array];
            for (NSIndexPath *selectionIndex in selectedRows)
            {
                NSString *contactName = @"";
                if (aTableView == self.DataTable)
                    contactName = [[self.sectionArray objectAtIndex:selectionIndex.section] objectAtIndex:selectionIndex.row];
                else
                    contactName = [self.filteredArray objectAtIndex:selectionIndex.row];
                //NSLog(@"%@",contactName);
                ABContact *contact = [ContactData byNameToGetContact:contactName];
                
                   
                for (int i=0;i<[contact.phoneArray count];i++) {
                    [phonenumbersArray addObject:[[contact.phoneArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"-" withString:@""]];
                }
                self.dataArray = phonenumbersArray;
                //NSLog(@"%@",self.dataArray);
                
                
            }
            
        }
    }

    
	
}




// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)aTableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(aTableView == self.DataTable)
		// Return NO if you do not want the specified item to be editable.
		return YES;
	else
		return NO;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {	
	NSString *contactName = @"";
	if (aTableView == self.DataTable)
		contactName = [[self.sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	else
		contactName = [self.filteredArray objectAtIndex:indexPath.row];
	ABContact *contact = [ContactData byNameToGetContact:contactName];
	
	if ([ModalAlert ask:@"真的要删除 %@?", contact.compositeName])
	{
		/*CATransition *animation = [CATransition animation];
		animation.delegate = self;
		animation.duration = 0.2;
		animation.timingFunction = UIViewAnimationCurveEaseInOut;
		animation.fillMode = kCAFillModeForwards;
		animation.removedOnCompletion = NO;
		animation.type = @"suckEffect";//110		
		[DataTable.layer addAnimation:animation forKey:@"animation"];*/
		[[self.sectionArray objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
		[ContactData removeSelfFromAddressBook:contact withErrow:nil];
		[DataTable reloadData];
	}
	[DataTable  setEditing:NO];
	editBtn.title = @"编辑";
	isEdit = NO;
}

/*
-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
	[DataTable.layer removeAllAnimations];
	[super.view.layer removeAllAnimations];
}
*/

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
	[self dismissModalViewControllerAnimated:YES];
	return NO;
}

- (void)cancelBtnAction:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
}


-(IBAction)addContactItemBtn:(id)sender{
	// create a new view controller
	ABNewPersonViewController *npvc = [[[ABNewPersonViewController alloc] init] autorelease];
	npvc.navigationItem.leftBarButtonItem = BARBUTTON(@"取消", @selector(addNewBackAction:));
	self.aBNewPersonNav = [[[UINavigationController alloc] initWithRootViewController:npvc] autorelease];
	self.aBNewPersonNav.navigationBar.tintColor = SETCOLOR(redcolor,greencolor,bluecolor);
	ABContact *contact = [ABContact contact];
	npvc.displayedPerson = contact.record;
	npvc.newPersonViewDelegate = self;
	[self presentModalViewController:aBNewPersonNav animated:YES];
}


- (void)addNewBackAction:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark NEW PERSON DELEGATE METHODS
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person
{
	if (person)
	{
		ABContact *contact = [ABContact contactWithRecord:person];
		//self.title = [NSString stringWithFormat:@"Added %@", contact.compositeName];
		if (![ABContactsHelper addContact:contact withError:nil])
		{
			// may already exist so remove and add again to replace existing with new
			[ContactData removeSelfFromAddressBook:contact withErrow:nil];
			[ABContactsHelper addContact:contact withError:nil];
		}
	}
	else
	{
	}
	[DataTable reloadData];
	[self dismissModalViewControllerAnimated:YES];
}


-(IBAction)editContactItemBtn:(id)sender
{
	if(isEdit == NO)
	{	
		[DataTable setEditing:YES];
		editBtn.title = @"完成";
	}else {
		[DataTable  setEditing:NO];
		editBtn.title = @"编辑";
	}
	isEdit = !isEdit;
}


-(IBAction)groupBtnAction:(id)sender{
	
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    [dataArray release];
    [sectionArray release];
}

- (void)dealloc {
	[sectionArray release];
    [dataArray release];
    [super dealloc];
}
@end
