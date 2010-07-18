//
//  GUIFunctions.m
//  PartyCamera
//
//  Created by Doug Russell on 6/29/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//  http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  

#import "GUIFunctions.h"
#import "ESAlertView.h"

CGRect ScreenDimensionsInPoints()
{
	UIScreen *screen = [UIScreen mainScreen];
	CGRect rect = [screen applicationFrame];
	return rect;
}

void BasicAlert(NSString *title, 
				NSString *message, 
				id<ESAlertViewDelegate> delegate, 
				NSString *cancelButtonTitle, 
				NSString *otherButtonTitle)
{
#ifdef __IPHONE_4_0
	if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive)
		return;
#endif
//	UIAlertView *alertView = 
//	[[UIAlertView alloc] 
//	 initWithTitle:title 
//	 message:message 
//	 delegate:delegate 
//	 cancelButtonTitle:cancelButtonTitle 
//	 otherButtonTitles:otherButtonTitle, nil];
	ESAlertView	*	alertView	=
	[[ESAlertView alloc]
	 initWithTitle:title 
	 message:message 
	 delegate:delegate 
	 cancelButtonTitle:cancelButtonTitle 
	 otherButtonTitle:otherButtonTitle];
	[alertView
	 performSelector:@selector(show)
	 onThread:[NSThread mainThread]
	 withObject:nil
	 waitUntilDone:YES];
	[alertView release];
}
