
//  Created on 03/08/09.

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

#import "vmailviewcontroller.h"

#import "LtpInterface.h"
#import "SpoknAppDelegate.h"
#include "contactviewcontroller.h"
#import "customcell.h"
#import "vmshowviewcontroller.h"
#include "ua.h"
#include "alertmessages.h"
#import "GEventTracker.h"
@implementation VmailViewController
@synthesize ltpInterfacesP;

- (void) handleTimer: (id) timer
{
   
	if(amt<maxtime)
	{	
		amt += 1;
		[uiProgressP setProgress: (amt / maxtime)];
		
	}
		
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
	[ownerobject retianThisObject:actionSheet];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(uiActionSheetP)
	{	
		[ownerobject vmsStop:false];
	}
}
-(void)stopvmsPlay
{
	
	[uiActionSheetP dismissWithClickedButtonIndex:0 animated:YES ];
	//[uiActionSheetP release];
	
	
	[uiProgressP release];
	[nsTimerP invalidate];
	nsTimerP = nil;
	uiProgressP = nil;
	uiActionSheetP = nil;
	

}
-(void)startVmsProgress:(char*)fileNameCharP :(int) max :(struct VMail *)vmailP
{
	
#define _TEST_VMAIL_
#ifdef _TEST_VMAIL_
	struct AddressBook * addressP;
	char type[30];
	viewPlayResult = 0;
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"All VMSes";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release]; 
	
	addressP = getContactAndTypeCall(vmailP->userid,type);	
	if(addressP)
	{
		VmShowViewController     *vmShowViewControllerP;	
		vmShowViewControllerP = [[VmShowViewController alloc] initWithNibName:@"vmshowviewcontroller" bundle:[NSBundle mainBundle]];
		//[ContactControllerDetailsviewP setAddressBook:addressP editable:false :CONTACTDETAILVIEWENUM];
		[vmShowViewControllerP setFileName: fileNameCharP :&viewPlayResult];
		[vmShowViewControllerP setvmsDetail: vmailP->userid : addressP->title :type :VMSStatePlay :max :vmailP];
		[vmShowViewControllerP setObject:self->ownerobject];
		
		[ [self navigationController] pushViewController:vmShowViewControllerP animated: YES ];
		//UINavigationController *tmpCtl;
		//tmpCtl = [[ [ UINavigationController alloc ] initWithRootViewController: vmShowViewControllerP ] autorelease];
		//[ownerobject.tabBarController presentModalViewController:tmpCtl animated:YES];
		
				
		if([vmShowViewControllerP retainCount]>1)
			[vmShowViewControllerP release];
		
	}
	else if(vmailP->recordUId)
	{
		//ABAddressBookRef addressBook = ABAddressBookCreate();
		//ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook,vmailP->recordUId);
		char *addressBookNameP = 0;
		char *addressBookTypeP = 0;
		[ContactViewController	getNameAndType:ownerobject.addressRef : vmailP->recordUId :vmailP->userid :&addressBookNameP :&addressBookTypeP];
		if(addressBookNameP)
		{
			
			VmShowViewController     *vmShowViewControllerP;	
			vmShowViewControllerP = [[VmShowViewController alloc] initWithNibName:@"vmshowviewcontroller" bundle:[NSBundle mainBundle]];
			//[ContactControllerDetailsviewP setAddressBook:addressP editable:false :CONTACTDETAILVIEWENUM];
			[vmShowViewControllerP setFileName: fileNameCharP :&viewPlayResult];
			[vmShowViewControllerP setvmsDetail: vmailP->userid : addressBookNameP :addressBookTypeP :VMSStatePlay :max :vmailP];
			[vmShowViewControllerP setObject:self->ownerobject];
			
			[ [self navigationController] pushViewController:vmShowViewControllerP animated: YES ];
			//UINavigationController *tmpCtl;
			//tmpCtl = [[ [ UINavigationController alloc ] initWithRootViewController: vmShowViewControllerP ] autorelease];
			//[ownerobject.tabBarController presentModalViewController:tmpCtl animated:YES];
			
			
			if([vmShowViewControllerP retainCount]>1)
				[vmShowViewControllerP release];
			free(addressBookNameP);
			if(addressBookTypeP)
			{	
				free(addressBookTypeP);
			}	
		}
	}
	else
	{
		VmShowViewController     *vmShowViewControllerP;	
		vmShowViewControllerP = [[VmShowViewController alloc] initWithNibName:@"vmshowviewcontroller" bundle:[NSBundle mainBundle]];
		[vmShowViewControllerP setFileName: fileNameCharP :&viewPlayResult];
		//[ContactControllerDetailsviewP setAddressBook:addressP editable:false :CONTACTDETAILVIEWENUM];
		if(strstr(vmailP->userid,"@")==0)
		{	
			[vmShowViewControllerP setvmsDetail: vmailP->userid : vmailP->userid :"mobile" :VMSStatePlay :max : vmailP];
		}
		else
		{
			[vmShowViewControllerP setvmsDetail: vmailP->userid : vmailP->userid :"email" :VMSStatePlay :max : vmailP];
		}

		[vmShowViewControllerP setObject:self->ownerobject];
		
		[ [self navigationController] pushViewController:vmShowViewControllerP animated: YES ];
		//UINavigationController *tmpCtl;
		//tmpCtl = [[ [ UINavigationController alloc ] initWithRootViewController: vmShowViewControllerP ] autorelease];
		//[ownerobject.tabBarController presentModalViewController:tmpCtl animated:YES];
		
		if([vmShowViewControllerP retainCount]>1)
			[vmShowViewControllerP release];
	}
	
	return;
