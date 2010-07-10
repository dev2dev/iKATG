//
//  GUIFunctions.h
//  PartyCamera
//
//  Created by Doug Russell on 6/29/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import <UIKit/UIKit.h>

CGRect ScreenDimensionsInPoints();

void BasicAlert(NSString *title, 
				NSString *message, 
				id delegate, 
				NSString *cancelButtonTitle,
				NSString *otherButtonTitle);

@end
