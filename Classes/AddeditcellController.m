
//
//  SectionedTableController.m
//  SectionedTable
//
//  Created by Vinod Panicker on 30/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AddeditcellController.h"
#import "spoknAppDelegate.h"
#import "contactDetailsviewcontroller.h"
#include "ua.h"
@implementation AddeditcellController

-(void) shiftToRoot: (id)lrootObject :(Boolean ) rootB
{
	self->navRootObject = lrootObject;
	self->shiftRootB = rootB;
	//printf("\n i am here");
}
-(void)setObject:(id) object 
{
	self->ownerobject = object;
}
-(IBAction)cancelPressed
{
	NSLog(@"Cancel");
	[txtField resignFirstResponder];
	
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
					UIAlertView *alert;
					alert = [ [ UIAlertView alloc ] initWithTitle: @"Spokn" 
													  message: [ NSString stringWithString:@"Invalid email address" ]
													 delegate: self
											cancelButtonTitle: nil
											otherButtonTitles: @"OK", nil
						 ];
					[ alert show ];
					[alert release];
					return;
				}	
				break;
				
				
		}
		
		//return;
	}	
	
	
	
	//TempP = (char*)[[txtField text]  cStringUsingEncoding:NSUTF8StringEncoding];
	TempP = (char*)[[txtField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_$!<>+"]]  cStringUsingEncoding:NSUTF8StringEncoding];
	NSLog([txtField text]);
	strcpy(rvalueCharP,TempP);
		if(returnP)
	{
		*returnP = 1;
	}
	//addressDataP->dirty = true;
NSLog(@"\nSave123");
	if(self->shiftRootB==false)
	{	
		[[self navigationController]  popViewControllerAnimated:YES];
	}	
	else
	{
		NSLog(@"Save");
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
-(void)setData:/*out parameter*/(char *)lvalueCharP value:(char*)fieldP placeHolder:(char*)lplaceHolderP/*out parameter*/returnValue:(int *)lreturnP;


{
		
	rvalueCharP = lvalueCharP;
	returnP = lreturnP;
	StringP = [[NSString alloc] initWithUTF8String:lvalueCharP];
	typeP = [[NSString alloc] initWithUTF8String:fieldP];
	placeHolderP = [[NSString alloc] initWithUTF8String:lplaceHolderP];
	
}
- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	// Add right button
	//printf("\n load");
	self.navigationItem.leftBarButtonItem = [ [ [ UIBarButtonItem alloc ]
											   initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
											   target: self
											   action: @selector(cancelPressed) ] autorelease ];	
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
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
	headLabelP.backgroundColor = [UIColor groupTableViewBackgroundColor];
	//viewP.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	[headLabelP setText:typeP];
	

}	

- (AddeditcellController *) init
{
	if (self = [super initWithStyle:UITableViewStyleGrouped])
	{	
		self.title = @"Edit";
	}
	buttonType = 0;
	CGRect LabelFrame2 = CGRectMake(0, 5, 320, 60);
	headLabelP = [[UILabel alloc] initWithFrame:LabelFrame2];
	headLabelP.textAlignment = UITextAlignmentCenter;
	headLabelP.tag = 1;
	headLabelP.numberOfLines = 2;
	self.tableView.tableHeaderView = headLabelP;
	[headLabelP release];
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
	return 50;
	
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	//NSLog(@"\n%@\n",string);
	if([textField.text length]<=1 && [string length]==0 )
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
        cell = [ [ [ UITableViewCell alloc ] initWithFrame: CGRectZero reuseIdentifier: CellIdentifier ] autorelease ];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		switch (section) 
		{
			case(0):
				switch(row)
				{
					case(0):
						txtField = [[UITextField alloc] initWithFrame:CGRectMake(20.0f, self.tableView.rowHeight/3, 280.0f, 50.0f)];
						txtField.delegate = self;
						[cell.contentView addSubview:txtField]; 
						[txtField becomeFirstResponder];
						[txtField release];
						txtField.keyboardType = keyboardtype;
						txtField.delegate = self;
						txtField.placeholder = placeHolderP;
						txtField.autocapitalizationType = UITextAutocapitalizationTypeNone;
						if(StringP)
						{	
							txtField.text =StringP;
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
	[placeHolderP release];
	//[headLabelP release];
	//[txtField release];
	[StringP release];
	[typeP release];
    [super dealloc];
}


@end


