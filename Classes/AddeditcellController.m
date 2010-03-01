
//  Created on 30/09/09.

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

#import "AddeditcellController.h"
#import "spoknAppDelegate.h"
#import "contactDetailsviewcontroller.h"
#include "ua.h"
#include "alertmessages.h"

@implementation AddeditcellController

-(void) shiftToRoot: (id)lrootObject :(Boolean ) rootB
{
	self->navRootObject = lrootObject;
	self->shiftRootB = rootB;
	}
-(void)setObject:(id) object 
{
	self->ownerobject = object;
}
-(IBAction)cancelPressed
{
	
	//[txtField resignFirstResponder];
	
	[[self navigationController]  popViewControllerAnimated:YES];
}

-(void) SetkeyBoardType:(UIKeyboardType) type : (int) maxCharInt buttonType:(int)lbuttonType

{
	keyboardtype = type;
	fieldRangeInt = maxCharInt ;
	buttonType = lbuttonType;
}
-(IBAction)savePressed
{
	
	char *TempP;
	//if([[txtField text] length]==0)
	{	
		
		switch(keyboardtype)
		{
				
		/*	case UIKeyboardTypePhonePad:
		
				alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn" 
											  message: [ NSString stringWithString:@"number can not be blanked" ]
										 delegate: self
								cancelButtonTitle: nil
								otherButtonTitles: @"OK", nil
			 ];
				break;
			case UIKeyboardTypeNamePhonePad:
				alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn" 
													  message: [ NSString stringWithString:@"name can not be blanked" ]
													 delegate: self
											cancelButtonTitle: nil
											otherButtonTitles: @"OK", nil
						 ];
				break;
				*/
			case UIKeyboardTypeEmailAddress:		
				if([SpoknAppDelegate emailValidate:[txtField text]]==NO)
				{	
					if(activeAditButtonB)//mean in edit mode allow edit email
					{
					
						if([[txtField text] length]==0)//mean delete field
							break;
					
					}
					
			/*		UIAlertView *alert;
					alert = [ [ UIAlertView alloc ] initWithTitle: _INVALID_EMAIL_ 
													  message: [ NSString stringWithString:_INVALID_EMAIL_MESSGAE_ ]
													 delegate: self
											cancelButtonTitle: nil
											otherButtonTitles: _OK_, nil
						 ];
					[ alert show ];
					[alert release];*/
					return;
				}	
				break;
				
				
		}
		
		//return;
	}	
	
	
	
	TempP = (char*)[[txtField text]  cStringUsingEncoding:NSUTF8StringEncoding];
	//TempP = (char*)[[txtField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_$!<>+"]]  cStringUsingEncoding:NSUTF8StringEncoding];
	strcpy(rvalueCharP,TempP);
		if(returnP)
	{
		*returnP = 1;
	}
	//addressDataP->dirty = true;
	if(self->shiftRootB==false)
	{	
		[[self navigationController]  popViewControllerAnimated:YES];
	}	
	else
	{
		if(self->navRootObject)
		{
			[[self navigationController]  popToViewController:self->navRootObject animated:NO];
		}
		else
		{	
			[[self navigationController]  popToRootViewControllerAnimated:YES];
		}	
	}
}
-(void)setData:/*out parameter*/(char *)lvalueCharP value:(char*)fieldP placeHolder:(char*)lplaceHolderP title:(char*)titleP/*out parameter*/returnValue:(int *)lreturnP


