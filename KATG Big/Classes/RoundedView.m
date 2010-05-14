//
//  RoundedView.m
//  KATG Big
//
//  Created by Doug Russell on 5/3/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "RoundedView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RoundedView
- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) 
	{
		self.layer.cornerRadius = 10;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame])) 
	{
		self.layer.cornerRadius = 10;
    }
    return self;
}
- (void)dealloc 
{
    [super dealloc];
}

@end
