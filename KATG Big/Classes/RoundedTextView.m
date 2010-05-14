//
//  RoundedTextView.m
//  PartyCamera
//
//  Created by Doug Russell on 3/26/10.
//  Copyright 2010 Doug Russell. All rights reserved.
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
