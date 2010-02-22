//
//  contactlookup.h
//  spokn
//
//  Created by Mukesh Sharma on 15/02/10.
//  Copyright 2010 Geodesic Ltd.. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AddressBook/AddressBook.h>
#import <AddressBook/ABPerson.h>
#import <AddressBook/ABRecord.h>
#import <AddressBookUI/AddressBookUI.h>
@interface AddressBookRecord:NSObject
{

	ABRecordID recordID;
	

}
@property (readwrite,assign) ABRecordID recordID;
@end
@interface Contactlookup : NSObject {
	NSMutableArray *peopleArray;
	ABAddressBookRef addressRef;
	NSMutableDictionary *contactDictionaryP;// = [[NSMutableDictionary alloc]init];

	long count;
}
-(void) makeIndex;
-(NSString*) getNameByNumber:(NSString*)numberP;


@end
