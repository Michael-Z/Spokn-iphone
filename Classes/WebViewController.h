//
//  WebViewController.h
//  spokn
//
//  Created by Mukesh Sharma on 09/10/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "spoknAppDelegate.h"


@interface WebViewController : UIViewController<UIActionSheetDelegate,UIWebViewDelegate>  {
	
	IBOutlet UIWebView *accountswebView;
	SpoknAppDelegate *ownerobject;
	UIActionSheet  *uiActionSheetP;
	UIActivityIndicatorView *spinner;
	NSString * urlnumberP;
}
@property (nonatomic, retain) UIWebView *accountswebView;
-(void)setObject:(id) object;
@end
