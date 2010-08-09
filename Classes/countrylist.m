//
//  countrylist.m
//  spokn
//
//  Created by Rishi Saxena on 21/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "countrylist.h"


@implementation countrylist

@synthesize code; 
@synthesize name;
@synthesize secondaryname; 
@synthesize number; 
@synthesize area;


- (void) dealloc
{
	[name release];
	[secondaryname release];
	[area release];
	[super dealloc];
}




@end
