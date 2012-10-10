//
//  ContactsCtrl.h
//  Phone
//
//  Created by angel li on 10-9-13.
//  Copyright 2010 Lixf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABContactsHelper.h"
#import "ABContact.h"
#import "CommSmsUtil.h"

@protocol SelectCardTableViewDelegate <NSObject>
- (void) SelectCardArraySendSMS:(NSMutableArray *)cardlist; 
- (void) SelectCardArraySendMail:(NSMutableArray *)cardlist; 
@end

@interface ContactsCtrl : UIViewController <UITableViewDelegate, UITableViewDataSource,ABNewPersonViewControllerDelegate, 
ABPersonViewControllerDelegate,UISearchBarDelegate>{
	IBOutlet UINavigationBar *NavBar;
	IBOutlet UINavigationBar *ContactNavBar;
	IBOutlet UITableView *DataTable;
	IBOutlet UIBarButtonItem *editBtn;
	IBOutlet UIBarButtonItem *groupBtn;
	UISearchDisplayController *searchDC;
	UISearchBar *searchBar;
	UINavigationController *aBPersonNav;
	UINavigationController *aBNewPersonNav;
	NSMutableArray *filteredArray;
	NSMutableArray *contactNameArray;
	NSMutableDictionary *contactNameDic;
	NSMutableArray *sectionArray;
	NSArray *contacts;
	NSString *sectionName;
	CGFloat redcolor, greencolor, bluecolor;
	BOOL isSearch, isEdit, isGroup;
    NSMutableArray *dataArray;

}
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (retain) IBOutlet UITableView *DataTable;
@property (retain) NSArray *contacts;
@property (retain) NSMutableArray *filteredArray;
@property (retain) NSMutableArray *contactNameArray;
@property (retain) NSMutableDictionary *contactNameDic;
@property (retain) NSMutableArray *sectionArray;
@property (retain) UISearchDisplayController *searchDC;
@property (retain) UISearchBar *searchBar;
@property (retain) UINavigationController *aBPersonNav;
@property (retain) UINavigationController *aBNewPersonNav;


//添加联系人
-(void)initData;
-(IBAction)addContactItemBtn:(id)sender;
-(IBAction)editContactItemBtn:(id)sender;
-(IBAction)groupBtnAction:(id)sender;
@end
