//
//  RoundedTextField.m
//  KATG Big
//
//  Created by Doug Russell on 5/11/10.
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

#import "RoundedTextField.h"
#import <QuartzCore/QuartzCore.h>

@implementation RoundedTextField

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		[self setup];
	}
	return self;
}
- (id)initWithFrame:(CGRect)aRect
{
	if (self = [super initWithFrame:aRect])
	{
		[self setup];
	}
	return self;
}
- (void)setup
{
	self.layer.cornerRadius = 4;
	// need to inset cursor a few pixels
}
- (void)dealloc
{
	[super dealloc];
}

@end
