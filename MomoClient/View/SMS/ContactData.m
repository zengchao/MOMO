//
//  ContactData.m
//  Phone
//
//  Created by angel li on 10-9-20.
//  Copyright 2010 Lixf. All rights reserved.
//

#import "ContactData.h"
#import "AppDelegate.h"

@implementation ContactData

//从Address Book里得到所有联系人
+ (NSArray *) contactsArray
{
	NSArray *thePeople = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:thePeople.count];
	for (id person in thePeople)
		[array addObject:[ABContact contactWithRecord:(ABRecordRef)person]];
	[thePeople release];
	return array;
}


//以号码来检测通讯录内是否已包含该联系人
+ (NSDictionary *) hasContactsExistInAddressBookByPhone:(NSString *)phone{
	NSString *PhoneNumber = nil;
	NSString *PhoneLabel = nil;
	NSString *PhoneName = nil;
	NSArray *contactarray = [ContactData contactsArray];
	for(int i=0; i<[contactarray count]; i++)
	{
		ABContact *contact = [contactarray objectAtIndex:i];
		NSArray *phoneCount = [ContactData getPhoneNumberAndPhoneLabelArray:contact];
		if([phoneCount count] > 0)
		{
			NSDictionary *PhoneDic = [phoneCount objectAtIndex:0];
			PhoneNumber = [ContactData getPhoneNumberFromDic:PhoneDic];
			PhoneLabel = [ContactData getPhoneLabelFromDic:PhoneDic];
			PhoneName = contact.contactName;
			if([PhoneNumber isEqualToString:phone])
			{
				NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:PhoneName,KPHONENAMEDICDEFINE,PhoneNumber,KPHONENUMBERDICDEFINE,PhoneLabel,KPHONELABELDICDEFINE,nil ];
				return dic;
			}
		}
	}
	return nil;
}


//通过号码得到该联系人
+(ABContact *) byPhoneNumberAndLabelToGetContact:(NSString *)phone withLabel:(NSString *)label{
	NSArray *array = [ContactData contactsArray];
	for(ABContact * contast in array)
	{
		NSArray *phoneArray = [ContactData getPhoneNumberAndPhoneLabelArray:contast];
		if(phoneArray == nil)
			return nil;
		for(NSDictionary *dic in phoneArray)
		{
			NSString *aPhone = [ContactData getPhoneNumberFromDic:dic];
			NSString *aLabel = [ContactData getPhoneLabelFromDic:dic];
			if([aPhone isEqualToString:phone] && [aLabel isEqualToString:label])
				return (ABContact *)contast;
		}
	}
	return nil;
}

//通过姓名与号码得到该联系人
+(ABContact *) byPhoneNumberAndNameToGetContact:(NSString *)name withPhone:(NSString *)phone{
	NSArray *array = [ContactData contactsArray];
	for(ABContact * contast in array)
	{
		NSArray *phoneArray = [ContactData getPhoneNumberAndPhoneLabelArray:contast];
		if(phoneArray == nil)
			return nil;
		for(NSDictionary *dic in phoneArray)
		{
			NSString *aPhone = [ContactData getPhoneNumberFromDic:dic];
		//	NSString *aLabel = [ContactData getPhoneLabelFromDic:dic];
			if([aPhone isEqualToString:phone] && [name isEqualToString:contast.contactName])
				return (ABContact *)contast;
		}
	}
	return nil;
}


//通过姓名得到该联系人
+(ABContact *) byNameToGetContact:(NSString *)name{
	NSArray *array = [ContactData contactsArray];
	for(ABContact * contast in array)
	{
		if([contast.contactName isEqualToString:name])
			return (ABContact *)contast;
	}
	return nil;
}


//通过号码得到该联系人
+(ABContact *) byPhoneNumberlToGetContact:(NSString *)phone withLabel:(NSString *)label{
	NSArray *array = [ContactData contactsArray];
	for(ABContact * contast in array)
	{
		NSArray *phoneArray = [ContactData getPhoneNumberAndPhoneLabelArray:contast];
		if(phoneArray == nil)
			return nil;
		for(NSDictionary *dic in phoneArray)
		{
			NSString *aPhone = [ContactData getPhoneNumberFromDic:dic];
			//NSString *aLabel = [ContactData getPhoneLabelFromDic:dic];
			if([aPhone isEqualToString:phone] && [label isEqualToString:@"未知"])
				return (ABContact *)contast;
		}
	}
	return nil;
}


