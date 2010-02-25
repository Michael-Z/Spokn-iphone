
//  Created on 02/10/09.

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

#define MAXVIEW 5
#define MAXSECTION 3
#import <UIKit/UIKit.h>
/*typedef struct SubViewDetails
	{
		int sectionInt;
		UIView *viewForrowP;
	}SubViewDetails;
 */
typedef struct ImageNameType
	{
		NSString *imageNameP;
	}ImageNameType;
#define MAXIMAGE 6

@class SpoknAppDelegate;
@interface SpoknViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
	
	SpoknAppDelegate *ownerobject;
	//SubViewDetails subViewDetails[MAXVIEW];
	IBOutlet UITableView *tableView;
	IBOutlet UIButton *buybuttonCtlP;
	IBOutlet UIButton *aboutbuttonCtlP;
	NSMutableArray *listOfItems;
	UILabel *labelBalance;
	UILabel *labelStatus;
	UILabel *labelForword;
	UILabel *labelSpoknNo;
	UILabel *labelSpoknID;
	UISwitch *switchView;
	//UIButton *buyCreditsButton;
	int viewResult;
	char *forwardNoCharP;
	int viewCallB;
	int stopProgressB;
	ImageNameType imageName[MAXSECTION][MAXIMAGE];
	UIActivityIndicatorView *activityIndicator;
	UIActivityIndicatorView *forwardactivityIndicator;
	int statusInt;
	

}
-(void)buyCredit:(id)sender;
-(void)aboutPage:(id)sender;
-(void)setObject:(id) object ;
-(void)setDetails:(char *)titleCharP :(int )statusInt :(int)subStatus :(float) balance :(char *)lforwardNoCharP :(char *)spoknCharP forwardOn:(int)forward spoknID:(char*)spoknLoginId;
- (IBAction)switchChange:(UISwitch*)sender;
-(void)startProgress;
-(void)showForwardNoScreen;
-(void)cancelProgress;
-(void) cancelPressed ;
-(void) LoginPressed ;
-(void) LogoutPressed;
-(void)startforwardactivityIndicator;
-(void)stopforwardactivityIndicator;
-(void)startProgress;
@end
