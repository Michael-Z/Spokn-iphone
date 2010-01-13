//
//  spoknalert.h
//  spokn
//
//  Created by Mukesh Sharma on 14/08/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//
/**
 Copyright 2009 John Smith, <john.smith@example.com>
 
 This file is part of FOOBAR.
 
 FOOBAR is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 FOOBAR is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with FOOBAR.  If not, see <http://www.gnu.org/licenses/>.
 */

#import <UIKit/UIKit.h>


@interface SpoknAlert : UIAlertView<UIAlertViewDelegate> {
	int buttonClickedIndex;
	
}
@property(readwrite,assign) int buttonClickedIndex;
@end
