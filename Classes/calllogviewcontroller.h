
//  Created on 03/08/09.

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

#import <UIKit/UIKit.h>
#import "LtpInterface.h"
#include "ua.h"
#import "customCell.h"



@class SpoknAppDelegate;
@interface CalllogViewController : UIViewController< UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIActionSheetDelegate> {
	IBOutlet UITableView *tableView;
	SpoknAppDelegate *ownerobject;	
	UAObjectType uaObject;
	UIImage  *missImageP;
	UIImage  *inImageP;
	UIImage  *outImageP;
	CellObjectContainer *cellofcalllogP;
	UIFont *fontGloP;
	int showMisscallInt;
	UISegmentedControl *segmentedControl;
	int resultInt;
	struct CDR *gcdrP;
	Boolean hideB;
	long count;
	int refreshB;
	
}
-(int)missCallSetCount;
-(int)resetMissCallCount;
-(int)setMissCallCount;
-(void)doRefresh;
-(void)setObject:(id) object ;
-(void)setObjType:(UAObjectType)luaObj;
- (void)addRow: (int )index sectionObject:(sectionType **)sectionPP;
-(void) hideLeftbutton:(Boolean) lhideB;
- (void) reload;
@end
