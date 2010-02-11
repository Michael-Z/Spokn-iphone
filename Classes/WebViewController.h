
//  Created by Mukesh Sharma on 09/10/09.

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
#import "spoknAppDelegate.h"


@interface WebViewController : UIViewController<UIActionSheetDelegate,UIWebViewDelegate>  {
	
	IBOutlet UIWebView *accountswebView;
	SpoknAppDelegate *ownerobject;
	//UIActionSheet  *uiActionSheetP;
	UIActivityIndicatorView *spinner;
	NSString *urlToLoadP;
	Boolean nowebB;//if true mean we need to downloaded from web
	Boolean modalB;
	
}
@property (nonatomic, retain) UIWebView *accountswebView;
-(void)setObject:(id) object;
-(void)setData:(NSString*)urlP web:(Boolean)lwebB;
-(void)modelViewB:(Boolean)lmodalB;

@end
