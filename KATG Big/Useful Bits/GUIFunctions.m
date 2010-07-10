//
//  GUIFunctions.m
//  PartyCamera
//
//  Created by Doug Russell on 6/29/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "GUIFunctions.h"

CGRect ScreenDimensionsInPoints()
{
	UIScreen *screen = [UIScreen mainScreen];
	CGRect rect = [screen applicationFrame];
	return rect;
}

void BasicAlert(NSString *title, 
				NSString *message, 
				id delegate, 
				NSString *cancelButtonTitle, 
				NSString *otherButtonTitle)
{
	UIAlertView *alertView = 
	[[UIAlertView alloc] initWithTitle:title 
							   message:message 
							  delegate:delegate 
					 cancelButtonTitle:cancelButtonTitle 
					 otherButtonTitles:otherButtonTitle, nil];
	[alertView show];
	[alertView release];
}
