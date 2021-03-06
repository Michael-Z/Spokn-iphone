
//  Created   on 01/07/09.

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

#import "contactDetailsviewcontroller.h"

#import "Ltptimer.h"
#import "LtpInterface.h"
#import "SpoknAppDelegate.h"
#import "AddEditcontactViewController.h"
#import  "AddeditcellController.h"
#import "vmailviewcontroller.h"
#include "alertmessages.h"
#import "GEventTracker.h"
#import "spokncalladd.h"
#define MAX_ROW_HIGHT 42
//self.navigationItem.leftBarButtonItem.enabled = YES;
@interface ContactDetailsViewController (Private)
- (void)menuControllerWillHide:(NSNotification *)notification;
- (void)menuControllerWillShow:(NSNotification *)notification;
- (void)menuControllerDidShow:(NSNotification *)notification;
@end

@implementation ContactDetailsViewController
@synthesize contactDetailsProtocolP;
@synthesize addcallDelegate;
-(void) setResult:(int)resultValue
{
	if(retValP)
	{	
		*retValP = resultValue;
	}	
	viewResult= resultValue;
}
-(void)hideCallAndVmailButton:(Boolean)showB
{
	hideCallAndVmailButtonB = showB;
}
 

-(void)setObject:(id) object 
{
	self->ownerobject = object;
}
/*
 *   Table Delegate
 */

