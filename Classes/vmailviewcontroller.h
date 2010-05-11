
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
#include "vmsplayrecord.h"
#import "customCell.h"



@class SpoknAppDelegate;
@interface VmailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate> {
	IBOutlet UITableView *tableView;
	SpoknAppDelegate *ownerobject;	
	UAObjectType uaObject;
	LtpInterfaceType *ltpInterfacesP;
	CellObjectContainer *cellofvmsP;
	UIImage  *activeImageP;
	UIImage  *dileverImageP;
	UIImage  *failedImageP;
	UIImage  *vnewImageP;
	UIImage  *readImageP;
	UIImage  *vnewoutImageP;
	UIProgressView *uiProgressP;
	UIActionSheet  *uiActionSheetP;
	NSTimer        *nsTimerP;
	float maxtime;
	float amt;
	int showFailInt;
	UISegmentedControl *segmentedControl;
	UIActivityIndicatorView *activityIndicator;
	int viewPlayResult;
	int openVmsCompose;
	char vmsNoChar[100];
	int onLine;
	int refreshB;
	int lbold;
	int startIndicator;
	


}

-(void)setObject:(id) object ;
-(void)setObjType:(UAObjectType)luaObj;
- (void)addRow: (int )index sectionObject:(sectionType **)sectionPP;
-(void)stopvmsPlay;
-(void)startVmsProgress:(char*)fileNameCharP :(int) max :(struct VMail *)vmailP;
-(void)setcomposeStatus:(int)lstatus;
-(void)refreshView;
- (void) reload ;
- (void) doRefresh ;
-(void)startProgress;
-(void)cancelProgress;
@property(readwrite,assign) LtpInterfaceType *ltpInterfacesP;
@end
