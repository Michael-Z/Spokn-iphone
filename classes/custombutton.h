//
//  CustomButton.h
//  spokn
//
//  Created by Mukesh Sharma on 12/10/09.
//  Copyright 2009 Geodesic Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomButton : UIButton {

}
-(void) CGContextAddRoundRect :(CGRect)rect :(float)radius;
+(void)setImages:	(UIButton *)buttonObjectP
		   image:(UIImage *)image
	imagePressed:(UIImage *)imagePressed;

@end
