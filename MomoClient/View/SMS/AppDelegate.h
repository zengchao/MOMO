//
//  AppDelegate.h
//  Phone
//
//  Created by xin dong on 10-9-6.
//  Copyright Lixf 2010. All rights reserved.
//

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
@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	IBOutlet  ContactsCtrl *contactView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

