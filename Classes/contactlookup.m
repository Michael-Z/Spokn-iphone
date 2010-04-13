
//  Created on 15/02/10.

/**
  Copyright 2009, 2010 Geodesic Limited. <http://www.geodesic.com/>
 
 Spokn for iPhone.
 
 This file is part of Spokn for iPhone.
 
 Spokn for iPhone is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, version 2 of the License.
  
 Spokn for iPhone is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Spokn for iPhone.  If not, see <http://www.gnu.org/licenses/>.
 */


#import "contactlookup.h"
#import "addressbookcontact.h"
#import "contactviewcontroller.h"
 
@implementation NSString (RemoveAllCharInSet)
- (NSString *)stringByRemovingCharactersInSet:(NSCharacterSet *)set
{
	NSMutableString *newString;
	newString = [[NSMutableString alloc] init];
	for (int Count=0; Count < self.length; Count++) {
		unichar aChar = [self characterAtIndex:Count];
		
		if([set characterIsMember:aChar]==FALSE)
		{
			[newString appendFormat:@"%c",aChar];
		}
	}	
	[newString autorelease];
	return newString;
		
}
@end



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
@synthesize addressRef;
-(Contactlookup*)init
{
	[super init];
	
//	ABAddressBookGetPersonCount(addressRef);
	contactDictionaryP = [[NSMutableDictionary alloc]init];
	appWillTerminateB = 0;
	return self;
}
-(void) dealloc
{
	[contactDictionaryP release];
	contactDictionaryP = nil;
	[super dealloc];

}
-(void)applicationwillTerminate
{
	appWillTerminateB = true;
}



-(int) makeIndex
{
	NSString *numberStringP;
	
	//NSString *nameP;
	char *numbercharP;
	//NSString *text1;
	ABMultiValueRef name1 ;
	NSString *tmpNumber;
	AddressBookRecord *recordP;
	ABAddressBookRef laddressRef;
	NSMutableArray *peopleArray;
	laddressRef = ABAddressBookCreate();
	peopleArray = (NSMutableArray *)ABAddressBookCopyArrayOfAllPeople(laddressRef);
	if(peopleArray==nil)
	{
		return 1;
	}
	for (NSString *person in peopleArray)
	{
		if(appWillTerminateB)
		{
			[peopleArray release];
			peopleArray = nil;
			return 1;
		}
		ABRecordID recordID = ABRecordGetRecordID(person); 
		name1 =(NSString*)ABRecordCopyValue(person,kABRealPropertyType);
		if(name1)
		{	
			
			/*for(CFIndex i=0;i<ABMultiValueGetCount(name1);i++)
			{
				numberStringP=(NSString*)ABMultiValueCopyValueAtIndex(name1,i);
				//labelStringP=(NSString*)ABMultiValueCopyLabelAtIndex(name1,i);
				if(numberStringP==0 )//|| labelStringP==0)
				{
					continue;
				}
				tmpNumber = [[NSString alloc] initWithString:numberStringP];
				//text1 = [numberStringP stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
				text1 = [tmpNumber stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"+-_$!<>"]];
				
				//numbercharP = (char*)[numberStringP  cStringUsingEncoding:NSUTF8StringEncoding];
				//typeCharP = (char*)[text1  cStringUsingEncoding:NSUTF8StringEncoding];
			
				recordP = [[AddressBookRecord alloc] init];
				recordP.recordID = recordID;
				NSLog(@"%@ %@",tmpNumber, text1);	
				
				[contactDictionaryP setObject: recordP forKey: text1];
								
				[tmpNumber release]
				[numberStringP release];
				//[labelStringP release];
			}*/
			for(CFIndex i=0;i<ABMultiValueGetCount(name1);i++)
			{
				numberStringP=(NSString*)ABMultiValueCopyValueAtIndex(name1,i);
				//labelStringP=(NSString*)ABMultiValueCopyLabelAtIndex(name1,i);
				if(numberStringP==0 )//|| labelStringP==0)
				{
					continue;
				}
				tmpNumber = [numberStringP stringByRemovingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()+- _$!<>"]];
				
				recordP = [[AddressBookRecord alloc] init];
				recordP.recordID = recordID;
				
				
				[contactDictionaryP setObject: recordP forKey: tmpNumber];
				[recordP release];
				//[tmpNumber release];
				[numberStringP release];
				//[labelStringP release];
			}
			
			[(id)name1 release];
		}	
		name1 =(NSString*)ABRecordCopyValue(person,kABDateTimePropertyType);
		if(name1)
		{	
			for(CFIndex i=0;i<ABMultiValueGetCount(name1);i++)
			{
				numberStringP=(NSString*)ABMultiValueCopyValueAtIndex(name1,i);
			
				if(numberStringP==0)
				{
					continue;
				}
				//text1 = [labelStringP stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_$!<>"]];
				
				
				numbercharP = (char*)[numberStringP  cStringUsingEncoding:NSUTF8StringEncoding];
				//typeCharP = (char*)[text1  cStringUsingEncoding:NSUTF8StringEncoding];
				
				
				if(strstr(numbercharP,"@"))//only email allowed
				{	
					//printf("email %s",numbercharP);
					NSString *trimStrP;
					recordP = [[AddressBookRecord alloc] init];
					recordP.recordID = recordID;
					trimStrP = [numberStringP stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
					[contactDictionaryP setObject: recordP forKey: trimStrP];
					
				}
				[numberStringP release];
				
			}
			[(id)name1 release];
		}	
		
		
	
		
	}	
	[peopleArray release];
	peopleArray = nil;
	return 0;
		
}
-(NSString*) getNameByNumber:(NSString*)numberP
{
	AddressBookRecord *recordP=0;
	NSString *nameP;
	NSString *newNumberP;
	newNumberP = [numberP stringByRemovingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"+- _$!<>"]];
	
	recordP = [contactDictionaryP objectForKey:newNumberP];
	if(recordP==nil)
		return nil;
	ABAddressBookRef addressBook = addressRef;
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
-(int) searchNameAndTypeBynumber :(char*)lnumberCharP :(char **) nameStringP :(char**)typeP :(ABRecordID *)recIDP
{
	AddressBookRecord *recordP=0;
	NSString *numberP;
	NSString *newNumberP;
	const char *nameCharP;
	if(recIDP)
	{
		*recIDP = -1;
	}
	numberP = [NSString stringWithUTF8String:lnumberCharP];
	if(strstr(lnumberCharP,"@")==0)
	{	
		newNumberP = [numberP stringByRemovingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()+- _$!<>"]];
	}
	else
	{
		newNumberP = numberP;
	}
	recordP = [contactDictionaryP objectForKey:newNumberP];
	if(recordP==nil)
		return 1;
	ABRecordID recID = recordP.recordID;
	nameCharP = [newNumberP UTF8String];
	if(recIDP)
	{
		*recIDP = recID;
	}
	return [ContactViewController getNameAndType:addressRef :recID :(char*)nameCharP :nameStringP :typeP];
	
	
}

@end
