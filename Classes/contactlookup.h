
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
	
	ABAddressBookRef addressRef;
	NSMutableDictionary *contactDictionaryP;// = [[NSMutableDictionary alloc]init];
	int appWillTerminateB;
	long count;
}
@property (readwrite,assign) ABAddressBookRef addressRef;
-(int) makeIndex;
-(NSString*) getNameByNumber:(NSString*)numberP;
-(int) searchNameAndTypeBynumber :(char*)lnumberCharP :(char **) nameStringP :(char**)typeP :(ABRecordID *)recIDP;
-(void)appTerminate;
@end