#endif
	
	
	
	
	
	amt = 0.0;
	maxtime = max*2;
	//CGRect rectSheet;
	uiActionSheetP = [[UIActionSheet alloc] 
			initWithTitle: @"" 
			delegate:self
			cancelButtonTitle:_CANCEL_
			destructiveButtonTitle:nil
			otherButtonTitles:nil, nil, nil];
	//rectSheet = uiActionSheetP.bounds;
	//rectSheet.size.height = 50;
	
	//[uiActionSheetP addButtonWithTitle:@"Test" ];
	uiProgressP = [[UIProgressView alloc] initWithFrame:
			   
			   CGRectMake(10.0f, 10.0f, 300.0f, 10.0f)];
	
	uiProgressP.backgroundColor = uiActionSheetP.backgroundColor;//[UIColor blueColor];
	uiProgressP.progressViewStyle= UIProgressViewStyleBar;
	
	//UIView *contentView1 = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 100.0f, 200.0f, 50.0f)];
	
	//uiProgressP.backgroundColor = [UIColor blueColor];
    
	// [contentView1 addSubview:progbar];
    [uiActionSheetP addSubview:uiProgressP];
	[uiProgressP release];//need to release because addsubview increse counter by one
		
    //[menu setStyle: 0];
	uiActionSheetP.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[uiActionSheetP showInView:[ownerobject tabBarController].view];
//	[uiProgressP release];//need to release because addsubview increse counter by o
		
	
	
	//[menu release];
		
    nsTimerP = [NSTimer scheduledTimerWithTimeInterval: 0.5
				
												target: self
				
											  selector: @selector(handleTimer:)
				
											  userInfo: nil
				
											   repeats: YES];
	
}


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		//[self.tabBarItem   initWithTabBarSystemItem: 
		// UITabBarSystemItemFavorites tag:4];
		//[self.tabBarItem initWithTitle:@"Dial" image:[UIImage imageNamed:@"Dial.png"] tag:1];
	//	[self.tabBarItem initWithTitle:@"Voicemail" image:[UIImage imageNamed:@"vmstab.png"] tag:4];
		//self.tabBarItem = [UITabBarItem alloc];
		//[self.tabBarItem initWithTitle:@"Voicemail" image:[UIImage imageNamed:@"vmstab.png"] tag:4];
		//self.title = @"Voicemail";
		//[self.tabBarItem initWithTitle:@"Voicemail" image:[UIImage imageNamed:@"vmstab.png"] tag:4];
		[self setTitle:@"VMS"];
		[self.tabBarItem initWithTitle:@"VMS" image:[UIImage imageNamed:_TAB_VMS_PNG_] tag:4];
		startIndicator = 0;
    }
    return self;
}


-(void)setObject:(id) object 
{
	self->ownerobject = object;
}

