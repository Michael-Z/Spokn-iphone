
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
#import "AddEditcontactViewController.h"

#import "SpoknAppDelegate.h"
#include "alertmessages.h"
@implementation AddEditcontactViewController
@synthesize ltpInterfacesP;
-(void)setObject:(id) object 
{
	self->ownerobject = object;
}
// This method catches the return action
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

-(void)setContactDetail:(struct AddressBook *)addrP
{
	[nameFieldP setText:@""];
	[mobileFieldP setText:@""];
	[homeFieldP setText:@""];
	[businessFieldP setText:@""];
	[emailFieldP setText:@""];
	[spoknIdFieldP setText:@""];
	
	if(addrP)
	{	
		NSString *stringP;
		if(strlen(addrP->title))
		{	
			stringP = [[NSString alloc] initWithUTF8String:addrP->title];
			[nameFieldP setText:stringP];
			[stringP release];
		}
		if(strlen(addrP->mobile))
		{	
			stringP = [[NSString alloc] initWithUTF8String:addrP->mobile];
			[mobileFieldP setText:stringP];
			[stringP release];
		}	
		if(strlen(addrP->home))
		{	
		
			stringP = [[NSString alloc] initWithUTF8String:addrP->home];
			[homeFieldP setText:stringP];
			[stringP release];
		}	
		if(strlen(addrP->business))
		{
			stringP = [[NSString alloc] initWithUTF8String:addrP->business];
			[businessFieldP setText:stringP];
			[stringP release];
		}	
		if(strlen(addrP->email))
		{	

			stringP = [[NSString alloc] initWithUTF8String:addrP->email];
			[emailFieldP setText:stringP];
			[stringP release];
		}
		if(strlen(addrP->spoknid))
		{	
			
			stringP = [[NSString alloc] initWithUTF8String:addrP->spoknid];
			[spoknIdFieldP setText:stringP];
			[stringP release];
		}
		contactID = addrP->id;
	}
	else
	{
		contactID = -1;
		
	}
	nameFieldP.delegate = self;
	mobileFieldP.delegate = self;
	homeFieldP.delegate = self;
	businessFieldP.delegate = self;
	emailFieldP.delegate = self;
	spoknIdFieldP.delegate = self;

	
}

-(IBAction)doneClicked
{
	char *namecharP;
	char *mobilecharP;
	char *businesscharP;
	char *homecharP;
	char *emailCharP;
	char *spoknIdCharP;
	struct AddressBook *addrP ;
	
	//dataP = [pathP cStringUsingEncoding:1];
	namecharP = (char*)[[nameFieldP text] cStringUsingEncoding:NSUTF8StringEncoding];
	mobilecharP = (char*)[[mobileFieldP text] cStringUsingEncoding:NSUTF8StringEncoding];
	businesscharP = (char*)[[businessFieldP text] cStringUsingEncoding:NSUTF8StringEncoding];
	homecharP = (char*)[[homeFieldP text] cStringUsingEncoding:NSUTF8StringEncoding];
	emailCharP = (char*)[[emailFieldP text] cStringUsingEncoding:NSUTF8StringEncoding];
	spoknIdCharP = (char*)[[spoknIdFieldP text] cStringUsingEncoding:NSUTF8StringEncoding];
	//|| ((mobilecharP && strlen(mobilecharP)||(businesscharP && strlen(businesscharP)||(homecharP && strlen(homecharP)||(emailCharP && strlen(emailCharP) ))
	if( (namecharP && strlen(namecharP))&&(  (mobilecharP && strlen(mobilecharP)) || (businesscharP && strlen(businesscharP))||(homecharP && strlen(homecharP))|| (emailCharP && strlen(emailCharP)) ) )
	{
		if(contactID==-1)
		{	
			addContact(namecharP,mobilecharP,homecharP,businesscharP,0,emailCharP,spoknIdCharP);
		}
		else
		{
			addrP = getContact(contactID);			
			if(addrP)
			{
				strcpy(addrP->title,namecharP);
				strcpy(addrP->mobile,mobilecharP);
				strcpy(addrP->business,businesscharP);
				strcpy(addrP->home,homecharP);
				strcpy(addrP->email,emailCharP);
				addrP->dirty = true;
				
			}
		}
		[ [self navigationController] popToRootViewControllerAnimated:YES ];
		contactID = -1;
		[ownerobject profileResynFromApp];
		
	}
	
	else
	{										 
		UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: _INVALID_CONTACT_ 
														   message: [ NSString stringWithString:_INVALID_CONTACT_MESSAGE_ ]
														  delegate: nil
												 cancelButtonTitle: nil
												 otherButtonTitles: _OK_, nil
							  ];
		[ alert show ];
		[alert release];
		
	}	
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
	
	
	}
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self setTitle:@"AddContact"];
	if(self.navigationItem.rightBarButtonItem==nil)
	{	
		self.navigationItem.rightBarButtonItem 
		= [ [ [ UIBarButtonItem alloc ]
			 initWithBarButtonSystemItem: UIBarButtonSystemItemDone
			 target: self
			 action: @selector(doneClicked) ] autorelease ];	
		
	}	
	contactID = -1;


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


- (void)dealloc {
    [super dealloc];
}


@end
