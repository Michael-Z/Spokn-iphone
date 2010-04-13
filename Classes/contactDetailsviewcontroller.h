
//  Created on 01/07/09.

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
#import "Ltptimer.h"
#import "LtpInterface.h"
#include "ua.h"
#import "customcell.h"
#import "custombutton.h"
//#import "vmailviewcontroller.h"
#define MAX_COUNT 10
#define MAX_SECTION 4
@class SpoknAppDelegate;
typedef struct SelectedContctType
	{
		char nameChar[150];
		char type[40];
		char number[150];
	}SelectedContctType;

typedef struct DataForSection
{
	int section;
	int selected;
	Boolean addNewB;
	char nameofRow[40];
	char placeholder[40];
	char *secRowP;
	char *elementP;
	SelectedContctType *contactdataP;
	UIView *customViewP;
	int rowHeight;
	
}DataForSection;
	
typedef struct SectionContactType
	{
		int count;
		int sectionheight;
		UIView *sectionView;
		
		
		DataForSection dataforSection[MAX_COUNT];
	}SectionContactType;

typedef enum ViewTypeEnum
	{
		CONTACTDETAILVIEWENUM,
		CONTACTEDITVIEWENUM,
		CONTACTADDVIEWENUM,
		CALLLOGDETAILVIEWENUM,
		CONTACTPHONEDETAIL,
		CONTACTPHONEADDRESSBOOKDETAIL,
		CONTACTFORWARDVMS,
		CONTACTDETAILFROMVMS
		
		
	}ViewTypeEnum; 
//this protocol is added sending message to parent 
@protocol ContactDeailsProtocol
@optional
-(void) setResult:(int) resultValue;

@end

@interface ContactDetailsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,ContactDeailsProtocol> {
	IBOutlet UILabel *userNameP;
	IBOutlet UITableView *tableView;
	IBOutlet UIView *viewP;
	UIView *sectionViewP;
	IBOutlet CustomButton  *delButtonP;
	IBOutlet UIButton  *vmsButtonP;
	IBOutlet UIButton  *callButtonP;
	//IBOutlet UIButton  *changeNameButtonP;
	IBOutlet UIButton  *addButtonP;
	int sectionCount;
	int tablesz;
	Boolean editableB;
	Boolean animationB;
	NSMutableArray *listOfItems;
	struct CDR *cdrP;
	int actionSheetType;
	int firstSecCount;
	int secondSecCount;
	SectionContactType sectionArray[MAX_SECTION];
	//char *element[MAX_COUNT]; 
	struct AddressBook *addressDataP;
	SpoknAppDelegate *ownerobject;
	ViewTypeEnum viewEnum;
	int viewType;
	char *stringSelected[MAX_COUNT+1];//extra for cancel
	Boolean loadedB;
	int viewResult;
	int updatecontact;
	int *retValP;
	UILabel *msgLabelP;
	char *numberCharP;
	id rootObjectP;
	NSString *titlesP;
	char selectNoCharP[150];//use to store selected no
	UIButton *deleteButton;
	BOOL showAddButtonB;
	SelectedContctType *selectContactP;
	Boolean noNameB;
	Boolean modelViewB;
	int addressID;
	int recordID;
	int numberFound;
	int showAlertB;
	id<ContactDeailsProtocol>contactDetailsProtocolP; 
	Boolean hideCallAndVmailButtonB;
	int editDataInt;	//id<VmailProtocol> VmailProtocolP;
	int addDataInt;
	//this two variable for solving crash
	UIAlertView *alertgP;
	UIActionSheet *uiActionSheetgP;
	
}
@property (nonatomic, assign) id<ContactDeailsProtocol>contactDetailsProtocolP;
-(void)hideCallAndVmailButton:(Boolean)showB;
- (void)addRow: (int)lsection:(int )row sectionObject:(sectionType **)sectionPP;
-(void)setObject:(id) object ;
-(void)setCdr:(struct CDR *)lcdrP;
-(void)setAddressBook:( struct AddressBook *)laddressDataP editable:(Boolean)editableB :(ViewTypeEnum) viewEnum;
-(IBAction)callPressed:(id)sender;
-(IBAction)vmsPressed:(id)sender;
-(IBAction)deletePressed:(id)sender;
-(IBAction)changeNamePressed:(id)sender;
-(IBAction)addContactPressed:(id)sender;
- (void) presentSheet:(int)typeInt;
-(void)setReturnValue:(int*)lretValB selectedContactNumber:(char*)lnumberCharP rootObject:(id)rootObject selectedContact:(SelectedContctType*)lselectContactP;
-(void)setTitlesString:(NSString*)nsP;
-(void)setSelectedNumber:(char*)noCharP showAddButton:(BOOL)lshowB;
-(void) addContactDetails:(SelectedContctType *)lcontactdataP;
-(void) setRecordID:(int)laddressID :(int)lrecordId;
-(void)hideOrShowVmsCallButton;
- (void)updateUI:(id) objectP;
@end

