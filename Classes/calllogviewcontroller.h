
//  Created on 03/08/09.

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
#import "LtpInterface.h"
#include "ua.h"
#import "customCell.h"
#pragma pack(4)  


@class SpoknAppDelegate;
@protocol AddCallProtocol;

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
	//struct CDR *gcdrP;
	int gUniqueID;
	Boolean hideB;
	long count;
	int refreshB;
	int lbold;
	id<AddCallProtocol> addcallDelegate;
	Boolean viewDownB;
	
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
@property(readwrite,assign) id<AddCallProtocol> addcallDelegate;


@end