//得到联系人的号码组与Label组
+(NSArray *) getPhoneNumberAndPhoneLabelArray:(ABContact *) contact
{
	NSMutableDictionary *phoneDic = [[[NSMutableDictionary alloc] init] autorelease];
	NSMutableArray *phoneArray = [[[NSMutableArray alloc] init] autorelease];
	ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(contact.record, kABPersonPhoneProperty);
	int i;
	for (i = 0;  i < ABMultiValueGetCount(phoneMulti);  i++) {
		NSString *phone = [(NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i) autorelease];
		NSString *label =  [(NSString*)ABMultiValueCopyLabelAtIndex(phoneMulti, i) autorelease];
		phoneDic = [NSDictionary dictionaryWithObjectsAndKeys:contact.contactName,KPHONENAMEDICDEFINE,phone,KPHONENUMBERDICDEFINE,label,KPHONELABELDICDEFINE,nil];
		[phoneArray addObject:phoneDic];
	}
	return phoneArray;
	CFRelease(phoneMulti);
}

//得到联系人的号码组与Label组
+(NSArray *) getPhoneNumberAndPhoneLabelArrayFromABRecodID:(ABRecordRef)person withABMultiValueIdentifier:(ABMultiValueIdentifier)identifierForValue
{
	NSString *nameStr = (NSString *)ABRecordCopyCompositeName(person);
	NSMutableDictionary *phoneDic = [[[NSMutableDictionary alloc] init] autorelease];
	NSMutableArray *phoneArray = [[[NSMutableArray alloc] init] autorelease];
	ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
	NSString *phone = [(NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, identifierForValue) autorelease];
	NSString *label =  [(NSString*)ABMultiValueCopyLabelAtIndex(phoneMulti, identifierForValue) autorelease];
	phoneDic = [NSDictionary dictionaryWithObjectsAndKeys:nameStr,KPHONENAMEDICDEFINE,phone,KPHONENUMBERDICDEFINE,label,KPHONELABELDICDEFINE,nil];
	[phoneArray addObject:phoneDic];
	CFRelease(phoneMulti);
	return phoneArray;
}


//从所存的辞典中得到当前联系人的电话号码
+(NSString *) getPhoneNumberFromDic:(NSDictionary *) Phonedic
{
	NSString * phoneNumber = [Phonedic objectForKey:KPHONENUMBERDICDEFINE];
	return [ContactData getPhoneNumberFomat:phoneNumber];
}

//从所存的辞典中得到当前联系人的姓名
+(NSString *) getPhoneNameFromDic:(NSDictionary *) Phonedic
{
	NSString * phoneName = [Phonedic objectForKey:KPHONENAMEDICDEFINE];
	return phoneName;
}


//从所存的辞典中得到当前联系人的Label
+(NSString *) getPhoneLabelFromDic:(NSDictionary *) Phonedic
{
	NSString * PhoneLabel = [Phonedic objectForKey:KPHONELABELDICDEFINE];
	if([PhoneLabel isEqualToString:@"_$!<Mobile>!$_"])
		PhoneLabel = @"移动电话";
	else if([PhoneLabel isEqualToString:@"_$!<Home>!$_"])
		PhoneLabel = @"住宅";
	else if([PhoneLabel isEqualToString:@"_$!<Work>!$_"])
		PhoneLabel = @"工作";
	else if([PhoneLabel isEqualToString:@"_$!<Main>!$_"])
		PhoneLabel = @"主要";
	else if([PhoneLabel isEqualToString:@"_$!<HomeFAX>!$_"])
		PhoneLabel = @"住宅传真";
	else if([PhoneLabel isEqualToString:@"_$!<WorkFAX>!$_"])
		PhoneLabel = @"工作传真";
	else if([PhoneLabel isEqualToString:@"_$!<Pager>!$_"])
		PhoneLabel = @"传呼";
	else if([PhoneLabel isEqualToString:@"_$!<Other>!$_"])
		PhoneLabel = @"其它";
	return PhoneLabel;
}


//向当前联系人表中插入一条电话记录
+ (BOOL)addPhone:(ABContact *)contact phone:(NSString*)phone{
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    CFErrorRef anError = NULL;
    
    // The multivalue identifier of the new value isn't used in this example,
    // multivalueIdentifier is just for illustration purposes.  Real-world
    // code can use this identifier to do additional work with this value.
    ABMultiValueIdentifier multivalueIdentifier;
    
    if (!ABMultiValueAddValueAndLabel(multi, (CFStringRef)phone, kABPersonPhoneMainLabel, &multivalueIdentifier)){
        CFRelease(multi);
        return NO;
    }
	
    if (!ABRecordSetValue(contact.record, kABPersonPhoneProperty, multi, &anError)){
        CFRelease(multi);
        return NO;
    }
    CFRelease(multi);
    return YES;
}


