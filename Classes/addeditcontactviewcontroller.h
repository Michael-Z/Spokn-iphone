
//  Created on 04/08/09.

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

#import <UIKit/UIKit.h>

#import "LtpInterface.h"
#include "ua.h"
@class SpoknAppDelegate;
@interface AddEditcontactViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UILabel *nameLabelP;
	IBOutlet UITextField *nameFieldP;
	IBOutlet UILabel *mobileLabelP;
	IBOutlet UITextField *mobileFieldP;
	IBOutlet UILabel *businessLabelP;
	IBOutlet UITextField *businessFieldP;
	IBOutlet UILabel *homeLabelP;
	IBOutlet UITextField *homeFieldP;
	IBOutlet UILabel *emailLabelP;
	IBOutlet UITextField *emailFieldP;
	IBOutlet UILabel *spoknIdLabelP;
	IBOutlet UITextField *spoknIdFieldP;

	SpoknAppDelegate *ownerobject;
	LtpInterfaceType *ltpInterfacesP;
	int contactID;

	

}
@property(readwrite,assign) LtpInterfaceType *ltpInterfacesP;
-(void)setObject:(id) object ;
-(void)setContactDetail:(struct AddressBook *)addrP;
-(IBAction)doneClicked;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@end
