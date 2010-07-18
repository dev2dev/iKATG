//
//  OnAirViewController+Feedback.m
//  KATG Big
//
//  Created by Doug Russell on 5/7/10.
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

#import "OnAirViewController+Feedback.h"

@implementation OnAirViewController (Feedback)

- (void)sendFeedback
{
	NSString *comment = [commentView text];
	if (comment == nil ||
		[comment isEqualToString:@""] ||
		[comment isEqualToString:@"Feedback"])
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
	if ([[textView text] isEqualToString:@"Feedback"])
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
		[textView setText:@"Feedback"];
	}
}

@end