/*
 *   Table Data Source
 */

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{
	
	return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section 
{
	int count;
	/*return [[UIFont	familyNames] count];*/
	count = GetTotalCount(showFailInt);
	return count;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
	
}
-(void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	SpoknUITableViewCell *cell = (SpoknUITableViewCell*)[ self->tableView cellForRowAtIndexPath: indexPath ];
	[cell tablecellsetEdit:YES :1];
	
	
}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	SpoknUITableViewCell *cell = (SpoknUITableViewCell*)[ self->tableView cellForRowAtIndexPath: indexPath ];
	[cell tablecellsetEdit:NO :1];

	
}
- (void)addRow: (int )index sectionObject:(sectionType **)sectionPP
{
	//struct AddressBook *addressP;
	void *objP;
	char *typeCallP = 0;
	char *objStrP=0;
	char *secObjStrP = 0;
	struct tm *tmP=0;
	time_t timeP;
	char disp[200];
	char s1[30];
	char type[100];
	unsigned char findResult = NO;
	//int index;
	NSString *stringStrP;
	char *contactNameP=0;
	//char *addressBookNameP = 0;
	//char *addressBookTypeP = 0;
	char *month[12]={"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
	char *ampmCharP=0;
	
	lbold = 0;
	
	objP = GetObjectAtIndex(showFailInt ,index);
	if(objP)
	{
		//	NSString *CellIdentifier;
		struct VMail *vmailP;
		vmailP =(struct VMail*) objP;
		objStrP = vmailP->userid;
		SetAddressBookDetails(ownerobject.ltpInterfacesP, vmailP->recordUId, vmailP->recordUId);
		contactNameP = [ownerobject getNameAndTypeFromNumber:objStrP :type :&findResult];
		if(findResult)
		{
			int uID;
			typeCallP = type;
			objStrP = contactNameP;
			uID = getAddressUid(ownerobject.ltpInterfacesP);
			if(uID)
			{
				vmailP->recordUId = uID;
				vmailP->isexistRecordID = 1;
			}
		}
		SetAddressBookDetails(ownerobject.ltpInterfacesP, 0, 0);
		
		
		/*
		addressP = getContactOf(objStrP);
		if(addressP)
		{
			
			if (!strcmp(addressP->mobile, objStrP))
			{
				typeCallP = "mobile";
			}
			
			if (!strcmp(addressP->home, objStrP))
			{
				typeCallP = "home";
			}
			
			if (!strcmp(addressP->business, objStrP))
			{
				typeCallP = "business";
			}	
			if (!strcmp(addressP->spoknid, objStrP))
			{
				typeCallP = "spokn";
			}	
			if (!strcmp(addressP->other, objStrP))
			{
				typeCallP = "other";
			}
			
			if (!strcmp(addressP->email, objStrP))
			{
				typeCallP = "email";
			}
			objStrP = addressP->title;
			
		}*/
/*		else
		{
			if(vmailP->recordUId)
			{	
				
				[ContactViewController	getNameAndType:vmailP->recordUId :vmailP->userid :&addressBookNameP :&addressBookTypeP];
				if(addressBookNameP)
				{	
					if(addressBookTypeP)
					{	
						typeCallP = addressBookTypeP;
					}
					char *nameP = addressBookNameP;
					if(nameP)
					{	
						while(*nameP==' '){
							nameP++;
						}
						if(*nameP!='\0')
						{
							objStrP = addressBookNameP;
						}
					}	
					
					
					
					
				}
				
				
			}		
		}	*/
		timeP = vmailP->date;
		tmP = localtime(&timeP);
		
		if(tmP)
		{	
			char *days[7]={"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"};
			
			time_t todaytime;
			long difftime;
			struct tm tmP1,tmP2;
			tmP1 = *tmP;
			todaytime = time(0);
			tmP =localtime(&todaytime);
			tmP2 = *tmP;
			
			difftime = tmP2.tm_yday -tmP1.tm_yday;
			if(difftime<0)
			{
				difftime = difftime*(-1);
			}	
			switch(difftime)
			{
				case 0:
					if(tmP1.tm_hour<12)
					{	
						//sprintf(s1,"%02d:%02d %s",tmP1.tm_hour,tmP1.tm_min,"AM");
						if(tmP1.tm_hour==0)//mid night
						{
							tmP1.tm_hour = 12;
						}
						sprintf(s1,"%02d:%02d",tmP1.tm_hour,tmP1.tm_min);
						ampmCharP = " AM";
					}
					else
					{
						if(tmP1.tm_hour>12)//mid night
						{
							tmP1.tm_hour-= 12;
						}
						//sprintf(s1,"%02d:%02d %s",tmP1.tm_hour,tmP1.tm_min,"PM");
						sprintf(s1,"%02d:%02d",tmP1.tm_hour,tmP1.tm_min);
						ampmCharP = " PM";
					}	
					
					lbold = 1;
				break;
				case 1:
					sprintf(s1,"Yesterday");
				
				break;
				default:
				if(difftime<7)
				{
					sprintf(s1,"%s",days[tmP1.tm_wday]);
				}
				else
				{
					sprintf(s1,"%3s %02d",month[tmP1.tm_mon],tmP1.tm_mday);
				}
				break;
			
			}
			
			
					
			
			//sprintf(disp,"%-20s %12s",objStrP,s1);
			//free(tmP);
			strcpy(disp,objStrP);
			//free(tmP);
			objStrP = disp;
			secObjStrP = s1;
			
		}
		
		
		
		
			
		
		displayData *dispP;	
		sectionType *secLocP;
		Boolean makeB = false;
		secLocP = [[sectionType alloc] init];
		secLocP->index = index;
		makeB = true;
		
		
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
		if(secObjStrP)
		{	
			dispP = [ [displayData alloc] init];
			dispP.left = 0;
			dispP.top = 0;
			dispP.width = 10;
			dispP.height = 70;
			
			if (vmailP->direction == VMAIL_OUT) 
			{
				
				switch(vmailP->status)
				{
					case VMAIL_DELIVERED:
						dispP.uiImageP =  dileverImageP;
						break;
					case VMAIL_FAILED:
						dispP.uiImageP =  failedImageP;
						break;
					case VMAIL_ACTIVE:
						dispP.uiImageP =  activeImageP;
						break;
					case VMAIL_NEW:
						dispP.uiImageP =  vnewoutImageP;
						break;
				}
			}
			if (vmailP->direction == VMAIL_IN) 
			{
				switch(vmailP->status)
				{
					case VMAIL_ACTIVE:
						dispP.uiImageP =  vnewImageP;
						break;
					case VMAIL_DELIVERED:
						dispP.uiImageP =  readImageP;
						break;
					case VMAIL_NEW:
						dispP.uiImageP =  vnewImageP;
						break;
					case VMAIL_FAILED:
						dispP.uiImageP =  failedImageP;
						break;
				}
			}
			dispP.showOnEditB = true;
			[secLocP->elementP addObject:dispP];
		}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		if(makeB)
		{
		//	secLocP->freeUDataB = true;
			//struct VMail *lvmailP;
			//lvmailP = malloc(sizeof(struct VMail)+4);
			//*lvmailP = *vmailP;
			//secLocP->userData = lvmailP;
			
			secLocP->uniqueID = vmailP->uniqueID;
			secLocP->userData = 0;
			secLocP->index = index;
			dispP = [ [displayData alloc] init];
			dispP.boldB = YES;
			dispP.left = 4;
			//dispP.top = 0;
			if(secObjStrP)
			{	
				dispP.width = 53;
			}
			else
			{
				dispP.width = 100;
			}
			if(typeCallP)
			{
				dispP.height = 30;
				dispP.top = 0;	
			}	
			else
			{
				dispP.height = 60;
				dispP.top = 6;	
			}	
		/*	if (vmailP->direction == VMAIL_OUT) 
			{

				switch(vmailP->status)
				{
					case VMAIL_DELIVERED:
						dispP.uiImageP =  dileverImageP;
						break;
					case VMAIL_FAILED:
						dispP.uiImageP =  failedImageP;
						break;
					case VMAIL_ACTIVE:
						dispP.uiImageP =  activeImageP;
						break;
					case VMAIL_NEW:
						dispP.uiImageP =  vnewoutImageP;
						break;
				}
			}
			if (vmailP->direction == VMAIL_IN) 
			{
				switch(vmailP->status)
				{
					case VMAIL_ACTIVE:
						dispP.uiImageP =  vnewImageP;
						break;
					case VMAIL_DELIVERED:
						dispP.uiImageP =  readImageP;
						break;
					case VMAIL_NEW:
						dispP.uiImageP =  vnewImageP;
						break;
					case VMAIL_FAILED:
						dispP.uiImageP =  failedImageP;
						break;
						
						
						

				}
			}*/
			if(vmailP->status==VMAIL_FAILED)
			{
				dispP.colorP = [UIColor colorWithRed:_REDCOLOR_];
			}
			else
			{
				dispP.colorP = [UIColor blackColor];
				[dispP.colorP release];
				
			}
			//[dispP.colorP release];
			dispP.fntSz = 16;
			//dispP.fontP =  [self->fontGloP fontWithSize:16];
			//[dispP.fontP retain];
			//[dispP.fontP release];
			stringStrP = [[NSString alloc] initWithUTF8String:objStrP ];
			dispP.dataP = stringStrP;
			[stringStrP release];
			
			dispP.fntSz = 20;
			dispP.showOnEditB = true;
			[secLocP->elementP addObject:dispP];
			

			
			if(secObjStrP)
			{	
				dispP = [ [displayData alloc] init];
				dispP.left = 0;
				dispP.top = 5;
				dispP.width = 25;
				if(ampmCharP==NULL)
				{	
					dispP.width = 28;
					
				}
				else {
					dispP.width = 20;
				}
				
				if(lbold)
				{	
					dispP.boldB = YES;
				}
				else
				{
					dispP.boldB = NO;
				}
				dispP.textAlignmentType = UITextAlignmentRight;
				dispP.height = 90;
				/*if(vmailP->status==VMAIL_FAILED)
				{
					dispP.colorP = [UIColor colorWithRed:_REDCOLOR_];
				}
				else
				*/{
					dispP.colorP = [UIColor colorWithRed:_TEXTCOLOR_];//[UIColor blackColor];
					//[dispP.colorP release];
					
				}
				
				stringStrP = [[NSString alloc] initWithUTF8String:secObjStrP ];
				dispP.dataP = stringStrP;
				[stringStrP release];
				//dispP.colorP = [[UIColor alloc] initWithRed:63/255.0 green:90/255.0 blue:139/255.0 alpha:1.0];
				dispP.fntSz = 14;
				//[dispP.colorP release];
				[secLocP->elementP addObject:dispP];
				lbold = 0;
				if(ampmCharP)
				{
					dispP = [ [displayData alloc] init];
					dispP.left = 0;
					dispP.top = 3;
					dispP.width = 8;
					dispP.boldB = NO;
					dispP.textAlignmentType = UITextAlignmentRight;
					dispP.height = 100;
					stringStrP = [[NSString alloc] initWithUTF8String:ampmCharP ];
					dispP.dataP = stringStrP;
					[stringStrP release];
					dispP.colorP = [[UIColor alloc] initWithRed:_TEXTCOLOR_];
					dispP.fntSz = 14;
					[dispP.colorP release];
					[secLocP->elementP addObject:dispP];
					
					
				}

				// [cell setNeedsDisplay];
			}	
			if(typeCallP)
			{	
				dispP = [ [displayData alloc] init];
				dispP.left = 18;
				dispP.top = 2;
				dispP.width = 70;
				dispP.row = 1;
				dispP.height = 45;
				stringStrP = [[NSString alloc] initWithUTF8String:typeCallP ];
				dispP.dataP = stringStrP;
				[stringStrP release];
				dispP.colorP = [UIColor lightGrayColor];
			
				dispP.fntSz = 14;
				[dispP.colorP release];
				dispP.showOnEditB = true;
				[secLocP->elementP addObject:dispP];
			}
			if(sectionPP==0)//mean we dont need to return section object
			{
				[self->cellofvmsP addObject:secLocP];	
			}
			else
			{
				*sectionPP = secLocP;
			}
			//[self->cellofcalllogP addObjectAtIndex:secLocP :index];	
			//[self->cellofcalllogP addObjectAtIndex:cell.spoknSubCellP.dataArrayP :index];	
			
			
		}
				
		//[CellIdentifier release];
		
	}
	else
	{
		if(sectionPP)
		*sectionPP = 0;
		
	}
	if(contactNameP)
	{
		free(contactNameP);
	}
	//return nil;
}
/*
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	sectionType *secLocP;
	NSString *CellIdentifier = [[NSString alloc] initWithUTF8String:"any cell"];
	SpoknUITableViewCell *cell = (SpoknUITableViewCell *) [ tableView dequeueReusableCellWithIdentifier: CellIdentifier ];
	if (cell == nil) {
		
		secLocP = [self->cellofvmsP getObjectAtIndex: [ indexPath indexAtPosition: 1 ]];
		if(secLocP)
		{	
			CGRect cellRect = CGRectMake(0, 0, 320, 40);
		
			cell =  [ [ SpoknUITableViewCell alloc ] initWithFrame: cellRect reuseIdentifier: CellIdentifier ]  ;
			cell->resusableCount = [ indexPath indexAtPosition: 1 ];
		}	
	}	
	else
	{	
		secLocP = [self->cellofvmsP getObjectAtIndex: [ indexPath indexAtPosition: 1 ]];
	}
	if(secLocP==0) return nil;
	cell.spoknSubCellP.userData = secLocP;
	cell.spoknSubCellP.dataArrayP = secLocP->elementP;
	cell.spoknSubCellP.ownerDrawB = true;
	cell.spoknSubCellP.rowHeight = 50;
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//UITableViewCellAccessoryDetailDisclosureButton; 
	//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	[CellIdentifier release];
	//cell.hidesAccessoryWhenEditing = YES;
	return cell;
	
	
}
*/
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	sectionType *secLocP;
	NSString *CellIdentifier = [[NSString alloc] initWithUTF8String:"any cell"];
	SpoknUITableViewCell *cell = (SpoknUITableViewCell *) [ tableView dequeueReusableCellWithIdentifier: CellIdentifier ];
	if (cell == nil) {
		
	//	secLocP = [self->cellofvmsP getObjectAtIndex: [ indexPath indexAtPosition: 1 ]];
	//	if(secLocP)
		{	
			CGRect cellRect = CGRectMake(0, 0, 320, 50);
			
			cell =  [[ [ SpoknUITableViewCell alloc ] initWithCustomFrame: cellRect reuseIdentifier: CellIdentifier ] autorelease] ;
			//cell->resusableCount = [ indexPath indexAtPosition: 1 ];
			[cell resizeFrame];
			[self addRow:[ indexPath indexAtPosition: 1 ] sectionObject:&secLocP];
			
		}	
	}	
	else
	{	
		secLocP = cell.spoknSubCellP.userData;
		cell.spoknSubCellP.userData = nil;
		[secLocP release];
		secLocP = nil;
		[self addRow:[ indexPath indexAtPosition: 1 ] sectionObject:&secLocP];
		//secLocP = [self->cellofvmsP getObjectAtIndex: [ indexPath indexAtPosition: 1 ]];
	}
	if(secLocP==0)
	{
		cell.spoknSubCellP.userData = 0;
		cell.spoknSubCellP.dataArrayP = 0;

	}
	else
	{
		cell.spoknSubCellP.userData = secLocP;
		cell.spoknSubCellP.dataArrayP = secLocP->elementP;

	}
	cell.spoknSubCellP.ownerDrawB = true;
	cell.spoknSubCellP.rowHeight = 50;
	[cell.spoknSubCellP setNeedsDisplay];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//UITableViewCellAccessoryDetailDisclosureButton; 
	//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	[CellIdentifier release];
	//cell.hidesAccessoryWhenEditing = YES;

	return cell;
	
	
}



