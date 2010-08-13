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
//@synthesize area;


- (void) dealloc
{
	[number release];
	[code release];
	[name release];
	[secondaryname release];
	//[area release];
	[super dealloc];
}
+(countrylist*)getCallThroughSavedObject
{
	countrylist *contP;
	NSString *lcode;
	lcode = [[NSUserDefaults standardUserDefaults] stringForKey:@"country_code"];
	if(lcode==nil)
	{
		return nil;
	}
	contP = [[countrylist alloc]init];
	contP.name = [[NSUserDefaults standardUserDefaults] stringForKey:@"city_name"];
	contP.code = lcode;
	contP.number = [[NSUserDefaults standardUserDefaults] stringForKey:@"city_number"];
	return contP;
	
}




@end
