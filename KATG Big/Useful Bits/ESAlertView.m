//
//  ESAlertView.m
//  KATG Big
//
//  Created by Doug Russell on 7/17/10.
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

#import "ESAlertView.h"
#import <QuartzCore/QuartzCore.h>.
#import "GradButton.h"

#define kTitleFontSize 24
#define kMessageFontSize 18
#define kButtonHeight 40.0
#define kCancelButtonIndex 0
#define kOtherButtonIndex 1

@interface ESAlertView ()
- (void)_viewDecoration;
- (void)_cancelButtonPressed:(id)sender;
- (void)_otherButtonPressed:(id)sender;
- (void)_dismiss:(id)sender;
@end

@implementation ESAlertView
@synthesize delegate			=	_delegate;
@synthesize title				=	_title;
@synthesize message				=	_message;
@synthesize cancelButtonTitle	=	_cancelButtonTitle;
@synthesize otherButtonTitle	=	_otherButtonTitle;

- (id)initWithTitle:(NSString *)title 
			message:(NSString *)message 
		   delegate:(id <ESAlertViewDelegate>)delegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle 
   otherButtonTitle:(NSString *)otherButtonTitle
{
	if ((self = [super init]))
	{
		//
		// iVars
		//
		self.delegate						=	delegate;
		self.title							=	title;
		self.message						=	message;
		self.cancelButtonTitle				=	cancelButtonTitle;
		self.otherButtonTitle				=	otherButtonTitle;
		//
		// Dimensions
		//
		CGRect				screenBounds	=	ScreenDimensionsInPoints();
		CGFloat				x				=	screenBounds.size.width * 0.05;
		CGFloat				y				=	0.0;
		CGFloat				w				=	screenBounds.size.width * 0.9;
		CGFloat				h				=	10.0;
		CGSize				titleSize		=	CGSizeMake(0.0, 0.0);
		CGRect				titleRect		=	CGRectMake(0.0, 10.0, 0.0, 0.0);
		CGSize				messageSize;
		CGRect				messageRect;
		CGRect				cancelButtonRect;
		CGRect				otherButtonRect;
		//
		// Alert Title Height
		//
		if (title)
		{
			titleSize		=	
			[title sizeWithFont:[UIFont boldSystemFontOfSize:kTitleFontSize] 
					   forWidth:w 
				  lineBreakMode:UILineBreakModeWordWrap];
			h								+=	titleSize.height;
		}
		//
		// Alert Message Height
		//
		if (message)
		{
			messageSize		=
			[message sizeWithFont:[UIFont systemFontOfSize:kMessageFontSize] 
				constrainedToSize:CGSizeMake(w - 20.0, screenBounds.size.height) 
					lineBreakMode:UILineBreakModeWordWrap];
			h								+=	messageSize.height + 10.0;
		}
		//
		// Cancel Button Height
		//
		if (cancelButtonTitle)
			h								+=	kButtonHeight;
		//
		// Other Button Height
		//
		if (otherButtonTitle)
			h								+=	kButtonHeight;
		//
		// Bottom Spacing
		//
		h									+=	10.0;
		//
		// Mininum Height
		//
		if (h < screenBounds.size.height * 0.3)
			h	=	screenBounds.size.height * 0.3;
		else if (h > screenBounds.size.height * 0.6)
			h = screenBounds.size.height * 0.6;
		//
		// Center Vertically In View
		//
		y	=	(screenBounds.size.height / 2) - (h / 2);
		//
		// Set Frame
		//
		self.frame							=	CGRectMake(x, y, w, h);
		//
		// Round corners, add gradient
		//
		[self _viewDecoration];
		//
		// Title Label
		//
		if (title)
		{
			titleRect						=	CGRectMake(w / 2 - titleSize.width / 2, 
														   10.0, 
														   titleSize.width, 
														   titleSize.height);
			UILabel	*	titleLabel			=
			[[UILabel alloc] initWithFrame:titleRect];
			titleLabel.font					=	[UIFont boldSystemFontOfSize:kTitleFontSize];
			titleLabel.textAlignment		=	UITextAlignmentCenter;
			titleLabel.text					=	title;
			titleLabel.backgroundColor		=	[UIColor clearColor];
			titleLabel.textColor			=	[UIColor whiteColor];
			titleLabel.shadowColor			=	[UIColor blackColor];
			titleLabel.shadowOffset			=	CGSizeMake(0, 1.0);
			[self addSubview:titleLabel];
			[titleLabel release];
		}
		//
		// Message
		//
		if (message)
		{
			if (h == screenBounds.size.height * 0.6)
			{
				messageRect					=	CGRectMake(10.0, 
														   titleRect.origin.y + titleRect.size.height + 10.0, 
														   w - 20.0, 
														   screenBounds.size.height * 0.3);
				UITextView	*	messageView	=	[[UITextView alloc] initWithFrame:messageRect];
				messageView.text			=	message;
				messageView.editable		=	NO;
				[self addSubview:messageView];
				[messageView release];
			}
			else
			{
				CGFloat		lineHeight		=	[[UIFont systemFontOfSize:kMessageFontSize] lineHeight];
				NSInteger	lines			=	ceil(messageSize.height / lineHeight);
				messageRect					=	CGRectMake(10.0, 
														   titleRect.origin.y + titleRect.size.height + 10.0, 
														   w - 20.0, 
														   lines * lineHeight);
				UILabel	*	messageLabel	=
				[[UILabel alloc] initWithFrame:messageRect];
				messageLabel.numberOfLines	=	lines;
				messageLabel.font			=	[UIFont systemFontOfSize:kMessageFontSize];
				messageLabel.textAlignment	=	UITextAlignmentLeft;
				messageLabel.text			=	message;
				messageLabel.backgroundColor=	[UIColor clearColor];
				messageLabel.textColor		=	[UIColor whiteColor];
				messageLabel.shadowColor	=	[UIColor blackColor];
				messageLabel.shadowOffset	=	CGSizeMake(0, 1.0);
				[self addSubview:messageLabel];
				[messageLabel release];
			}
		}
		//
		// Cancel Button
		//
		if (cancelButtonTitle)
		{
			cancelButtonRect						=	CGRectMake(10.0, 
																   h - (kButtonHeight + 5.0), 
																   w - 20.0, 
																   kButtonHeight);
			if (otherButtonTitle)
				cancelButtonRect.origin.y			-=	(kButtonHeight + 5.0);
			GradButton	*	cancelButton			=	
			[[GradButton alloc] initWithFrame:cancelButtonRect];
			[cancelButton setTitle:cancelButtonTitle 
						  forState:UIControlStateNormal];
			[cancelButton setTitleColor:[UIColor whiteColor] 
							   forState:UIControlStateNormal];
			[cancelButton setTitleColor:[UIColor lightGrayColor] 
							   forState:UIControlStateSelected];
			cancelButton.backgroundColor			=	[UIColor clearColor];
			cancelButton.titleLabel.font			=	[UIFont boldSystemFontOfSize:18];
			cancelButton.titleLabel.shadowColor		=	[UIColor blackColor];
			cancelButton.titleLabel.shadowOffset	=	CGSizeMake(0, 1.0);
			cancelButton.tag						=	kCancelButtonIndex;
			[cancelButton addTarget:self 
							 action:@selector(_cancelButtonPressed:) 
				   forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:cancelButton];
			[cancelButton release];
		}
		//
		// Other Button
		//
		if (otherButtonTitle)
		{
			otherButtonRect						=	CGRectMake(10.0, 
															   h - (kButtonHeight + 5.0), 
															   w - 20.0, 
															   kButtonHeight);
			GradButton	*	otherButton			=	
			[[GradButton alloc] initWithFrame:otherButtonRect];
			[otherButton setTitle:otherButtonTitle 
						 forState:UIControlStateNormal];
			[otherButton setTitleColor:[UIColor whiteColor] 
							  forState:UIControlStateNormal];
			[otherButton setTitleColor:[UIColor lightGrayColor] 
							  forState:UIControlStateSelected];
			otherButton.backgroundColor			=	[UIColor clearColor];
			otherButton.titleLabel.font			=	[UIFont boldSystemFontOfSize:18];
			otherButton.titleLabel.shadowColor	=	[UIColor blackColor];
			otherButton.titleLabel.shadowOffset	=	CGSizeMake(0, 1.0);
			otherButton.tag						=	kOtherButtonIndex;
			[otherButton addTarget:self 
							action:@selector(_otherButtonPressed:) 
				  forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:otherButton];
			[otherButton release];
		}
	}
	return self;
}
- (void)_viewDecoration
{
	CAGradientLayer	*	gradient		=	[CAGradientLayer layer];
	gradient.frame						=	self.bounds;
	gradient.colors						=	[NSArray arrayWithObjects:
											 (id)[[UIColor blackColor] CGColor],
											 (id)[[UIColor colorWithRed:(CGFloat)(57.0/255.0) 
																  green:(CGFloat)(143.0/255.0) 
																   blue:(CGFloat)(47.0/255.0) 
																  alpha:0.9] CGColor],
											 (id)[[UIColor colorWithRed:(CGFloat)(112.0/255.0) 
																  green:(CGFloat)(174.0/255.0) 
																   blue:(CGFloat)(36.0/255.0) 
																  alpha:0.9] CGColor], nil];
	[self.layer insertSublayer:gradient atIndex:0];
	self.layer.cornerRadius				=	10;
	self.layer.masksToBounds			=	YES;
	self.layer.borderColor				=	[[UIColor whiteColor] CGColor];
	self.layer.borderWidth				=	1.0f;
}
- (void)dealloc 
{
	_delegate = nil;
	[_title release];
	[_message release];
	[_cancelButtonTitle release];
	[_otherButtonTitle release];
    [super dealloc];
}
- (void)_cancelButtonPressed:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
		[self.delegate alertView:self clickedButtonAtIndex:kCancelButtonIndex];
	[self _dismiss:sender];
}
- (void)_otherButtonPressed:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
		[self.delegate alertView:self clickedButtonAtIndex:kOtherButtonIndex];
	[self _dismiss:sender];
}
- (void)_dismiss:(id)sender
{
	if (sender && [self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)])
	{
		NSInteger	buttonIndex	=	[(UIButton *)sender tag];
		[self.delegate alertView:self willDismissWithButtonIndex:buttonIndex];
	}
	[self removeFromSuperview];
	if (sender && [self.delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)])
	{
		NSInteger	buttonIndex	=	[(UIButton *)sender tag];
		[self.delegate alertView:self didDismissWithButtonIndex:buttonIndex];
	}
}
- (void)show
{
	if ([self.delegate respondsToSelector:@selector(willPresentAlertView:)])
		[self.delegate willPresentAlertView:self];
	UIWindow* window = [UIApplication sharedApplication].keyWindow;
	if (!window)
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	[window addSubview:self];
	if ([self.delegate respondsToSelector:@selector(didPresentAlertView:)])
		[self.delegate didPresentAlertView:self];
}
- (void)dismiss
{
	[self _dismiss:nil];
}

@end