/*
 *   Table Delegate
 */

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//selection = [[[UIFont familyNames] objectAtIndex:[newIndexPath row]] retain];
	sectionType *secLocP;
	SpoknUITableViewCell *cell = (SpoknUITableViewCell*)[ self->tableView cellForRowAtIndexPath: indexPath ];
	
	struct VMail *vmailP;
	char *fNameP=0;
	unsigned long timeTotal=0;
	secLocP = cell.spoknSubCellP.userData;
	
	vmailP = GetObjectByUniqueID(GETVMAILLIST, secLocP->uniqueID);
	//vmailP =(struct VMail*) secLocP->userData;
	if(GetVmsFileName(vmailP,&fNameP)==0)
	{
		int er;
		UIAlertView *alert;
	//	er = [ownerobject vmsPlayStart:fName :&timeTotal];
		er = [ownerobject getFileSize:fNameP :&timeTotal];
		switch(er)
		{
			case 0:
				if(vmailP->direction==VMAIL_IN && vmailP->status==VMAIL_ACTIVE)		
				{
					vmailP->status=VMAIL_DELIVERED;
					vmailP->dirty=1;
					newVMailCountdecrease();
					
					[ownerobject profileResynFromApp];	
				}
				NSString *stringStrP;
				char s1[30];
				int count;
				
				count = newVMailCount();
				if(count)
				{	
					sprintf(s1,"%d",count);
					stringStrP = [[NSString alloc] initWithUTF8String:s1 ];
					[self navigationController].tabBarItem.badgeValue= stringStrP;
				
					[stringStrP release];
				}
				else
				{
					[self navigationController].tabBarItem.badgeValue= nil;
				}
				
				[self startVmsProgress:fNameP :timeTotal :vmailP];
				

				break;
			case 2:
				alert = [ [ UIAlertView alloc ] initWithTitle: _TITLE_ 
													  message: [ NSString stringWithString:_VMS_ALREADY_PLAYING_]
																  delegate: nil
														 cancelButtonTitle: nil
														 otherButtonTitles: _OK_, nil
									  ];
				[ alert show ];
				[alert release];
				
				break;
			case 1:
								
				alert = [ [ UIAlertView alloc ] initWithTitle: _INCOMPLETE_VMS_ 
																   message: [ NSString stringWithString:_VMS_NOT_FULLY_DOWNLOADED_ ]
																  delegate: self
														 cancelButtonTitle:_CANCEL_
														 otherButtonTitles: _OK_, nil
									  ];
				
				[ alert show ];
				[alert release];
			//	

				
				break;
			
		}
		
		
		
	}	
	if(fNameP)
	{
		free(fNameP);
	}
		

}
- (void)alertViewCancel:(UIAlertView *)alertView
{
	[ownerobject retianThisObject:alertView];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{
	switch(buttonIndex)
	{
		case 1:
			[ownerobject profileResynFromApp];
			break;
	}
	
}
- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle) editingStyle 
forRowAtIndexPath:(NSIndexPath *) indexPath 
{ 
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		SpoknUITableViewCell *cell = (SpoknUITableViewCell*)[ self->tableView cellForRowAtIndexPath: indexPath ];
		sectionType *secLocP;
		
		struct VMail *vmailP;
		[cell tablecellsetEdit:NO :0];
		secLocP = cell.spoknSubCellP.userData;
		vmailP = GetObjectByUniqueID(GETVMAILLIST, secLocP->uniqueID);
		if(vmailP)
		{
		
		//vmailP =(struct VMail*) secLocP->userData;
			if(vmailP->direction==VMAIL_IN && vmailP->status==VMAIL_ACTIVE)		
			{
				vmailP->status=VMAIL_DELIVERED;
				vmailP->dirty=1;
				newVMailCountdecrease();
			}
		}	
		cell.spoknSubCellP.userData = nil;
		[secLocP release];
		secLocP = 0;
		NSString *stringStrP;
		char s1[30];
		int count;
		
		count = newVMailCount();
		
		if(count)
		{	
			sprintf(s1,"%d",count);
			stringStrP = [[NSString alloc] initWithUTF8String:s1 ];
			[self navigationController].tabBarItem.badgeValue= stringStrP;
			
			[stringStrP release];
		}
		else
		{
			[self navigationController].tabBarItem.badgeValue= nil;
		}
		vmsDelete(vmailP);
		[ownerobject profileResynFromApp];
		/* Delete cell from data source */
		/*
		 UITableViewCell *cell = [ self.tableView cellForRowAtIndexPath: indexPath ];
		 for(int i = 0; i < [ fileList count ]; i++) {
		 if ([ cell.text isEqualToString: [ fileList objectAtIndex: i ] ]) {
		 [ fileList removeObjectAtIndex: i ];
		 }
		 }
		 */
		/* Delete cell from table */
		
	    NSMutableArray *array = [ [ NSMutableArray alloc ] init ];
	    [ array addObject: indexPath ];
        [ self->tableView deleteRowsAtIndexPaths: array withRowAnimation: UITableViewRowAnimationTop ];
		[self->cellofvmsP removeObjectAtIndex: [ indexPath indexAtPosition: 1 ]];
		[array release];
		
	} 
}

