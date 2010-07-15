//
//  OnAirViewControlleriPhone.m
//  KATG Big
//
//  Created by Doug Russell on 5/10/10.
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

#import "OnAirViewControlleriPhone.h"

@interface OnAirViewControlleriPhone ()
- (void)registerNotifications;
- (void)registerKeyboardNotifications;
@end

@implementation OnAirViewControlleriPhone
@synthesize resigned;

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self registerNotifications];	
	
	initialFeedbackViewFrame	=	CGRectNull;
	initialCommentViewFrame		=	CGRectNull;
	initialSubmitButtonFrame	=	CGRectNull;
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[self registerKeyboardNotifications];
}
- (void)viewWillDisappear:(BOOL)animated
{
	
}
- (void)registerNotifications
{
	[[NSNotificationCenter defaultCenter] 
	 addObserver:self 
	 selector:@selector(resign:) 
	 name:UIApplicationWillResignActiveNotification 
	 object:nil];
	[[NSNotificationCenter defaultCenter] 
	 addObserver:self 
	 selector:@selector(unresign:) 
	 name:UIApplicationWillEnterForegroundNotification
	 object:nil];
}
- (void)resign:(NSNotification *)note
{
	self.resigned = YES;
}
- (void)unresign:(NSNotification *)note
{
	self.resigned = NO;
}
- (void)registerKeyboardNotifications
{
	[[NSNotificationCenter defaultCenter] 
	 addObserver:self 
	 selector:@selector(keyboardWillShow:) 
	 name:UIKeyboardWillShowNotification 
	 object:nil];
	[[NSNotificationCenter defaultCenter] 
	 addObserver:self 
	 selector:@selector(keyboardWillHide:) 
	 name:UIKeyboardWillHideNotification 
	 object:nil];
	[[NSNotificationCenter defaultCenter] 
	 addObserver:self 
	 selector:@selector(keyboardDidHide:) 
	 name:UIKeyboardDidHideNotification 
	 object:nil];
}
- (void)keyboardWillShow:(NSNotification *)note
{
	
}
- (void)keyboardWillHide:(NSNotification *)note
{
	
}
- (void)keyboardDidHide:(NSNotification *)note
{
	
}
- (void)spinButton
{
	if (self.isResigned)
		return;
	[super spinButton];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
	[super textViewDidBeginEditing:textView];
	if (CGRectIsNull(initialFeedbackViewFrame))
	{
		initialFeedbackViewFrame	=	[self.feedbackView frame];
		initialCommentViewFrame		=	[self.commentView frame];
		initialSubmitButtonFrame	=	[self.submitButton frame];
	}
	[UIView beginAnimations:NULL context:NULL];
	[UIView setAnimationDuration:0.3];
	if (CGRectEqualToRect(initialFeedbackViewFrame, [self.feedbackView frame]))
	{
		CGRect frame			=	[self.feedbackView frame];
		frame.size.height		=	frame.size.height + 130.0;
		[self.feedbackView setFrame:frame];
		
		frame					=	[self.commentView frame];
		frame.origin.y			=	frame.origin.y + 40.0;
		frame.size.height		=	frame.size.height +	90.0;
		[self.commentView setFrame:frame];
		
		frame					=	[self.submitButton frame];
		frame.origin.y			=	frame.origin.y + 180.0;
		frame.size.height		=	frame.size.height + 10.0;
		[self.submitButton setFrame:frame];
	}
	[UIView commitAnimations];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
	[super textViewDidEndEditing:textView];
	[UIView beginAnimations:NULL context:NULL];
	[UIView setAnimationDuration:0.3];
	[self.feedbackView setFrame:initialFeedbackViewFrame];
	[self.commentView setFrame:initialCommentViewFrame];
	[self.submitButton setFrame:initialSubmitButtonFrame];
	[UIView commitAnimations];
}
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
