//
//  contactlookup.m
//  spokn
//
//  Created by Mukesh Sharma on 15/02/10.
//  Copyright 2010 Geodesic Ltd.. All rights reserved.
//

#import "contactlookup.h"
#import "addressbookcontact.h"
@implementation AddressBookRecord

@synthesize recordID;
-(AddressBookRecord*)init
{
	 [super init];
	  recordID = -1;
	return self;
}
-(void) dealloc
{
	[super dealloc];
	
}

@end

@implementation Contactlookup
-(Contactlookup*)init
{
	[super init];
	addressRef = ABAddressBookCreate();
	peopleArray = (NSMutableArray *)ABAddressBookCopyArrayOfAllPeople(addressRef);
//	ABAddressBookGetPersonCount(addressRef);
	contactDictionaryP = [[NSMutableDictionary alloc]init];

	return self;
}
-(void) dealloc
{
	[contactDictionaryP release];
	[peopleArray release];
	[super dealloc];

}




-(void) makeIndex
{
	NSString *numberStringP;
	NSString *labelStringP;
	//NSString *nameP;
	char *numbercharP;
	NSString *text1;
	char *typeCharP;
	ABMultiValueRef name1 ;
	AddressBookRecord *recordP;
	for (NSString *person in peopleArray)
	{
			ABRecordID recordID = ABRecordGetRecordID(person); 
		name1 =(NSString*)ABRecordCopyValue(person,kABRealPropertyType);
		if(name1)
		{	
			
			for(CFIndex i=0;i<ABMultiValueGetCount(name1);i++)
			{
				numberStringP=(NSString*)ABMultiValueCopyValueAtIndex(name1,i);
				labelStringP=(NSString*)ABMultiValueCopyLabelAtIndex(name1,i);
				if(numberStringP==0 || labelStringP==0)
				{
					continue;
				}
				
				//text1 = [labelStringP stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
				text1 = [labelStringP stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_$!<>"]];
				
				numbercharP = (char*)[numberStringP  cStringUsingEncoding:NSUTF8StringEncoding];
				typeCharP = (char*)[text1  cStringUsingEncoding:NSUTF8StringEncoding];
			
				recordP = [[AddressBookRecord alloc] init];
				recordP.recordID = recordID;
				NSLog(numberStringP);	
				[contactDictionaryP setObject: recordP forKey: numberStringP];
								
				
				[numberStringP release];
				[labelStringP release];
			}
			[(id)name1 release];
		}	
		name1 =(NSString*)ABRecordCopyValue(person,kABDateTimePropertyType);
		if(name1)
		{	
			for(CFIndex i=0;i<ABMultiValueGetCount(name1);i++)
			{
				numberStringP=(NSString*)ABMultiValueCopyValueAtIndex(name1,i);
				labelStringP=(NSString*)ABMultiValueCopyLabelAtIndex(name1,i);
				if(numberStringP==0 || labelStringP==0)
				{
					continue;
				}
				text1 = [labelStringP stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_$!<>"]];
				
				
				numbercharP = (char*)[numberStringP  cStringUsingEncoding:NSUTF8StringEncoding];
				typeCharP = (char*)[text1  cStringUsingEncoding:NSUTF8StringEncoding];
				
				
				if(strstr(numbercharP,"@"))//only email allowed
				{	
					recordP = [[AddressBookRecord alloc] init];
					recordP.recordID = recordID;
					[contactDictionaryP setObject: recordP forKey: numberStringP];
					
				}
				[numberStringP release];
				[labelStringP release];
			}
			[(id)name1 release];
		}	
		
		
		
		
	}	
	NSLog(@"size dicttionry %d",contactDictionaryP.count);

}
-(NSString*) getNameByNumber:(NSString*)numberP
{
	AddressBookRecord *recordP=0;
	NSString *nameP;
	recordP = [contactDictionaryP objectForKey:numberP];
	if(recordP==nil)
		return nil;
	ABAddressBookRef addressBook = ABAddressBookCreate();
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook,
                                                            recordP.recordID);
	if(person==0)
	{
		//	[addressBook release];
		return nil;
	}
	nameP = [AddressBookContact getName:person];
	
	return nameP;
	
}
@end