{
		
	rvalueCharP = lvalueCharP;
	returnP = lreturnP;
	//char titleChar[80];
	StringP = [[NSString alloc] initWithUTF8String:lvalueCharP];
	if(lreturnP && strlen(lvalueCharP)>0)
	{
		activeAditButtonB = YES;
	}
	//typeP = [[NSString alloc] initWithUTF8String:fieldP];
	titleStrP = [[NSString alloc] initWithUTF8String:titleP];
	placeHolderP = [[NSString alloc] initWithUTF8String:lplaceHolderP];
	if(strcasestr(titleP,"email"))
	{
		typeP = [[NSString alloc] initWithUTF8String:"Type valid email address"];
		exampleStrP = [[NSString alloc] initWithUTF8String:"Example : example@example.org"];
	}
	else
	{
		if(strcasestr(titleP,"Name"))
		{
			typeP = [[NSString alloc] initWithUTF8String:"Enter name"];
			exampleStrP = [[NSString alloc] initWithUTF8String:""];

		}
		else
		{	
			typeP = [[NSString alloc] initWithUTF8String:"7-digit Spokn ID or phone number with country code "];
			exampleStrP = [[NSString alloc] initWithUTF8String:"Example : +1 847 425 5380"];
		}	
	}
/*	if(strcasestr(lplaceHolderP,"email"))
	{
		placeHolderP = [[NSString alloc] initWithUTF8String:"email"];
		sprintf(titleChar,"%s Email",titleP);
		
	}
	else
	{
		if(strcasestr(lplaceHolderP,"first"))
		{
			placeHolderP = [[NSString alloc] initWithUTF8String:"Name"];
			//sprintf(titleChar,"%s Name",titleP);
			strcpy(titleChar,titleP);
		
		}
		else
		{
			placeHolderP = [[NSString alloc] initWithUTF8String:"Phone"];
			if(strcasestr(titleP,"forward")==0)
			{	
				sprintf(titleChar,"%s Phone",titleP);
			}
			else
			{
				strcpy(titleChar,titleP);
			}
		}
		
	}
	titleStrP = [[NSString alloc] initWithUTF8String:titleChar];
*/	self.title = titleStrP;
	
	
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	onlyOneB = true;
	self.tableView.scrollEnabled = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	// Add right button
	
	self.navigationItem.leftBarButtonItem = [ [ [ UIBarButtonItem alloc ]
											   initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
											   target: self
											   action: @selector(cancelPressed) ] autorelease ];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleTextFieldChanged:)
												 name:UITextFieldTextDidChangeNotification
											   object:txtField];
	
	
	headLabelP.backgroundColor = [UIColor groupTableViewBackgroundColor];
	footerLabelP.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	self.tableView.tableHeaderView = headLabelP;
	//[headLabelP release];
	//headLabelP = nil;
	
	self.tableView.tableFooterView = footerLabelP;
	//[footerLabelP release];
	//footerLabelP = nil;
	self.title = titleStrP;
	if(buttonType==0)
	{	
		self.navigationItem.rightBarButtonItem = [ [ [ UIBarButtonItem alloc ]
													initWithBarButtonSystemItem: UIBarButtonSystemItemSave
													target: self
													action: @selector(savePressed) ] autorelease ];
	}
	else
	{
		self.navigationItem.rightBarButtonItem = [ [ [ UIBarButtonItem alloc ]
													initWithBarButtonSystemItem: UIBarButtonSystemItemDone
													target: self
													action: @selector(savePressed) ] autorelease ];
		
	}
	self.navigationItem.rightBarButtonItem.enabled = NO;
	//viewP.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	[headLabelP setText:typeP];
	[footerLabelP setText:exampleStrP];
	
	[self.tableView reloadData];
	//[self updateUI:nil];
	


}

- (void) handleTextFieldChanged:(id)sender
{
	if(keyboardtype !=UIKeyboardTypeEmailAddress)
	{
		return;
	}
	if([txtField.text length])
	{
		if([SpoknAppDelegate emailValidate:[txtField text]]==NO)
		{	
			self.navigationItem.rightBarButtonItem.enabled = NO;
			
		}
		else
		{
			self.navigationItem.rightBarButtonItem.enabled = YES;
		}	
		
	}
	else
	{
		if(activeAditButtonB==NO)
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}	
}
- (void)updateUI:(id) objectP
{
	if(onlyOneB)
	{	
	    [txtField becomeFirstResponder];
		onlyOneB = false;
	}
	
	
}
- (void)viewDidAppear:(BOOL)animated
{
	//onlyOneB = false;
	[super viewDidAppear:animated];
	[self updateUI:nil];
}	