//号码显示格式
+ (NSString *)getPhoneNumberFomat:(NSString *)phone{
	if([phone length] <1)
		return nil;
	NSString* telNumber = @"";
	for (int i=0; i<[phone length]; i++) {
		NSString* chr = [phone substringWithRange:NSMakeRange(i, 1)];
		if([ContactData doesStringContain:@"0123456789" Withstr:chr]) {
			/*if([telNumber length] == 3 || [telNumber length] == 8)
			 telNumber = [telNumber stringByAppendingFormat:@"-%@", chr];
			 else
			 telNumber = [telNumber stringByAppendingFormat:@"%@", chr];*/
			telNumber = [telNumber stringByAppendingFormat:@"%@", chr];
		}
	}
	return telNumber;
}

//检测字符
+ (BOOL)doesStringContain:(NSString* )string Withstr:(NSString*)charcter{
	if([string length] < 1)
		return FALSE;
	for (int i=0; i<[string length]; i++) {
		NSString* chr = [string substringWithRange:NSMakeRange(i, 1)];
		if([chr isEqualToString:charcter])
			return TRUE;
	}
	return FALSE;
}


+(NSString *)equalContactByAddressBookContacts:(NSString *)name withPhone:(NSString *)phone withLabel:(NSString *)label PhoneOrLabel:(BOOL)isPhone withFavorite:(BOOL)isFavorite
{
	ABContact *contact = nil;
	NSArray *array;
	NSString *phoneNumber = @"";
	NSString *phoneLabel = @"";
	if(isFavorite)
		contact = [ContactData byNameToGetContact:name];
	if(!contact)
		contact = [ContactData byPhoneNumberAndLabelToGetContact:phone withLabel:label];
	if(!contact)
		contact = [ContactData byPhoneNumberAndNameToGetContact:name withPhone:phone];
	if([label isEqualToString:@"未知"] && contact == nil)
		contact = [ContactData byPhoneNumberlToGetContact:phone withLabel:label];
	if(contact)
	{
		array = [ContactData getPhoneNumberAndPhoneLabelArray:contact];
	}
	if(contact == nil)
		return nil;
	if([array count] == 1)
	{
		NSDictionary *PhoneDic = [array objectAtIndex:0];
		phoneNumber = [ContactData getPhoneNumberFromDic:PhoneDic];
		phoneLabel = [ContactData getPhoneLabelFromDic:PhoneDic];
	}else  if([array count] > 1)
	{
		for(NSDictionary *dic in array)
		{
			NSString *aPhone = [ContactData getPhoneNumberFromDic:dic];
			NSString *aLabel = [ContactData getPhoneLabelFromDic:dic];
			if([phone isEqualToString:aPhone] && [label isEqualToString:aLabel])
			{
				phoneNumber = aPhone;
				phoneLabel = aLabel;
				break;
			}
		}
	}
	if(isPhone)
		return phoneNumber;
	else
		return phoneLabel;
}


+(NSString *)getContactsNameByPhoneNumberAndLabel:(NSString *)phone withLabel:(NSString *)label{
	NSArray *array = [ContactData contactsArray];
	for(ABContact * contast in array)
	{
		NSArray *phoneArray = [ContactData getPhoneNumberAndPhoneLabelArray:contast];
		if(phoneArray == nil)
			return nil;
		for(NSDictionary *dic in phoneArray)
		{
			NSString *aPhone = [ContactData getPhoneNumberFromDic:dic];
			NSString *aLabel = [ContactData getPhoneLabelFromDic:dic];
			if([aPhone isEqualToString:phone] && [aLabel isEqualToString:label])
				return contast.contactName;
		}
	}
	return nil;	
}


// 从通讯录中删除联联人
+(BOOL) removeSelfFromAddressBook:(ABContact *)contact withErrow:(NSError **) error
{
	if (!ABAddressBookRemoveRecord(addressBook, contact.record, (CFErrorRef *) error)) return NO;
	return ABAddressBookSave(addressBook,  (CFErrorRef *) error);
}

+(BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchT{
	NSComparisonResult result = [contactName compare:searchT options:NSCaseInsensitiveSearch
											   range:NSMakeRange(0, searchT.length)];
	if (result == NSOrderedSame)
		return YES;
	else
		return NO;
}
@end
