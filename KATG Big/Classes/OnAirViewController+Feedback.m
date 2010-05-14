//
//  OnAirViewController+Feedback.m
//  KATG Big
//
//  Created by Doug Russell on 5/7/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "OnAirViewController+Feedback.h"

@implementation OnAirViewController (Feedback)

- (void)sendFeedback
{
	NSString *comment = [commentView text];
	if (comment == nil ||
		[comment isEqualToString:@""] ||
		[comment isEqualToString:@"Comment"])
		return;
	NSString *name = [nameField text];
	if (name == nil)
		name = @"";
	NSString *location = [locationField text];
	if (location == nil)
		location = @"";
	[model feedback:name 
		   location:location 
			comment:comment];
	[commentView setText:@""];
	[commentView resignFirstResponder];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
	if ([[textView text] isEqualToString:@"Comment"])
	{
		[textView setTextColor:[UIColor blackColor]];
		[textView setText:@""];
	}
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
	if ([[textView text] isEqualToString:@""])
	{
		[textView setTextColor:[UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.0]];
		[textView setText:@"Comment"];
	}
}

@end
