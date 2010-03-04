
//  Created on 15/02/10.

/**
 Copyright 2009,2010 Geodesic, <http://www.geodesic.com/>
 
 Spokn SIP-VoIP for iPhone and iPod Touch.
 
 This file is part of Spokn iphone.
 
 Spokn iphone is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 Spokn iphone is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Spokn iphone.  If not, see <http://www.gnu.org/licenses/>.
 */


#import <Foundation/Foundation.h>

#import <AddressBook/AddressBook.h>
#import <AddressBook/ABPerson.h>
#import <AddressBook/ABRecord.h>
#import <AddressBookUI/AddressBookUI.h>
@interface NSString (RemoveAllCharInSet)
- (NSString *)stringByRemovingCharactersInSet:(NSCharacterSet *)set;
@end

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
@property (readwrite,assign) ABAddressBookRef addressRef;
-(void) makeIndex;
-(NSString*) getNameByNumber:(NSString*)numberP;
-(int) searchNameAndTypeBynumber :(char*)lnumberCharP :(char **) nameStringP :(char**)typeP :(ABRecordID *)recIDP;

@end
