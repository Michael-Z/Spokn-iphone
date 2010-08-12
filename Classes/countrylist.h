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
	NSUInteger number;
	//NSString *area;

}
@property (nonatomic, readwrite) NSInteger code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *secondaryname;
@property (nonatomic, readwrite) NSUInteger number;
//@property (nonatomic, copy) NSString *area;
+(countrylist*)getCallThroughSavedObject;

@end