- (void) reload {
	
	
			
	[ self->tableView reloadData ];
	
}

- (void) ComposeVmailPressed {
/*	NSIndexPath * indexPath;
	sectionType *secLocP;
	indexPath = self->tableView.indexPathForSelectedRow;
	if(indexPath)
	{	
		SpoknUITableViewCell *cell = (SpoknUITableViewCell*)[ self->tableView cellForRowAtIndexPath: indexPath ];
	
		struct VMail *vmailP;
		//char *fNameP=0;
		//unsigned long timeTotal=0;
		if(cell)
		{	
			secLocP = cell.spoknSubCellP.userData;
			vmailP =(struct VMail*) secLocP->userData;
			[ownerobject vmsShowRecordScreen:vmailP->userid];
		}
	}	
	
	*/
#ifdef _ANALYST_
	[[GEventTracker sharedInstance] trackEvent:@"VMS" action:@"INITIATED" label:@"NAVIGATION BAR"];
#endif
	openVmsCompose = 0;
	VmShowViewController     *vmShowViewControllerP;	
	vmShowViewControllerP = [[VmShowViewController alloc] initWithNibName:@"vmshowviewcontroller" bundle:[NSBundle mainBundle]];
	[vmShowViewControllerP setFileName: "temp" :0];
	//[ContactControllerDetailsviewP setAddressBook:addressP editable:false :CONTACTDETAILVIEWENUM];
	[vmShowViewControllerP setvmsDetail: "" : "" :"" :VMSStateRecord :20 : 0];
	[vmShowViewControllerP setObject:self->ownerobject];
	//[[self navigationController] popToRootViewControllerAnimated:NO];
	//[ [self navigationController] pushViewController:vmShowViewControllerP animated: YES ];
	UINavigationController *tmpCtl;
	tmpCtl = [[ [ UINavigationController alloc ] initWithRootViewController: vmShowViewControllerP ] autorelease];
	[ownerobject.tabBarController presentModalViewController:tmpCtl animated:YES];
	
	if([vmShowViewControllerP retainCount]>1)
		[vmShowViewControllerP release];
	vmsNoChar[0] = 0;
	
	//openVmsCompose = 0;
	
	//vmsNoChar[0] = 0;
	//showContactScreen:(id) navObject returnnumber:(char*) noCharP  result:(int *) resultP
	//[ownerobject showContactScreen:self returnnumber:vmsNoChar result:&openVmsCompose];
	//[ownerobject changeView];
	

}

