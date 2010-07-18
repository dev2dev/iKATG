//
//  GradButton.m
//  KATG Big
//
//  Created by Doug Russell on 7/18/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//
//  Created by Doug Russell on 7/18/10.
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

#import "GradButton.h"
#import <QuartzCore/QuartzCore.h>

@interface GradButton (Private)
- (void)setup;
- (void)grad;
@end

@implementation GradButton

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
	self.layer.cornerRadius		=	10.0;
	self.layer.borderWidth		=	2.0;
	self.layer.masksToBounds	=	YES;
	self.layer.borderColor		=	[[UIColor colorWithRed:0.2 
											   green:0.4
												blue:0.2 
											   alpha:0.8] CGColor];
	[self grad];
}
- (void)grad
{
	CAGradientLayer	*	gradient	=	[CAGradientLayer layer];
	gradient.frame					=	self.bounds;
	gradient.colors					=	[NSArray arrayWithObjects:
										 (id)[[UIColor whiteColor] CGColor],
										 (id)[[UIColor colorWithRed:(CGFloat)(57.0/255.0) 
															  green:(CGFloat)(143.0/255.0) 
															   blue:(CGFloat)(47.0/255.0) 
															  alpha:1.0] CGColor],
										 (id)[[UIColor colorWithRed:(CGFloat)(112.0/255.0) 
															  green:(CGFloat)(174.0/255.0) 
															   blue:(CGFloat)(36.0/255.0) 
															  alpha:1.0] CGColor], nil];
	[self.layer insertSublayer:gradient atIndex:0];
}
#pragma mark -
#pragma mark Cleanup
#pragma mark -
- (void)dealloc
{
	[super dealloc];
}

@end