- (void)addRow: (int)lsection:(int )row sectionObject:(sectionType **)sectionPP;
{
		char *objStrP=0;
	char *secObjStrP = 0;
	
		//int index;
	NSString *stringStrP;
	UITextAlignment alignmentType;
	objStrP = sectionArray[lsection].dataforSection[row].nameofRow;
	secObjStrP = sectionArray[lsection].dataforSection[row].elementP;
	if(objStrP==0 || strlen(objStrP)==0)
	{
		objStrP = secObjStrP;
		secObjStrP = 0;
	}
	
	
	{
				
		displayData *dispP;	
		sectionType *secLocP;
		Boolean makeB = false;
		secLocP = [[sectionType alloc] init];
		secLocP->index = row;
		makeB = true;
		
		if(makeB)
		{
			secLocP->userData = 0;
			
									
			dispP = [ [displayData alloc] init];
			dispP.left = 0;
			dispP.top = 1;
			dispP.width = 100;
			if(secObjStrP)
			{	
				//if(strlen(secObjStrP)>0)
					dispP.width = 25;
				alignmentType = UITextAlignmentRight;
			}
			else
			{
				dispP.left = 6;
				alignmentType = UITextAlignmentLeft;
			}
			dispP.height = 50;
			if(secObjStrP)
			{	
				dispP.colorP = [UIColor colorWithRed:81.0/255.0 green:102.0/255.0 blue:145.0/255.0 alpha:1.0];
				dispP.fntSz = 14;
				dispP.boldB = YES;
			}
			else
			{
				if(noNameB)
				{	
					dispP.colorP =[[UIColor lightGrayColor] autorelease]; 
					objStrP = "Name";
					dispP.boldB = NO;
					
				}
				else
				{	
					dispP.colorP = [[UIColor blackColor] autorelease];
					dispP.boldB = YES;
				}
				dispP.noChangeDimentationB = YES;
				dispP.fntSz = 30;
				dispP.height = 100;
			}
			
			
			//dispP.fontP =  [self->fontGloP fontWithSize:16];
			//[dispP.fontP retain];
			//[dispP.fontP release];
			stringStrP = [[NSString alloc] initWithUTF8String:objStrP ];
			dispP.dataP = stringStrP;
			[stringStrP release];
			//[dispP.colorP release];
			dispP.showOnEditB = true;
			dispP.textAlignmentType = alignmentType;
			[secLocP->elementP addObject:dispP];
			
			if(secObjStrP)
			{	
				dispP = [ [displayData alloc] init];
				dispP.left = 5;
				dispP.top = 0;
				dispP.width = 60;
				dispP.textAlignmentType = UITextAlignmentLeft;
				dispP.height = 70;
				stringStrP = [[NSString alloc] initWithUTF8String:secObjStrP ];
				dispP.dataP = stringStrP;
				[stringStrP release];
				if(sectionArray[lsection].dataforSection[row].selected)
				{	
					if(rootObjectP == 0)
					{	
						if(cdrP)
						{	
							if((cdrP->direction & CALLTYPE_IN) && (cdrP->direction & CALLTYPE_MISSED))
							{
								dispP.colorP =[UIColor colorWithRed:140.0/255.0 green:16.0/255.0 blue:5.0/255.0 alpha:1.0];
							}
							else
							{	
								dispP.colorP = [UIColor colorWithRed:40.0/255.0 green:108.0/255.0 blue:214/255.0 alpha:1.0];
							}
						}
						else
						{
							dispP.colorP = [UIColor colorWithRed:40.0/255.0 green:108.0/255.0 blue:214/255.0 alpha:1.0];
							
						}
					}
					else
					{
						dispP.colorP = [UIColor colorWithRed:40.0/255.0 green:108.0/255.0 blue:214/255.0 alpha:1.0];
					}	
					
				}
				else
				{
					dispP.colorP = [[UIColor blackColor] autorelease];
					
				}
				dispP.fntSz = 14;
				dispP.boldB = YES;
				dispP.showOnEditB = NO;
				//[dispP.colorP release];
				[secLocP->elementP addObject:dispP];
				
				// [cell setNeedsDisplay];
			}	
				*sectionPP = secLocP;//back the pointer
			
			//[self->cellofcalllogP addObjectAtIndex:secLocP :index];	
			//[self->cellofcalllogP addObjectAtIndex:cell.spoknSubCellP.dataArrayP :index];	
			
			
		}
		
		//[CellIdentifier release];
		
	}
	//return nil;
}


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		loadedB = false;
		sectionCount = 1;
		addcallDelegate = nil;
		[self setTitle:@"Info"];
		[self setTitlesString:@"Select number for vms"];
		[self setSelectedNumber:"\0" showAddButton:NO];
		msgLabelP = 0;
		for(int i=0;i<MAX_SECTION;++i)
		{
			memset(&sectionArray[i],0,sizeof(SectionContactType));
		}
		// white button:
		firstSecCount = 0;
		secondSecCount = 0;	
		 uiActionSheetgP = 0;
		alertgP = 0;
		sectionViewP = [[UIView alloc] initWithFrame:CGRectMake(1, 1, 320, 40)];
		CGRect LabelFrame2 = CGRectMake(0, 1, 320, 40);
		
		userNameP = [[UILabel alloc] initWithFrame:LabelFrame2];
		userNameP.textAlignment = UITextAlignmentLeft;
		userNameP.tag = 2;
		userNameP.numberOfLines = 1;
		userNameP.backgroundColor = [[UIColor clearColor] autorelease];
		userNameP.font = [UIFont boldSystemFontOfSize:24];
		
		
	}
    return self;
}
- (void)alertViewCancel:(UIAlertView *)alertView
{
	[ownerobject retianThisObject:alertView];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation
{
	alertgP = nil;
	if(buttonIndex==0 && showAlertB==NO)
	{	
		if(retValP)
		{	
			*retValP = 2;//mean delete
			[ownerobject refreshallViews];
		}
	
		[ [self navigationController] popToRootViewControllerAnimated:YES ];
	}
	showAlertB = YES;
	//[alertView release];
}
- (void)didPresentAlertView:(UIAlertView *)alertView;  // after animation
{
	alertgP = alertView;
}
#pragma mark ACTIONSHEET
- (void)didPresentActionSheet:(UIActionSheet *)actionSheet;  // after animation
{
	uiActionSheetgP = actionSheet;
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
	[ownerobject retianThisObject:actionSheet];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
 {
	 uiActionSheetgP = 0;
	 switch(actionSheetType)
	 {
			 
		 case 2:
		 case  3:	 
			 if(buttonIndex==0)
			 {	 
				 if(retValP)
				 {	
					 *retValP = 2;//mean delete
					
					
				 }
				  [ownerobject refreshallViews];
				  [contactDetailsProtocolP setResult:2];//change in data
				 [ [self navigationController] popToRootViewControllerAnimated:YES ];
			 }
			 break;
		 default:
			 if(stringSelected[buttonIndex])
			 {	
				 SetAddressBookDetails(ownerobject.ltpInterfacesP,addressID,recordID);
				 
				 
				 if(actionSheetType)
				 {
					
					 if([self->ownerobject makeCall:stringSelected[buttonIndex]]==YES)
					 {	
						 [self->ownerobject changeView];
					 }	
					 
				 }
				 else
				 {
					 [ownerobject vmsShowRecordOrForwardScreen:stringSelected[buttonIndex] VMSState : VMSStateRecord filename:"temp" duration:0 vmail:0];
					 
					//  [ownerobject vmsShowRecordScreen:stringSelected[buttonIndex]];
				 }
				 
			 } 
			 
	 
	 }		 
	
	 
	 
	[actionSheet release];
 }




- (void) presentSheet:(int)typeInt
{
	UIActionSheet *uiActionSheetP;
	actionSheetType = typeInt;
	int i=0;
	if(typeInt==1 || typeInt ==0)// "1" For call & "0"  for VMS
	{	
		if(typeInt)
		{	
			uiActionSheetP= [[UIActionSheet alloc] 
						 initWithTitle: @"" 
						 delegate:self
						 cancelButtonTitle:nil 
						 destructiveButtonTitle:nil
						 otherButtonTitles:nil, nil];
			if(firstSecCount==0 && secondSecCount==0)
			{	
				if(strlen(addressDataP->home)>0)
				{	
					[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%+10s %-22s", "home",addressDataP->home] ];
					stringSelected[i++] = addressDataP->home;
				}
				if(strlen(addressDataP->business)>0)
				{	
					[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%+10s %-22s","work" ,addressDataP->business] ];
					stringSelected[i++] = addressDataP->business;
				}	
				if(strlen(addressDataP->mobile)>0)
				{	
					[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%+10s %-22s","mobile", addressDataP->mobile] ];
					stringSelected[i++] = addressDataP->mobile;
				}	

			
				if(strlen(addressDataP->spoknid)>0)
				{		
					[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%+10s %-22s", "spokn",addressDataP->spoknid] ];
					stringSelected[i++] = addressDataP->spoknid;
				}	

			
				if(strlen(addressDataP->other)>0)
				{	
					[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%+10s %-22s","other", addressDataP->other] ];
			
					stringSelected[i++] = addressDataP->other;
				}
				if( strlen(addressDataP->mobile) ||  strlen(addressDataP->business) || strlen(addressDataP->home)||  strlen(addressDataP->other) ||  strlen(addressDataP->spoknid) )
				{	
					uiActionSheetP.title = _SELECT_NUM_TO_CALL_;
				}
				//else
				//{
				//	uiActionSheetP.title = _NO_NUMBER_TO_CALL_;
				//}	
			}
			else
			{
				for(int k=0;k<1;++k)
				{	
					for(int j=0;j<sectionArray[k].count;++j)
					{	
					
						if(strstr(sectionArray[k].dataforSection[j].elementP,"@")==0)
						{	
							numberFound = 1;
							//[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%-8s %-15s",sectionArray[k].dataforSection[j].nameofRow, sectionArray[k].dataforSection[j].elementP ] ];
							//stringSelected[i++] = sectionArray[k].dataforSection[j].elementP;
							NSString *str,*str1,*str2;
							str1=[NSString stringWithFormat:@"%s",sectionArray[k].dataforSection[j].nameofRow];
							if([str1 length]>7)
							{
								str=[NSString stringWithString:[str1 substringToIndex:5]];
								str=[str stringByAppendingString:@"..."];
								str2=[NSString stringWithFormat:@"%-10s",sectionArray[k].dataforSection[j].elementP];
								str=[str stringByAppendingString:str2];
								
								//str=[str appendString:@"%-22s",sectionArray[k].dataforSection[j].elementP];
								//str = [NSString stringWithFormat:@"%s %-22s",substring , sectionArray[k].dataforSection[j].elementP] ;
							}
							else
							{	
								str = [NSString stringWithFormat:@"%+10s %-22s",sectionArray[k].dataforSection[j].nameofRow, sectionArray[k].dataforSection[j].elementP] ;
							}
							[uiActionSheetP addButtonWithTitle:str];
							stringSelected[i++] = sectionArray[k].dataforSection[j].elementP;
						}
					}
				}
				
				if(numberFound)
				{
					uiActionSheetP.title = _SELECT_NUM_TO_CALL_;
					numberFound = 0; 
					callButtonP.enabled = YES;
				}
				else
				{
					//uiActionSheetP.title = _NO_NUMBER_TO_CALL_;
					callButtonP.enabled = NO;
				}	
			
			
			}
		
				
		}
		else
		{
			uiActionSheetP= [[UIActionSheet alloc] 
							 initWithTitle: _SELECT_NUM_TO_VMS_
							 delegate:self
							 cancelButtonTitle:nil 
							 destructiveButtonTitle:nil
							 otherButtonTitles:nil, nil];
			if(firstSecCount==0 && secondSecCount==0)
			{	
				if(strlen(addressDataP->home)>0)
				{	
					[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%+10s %-22s", "home",addressDataP->home] ];
					stringSelected[i++] = addressDataP->home;
				}
				if(strlen(addressDataP->business)>0)
				{	
					[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%+10s %-22s","work" ,addressDataP->business] ];
					stringSelected[i++] = addressDataP->business;
				}	
				if(strlen(addressDataP->mobile)>0)
				{	
					[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%+10s %-22s","mobile", addressDataP->mobile] ];
					stringSelected[i++] = addressDataP->mobile;
				}	
			
			
				if(strlen(addressDataP->spoknid)>0)
				{		
					[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%+10s %-22s", "Spokn",addressDataP->spoknid] ];
					stringSelected[i++] = addressDataP->spoknid;
				}	
			
			
				if(strlen(addressDataP->other)>0)
				{	
					[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%+10s %-22s","other", addressDataP->other] ];
				
					stringSelected[i++] = addressDataP->other;
				}			
			
				if(strlen(addressDataP->email)>0)
				{	
					[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%+10s %-22s","email", addressDataP->email] ];
			
					stringSelected[i++] = addressDataP->email;
				}	
			}	
			else
			{
				for(int k=0;k<MAX_SECTION;++k)
				{	
					for(int j=0;j<sectionArray[k].count;++j)
					{	
					//	[uiActionSheetP addButtonWithTitle:[NSString stringWithFormat:@"%-8s %-15s",sectionArray[k].dataforSection[j].nameofRow, sectionArray[k].dataforSection[j].elementP] ];
					//	stringSelected[i++] = sectionArray[k].dataforSection[j].elementP;
						
						NSString *str,*str1,*str2;
						str1=[NSString stringWithFormat:@"%s",sectionArray[k].dataforSection[j].nameofRow];
						if([str1 length]>7)
						{
							str=[NSString stringWithString:[str1 substringToIndex:5]];
							str=[str stringByAppendingString:@"..."];
							str2=[NSString stringWithFormat:@"%-10s",sectionArray[k].dataforSection[j].elementP];
							str=[str stringByAppendingString:str2];
							
							//str=[str appendString:@"%-22s",sectionArray[k].dataforSection[j].elementP];
							//str = [NSString stringWithFormat:@"%s %-22s",substring , sectionArray[k].dataforSection[j].elementP] ;
						}
						else
						{	
							str = [NSString stringWithFormat:@"%+10s %-22s",sectionArray[k].dataforSection[j].nameofRow, sectionArray[k].dataforSection[j].elementP] ;
						}
						[uiActionSheetP addButtonWithTitle:str];
						stringSelected[i++] = sectionArray[k].dataforSection[j].elementP;
						
					}
				}	
			
			}

				
			
		}
		
		switch(i)
		{
			case 0://no element found
				[uiActionSheetP release];
			/*	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_NO_NUMBER_ 
																message:_NO_NUMBER_IN_CONTACT_
															   delegate:self 
													  cancelButtonTitle:nil 
													  otherButtonTitles:_OK_, nil];
				[alert show];
				[alert release];
				showAlertB = YES;*/
			
				break;
			case 1:
				if(actionSheetType)
				{
					if([self->ownerobject makeCall:stringSelected[0]]==YES)
					{	
						//[[self navigationController]  popViewControllerAnimated:YES];
					//	[self->ownerobject changeView];
						
					}	
					
				}
				else
				{
					[ownerobject vmsShowRecordOrForwardScreen:stringSelected[0] VMSState : VMSStateRecord filename:"temp" duration:0 vmail:0];
					
					
					//[ownerobject vmsShowRecordScreen:stringSelected[0]];
				}
				[uiActionSheetP release];
				break;
			default:
				[uiActionSheetP addButtonWithTitle:_CANCEL_];
				uiActionSheetP.cancelButtonIndex = i;
				stringSelected[i++] = 0;
				uiActionSheetP.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
				[uiActionSheetP showInView:[ownerobject tabBarController].view];
		}
	}
	else
	{
		if(typeInt==2)
		{	
			uiActionSheetP= [[UIActionSheet alloc] 
						 initWithTitle: @"" 
						 delegate:self
						 cancelButtonTitle:_CANCEL_ 
						 destructiveButtonTitle:_DELETE_CONTACT_
						 otherButtonTitles:nil, nil];
		}
		else
		{
			uiActionSheetP= [[UIActionSheet alloc] 
							 initWithTitle: @"" 
							 delegate:self
							 cancelButtonTitle:_CANCEL_ 
							 destructiveButtonTitle:_DELETE_CALLLOG_
							 otherButtonTitles:nil, nil];
			
		}
		uiActionSheetP.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
		if(hideCallAndVmailButtonB==NO)
		{	
			[uiActionSheetP showInView:[ownerobject tabBarController].view];
		}
		else
		{
			[uiActionSheetP showInView:self.view];
		}
	
	}
	
	
}


-(IBAction)callPressed:(id)sender
{
	[self presentSheet:1];
}
-(IBAction)vmsPressed:(id)sender
{
	[self presentSheet:0];
}
-(IBAction)deletePressed:(id)sender
{
	
	/*UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn" 
													   message: [ NSString stringWithString:_CONTACT_DELETE_ ]
													  delegate: nil
											 cancelButtonTitle: nil
											 otherButtonTitles: @"OK", nil
						  ];
	[alert addButtonWithTitle:@"Cancel"];
	[ alert show ];
	[alert release];
	*/
	[self presentSheet:2];

	
}
-(IBAction)changeNamePressed:(id)sender
{
	AddeditcellController     *AddeditcellControllerviewP;	
	AddeditcellControllerviewP = [[AddeditcellController alloc]init];
	[AddeditcellControllerviewP setObject:self->ownerobject];
	if(hideCallAndVmailButtonB)
	{
		[AddeditcellControllerviewP hideFooter];
	}
	viewResult = 0;
	
	[AddeditcellControllerviewP SetkeyBoardType:UIKeyboardTypeDefault :CONTACT_RANGE buttonType:0];
	
	if(viewEnum!=CONTACTADDVIEWENUM)
	{	
		[AddeditcellControllerviewP setData:addressDataP->title value:"Name of person" placeHolder:"First Last" title:"Edit Name" returnValue:&viewResult];
	}
	else
	{
		[AddeditcellControllerviewP setData:addressDataP->title value:"Name of person" placeHolder:"First Last" title:"Add Name" returnValue:&viewResult];
		
	}
	[ [self navigationController] pushViewController:AddeditcellControllerviewP animated: YES ];
	
	[AddeditcellControllerviewP release];
	
}
-(IBAction)cancelClicked
{
	
	
	if(viewEnum!=CONTACTADDVIEWENUM || modelViewB ==true || hideCallAndVmailButtonB==true )
	{	
		[ [self navigationController] popViewControllerAnimated:YES ];
	}	
	else
	{
		[self dismissModalViewControllerAnimated:YES];
	}
}
-(IBAction)doneClicked
{
	/*struct AddressBook *addressDataTmpP;
	self.navigationItem.rightBarButtonItem 
	= [ [ [ UIBarButtonItem alloc ]
		 initWithBarButtonSystemItem: UIBarButtonSystemItemEdit
		 target: self
		 action: @selector(editClicked) ] autorelease ];	
	addressDataTmpP = addressDataP;
	addressDataP = 0;
	[self setAddressBook:addressDataTmpP editable:false :viewEnum];
	free(addressDataTmpP);
	 */
	struct AddressBook *addrP ;
	Boolean popupB = true;
	if(updatecontact)
	{	
		
		if(viewEnum==CONTACTADDVIEWENUM)
		{	
			if(  strlen(addressDataP->title)&&(  strlen(addressDataP->mobile) ||  strlen(addressDataP->business)|| strlen(addressDataP->home)||  strlen(addressDataP->email)||  strlen(addressDataP->other) ||  strlen(addressDataP->spoknid)) )
			{										 
				#ifdef _ANALYST_
					[[GEventTracker sharedInstance] trackEvent:@"SPOKN" action:@"ADD CONTACT" label:@"ADD CONTACT"];
				#endif
				
				addContact(addressDataP->title,addressDataP->mobile,addressDataP->home,addressDataP->business,addressDataP->other,addressDataP->email,addressDataP->spoknid);
			}
			else
			{	
						
				UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle:_INVALID_CONTACT_ 
															 message: [ NSString stringWithString:_INVALID_CONTACT_MESSAGE_ ]
															 delegate: self
															 cancelButtonTitle: nil
														 otherButtonTitles: _OK_, nil];
					[ alert show ];
					
					[alert release];
					popupB = false;
					showAlertB = YES;
			}	
		}
		else
		{
			addrP = getContact(addressDataP->id);			
			if(addrP)
			{
				
				
				if(validName(addressDataP->title) && (validName(addressDataP->home) || validName(addressDataP->business) || validName(addressDataP->mobile)
														|| validName(addressDataP->spoknid)  || validName(addressDataP->email) || validName(addressDataP->other)))
				{
					strcpy(addrP->title,addressDataP->title);
					strcpy(addrP->home,addressDataP->home);
					strcpy(addrP->business,addressDataP->business);
					strcpy(addrP->mobile,addressDataP->mobile);
					strcpy(addrP->spoknid,addressDataP->spoknid);
					strcpy(addrP->email,addressDataP->email);
					strcpy(addrP->other,addressDataP->other);
					addrP->dirty = true;
				}
				else
				{
					UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: _INVALID_CONTACT_ 
																	   message: [ NSString stringWithString:_INVALID_CONTACT_MESSAGE_ ]
																	  delegate: self
															 cancelButtonTitle: nil
															 otherButtonTitles: _OK_, nil];
					[ alert show ];
					
					[alert release];
					popupB = false;
					showAlertB = YES;
				
				}
			
			}
			/*if(  !(strlen(addressDataP->title)&&(strlen(addressDataP->mobile) ||  strlen(addressDataP->business)|| strlen(addressDataP->home)||  strlen(addressDataP->email)||  strlen(addressDataP->other) ||  strlen(addressDataP->spoknid))) )
			{
				UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn" 
																   message: [ NSString stringWithString:@"invalid contact" ]
																  delegate: self
														 cancelButtonTitle: nil
														 otherButtonTitles: @"OK", nil];
				[ alert show ];
				[alert release];
				popupB = false;
				
			}	*/
			
		}
		
		if(popupB  && hideCallAndVmailButtonB==false)
			[ownerobject profileResynFromApp];
	}
	if(popupB)
	{	
		if(viewEnum!=CONTACTADDVIEWENUM || modelViewB==true || hideCallAndVmailButtonB==true)
		{	
			[ [self navigationController] popViewControllerAnimated:YES ];
			[ownerobject refreshallViews];
		}	
		else
		{
			[self dismissModalViewControllerAnimated:YES];
			[ownerobject refreshallViews];
		}
		if(retValP)
		{
			
			*retValP = 1;
		}
		[contactDetailsProtocolP setResult:1];//change in data
	}	//contactID = -1;
}


-(IBAction)deleteClicked
{
	/*struct AddressBook *addressDataTmpP;
	 self.navigationItem.rightBarButtonItem 
	 = [ [ [ UIBarButtonItem alloc ]
	 initWithBarButtonSystemItem: UIBarButtonSystemItemEdit
	 target: self
	 action: @selector(editClicked) ] autorelease ];	
	 addressDataTmpP = addressDataP;
	 addressDataP = 0;
	 [self setAddressBook:addressDataTmpP editable:false :viewEnum];
	 free(addressDataTmpP);
	 */
	/*	UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn" 
													   message: [ NSString stringWithString:_DELETE_CALL_LOG_ ]
													  delegate: self
											 cancelButtonTitle: nil
											 otherButtonTitles: @"OK", nil
						  ];
	[alert addButtonWithTitle:@"Cancel"];
	[ alert show ];
	[alert release];
	*/
	[self presentSheet:3];//call log
	//[ [self navigationController] popToRootViewControllerAnimated:YES ];
	//contactID = -1;
	//profileResync();
	
	
}
-(IBAction)editClicked
{
		
	ContactDetailsViewController     *ContactControllerDetailsviewP;	
	ContactControllerDetailsviewP = [[ContactDetailsViewController alloc] initWithNibName:@"contactDetails" bundle:[NSBundle mainBundle]];
	
	ContactControllerDetailsviewP->ownerobject = self->ownerobject;
	ContactControllerDetailsviewP->contactDetailsProtocolP = self;
	[ContactControllerDetailsviewP hideCallAndVmailButton:hideCallAndVmailButtonB];
	[ContactControllerDetailsviewP setReturnValue:0 selectedContactNumber:0  rootObject:0 selectedContact:0] ;
		
	editDataInt = 1;
	
	[ContactControllerDetailsviewP setAddressBook:addressDataP editable:true :viewEnum];
	
	[ [self navigationController] pushViewController:ContactControllerDetailsviewP animated: YES ];
	
	if([ContactControllerDetailsviewP retainCount]>1)
		[ContactControllerDetailsviewP release];
	
	
	
	
	
	
	
	/*
	struct AddressBook *addressDataTmpP;
	
	self.navigationItem.rightBarButtonItem 	= [ [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
																			target: self
																			action: @selector(doneClicked) ] autorelease ];	
	self.navigationItem.rightBarButtonItem.enabled = NO;
	addressDataTmpP = addressDataP;
	addressDataP = 0;
//	animationB = YES;
	[self setAddressBook:addressDataTmpP editable:true :viewEnum];
	free(addressDataTmpP);
	
//	animationB = NO;
	*/
	
}
#define TABLE_VIEW_TAG			2000

- (void)updateUI:(id) objectP
{
	
	if(viewResult )
	{
				
		updatecontact = 1;
		viewResult = 0;
		self.navigationItem.rightBarButtonItem.enabled = YES;
		
		struct AddressBook *addressDataTmpP=0;
		if(editDataInt)
		{
			editDataInt = 0;
			if(addressDataP)
			{	
				addressDataTmpP = getContact(addressDataP->id);
				if(addressDataTmpP)
				{
					[self setAddressBook:addressDataTmpP editable:self->editableB :viewEnum];
				}
			}
		}
		else
		{	
		
			
			if(addDataInt)
			{
				showAddButtonB = NO;
				viewP.hidden = NO;

				addDataInt =0;
				if(cdrP)
					addressDataTmpP = getContactOf(cdrP->userid);
				else
				{
					addressDataTmpP = getContactOf(self->selectNoCharP);
				}
				if(addressDataTmpP)
				{
					[self setAddressBook:addressDataTmpP editable:self->editableB :viewEnum];
				}
				
			}
			else
			{
				addressDataTmpP = addressDataP;
				addressDataP = 0;
				[self setAddressBook:addressDataTmpP editable:self->editableB :viewEnum];
				free(addressDataTmpP);

			
			}
			
		}
		[ self->tableView reloadData ];
	}
	NSIndexPath *nsP;
	nsP = [self->tableView indexPathForSelectedRow];
	if(nsP)
	{
		[self->tableView deselectRowAtIndexPath : nsP animated:NO];
	}
	
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self updateUI:nil];
		
}	
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	

}

-(void)setTitlesString:(NSString*)nsP
{
	[titlesP release];
	titlesP = [[NSString alloc] initWithString:nsP];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(menuControllerWillHide:)
												 name:UIMenuControllerWillHideMenuNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(menuControllerWillShow:)
												 name:UIMenuControllerWillShowMenuNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(menuControllerDidShow:)
												 name:UIMenuControllerDidShowMenuNotification
											   object:nil];
//	animationB = NO;
	alertgP = 0;
	[sectionViewP addSubview:userNameP];
	self->addButtonP.exclusiveTouch = YES;
	self->vmsButtonP.exclusiveTouch = YES;
	self->callButtonP.exclusiveTouch = YES;
	self->delButtonP.exclusiveTouch = YES;
	numberFound = 0;
	updatecontact = 0;
	printf("\norg %f     ",tableView.frame.origin.y);
	tableView.delegate = self;
	tableView.dataSource = self;
	sectionViewP.backgroundColor = [UIColor groupTableViewBackgroundColor];
	if([ownerobject checkForHighResolution] == NO)
	{ 
		tableView.sectionHeaderHeight = 14;//(tableView.sectionHeaderHeight+4)/2;
	}
	else {
		
		tableView.sectionHeaderHeight = 10;
		if(editableB)
		{	
			CGRect xr = tableView.frame;
			xr.origin.y-=5;
			tableView.frame = xr;
		}
	}

	tableView.sectionFooterHeight = 0;//(tableView.sectionFooterHeight+4)/2;   	
	loadedB = true;
	orignalheight = sectionViewP.frame.size.height;
	UIImage *buttonBackground;
	UIImage *buttonBackgroundPressed;
	if(hideCallAndVmailButtonB)
	{
		vmsButtonP.hidden = YES;
		callButtonP.hidden = YES;
	
	}
	if(showAddButtonB==FALSE)
	{
		CGRect recframe;
		recframe = viewP.frame;
		recframe.size.height-=59;
	}
	buttonBackground = [UIImage imageNamed:_DEL_NORMAL_PNG_];
	buttonBackgroundPressed = [UIImage imageNamed:_DEL_PRESSED_PNG_];
	[CustomButton setImages:delButtonP image:buttonBackground imagePressed:buttonBackgroundPressed change:NO];
	[buttonBackground release];
	[buttonBackgroundPressed release];
	delButtonP.backgroundColor =  [[UIColor clearColor] autorelease ];	
	tableView.backgroundColor =  [[UIColor clearColor] autorelease ];	
	/*
	UIImage *buttonBackground = [UIImage imageNamed:@"blueButton.png"];
	UIImage *buttonBackgroundPressed = [UIImage imageNamed:@"green.png"];
	[CustomButton setImages:callButtonP image:buttonBackground imagePressed:buttonBackgroundPressed];
	[buttonBackground release];
	[buttonBackgroundPressed release];
	buttonBackground = [UIImage imageNamed:@"red.png"];
	buttonBackgroundPressed = [UIImage imageNamed:@"blueButton.png"];
	[CustomButton setImages:delButtonP image:buttonBackground imagePressed:buttonBackgroundPressed];
	[buttonBackground release];
	[buttonBackgroundPressed release];
	
	buttonBackground = [UIImage imageNamed:@"orange.png"];
	buttonBackgroundPressed = [UIImage imageNamed:@"blueButton.png"];
	[CustomButton setImages:vmsButtonP image:buttonBackground imagePressed:buttonBackgroundPressed];
	[buttonBackground release];
	[buttonBackgroundPressed release];
	
	buttonBackground = [UIImage imageNamed:@"whiteButton.png"];
	buttonBackgroundPressed = [UIImage imageNamed:@"blueButton.png"];
	[CustomButton setImages:addButtonP image:buttonBackground imagePressed:buttonBackgroundPressed];
	[buttonBackground release];
	[buttonBackgroundPressed release];
	*/
	
	//[changeNameButtonP setFrame:CGRectMake(55,0,250,40)];
	//UIImage *buttonBackground;
	//UIImage *buttonBackgroundPressed;
	
	/*buttonBackground = [UIImage imageNamed:@"red.png"];
	buttonBackgroundPressed = [UIImage imageNamed:@"blueButton.png"];
	[CustomButton setImages:delButtonP image:buttonBackground imagePressed:buttonBackgroundPressed change:YES];
	[buttonBackground release];
	[buttonBackgroundPressed release];
	*/
	//tableView.tag = TABLE_VIEW_TAG;
	if(self.navigationItem.rightBarButtonItem==nil)
	{	
		if(viewEnum==CONTACTDETAILVIEWENUM ||viewEnum == CONTACTPHONEADDRESSBOOKDETAIL)
		{	
			if(editableB==false && viewEnum==CONTACTDETAILVIEWENUM )
			{	
				self.navigationItem.rightBarButtonItem 
				= [ [ [ UIBarButtonItem alloc ]
				 initWithBarButtonSystemItem: UIBarButtonSystemItemEdit
				 target: self
				 action: @selector(editClicked) ] autorelease ];
				//self.navigationItem.rightBarButtonItem.enabled = NO;
			}
			else
			{
				if(viewEnum != CONTACTPHONEADDRESSBOOKDETAIL)
				{	
					self.navigationItem.rightBarButtonItem 
					= [ [ [ UIBarButtonItem alloc ]
						 initWithBarButtonSystemItem: UIBarButtonSystemItemDone
						 target: self
						 action: @selector(doneClicked) ] autorelease ];
					self.navigationItem.rightBarButtonItem.enabled = NO;
				}	
			}
		}
		else
		{	
			if(viewEnum==CALLLOGDETAILVIEWENUM)
			{	
				deleteButton = [[UIButton alloc] init];
				// The default size for the save button is 49x30 pixels
				deleteButton.frame = CGRectMake(0, 0, 50, 30.0);
				
				// Center the text vertically and horizontally
				deleteButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
				deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
				
				UIImage *buttonBackground;
				UIImage *buttonBackgroundPressed;
				
				
				buttonBackground = [UIImage imageNamed:_TAB_DEL_NORMAL_PNG_];
				buttonBackgroundPressed = [UIImage imageNamed:_TAB_DEL_PRESSED_PNG_];
				[CustomButton setImages:deleteButton image:buttonBackground imagePressed:buttonBackgroundPressed change:NO];
				[buttonBackground release];
				[buttonBackgroundPressed release];
				deleteButton.backgroundColor =  [UIColor clearColor];	
					
				
				//[deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
				
				[deleteButton addTarget:self action:@selector(deleteClicked) forControlEvents:UIControlEventTouchUpInside];
				
				UIBarButtonItem *navButton = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
				
				self.navigationItem.rightBarButtonItem = navButton;
				//self.navigationItem.rightBarButtonItem.enabled = NO;
				
				[navButton release];
				[deleteButton release];
				
				//self.navigationItem.rightBarButtonItem = [ [ [ UIBarButtonItem alloc ] initWithTitle:@"Delete" style:UIBarButtonItemStyleDone target:self action:@selector(deleteClicked)] autorelease];
				struct tm tmP1,*tmP=0;
				time_t timeP;
				char *month[12]={"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
				
				//char *month[12]={"January","February","March","April","May","June","July","August","September","October","November","December"};
				
				
				
				CGRect LabelFrame2 = CGRectMake(0, 45, 320, 40);
				CGRect viewFrame;
				msgLabelP = [[UILabel alloc] initWithFrame:LabelFrame2];
				msgLabelP.textAlignment = UITextAlignmentLeft;
				msgLabelP.tag = 1;
				msgLabelP.numberOfLines = 2;
				msgLabelP.backgroundColor = [[UIColor clearColor] autorelease];
				//viewP.backgroundColor = [UIColor groupTableViewBackgroundColor];
				[sectionViewP insertSubview: msgLabelP belowSubview:userNameP ];
				viewFrame = sectionViewP.frame;
				viewFrame.size.height+=LabelFrame2.size.height+10;
				sectionViewP.frame = viewFrame;
				orignalheight = sectionViewP.frame.size.height;
				
				//[msgLabelP release];
				
				char s1[200];
				if(cdrP)
				{	
					timeP = cdrP->date;
					tmP = localtime(&timeP);
					tmP1 = *tmP;
					
					if(tmP1.tm_hour<12)
					{	
						sprintf(s1,"   %02d:%02d AM on %02d %3s %d",(tmP1.tm_hour)?tmP1.tm_hour:12,tmP1.tm_min,tmP1.tm_mday,month[tmP1.tm_mon],tmP1.tm_year+1900);
					}
					else
					{	
						sprintf(s1,"   %02d:%02d PM on %02d %3s %d",(tmP1.tm_hour-12)?(tmP1.tm_hour-12):12,tmP1.tm_min,tmP1.tm_mday,month[tmP1.tm_mon],tmP1.tm_year+1900);
					}
					if(cdrP->direction&CALLTYPE_IN)
					{	
						if(cdrP->direction&CALLTYPE_MISSED)
						{	
							[msgLabelP setText:[NSString stringWithFormat:@"   Incoming call\n%s", s1]];
						}	
						else
						{
							[msgLabelP setText:[NSString stringWithFormat:@"   Incoming call\n%s", s1]];
						}
					}
					else
					{
						[msgLabelP setText:[NSString stringWithFormat:@"   Outgoing call\n%s", s1]];
					}
					
				}	
				
			}
			else
			{
				self.navigationItem.rightBarButtonItem 
				= [ [ [ UIBarButtonItem alloc ]
					 initWithBarButtonSystemItem: UIBarButtonSystemItemDone
					 target: self
					 action: @selector(doneClicked) ] autorelease ];
				self.navigationItem.rightBarButtonItem.enabled = NO;
			/*	if(viewEnum!=CONTACTFORWARDVMS)
				{	
					self.navigationItem.leftBarButtonItem = [ [ [ UIBarButtonItem alloc ]
														   initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
														   target: self
														   action: @selector(cancelClicked) ] autorelease ];	
				}	*/
			}	
		}	
		
		
	}	
	/*self.navigationItem.leftBarButtonItem = [ [ [ UIBarButtonItem alloc ]
											   initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
											   target: self
											   action: @selector(cancelClicked) ] autorelease ];	*/
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	viewP.backgroundColor = [[UIColor clearColor] autorelease];
	if(viewEnum==CONTACTADDVIEWENUM)
	{
		self.title = @"New Contact";
	}
	if(viewEnum==CONTACTADDVIEWENUM || viewEnum == CONTACTFORWARDVMS)
	{
		viewP.hidden = !showAddButtonB;
		
		tableView.tableFooterView = viewP;
		//[viewP release];
		if(viewEnum == CONTACTFORWARDVMS)
		{
			[self setTitle:titlesP ];
		}

	}
	else
	{
		tableView.tableFooterView = viewP;
		//[viewP release];
		if(viewEnum == CONTACTDETAILFROMVMS)
		{
			[self setTitle:titlesP ];
		}
		
		

	}
	struct AddressBook *addressDataTmpP;
	
	
	addressDataTmpP = addressDataP;
	addressDataP = 0;
	
	[self setAddressBook:addressDataTmpP editable:self->editableB :viewEnum];
	free(addressDataTmpP);
	
	[ self->tableView reloadData ];
	
	/*
	NSString *nsp;
	nsp = [[NSString alloc] initWithUTF8String:(const char*)addressDataP->title ];
	[userNameP setText:nsp];
	[nsp release];
	//[userNameP release];
	[self setTitle:@"Info"];
	
	
	if(editableB)
	{	
		[ self->tableView setEditing: YES animated: YES ];
		self->tableView.allowsSelectionDuringEditing = YES;
		self->delButtonP.hidden = NO;
		self->vmsButtonP.hidden = YES;
		self->callButtonP.hidden = YES;
		changeNameButtonP.hidden = NO;
		if([[userNameP text] length]==0)
		{
			[userNameP setTextColor:[UIColor grayColor]];
			[userNameP setText:@"First Last"];
		}
		else
		{
			[userNameP setTextColor:[UIColor blackColor]];
		}
		userNameP.hidden = YES;
		//	[changeNameButtonP addSubview:userNameP];
		//[userNameP release];
		//setTitle:(NSString *)title forState:(UIControlState)state
		[changeNameButtonP setTitle:userNameP.text forState:UIControlStateNormal];
		tableView.tableHeaderView = changeNameButtonP;
		
	}	
	else
	{
		self->delButtonP.hidden = YES;
		self->vmsButtonP.hidden = NO;
		self->callButtonP.hidden = NO;
		changeNameButtonP.hidden = YES;
		tableView.tableHeaderView = userNameP;
		
	}
*/	
	//[tableView reloadData];

}
// Add a title for each section 


#pragma mark Table view methods
/*
-(void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	SpoknUITableViewCell *cell = (SpoknUITableViewCell*)[ self->tableView cellForRowAtIndexPath: indexPath ];
	[cell tablecellsetEdit:YES];
		
}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	SpoknUITableViewCell *cell = (SpoknUITableViewCell*)[ self->tableView cellForRowAtIndexPath: indexPath ];
	[cell tablecellsetEdit:NO];
	
}
 */

/*
 *   Table Data Source
 */
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

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int row = [indexPath row];
	int section = [indexPath section];
	sectionType *secLocP;
	char*tmpCellP =0;
	if(sectionArray[section].dataforSection[row].customViewP)
	{
		tmpCellP = "any-cell";
	}
	else
	{
		tmpCellP = "any-cell1";
	}
	
	NSString *CellIdentifier = [[NSString alloc] initWithUTF8String:tmpCellP];
	
	SpoknUITableViewCell *cell = (SpoknUITableViewCell *) [ tableView dequeueReusableCellWithIdentifier: CellIdentifier ];
	if (cell == nil) {
		
		//	secLocP = [self->cellofvmsP getObjectAtIndex: [ indexPath indexAtPosition: 1 ]];
		//	if(secLocP)
		{	
			
			if(sectionArray[section].dataforSection[row].customViewP)
			{
			
				#ifdef __IPHONE_3_0
								
					cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				#else
					cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];

				#endif
				
								
				[cell.contentView addSubview:sectionArray[section].dataforSection[row].customViewP];
				//[sectionArray[section].dataforSection[row].customViewP release];
				[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			}
			else
			{	
				CGRect cellRect = CGRectMake(0, 0, 320, 50);
				cell = [ [ [ SpoknUITableViewCell alloc ] initWithCustomFrame: cellRect reuseIdentifier: CellIdentifier ] autorelease] ;
				//cell->resusableCount = [ indexPath indexAtPosition: 1 ];
				[self addRow:section :row sectionObject:&secLocP];
				[cell setAutoResize:YES];
			}	
			
		}	
	}	
	else
	{	
		if(sectionArray[section].dataforSection[row].customViewP==0)
		{	
			secLocP = cell.spoknSubCellP.userData;
			[secLocP release];
		
			[self addRow:section :row sectionObject:&secLocP];
		//secLocP = [self->cellofvmsP getObjectAtIndex: [ indexPath indexAtPosition: 1 ]];
		}	
	}
	if(sectionArray[section].dataforSection[row].customViewP==0)
	{	
		if(secLocP)
		{	
			cell.spoknSubCellP.userData = secLocP;
			cell.spoknSubCellP.dataArrayP = secLocP->elementP;
		}
		else
		{
			cell.spoknSubCellP.userData = 0;
			cell.spoknSubCellP.dataArrayP = 0;
			
		}
		
		cell.spoknSubCellP.ownerDrawB = true;
		cell.spoknSubCellP.rowHeight = MAX_ROW_HIGHT;
		[cell.spoknSubCellP setNeedsDisplay];
		if(editableB)
		{
			//	cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;//UITableViewCellAccessoryDetailDisclosureButton; 
			//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			//cell.hidesAccessoryWhenEditing = NO;
			//cell.accessoryType = UITableViewCellAccessoryNone;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		else
		{
			cell.accessoryType = UITableViewCellAccessoryNone;
			//cell.editingAccessoryType = UITableViewCellAccessoryNone;//UITableViewCellAccessoryDetailDisclosureButton; 
			
		}
	}
	else
	{
			cell.accessoryType = UITableViewCellAccessoryNone;
	}
	cell.delegate = self;
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	[CellIdentifier release];
	//cell.hidesAccessoryWhenEditing = YES;
	return cell;
	
	
}
-(void)tableView:(UITableView *)ltableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	int row = [indexPath row];
	int section = [indexPath section];
	
	// If row is deleted, remove it from the list.
	if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
		//sectionArray[section].count--;
		if(sectionArray[section].dataforSection[row].elementP)
		{
			strcpy(sectionArray[section].dataforSection[row].elementP,"\0");//mean row is deleted
			updatecontact = 1;
			if(row==0 && section==0)
			{
				noNameB = true;
			}
		}
		self.navigationItem.rightBarButtonItem.enabled = YES;
		// [dataController removeDataAtIndex:indexPath.row-1];
	//	[ltableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
		//				  withRowAnimation:UITableViewRowAnimationFade];
		[tableView reloadData]; 
	}
	else if(editingStyle == UITableViewCellEditingStyleInsert)
	{
		//  [dataController addData:@"New Row Added"];
		// [tableView reloadData];        
	}
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:
(NSIndexPath *)indexPath
{
	int row = [indexPath row];
	int section = [indexPath section];
	if(editableB)
	{	
		if(sectionArray[section].dataforSection[row].addNewB)
		{
			return UITableViewCellEditingStyleInsert;
		}
		else
		{
			return UITableViewCellEditingStyleDelete;
		}
	}	
	
	return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
	
	if (showingEditMenu) {
		return;
	}
	
	int row = [newIndexPath row];
	int section = [newIndexPath section];

	if(hideCallAndVmailButtonB && editableB==false)//dont to any thing
	{
		[self->tableView deselectRowAtIndexPath : newIndexPath animated:YES];
		
		if(addcallDelegate)
		{	
			if(sectionArray[section].dataforSection[row].elementP)
			{	
				if(strstr( sectionArray[section].dataforSection[row].elementP,"@")==0)
				{	
					[addcallDelegate makeCall:sectionArray[section].dataforSection[row].elementP];
					[self->tableView deselectRowAtIndexPath : newIndexPath animated:YES];
				
				}
			}
			return;
		}	
	}
	
	//selection = [[[UIFont familyNames] objectAtIndex:[newIndexPath row]] retain];
		
	if(editableB==false)
	{	
		if(viewEnum == CONTACTFORWARDVMS)
		{
			
			if(retValP)
			{
				*retValP = 1;
				if(numberCharP)
				{	
					strcpy(numberCharP,sectionArray[section].dataforSection[row].elementP);
				}	
				if(selectContactP)
				{
					strcpy(selectContactP->nameChar,addressDataP->title);
					strcpy(selectContactP->number,sectionArray[section].dataforSection[row].elementP);
					
					strcpy(selectContactP->type,sectionArray[section].dataforSection[row].nameofRow);
				
				}
				if(self->rootObjectP)
				{
					[[self navigationController]  popToViewController:self->rootObjectP animated:YES];
				}
			}
			return;
		}
		
		if(strstr( sectionArray[section].dataforSection[row].elementP,"@")==0)
		{	
			SetAddressBookDetails(ownerobject.ltpInterfacesP,addressID,recordID);
			if([self->ownerobject makeCall:sectionArray[section].dataforSection[row].elementP]==YES)
			{	
				[self->ownerobject changeView];
			}
			else
			{
				NSIndexPath *nsP;
				nsP = [self->tableView indexPathForSelectedRow];
				if(nsP)
				{
					[self->tableView deselectRowAtIndexPath : nsP animated:NO];
				}
			}
		}	
		else
		{
			[ownerobject vmsShowRecordOrForwardScreen:sectionArray[section].dataforSection[row].elementP VMSState : VMSStateRecord filename:"temp" duration:0 vmail:0];
			
			//[ownerobject vmsShowRecordScreen:sectionArray[section].dataforSection[row].elementP];
		}
	}	
	else
	{
		if(strcmp(sectionArray[section].dataforSection[row].placeholder,"FirstLast")==0)
		{
			return [self changeNamePressed:nil];
		}
		
		
		
		AddeditcellController     *AddeditcellControllerviewP;	
		AddeditcellControllerviewP = [[AddeditcellController alloc]init];
		[AddeditcellControllerviewP setObject:self->ownerobject];
		if(hideCallAndVmailButtonB)
		{
			[AddeditcellControllerviewP hideFooter];
		}
		viewResult = 0;
		if(section==2)
		{
			[AddeditcellControllerviewP SetkeyBoardType:UIKeyboardTypeEmailAddress :EMAIL_RANGE buttonType:0];
		}
		else
		{
			if(sectionArray[section].dataforSection[row].elementP == addressDataP->spoknid)
			{
				[AddeditcellControllerviewP SetkeyBoardType:UIKeyboardTypePhonePad :NUMBER_RANGE buttonType:0];
			}
			else
			{
				[AddeditcellControllerviewP SetkeyBoardType:UIKeyboardTypePhonePad :NUMBER_RANGE buttonType:0];
				
				
			}
			
		}
		if(viewEnum!=CONTACTADDVIEWENUM)
		{	
			char titleChar[80];
			sprintf(titleChar,"Edit %s",sectionArray[section].dataforSection[row].placeholder);
			[AddeditcellControllerviewP setData:sectionArray[section].dataforSection[row].elementP value:sectionArray[section].dataforSection[row].nameofRow placeHolder:sectionArray[section].dataforSection[row].placeholder  title:titleChar returnValue:&viewResult];
		}
		else
		{
			char titleChar[80];
			sprintf(titleChar,"Add %s",sectionArray[section].dataforSection[row].placeholder);
			
			[AddeditcellControllerviewP setData:sectionArray[section].dataforSection[row].elementP value:sectionArray[section].dataforSection[row].nameofRow placeHolder:sectionArray[section].dataforSection[row].placeholder title:titleChar returnValue:&viewResult];
			
		}
		[ [self navigationController] pushViewController:AddeditcellControllerviewP animated: YES ];
		[AddeditcellControllerviewP release];
		
	}
}




- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section 
{ 
	return nil;
} 
/*
 - (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView 
 { 
 return ALPHA_ARRAY; 
 
 } 
 */


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

	
	if(sectionCount)
	return  sectionCount;
	return 1;
}
- (CGFloat)tableView:(UITableView *)ltableView heightForHeaderInSection:(NSInteger)section{
	
	//printf("\nheight %d",sectionArray[section].sectionheight);
	return sectionArray[section].sectionheight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	return sectionArray[section].sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	
	return sectionArray[section].count;
	
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int row = [indexPath row];
	int section = [indexPath section];
	if(sectionArray[section].dataforSection[row].rowHeight)
	{
		return sectionArray[section].dataforSection[row].rowHeight;
	
	}
	
	
	return MAX_ROW_HIGHT;
	
}
-(void)setCdr:(struct CDR *)lcdrP
{
	if(self->cdrP)
	{
		free(self->cdrP);
	}
	self->cdrP = 0;
	if(lcdrP)
	{	
		self->cdrP = (struct CDR *)malloc(sizeof(struct CDR )+4);
		*self->cdrP=*lcdrP;
		//[ContactControllerDetailsviewP setSelectedNumber:numberCharP showAddButton:NO ];
		[self setSelectedNumber:self->cdrP->title showAddButton:NO];
		
		
	}	
}
-(IBAction)addContactPressed:(id)sender
{

	
	
	ContactDetailsViewController     *ContactControllerDetailsviewP;	
	ContactControllerDetailsviewP = [[ContactDetailsViewController alloc] initWithNibName:@"contactDetails" bundle:[NSBundle mainBundle]];
	[ContactControllerDetailsviewP hideCallAndVmailButton:hideCallAndVmailButtonB];
	[ContactControllerDetailsviewP setObject:self->ownerobject];
	char x = addressDataP->title[0];
	addressDataP->title[0] = 0;
	[ContactControllerDetailsviewP setReturnValue:0 selectedContactNumber:0  rootObject:0 selectedContact:0] ;
	[ContactControllerDetailsviewP setSelectedNumber:self->selectNoCharP showAddButton:NO];
	[ContactControllerDetailsviewP setCdr:self->cdrP];
	[ContactControllerDetailsviewP setAddressBook:addressDataP editable:true :CONTACTADDVIEWENUM];
	
	[ContactControllerDetailsviewP hideCallAndVmailButton:hideCallAndVmailButtonB];
	ContactControllerDetailsviewP->contactDetailsProtocolP = self;
	
	addressDataP->title[0] = x;
	UINavigationController *tmpCtl;
	tmpCtl = [[ [ UINavigationController alloc ] initWithRootViewController: ContactControllerDetailsviewP ] autorelease];
		//[tmpCtl release];
		
		//[ [self navigationController] pushViewController:ContactControllerDetailsviewP animated: YES ];
	addDataInt = 1;	
	[ownerobject.tabBarController presentModalViewController:tmpCtl animated:YES];
	return;
	
		
}
-(void)setSelectedNumber:(char*)noCharP showAddButton:(BOOL)lshowB;
{
	strcpy(self->selectNoCharP,noCharP);
	showAddButtonB = lshowB;
	
	
}
-(void) addContactDetails:(SelectedContctType *)lcontactdataP
{
	char *normalizeNoCharP=0;
	char *tempCharP = 0;
	if(strstr(lcontactdataP->number,"@")==0)
	{	
		if(firstSecCount<MAX_COUNT)
		{	
			sectionArray[0].dataforSection[firstSecCount].contactdataP = malloc(sizeof(SelectedContctType));
			*sectionArray[0].dataforSection[firstSecCount].contactdataP = *lcontactdataP;
		
			
			sectionArray[0].dataforSection[firstSecCount].section = 0;
			strcpy(sectionArray[0].dataforSection[firstSecCount].nameofRow,lcontactdataP->type);
			strcpy(sectionArray[0].dataforSection[firstSecCount].placeholder,"Phone");
			sectionArray[0].dataforSection[firstSecCount].elementP = sectionArray[0].dataforSection[firstSecCount].contactdataP->number;
			normalizeNoCharP = NormalizeNumber(sectionArray[0].dataforSection[firstSecCount].elementP,0);
			//printf("\n%s %s",normalizeNoCharP,selectNoCharP);
			if(*normalizeNoCharP=='+' && *selectNoCharP!='+')
			{
				tempCharP = normalizeNoCharP + 1;
			}
			else
			{
				tempCharP = normalizeNoCharP;
			}
			if(!strcmp(selectNoCharP,tempCharP ))
			{
				sectionArray[0].dataforSection[firstSecCount].selected = 1;
			}
			sectionArray[0].count++;
			firstSecCount++;
			if(normalizeNoCharP)
			{	
				free(normalizeNoCharP);
				normalizeNoCharP = 0;
			}
		}	
		
	}
	else
	{
		if(secondSecCount<MAX_COUNT)
		{	
			sectionArray[1].dataforSection[secondSecCount].contactdataP = malloc(sizeof(SelectedContctType));
			*sectionArray[1].dataforSection[secondSecCount].contactdataP = *lcontactdataP;
		
			sectionArray[1].dataforSection[secondSecCount].section = 1;
			strcpy(sectionArray[1].dataforSection[secondSecCount].nameofRow,lcontactdataP->type);
			strcpy(sectionArray[0].dataforSection[firstSecCount].placeholder,"Email");
			sectionArray[1].dataforSection[secondSecCount].elementP = sectionArray[1].dataforSection[secondSecCount].contactdataP->number;
			if(!strcmp(selectNoCharP,sectionArray[1].dataforSection[secondSecCount].elementP ))
			{
				sectionArray[1].dataforSection[secondSecCount].selected = 1;
			}
			sectionArray[1].count++;
		
			secondSecCount++;
		}	
		
		
	}
}
-(void)setAddressBook:( struct AddressBook *)laddressDataP editable:(Boolean)leditableB :(ViewTypeEnum) lviewEnum
{
	NSString *nsp;
	if(addressDataP)
	{	
		free(addressDataP);
		addressDataP = 0;
	}	
	self->viewEnum = lviewEnum;
	self->editableB = leditableB;
	
	self->tablesz = 0;
	addressDataP = 0;
	if(leditableB)
	{
		sectionViewP.hidden = YES;
	}
	else
	{
		sectionViewP.hidden = NO;
	}
	if(firstSecCount==0 && secondSecCount==0)
	{	
		
		for(int i=0;i<MAX_SECTION;++i)
		{
			memset(&sectionArray[i],0,sizeof(SectionContactType));
			
		}
		
		sectionCount = 0;
		addressDataP = malloc(sizeof(struct AddressBook)+4);//extra 4 for padding
		memset(addressDataP,0,sizeof(struct AddressBook));
		if(laddressDataP)
		{
			*addressDataP=*laddressDataP;
			
		}
		
		if(leditableB)
		{
			sectionArray[sectionCount].dataforSection[0].section = 0;
			strcpy(sectionArray[sectionCount].dataforSection[0].nameofRow,"");
			strcpy(sectionArray[sectionCount].dataforSection[0].placeholder,"FirstLast");
			sectionArray[sectionCount].dataforSection[0].elementP = addressDataP->title;
			sectionArray[sectionCount].dataforSection[0].rowHeight = 50;
			sectionArray[sectionCount].count++;
			sectionCount++;
			sectionArray[sectionCount].sectionView = sectionViewP;
			sectionArray[sectionCount].sectionheight = tableView.sectionHeaderHeight;//+tableView.sectionFooterHeight;
			
		}
		else
		{
			sectionArray[sectionCount].sectionView = sectionViewP;
			sectionArray[sectionCount].sectionheight = orignalheight+7;//+tableView.sectionHeaderHeight;//+tableView.sectionFooterHeight;
			
		}
		
		
		
		//sectionArray[sectionCount] = 1;
		
		if(strlen(addressDataP->home)>0)
		{
			//if(self->cdrP)
				if(!strcmp(selectNoCharP,addressDataP->home ))
				{
					sectionArray[sectionCount].dataforSection[tablesz].selected = 1;
				}
			//element[tablesz++] = addressDataP->home;
			sectionArray[sectionCount].dataforSection[tablesz].section = 0;
			strcpy(sectionArray[sectionCount].dataforSection[tablesz].nameofRow,"home");
			strcpy(sectionArray[sectionCount].dataforSection[tablesz].placeholder,"Phone");
			sectionArray[sectionCount].dataforSection[tablesz].elementP = addressDataP->home;
			sectionArray[sectionCount].count++;
			tablesz++;
		}
		else
		{
			if(leditableB)
			{
				sectionArray[sectionCount].dataforSection[tablesz].section = 0;
				strcpy(sectionArray[sectionCount].dataforSection[tablesz].nameofRow,"home");
				strcpy(sectionArray[sectionCount].dataforSection[tablesz].placeholder,"Phone");
				sectionArray[sectionCount].dataforSection[tablesz].elementP = addressDataP->home;
				sectionArray[sectionCount].count++;
				sectionArray[sectionCount].dataforSection[tablesz].addNewB = true;
				tablesz++;
					
					
			}
		}
		if(strlen(addressDataP->business)>0)
		{
			//if(self->cdrP)
				if(!strcmp(selectNoCharP,addressDataP->business ))
				{
					sectionArray[sectionCount].dataforSection[tablesz].selected = 1;
				}
			//element[tablesz++] = addressDataP->business;
			sectionArray[sectionCount].dataforSection[tablesz].section = 0;
			strcpy(sectionArray[sectionCount].dataforSection[tablesz].nameofRow,"work");
			strcpy(sectionArray[sectionCount].dataforSection[tablesz].placeholder,"Phone");
			sectionArray[sectionCount].dataforSection[tablesz].elementP = addressDataP->business;
			sectionArray[sectionCount].count++;
			tablesz++;
			
		}
		else
		{
			if(leditableB)
			{
				sectionArray[sectionCount].dataforSection[tablesz].section = 0;
				strcpy(sectionArray[sectionCount].dataforSection[tablesz].nameofRow,"work");
				strcpy(sectionArray[sectionCount].dataforSection[tablesz].placeholder,"Phone");
				sectionArray[sectionCount].dataforSection[tablesz].elementP = addressDataP->business;
				sectionArray[sectionCount].count++;
				sectionArray[sectionCount].dataforSection[tablesz].addNewB = true;
					tablesz++;
				
			}
		}
		if(strlen(addressDataP->mobile)>0)
		{
			//if(self->cdrP)
				if(!strcmp(selectNoCharP,addressDataP->mobile ))
				{
					sectionArray[sectionCount].dataforSection[tablesz].selected = 1;
				}
			//element[tablesz++] = addressDataP->mobile;
			sectionArray[sectionCount].dataforSection[tablesz].section = 0;
			strcpy(sectionArray[sectionCount].dataforSection[tablesz].nameofRow,"mobile");
			strcpy(sectionArray[sectionCount].dataforSection[tablesz].placeholder,"Phone");
			sectionArray[sectionCount].dataforSection[tablesz].elementP = addressDataP->mobile;
			sectionArray[sectionCount].count++;
			
			tablesz++;
		}
		else
		{
			if(leditableB)
			{
				sectionArray[sectionCount].dataforSection[tablesz].section = 0;
				strcpy(sectionArray[sectionCount].dataforSection[tablesz].nameofRow,"mobile");
				strcpy(sectionArray[sectionCount].dataforSection[tablesz].placeholder,"Phone");
				sectionArray[sectionCount].dataforSection[tablesz].elementP = addressDataP->mobile;
				sectionArray[sectionCount].count++;
				sectionArray[sectionCount].dataforSection[tablesz].addNewB = true;
					tablesz++;
				
			}
		}
		/*
		if(strlen(addressDataP->other)>0)
		{
			//if(self->cdrP)
				if(!strcmp(selectNoCharP,addressDataP->other ))
				{
					sectionArray[sectionCount].dataforSection[tablesz].selected = 1;
				}
			//element[tablesz++] = addressDataP->other;
			sectionArray[sectionCount].dataforSection[tablesz].section = 0;
			strcpy(sectionArray[sectionCount].dataforSection[tablesz].nameofRow,"Other");
			sectionArray[sectionCount].dataforSection[tablesz].elementP = addressDataP->other;
			sectionArray[sectionCount].count++;
			tablesz++;
		}
		else
		{
			if(leditableB)
			{
				sectionArray[sectionCount].dataforSection[tablesz].section = 0;
				strcpy(sectionArray[sectionCount].dataforSection[tablesz].nameofRow,"Other");
				sectionArray[sectionCount].dataforSection[tablesz].elementP = addressDataP->other;
				sectionArray[sectionCount].count++;
				sectionArray[sectionCount].dataforSection[tablesz].addNewB = true;
				tablesz++;
			
			}
		}*/
		if(strlen(addressDataP->spoknid)>0)
		{
			//element[tablesz++] = addressDataP->spoknid;
			//if(self->cdrP)
			if(!strcmp(selectNoCharP,addressDataP->spoknid ))
			{
				sectionArray[sectionCount].dataforSection[tablesz].selected = 1;
			}
			sectionArray[sectionCount].dataforSection[tablesz].section = 0;
			strcpy(sectionArray[sectionCount].dataforSection[tablesz].nameofRow,"spokn");
			strcpy(sectionArray[sectionCount].dataforSection[tablesz].placeholder,"Phone");
			sectionArray[sectionCount].dataforSection[tablesz].elementP = addressDataP->spoknid;
			sectionArray[sectionCount].count++;
			tablesz++;
			
		}
		else
		{
			if(leditableB)
			{
				sectionArray[sectionCount].dataforSection[tablesz].section = 0;
				strcpy(sectionArray[sectionCount].dataforSection[tablesz].nameofRow,"spokn");
				strcpy(sectionArray[sectionCount].dataforSection[tablesz].placeholder,"Phone");
				sectionArray[sectionCount].dataforSection[tablesz].elementP = addressDataP->spoknid;
				sectionArray[sectionCount].count++;
				sectionArray[sectionCount].dataforSection[tablesz].addNewB = true;
				tablesz++;
				
			}
		}
		if(tablesz==0)
		{
			sectionCount = 0;
			
		}
		else
		{
			sectionCount++;
		}
		if(strlen(addressDataP->email)>0)
		{
			//element[tablesz++] = addressDataP->email;
			if(!strcmp(selectNoCharP,addressDataP->email ))
			{
				sectionArray[sectionCount].dataforSection[0].selected = 1;
			}
			sectionArray[sectionCount].dataforSection[0].section = 0;
			strcpy(sectionArray[sectionCount].dataforSection[0].nameofRow,"email");
			strcpy(sectionArray[sectionCount].dataforSection[0].placeholder,"Email");
			sectionArray[sectionCount].dataforSection[0].elementP = addressDataP->email;
			sectionArray[sectionCount].count++;
			//tablesz++;
			sectionCount++;
		}
		else
		{
			if(sectionCount==0)
			{
				sectionCount = 1;
			}
			if(leditableB)
			{
				
				sectionArray[sectionCount].dataforSection[0].section = 0;
				strcpy(sectionArray[sectionCount].dataforSection[0].nameofRow,"email");
				strcpy(sectionArray[sectionCount].dataforSection[0].placeholder,"Email");
				sectionArray[sectionCount].dataforSection[0].elementP = addressDataP->email;
				sectionArray[sectionCount].count++;
				sectionArray[sectionCount].dataforSection[0].addNewB = true;
				sectionCount++;
			}
		}
		if(sectionCount==0)
		{
			editableB = true;
		}
		else
		{
			if(tablesz==0) //need to display table
				tablesz = 1;
		}
	}
	else
	{
		sectionCount = 0;
		sectionArray[sectionCount].sectionView = sectionViewP;
		sectionArray[sectionCount].sectionheight = orignalheight+tableView.sectionHeaderHeight,tableView.sectionFooterHeight;
		if(laddressDataP)
		{	
			addressDataP = malloc(sizeof(struct AddressBook)+4);//extra 4 for padding
			memset(addressDataP,0,sizeof(struct AddressBook));
			if(laddressDataP)
			{
				*addressDataP=*laddressDataP;
			
			}
		}	
		if(firstSecCount)
		{
			sectionCount++;
		}
		if(secondSecCount)
		{
			sectionCount++;
			if(firstSecCount==0) //mean we need to transfer contant of section two to one
			{
				sectionArray[0] = sectionArray[1];
				firstSecCount = secondSecCount;
				secondSecCount = 0;
				memset(&sectionArray[1],0,sizeof(SectionContactType));
				
			}
		}
		tablesz = 1;
	}
		
	
	if(loadedB)
	{
		
		[self hideOrShowVmsCallButton];
		nsp = [[NSString alloc] initWithFormat:@"  %s",(const char*)addressDataP->title ];
		
		
		[userNameP setText:nsp];
		[nsp release];
		if(tablesz)
		{
			
			
			if(editableB)
			{	
				NSString *userNameStrP;
				self->tableView.allowsSelectionDuringEditing = YES;
				self->delButtonP.hidden = NO;
				self->vmsButtonP.hidden = YES;
				self->callButtonP.hidden = YES;
				self->addButtonP.hidden = !showAddButtonB;
				//changeNameButtonP.hidden = NO;
				userNameStrP = [userNameP.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
				if([userNameStrP length]==0 )//space added in number
				{
				//	[userNameP setTextColor:[UIColor grayColor]];
					[userNameP setText:@"    First Last"];
					noNameB = true;
				}
				else
				{
					noNameB = false;
					NSString *nsP;
					nsP = [[NSString alloc]initWithFormat:@"   %@",userNameP.text];
					[userNameP setText:nsP];
					[nsP release];
					//[userNameP setTextColor:[UIColor blackColor]];
				}
				userNameP.hidden = YES;
			//	[changeNameButtonP addSubview:userNameP];
				//[userNameP release];
				//setTitle:(NSString *)title forState:(UIControlState)state
				/*if(noNameB)
				{
					[changeNameButtonP setTitleColor:[[UIColor lightGrayColor] autorelease] forState:UIControlStateNormal];
				}
				else
				{
					[changeNameButtonP setTitleColor:[[UIColor blackColor] autorelease] forState:UIControlStateNormal];
					
				}*/
				//[changeNameButtonP setTitle:userNameP.text forState:UIControlStateNormal];
				//tableView.tableHeaderView = changeNameButtonP;
				//[changeNameButtonP release];
				tableView.tableHeaderView = nil;
				//if(viewEnum!=CONTACTADDVIEWENUM)
				{
					self.navigationItem.leftBarButtonItem = [ [ [ UIBarButtonItem alloc ]
														   initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
														   target: self
														   action: @selector(cancelClicked) ] autorelease ];	
				}	
						
			}	
			else
			{
				self->delButtonP.hidden = YES;
				if(hideCallAndVmailButtonB)
				{
					vmsButtonP.hidden = YES;
					callButtonP.hidden = YES;
					
					
				}
				else
				{	
					self->vmsButtonP.hidden = NO;
					self->callButtonP.hidden = NO;
				}	
				//changeNameButtonP.hidden = YES;
				self->addButtonP.hidden = !showAddButtonB;
			//	tableView.tableHeaderView = userNameP;
			//	[userNameP release];
				if(CONTACTPHONEDETAIL==viewEnum)
				{
					self.navigationItem.rightBarButtonItem = nil;
				}
				if(CONTACTFORWARDVMS == viewEnum || viewEnum == CONTACTDETAILFROMVMS)
				{
					self.navigationItem.rightBarButtonItem = nil;

				}
							
			}
			if(tableView)
			{	
		/*		if(animationB)
				{
					tableView.transform = CGAffineTransformMakeScale(0.5,0.5);
					[UIView beginAnimations:nil context:NULL];
					[UIView setAnimationDuration:1];
					tableView.transform = CGAffineTransformMakeScale(1,1);
					[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:tableView cache:YES];
					[UIView setAnimationCurve:UIViewAnimationCurveLinear];
					[tableView reloadData];
					[UIView commitAnimations];
				}
				else
				{
					[tableView reloadData];
				}
			*/	
				[tableView reloadData];
			}	
						
		}
	}	
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
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super viewDidUnload];
}

#pragma mark Notification Handlers

- (void)menuControllerWillHide:(NSNotification *)notification {
	showingEditMenu = NO;
	[self->tableView deselectRowAtIndexPath:[self->tableView indexPathForSelectedRow] animated:YES];
}

- (void)menuControllerWillShow:(NSNotification *)notification {
	showingEditMenu = YES;
	self->tableView.scrollEnabled = NO;
}

- (void)menuControllerDidShow:(NSNotification *)notification {
	self->tableView.scrollEnabled = YES;
}

- (void)showSelectMenuForCell:(SpoknUITableViewCell *)cell 
{
	if ([cell isHighlighted])
	{
		UIMenuController *sharedMenu = [UIMenuController sharedMenuController];
		[cell becomeFirstResponder];
		sharedMenu.arrowDirection = UIMenuControllerArrowDown;
 		[sharedMenu setTargetRect:cell.frame inView:self.view];
		[sharedMenu setMenuVisible:YES animated:YES];
		// Select cell so it doesn't become un-highlighted if finger moves off it while showing edit menu
		[self->tableView selectRowAtIndexPath:[self->tableView indexPathForCell:cell] animated:NO scrollPosition:UITableViewScrollPositionNone];
	}
}

#pragma mark Delegates (CopyableTableViewCell)
- (void)spoknUITableViewCell:(SpoknUITableViewCell *)spoknUITableViewCell willHighlight:(BOOL)highlighted {
	if (highlighted)
		[self performSelector:@selector(showSelectMenuForCell:) withObject:spoknUITableViewCell afterDelay:1.0];
}

- (NSString*)spoknUITableviewCellCopy
{
	NSIndexPath * index = [self->tableView indexPathForSelectedRow];
	int row = [index row];
	int section = [index section];
	char * temp ;
	temp = sectionArray[section].dataforSection[row].elementP;
	[self->tableView deselectRowAtIndexPath:[self->tableView indexPathForSelectedRow] animated:YES];
	if(temp)
	return [NSString stringWithUTF8String:temp];
	return nil;
	
}

- (void)dealloc {
	if(alertgP)
	{	
		[alertgP dismissWithClickedButtonIndex:0 animated:NO]	;
		alertgP = 0;
	}
	if(uiActionSheetgP)
	{	
		[uiActionSheetgP dismissWithClickedButtonIndex:[uiActionSheetgP cancelButtonIndex] animated:NO];
		uiActionSheetgP = 0;
	}
	for(int k=0;k<MAX_SECTION;++k)
	{	
		for(int j=0;j<sectionArray[k].count;++j)
		{	
			
			if(sectionArray[k].dataforSection[j].contactdataP)
			{	
				free(sectionArray[k].dataforSection[j].contactdataP);	
			}	
		}
	}	
	[sectionViewP release];
	[titlesP release];
	//[changeNameButtonP release];
	[userNameP release];
	[msgLabelP release];
	if(self->cdrP)
	{
		free(self->cdrP);
	}
	self->cdrP = 0;
	
	if(addressDataP)
		free(addressDataP);
	addressDataP = 0;
	[viewP release];
	viewP = 0;
	 [super dealloc];
}

-(void)setReturnValue:(int*)lretValP selectedContactNumber:(char*)lnumberCharP rootObject:(id)lrootObjectP selectedContact:(SelectedContctType*)lselectContactP

{
	retValP = lretValP;
	numberCharP = lnumberCharP;
	rootObjectP = lrootObjectP;
	selectContactP = lselectContactP;
	
}
-(void)hideOrShowVmsCallButton
{
	BOOL vmsShowB = FALSE;
	BOOL callShowB = FALSE;
	if(editableB==TRUE)
		return;
		
	for(int i=0;i<MAX_SECTION;++i)
	{
		for(int j=0;j<sectionArray[i].count && j<MAX_COUNT;++j)
		{
			if(sectionArray[i].dataforSection[j].elementP)
			{
				vmsShowB = true;
				if(strstr(sectionArray[i].dataforSection[j].elementP,"@")==0)
				{
					callShowB = true;
					i=MAX_SECTION;
					break;
				}
			}
		}
	
	}
	if(vmsShowB)
	{
			vmsButtonP.enabled  = YES;	
	
	}
	else
	{
		vmsButtonP.enabled  = NO;
		[vmsButtonP setTitleShadowColor:[[UIColor darkGrayColor] autorelease ] forState:UIControlStateNormal];
		[vmsButtonP setTitleShadowColor:[UIColor colorWithWhite:0. alpha:0.2]  forState:UIControlStateDisabled];
		[vmsButtonP setTitleColor:[[UIColor grayColor] autorelease ]  forState:UIControlStateHighlighted];
		[vmsButtonP setTitleColor:[[UIColor grayColor] autorelease ]  forState:UIControlStateDisabled];
		
	}
	if(callShowB)
	{
		callButtonP.enabled  = YES;
	}
	else
	{
		 callButtonP.enabled  = NO;
		[callButtonP setTitleShadowColor:[[UIColor darkGrayColor] autorelease ] forState:UIControlStateNormal];
		[callButtonP setTitleShadowColor:[UIColor colorWithWhite:0. alpha:0.2]  forState:UIControlStateDisabled];
		[callButtonP setTitleColor:[[UIColor grayColor] autorelease ]  forState:UIControlStateHighlighted];
		[callButtonP setTitleColor:[[UIColor grayColor] autorelease ]  forState:UIControlStateDisabled];
		
	}
	
	
}
-(void) setRecordID:(int)laddressID :(int)lrecordId
{
	addressID= laddressID;
	recordID = lrecordId;
}
@end
