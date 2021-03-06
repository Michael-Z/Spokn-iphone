
//  Created on 27/05/09.
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

#import <UIKit/UIKit.h>

@interface GTokenFieldCell : UIView {
	id _object;
	UILabel* _labelView;
	BOOL _selected;
	NSString* _number;
	UIColor* _color1;
	UIColor* _color2;
	UIColor* _color3;
	UIColor* _color4;
}

@property(nonatomic,retain) id object;
@property(nonatomic,copy) NSString* _number;
@property(nonatomic,copy) NSString* label;
@property(nonatomic,retain) UIFont* font;
@property(nonatomic) BOOL selected;

@property(nonatomic,retain) UIColor* color1;
@property(nonatomic,retain) UIColor* color2;
@property(nonatomic,retain) UIColor* color3;
@property(nonatomic,retain) UIColor* color4;

@end
