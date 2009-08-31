//
//  OverlayViewController.h
//  TableView
//
//  Created by iPhone SDK Articles on 1/17/09.
//  Copyright www.iPhoneSDKArticles.com 2009. 
//
//this class is added for transprent view
#import <UIKit/UIKit.h>

@class ContactViewController;

@interface OverlayViewController : UIViewController {

	ContactViewController *rvController;
}

@property (nonatomic, retain) ContactViewController *rvController;

@end
