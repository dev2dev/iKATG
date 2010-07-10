//
//  RoundedButton.m
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

#import "RoundedButton.h"
#import "UIColor+Additions.h"
#import <QuartzCore/QuartzCore.h>

@interface RoundedButton (Private)
- (void)setup;
@end

@implementation RoundedButton
@synthesize highlightColor;

#pragma mark -
#pragma mark Init
#pragma mark -
- (id)init
{
	if (self = [super init])
	{
		[self setup];
	}
	return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		[self setup];
	}
	return self;
}
- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		[self setup];
	}
	return self;
}
- (void)setup
{
	highlightColor = nil;
	initialBackgroundColor = nil;
	self.layer.cornerRadius = 10.0;
	self.layer.borderWidth = 2.0;
	self.layer.borderColor = 
	[[UIColor colorWithRed:0.4 
					green:0.4 
					 blue:0.4 
					alpha:0.8] CGColor];
}
#pragma mark -
#pragma mark Touch Events
#pragma mark -
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	BOOL beginTracking = [super beginTrackingWithTouch:touch withEvent:event];
	if (initialBackgroundColor == nil)
		initialBackgroundColor = [[self backgroundColor] retain];
	if (highlightColor != nil)
		[self setBackgroundColor:highlightColor];
	return beginTracking;
}
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[super endTrackingWithTouch:touch withEvent:event];
	[self setBackgroundColor:initialBackgroundColor];
}
- (void)cancelTrackingWithEvent:(UIEvent *)event
{
	// probably need a super here
	[self setBackgroundColor:initialBackgroundColor];
}
#pragma mark -
#pragma mark Cleanup
#pragma mark -
- (void)dealloc
{
	[initialBackgroundColor release];
	[highlightColor release];
	[super dealloc];
}

@end
