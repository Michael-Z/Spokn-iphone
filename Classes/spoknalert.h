//
//  spoknalert.h
//  spokn
//
//  Created by Mukesh Sharma on 14/08/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SpoknAlert : UIAlertView<UIAlertViewDelegate> {
	int buttonClickedIndex;
	
}
@property(readwrite,assign) int buttonClickedIndex;
@end