- (void) stopEditing {
/*	[ self->tableView setEditing: NO animated: YES ];
	
	self.navigationItem.rightBarButtonItem  
	= [ [ [ UIBarButtonItem alloc ]
		 initWithBarButtonSystemItem: UIBarButtonSystemItemEdit
		 target: self
		 action: @selector(startEditing) ] autorelease ];*/
}


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */
-(void) clearPressed {
	
	UIAlertView	*alert = [ [ UIAlertView alloc ] initWithTitle: _TITLE_ 
													   message: [ NSString stringWithString:_CLEAR_VMS_LOG_ ]
													  delegate: self
											 cancelButtonTitle: _CANCEL_
											 otherButtonTitles: _OK_, nil];
	//[alert addButtonWithTitle:_CANCEL_];
	[ alert show ];
	[alert release];
	
}

- (void)controlPressed:(id) sender {
	int index = segmentedControl.selectedSegmentIndex;
	switch(index)
	{
		case 0:
			showFailInt = GETVMAILLIST;
			
			break;
		case  2:
		{
			showFailInt = GETVMAILUNDILEVERD;
			
		}
			break;
			
	}
	[ self->tableView reloadData ];
}




#define TABLE_VIEW_TAG			2000
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[self cancelProgress];
	refreshB = 0;
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if(viewPlayResult)
	{
		viewPlayResult = 0;
		[ self->tableView reloadData ];
	}
	if(openVmsCompose)
	{
			
		openVmsCompose = 0;
		[ownerobject vmsShowRecordOrForwardScreen:vmsNoChar VMSState : VMSStateRecord filename:"temp" duration:0 vmail:0];
		//[ownerobject vmsShowRecordScreen:vmsNoChar];
		vmsNoChar[0] = 0;
	
	}
	NSIndexPath *nsP;
	nsP = [self->tableView indexPathForSelectedRow];
	if(nsP)
	{
		[self->tableView deselectRowAtIndexPath : nsP animated:NO];
	}
	if(onLine)
	{
		self.navigationItem.rightBarButtonItem.enabled =YES;
	}	
	else
	{
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}
	if(refreshB)
	{
		[self->tableView reloadData];
		refreshB = 0;
		if([tableView numberOfRowsInSection:0])
		{
			NSUInteger index[] = {0,0};
			[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathWithIndexes:index length:2] atScrollPosition:UITableViewScrollPositionTop animated:NO];
		}	
	}
}	

