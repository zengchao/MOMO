//
//  InviteFriendsVC.h
//  MOMO
//
//  Created by 超 曾 on 12-5-11.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <QuartzCore/QuartzCore.h>
#import "ModalAlert.h"

//Address Book contact
#define KPHONELABELDICDEFINE		@"KPhoneLabelDicDefine"
#define KPHONENUMBERDICDEFINE	@"KPhoneNumberDicDefine"
#define KPHONENAMEDICDEFINE	@"KPhoneNameDicDefine"


#define BARBUTTON(TITLE, SELECTOR)		[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]//UIBarButtonItem
#define NUMBER(X) [NSNumber numberWithInt:X]

@class ContactsCtrl;

ABAddressBookRef addressBook;

@interface InviteFriendsVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
    IBOutlet  ContactsCtrl *contactView;
}
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,strong)ContactsCtrl *contactView;
@end