- (AddeditcellController *) init
{
	if (self = [super initWithStyle:UITableViewStyleGrouped])
	{	
		self.title = @"Edit";
	}
	buttonType = 0;
	activeAditButtonB = NO;
	CGRect LabelFrame2 = CGRectMake(0, 5, 320, 60);
	headLabelP = [[UILabel alloc] initWithFrame:LabelFrame2];
	headLabelP.textAlignment = UITextAlignmentCenter;
	headLabelP.tag = 1;
	headLabelP.numberOfLines = 2;
		
	//CGRect LabelFrame2 = CGRectMake(0, 5, 320, 60);
	footerLabelP = [[UILabel alloc] initWithFrame:LabelFrame2];
	footerLabelP.textAlignment = UITextAlignmentCenter;
	footerLabelP.tag = 2;
	footerLabelP.numberOfLines = 2;
	
	
	
	self->shiftRootB  = false;
	keyboardtype = UIKeyboardTypePhonePad;
	fieldRangeInt = NUMBER_RANGE;
	//self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Detemine if it's in editing mode
	
    return UITableViewCellEditingStyleNone;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 50.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(keyboardtype==UIKeyboardTypePhonePad|| keyboardtype==UIKeyboardTypeNumberPad)
	{
		return 50;
	}
	return 40;
	
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if([textField.text length]<=1 && [string length]==0 && activeAditButtonB ==NO)
	{
		self.navigationItem.rightBarButtonItem.enabled = NO;	
	}
	else
	{	
		if(!self.navigationItem.rightBarButtonItem.enabled)
			self.navigationItem.rightBarButtonItem.enabled = YES;	
	}
	NSString *usernameString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return !([usernameString length] > fieldRangeInt);
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	
	NSString *CellIdentifier = @"any-cell";//[ NSString stringWithFormat: @"%d:%d", [ indexPath indexAtPosition: 0 ],
								//[ indexPath indexAtPosition:1] ];
	
    UITableViewCell *cell = [ tableView dequeueReusableCellWithIdentifier: CellIdentifier ];
    if (cell == nil)
	{
		#ifdef __IPHONE_3_0
				
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		#else
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
				
		#endif
				
		// cell = [ [ [ UITableViewCell alloc ] initWithFrame: CGRectZero reuseIdentifier: CellIdentifier ] autorelease ];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		switch (section) 
		{
			case(0):
				switch(row)
				{
					case(0):
						
						txtField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 7, 280.0f, self.tableView.rowHeight-4)];
						txtField.delegate = self;
						[cell.contentView addSubview:txtField]; 
						//[txtField becomeFirstResponder];
						[txtField release];
						txtField.keyboardType = keyboardtype;
						txtField.delegate = self;
						txtField.placeholder = placeHolderP;
						txtField.autocapitalizationType = UITextAutocapitalizationTypeNone;
						if(StringP)
						{	
							txtField.text =StringP;
						}
						if(keyboardtype==UIKeyboardTypePhonePad|| keyboardtype==UIKeyboardTypeNumberPad)
						{
							txtField.font = [UIFont systemFontOfSize:30];
						}
						else
						{
							txtField.font = [UIFont systemFontOfSize:20];
						}
							//else
						//{
							//txtField.text = @"";
						//}
						//cell.text = @"";
				}
				break;
		}
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		
	}
    return self;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
		[txtField resignFirstResponder];
	return YES;
}

- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[exampleStrP release];
	[titleStrP release];
	[placeHolderP release];
	[headLabelP release];
	[footerLabelP release];
	//[txtField release];
	[StringP release];
	[typeP release];
    [super dealloc];
}


@end


