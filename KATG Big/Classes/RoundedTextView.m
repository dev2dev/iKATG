//
//  RoundedTextView.m
//  PartyCamera
//
//  Created by Doug Russell on 3/26/10.
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

#import "RoundedTextView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RoundedTextView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) 
	{
		[self setEditable:YES];
		[self setScrollEnabled:NO];
		[self setContentInset:UIEdgeInsetsMake(4, 4, 4, 4)];
		[self round:10];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
	{
		[self setEditable:YES];
		[self setScrollEnabled:NO];
		[self setContentInset:UIEdgeInsetsMake(4, 4, 4, 4)];
		[self round:10];
    }
    return self;
}
- (void)dealloc 
{
    [super dealloc];
}
- (void)round:(NSInteger)radius
{
	self.layer.cornerRadius = radius;
}


@end
