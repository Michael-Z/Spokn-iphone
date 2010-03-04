
//  Created on 14/06/09.
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

#import <Foundation/Foundation.h>

@interface Contact: NSObject {
	
	NSString *_name;
	NSString *_detail;
	NSString *_number;
}

- (NSString*)Name;
- (void)setName:(NSString*)value;
- (NSString*)Detail;
- (void)setDetail:(NSString*)value;
- (NSString*)Number;
- (void)setNumber:(NSString*)value;
//
//- (void)cleanup;

//@property (nonatomic, retain) NSString *Name;
//@property (nonatomic, retain) NSString *Detail;
//@property (nonatomic, retain) NSString *Number;
@end
