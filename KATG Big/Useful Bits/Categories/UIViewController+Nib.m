//
//  UIViewController+Nib.m
//  PartyCamera
//
//  Created by Doug Russell on 6/17/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "UIViewController+Nib.h"

@implementation UIViewController (Nib)
+ (id)loadFromNibName:(NSString *)nibNameOrNil owner:(id)owner
{
	NSArray *nib = 
	[[NSBundle mainBundle] 
	 loadNibNamed:nibNameOrNil 
	 owner:owner 
	 options:nil];
	return [nib objectAtIndex:0];
}
@end

@implementation UIView (Nib)
+ (id)loadFromNibName:(NSString *)nibNameOrNil owner:(id)owner
{
	NSArray *nib = 
	[[NSBundle mainBundle] 
	 loadNibNamed:nibNameOrNil 
	 owner:owner 
	 options:nil];
	return [nib objectAtIndex:0];
}
@end
