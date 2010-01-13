//
//  WebViewController.h
//  spokn
//
//  Created by Mukesh Sharma on 09/10/09.
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
#import "spoknAppDelegate.h"


@interface WebViewController : UIViewController<UIActionSheetDelegate,UIWebViewDelegate>  {
	
	IBOutlet UIWebView *accountswebView;
	SpoknAppDelegate *ownerobject;
	//UIActionSheet  *uiActionSheetP;
	UIActivityIndicatorView *spinner;
	
}
@property (nonatomic, retain) UIWebView *accountswebView;
-(void)setObject:(id) object;
@end
