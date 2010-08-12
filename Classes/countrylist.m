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
	[name release];
	[secondaryname release];
	//[area release];
	[super dealloc];
}
+(countrylist*)getCallThroughSavedObject
{
	countrylist *contP;
	int lcode;
	lcode = [[NSUserDefaults standardUserDefaults] integerForKey:@"country_code"];
	if(lcode==0)
	{
		return nil;
	}
	contP = [[countrylist alloc]init];
	contP.name = [[NSUserDefaults standardUserDefaults] stringForKey:@"city_name"];
	contP.code = lcode;
	contP.number = [[NSUserDefaults standardUserDefaults] integerForKey:@"city_number"];
	return contP;
	
}




@end
