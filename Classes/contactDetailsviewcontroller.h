//
//  ContactDetailsViewController.h
//  spoknclientContactDetails

//  Created by Mukesh Sharma on 01/07/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ltptimer.h"
#import "LtpInterface.h"
#include "ua.h"
#import "customcell.h"
#import "custombutton.h"
#define MAX_COUNT 7
#define MAX_SECTION 2
@class SpoknAppDelegate;
typedef struct DataForSection
{
	int section;
	int selected;
	Boolean addNewB;
	char nameofRow[40];
	char *secRowP;
	char *elementP;
	UIView *customViewP;
	
}DataForSection;
typedef struct SectionContactType
	{
		int count;
		int sectionheight;
		UIView *sectionView;
		//int rowHeight;
		DataForSection dataforSection[MAX_COUNT];
	}SectionContactType;

typedef enum ViewTypeEnum
	{
		CONTACTDETAILVIEWENUM,
		CONTACTEDITVIEWENUM,
		CONTACTADDVIEWENUM,
		CALLLOGDETAILVIEWENUM,
		CONTACTPHONEDETAIL,
		CONTACTFORWARDVMS
		
	}ViewTypeEnum;
@interface ContactDetailsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate> {
	IBOutlet UILabel *userNameP;
	IBOutlet UITableView *tableView;
	IBOutlet UIView *viewP;
	
	IBOutlet CustomButton  *delButtonP;
	IBOutlet CustomButton  *vmsButtonP;
	IBOutlet CustomButton  *callButtonP;
	IBOutlet UIButton  *changeNameButtonP;
	int sectionCount;
	int tablesz;
	Boolean editableB;
	NSMutableArray *listOfItems;
	struct CDR *cdrP;
	Boolean callActionSheetB;
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
	
}

- (void)addRow: (int)lsection:(int )row sectionObject:(sectionType **)sectionPP;
-(void)setObject:(id) object ;
-(void)setCdr:(struct CDR *)lcdrP;
-(void)setAddressBook:( struct AddressBook *)laddressDataP editable:(Boolean)editableB :(ViewTypeEnum) viewEnum;
-(IBAction)callPressed:(id)sender;
-(IBAction)vmsPressed:(id)sender;
-(IBAction)deletePressed:(id)sender;
-(IBAction)changeNamePressed:(id)sender;
- (void) presentSheet:(bool)callB;
-(void)setReturnValue:(int*)lretValB selectedContact:(char*)lnumberCharP rootObject:(id)rootObject;
@end
