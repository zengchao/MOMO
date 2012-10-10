/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import "ABGroup.h"
#import "ABContactsHelper.h"
#import "AppDelegate.h"
@implementation ABGroup
@synthesize record;

// Thanks to Quentarez, Ciaran
- (id) initWithRecord: (ABRecordRef) aRecord
{
	if (self = [super init]) record = CFRetain(aRecord);
	return self;
}

+ (id) groupWithRecord: (ABRecordRef) grouprec
{
	return [[[ABGroup alloc] initWithRecord:grouprec] autorelease];
}

+ (id) groupWithRecordID: (ABRecordID) recordID
{
	ABRecordRef grouprec = ABAddressBookGetGroupWithRecordID(addressBook, recordID);
	ABGroup *group = [self groupWithRecord:grouprec];
	CFRelease(grouprec);
	return group;
}

// Thanks to Ciaran
+ (id) group
{
	ABRecordRef grouprec = ABGroupCreate();
	id group = [ABGroup groupWithRecord:grouprec];
	CFRelease(grouprec);
	return group;
}

- (void) dealloc
{
	if (record) CFRelease(record);
	[super dealloc];
}


#pragma mark Record ID and Type
- (ABRecordID) recordID {return ABRecordGetRecordID(record);}
- (ABRecordType) recordType {return ABRecordGetRecordType(record);}
- (BOOL) isPerson {return self.recordType == kABPersonType;}

#pragma mark management
- (NSArray *) members
{
	NSArray *contacts = (NSArray *)ABGroupCopyArrayOfAllMembers(self.record);
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:contacts.count];
	for (id contact in contacts)
		[array addObject:[ABContact contactWithRecord:(ABRecordRef)contact]];
	[contacts release];
	return array;
}

// kABPersonSortByFirstName = 0, kABPersonSortByLastName  = 1
- (NSArray *) membersWithSorting: (ABPersonSortOrdering) ordering
{
	NSArray *contacts = (NSArray *)ABGroupCopyArrayOfAllMembersWithSortOrdering(self.record, ordering);
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:contacts.count];
	for (id contact in contacts)
		[array addObject:[ABContact contactWithRecord:(ABRecordRef)contact]];
	[contacts release];
	return array;
}

- (BOOL) addMember: (ABContact *) contact withError: (NSError **) error
{
	return ABGroupAddMember(self.record, contact.record, (CFErrorRef *) error);
}

- (BOOL) removeMember: (ABContact *) contact withError: (NSError **) error
{
	return ABGroupRemoveMember(self.record, contact.record, (CFErrorRef *) error);
}

#pragma mark name

- (NSString *) getRecordString:(ABPropertyID) anID
{
	return [(NSString *) ABRecordCopyValue(record, anID) autorelease];
}

- (NSString *) name
{
	NSString *string = (NSString *)ABRecordCopyCompositeName(record);
	return [string autorelease];
}

- (void) setName: (NSString *) aString
{
	CFErrorRef error;
	ABRecordSetValue(record, kABGroupNameProperty, (CFStringRef) aString, &error);
}
@end
