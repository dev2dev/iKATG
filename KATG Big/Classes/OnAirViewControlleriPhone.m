//
//  OnAirViewControlleriPhone.m
//  KATG Big
//
//  Created by Doug Russell on 5/10/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "OnAirViewControlleriPhone.h"

@implementation OnAirViewControlleriPhone

- (BOOL)textView:(UITextView *)textView 
shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
	if ([text isEqualToString:@"\n"])
	{
		[textView resignFirstResponder];;
		return NO;
	}
	return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return NO;
}

- (void)events:(NSArray *)events
{
	[super events:events];
	if ([NSThread isMainThread])
	{
		if (events && events.count > 0)
		{
			
		}
	}
	else
	{
		[self performSelectorOnMainThread:@selector(events:) 
							   withObject:events 
							waitUntilDone:NO];
	}
}

@end
