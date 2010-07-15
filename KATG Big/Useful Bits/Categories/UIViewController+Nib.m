//
//  UIViewController+Nib.m
//  PartyCamera
//
//  Created by Doug Russell on 6/17/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "UIViewController+Nib.h"

@implementation UIViewController (Nib)
+ (id)loadFromNibName:(NSString *)nibNameOrNil 
				owner:(id)ownerOrNil
{
	return [self loadFromNibName:nibNameOrNil owner:ownerOrNil bundle:nil options:nil];
}
+ (id)loadFromNibName:(NSString *)nibNameOrNil 
				owner:(id)ownerOrNil 
			   bundle:(NSBundle *)bundleOrNil 
			  options:(NSDictionary *)optionsOrNil
{
#ifdef __IPHONE_4_0
	UINib	*	NIB		=	[UINib nibWithNibName:nibNameOrNil bundle:bundleOrNil];
	NSArray	*	nib		=	[NIB instantiateWithOwner:ownerOrNil options:optionsOrNil];
#elif __IPHONE_3_2
	NSArray	*	nib		=	[[NSBundle mainBundle] loadNibNamed:nibNameOrNil 
												   owner:ownerOrNil 
												 options:nil];
#endif
	return [nib objectAtIndex:0];
}
@end

@implementation UIView (Nib)
+ (id)loadFromNibName:(NSString *)nibNameOrNil 
				owner:(id)ownerOrNil
{
	return [self loadFromNibName:nibNameOrNil owner:ownerOrNil bundle:nil options:nil];
}
+ (id)loadFromNibName:(NSString *)nibNameOrNil 
				owner:(id)ownerOrNil 
			   bundle:(NSBundle *)bundleOrNil 
			  options:(NSDictionary *)optionsOrNil
{
#ifdef __IPHONE_4_0
	UINib	*	NIB		=	[UINib nibWithNibName:nibNameOrNil bundle:bundleOrNil];
	NSArray	*	nib		=	[NIB instantiateWithOwner:ownerOrNil options:optionsOrNil];
#elif __IPHONE_3_2
	NSArray	*	nib		=	[[NSBundle mainBundle] loadNibNamed:nibNameOrNil 
												   owner:ownerOrNil 
												 options:nil];
#endif
	return [nib objectAtIndex:0];
}
@end