-(void)setcomposeStatus:(int)lstatus
{
	onLine = lstatus;
	if(onLine)
	{
		self.navigationItem.rightBarButtonItem.enabled =YES;
	}	
	else
	{
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}	
	
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[ownerobject startRutine];
	//[self retain];
	//activeImageP =[ [UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_VMS_OUT_ACTIVE_PNG_ ofType:@"png" inDirectory:@"/"]]];
	
	activeImageP=[UIImage imageNamed:_VMS_OUT_ACTIVE_PNG_];
	[activeImageP retain];
	
	dileverImageP=[UIImage imageNamed:_VMS_OUT_DELIVERED_PNG_];
	[dileverImageP retain];
	failedImageP=[UIImage imageNamed:_VMS_OUT_UNDELIVERED_PNG_];
	[failedImageP retain];
	vnewImageP=[UIImage imageNamed:_VMS_IN_NEW_PNG_];
	[vnewImageP retain];
	readImageP=[UIImage imageNamed:_VMS_IN_READ_PNG_];
	[readImageP retain];
	vnewoutImageP=[UIImage imageNamed:_VMS_OUT_NEWHIGH_PNG_];
	[vnewoutImageP retain];
	
	//[self.tabBarItem initWithTitle:@"Voicemail" image:[UIImage imageNamed:@"vmstab.png"] tag:4];
	refreshB = 0;
	//self.tabBarItem = [UITabBarItem alloc];
	//[self.tabBarItem initWithTitle:@"Voicemail" image:[UIImage imageNamed:@"vmstab.png"] tag:4];
	//self->tablesz = 0;
	
	tableView.delegate = self;
	tableView.dataSource = self;
	self->cellofvmsP  = nil;
	//tableView.tag = TABLE_VIEW_TAG;
	tableView.clearsContextBeforeDrawing = YES;
	[tableView reloadData];
	//[self setTitle:@"vmail"];
	nsTimerP = nil;
	uiProgressP = nil;
	uiActionSheetP = nil;
	[self setTitle:@"VMS"];
	segmentedControl = [ [ UISegmentedControl alloc ] initWithItems: nil ];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	
	[ segmentedControl insertSegmentWithTitle: _ALL_ atIndex: 0 animated: NO ];
	[ segmentedControl insertSegmentWithTitle: @"" atIndex: 1 animated: NO ];
	[ segmentedControl insertSegmentWithTitle: _UNDELIVERED_ atIndex: 2 animated: NO ];
	[segmentedControl setWidth:0.1 forSegmentAtIndex:1];  
	[segmentedControl setEnabled:NO forSegmentAtIndex:1];
	showFailInt = GETVMAILLIST;
	[ segmentedControl addTarget: self action: @selector(controlPressed:) forControlEvents:UIControlEventValueChanged ];
	
	self.navigationItem.titleView = segmentedControl;
	segmentedControl.selectedSegmentIndex = 0;
	
	self.navigationItem.leftBarButtonItem 	= [ [ [ UIBarButtonItem alloc ]
												 initWithBarButtonSystemItem: UIBarButtonSystemItemRefresh
												 target: self
												 action: @selector(refreshView) ] autorelease ];
	self.navigationItem.rightBarButtonItem 	= [ [ [ UIBarButtonItem alloc ]
												 initWithBarButtonSystemItem: UIBarButtonSystemItemCompose
												 target: self
												 action: @selector(ComposeVmailPressed) ] autorelease ];
	if(onLine)
	{
		self.navigationItem.rightBarButtonItem.enabled =YES;
	}	
	else
	{
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}	
	
 
	activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
	[activityIndicator setCenter:CGPointMake(22, 42)];
	[activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
	activityIndicator.tag = 1;
	[[self navigationController].view addSubview:activityIndicator];
	if(startIndicator)
	{
		[self startProgress];
	}
	
}
-(void)refreshView
{
	[self startProgress];
	if([ownerobject profileResynFromApp])
	{
		[self cancelProgress];
	}
	else
	{	
		[self->tableView reloadData];
	}	
}

-(void)startProgress
{
	startIndicator = 1;
	self.navigationItem.leftBarButtonItem.enabled = NO;
	[activityIndicator startAnimating];
	
}

-(void)cancelProgress
{
	self.navigationItem.leftBarButtonItem.enabled = YES;
	[activityIndicator stopAnimating];
	activityIndicator.hidden = YES;
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
		// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
- (void) doRefresh
{
	refreshB = 1;
	if([tableView numberOfRowsInSection:0])
	{
		NSUInteger index[] = {0,0};
		[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathWithIndexes:index length:2] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	}	
}

- (void)dealloc {
	[activityIndicator release];
	[activeImageP release];
	[dileverImageP release];
	[failedImageP release];
	[vnewImageP release];
	[readImageP release];
	[vnewoutImageP release];
	
	
    [super dealloc];
}
-(void)setObjType:(UAObjectType)luaObj
{
	switch(luaObj)
	{
		case GETCONTACTLIST:
			[self setTitle:@"Contact"];
			break;
		case GETVMAILLIST:
			[self setTitle:@"VMail"];
			break;
		case GETCALLLOGLIST:
			[self setTitle:@"Calllog"];
			
			break;
			
	}
	uaObject = luaObj;
	
}


@end
