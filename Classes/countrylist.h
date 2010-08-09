//
//  countrylist.h
//  spokn
//
//  Created by Rishi Saxena on 21/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface countrylist : NSObject {
	
	NSString *name;
	NSString *secondaryname;
	NSInteger code;
	NSInteger number;
	NSString *area;

}
@property (nonatomic, readwrite) NSInteger code;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *secondaryname;
@property (nonatomic, readwrite) NSInteger number;
@property (nonatomic, retain) NSString *area;


@end
