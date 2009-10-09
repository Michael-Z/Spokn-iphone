//
//  AddEditcontactViewController.m
//  spokn
//
//  Created by Mukesh Sharma on 04/08/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import "AddEditcontactViewController.h"

#import "SpoknAppDelegate.h"

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
	namecharP = (char*)[[nameFieldP text] cStringUsingEncoding:1];
	mobilecharP = (char*)[[mobileFieldP text] cStringUsingEncoding:1];
	businesscharP = (char*)[[businessFieldP text] cStringUsingEncoding:1];
	homecharP = (char*)[[homeFieldP text] cStringUsingEncoding:1];
	emailCharP = (char*)[[emailFieldP text] cStringUsingEncoding:1];
	spoknIdCharP = (char*)[[spoknIdFieldP text] cStringUsingEncoding:1];
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
		profileResync();
		
	}
	
	else
	{										 
		UIAlertView *alert = [ [ UIAlertView alloc ] initWithTitle: @"Error" 
														   message: [ NSString stringWithString:@"invalid contact" ]
														  delegate: nil
												 cancelButtonTitle: nil
												 otherButtonTitles: @"OK", nil
							  ];
		[ alert show ];
		[alert release];
		
	}	
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		NSLog(@"test log");
	
	
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
    NSLog(@"memory leak");
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	NSLog(@"dealloc ");
    [super dealloc];
}


@end
