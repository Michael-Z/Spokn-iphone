//
//  WebViewController.h
//  spokn
//
//  Created by Mukesh Sharma on 09/10/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "spoknAppDelegate.h"

@interface WebViewController : UIViewController {
	
	IBOutlet UIWebView *accountswebView;
	SpoknAppDelegate *ownerobject;
}
@property (nonatomic, retain) UIWebView *accountswebView;
-(void)setObject:(id) object;
@end
