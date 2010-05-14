//
//  RoundedButton.m
//  KATG Big
//
//  Created by Doug Russell on 5/10/10.
//  Copyright 2010 Doug Russell. All rights reserved.
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
	else
		[self setBackgroundColor:[initialBackgroundColor colorByChangingBrightness:1.2]];
	return beginTracking;
}
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[super endTrackingWithTouch:touch withEvent:event];
	[self setBackgroundColor:initialBackgroundColor];
}
- (void)cancelTrackingWithEvent:(UIEvent *)event
{
	
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

@implementation UIColor (Tools)
- (UIColor *)colorByDarkeningColor
{
	return [self colorByChangingBrightness:0.7];
}
- (UIColor *)colorByLighteningColor
{
	return [self colorByChangingBrightness:1.3];
}
- (UIColor *)colorByChangingBrightness:(CGFloat)multiplier
{
	// oldComponents is the array INSIDE the original color
	// changing these changes the original, so we copy it
	CGFloat *oldComponents = (CGFloat *)CGColorGetComponents([self CGColor]);
	CGFloat newComponents[4];
	int numComponents = CGColorGetNumberOfComponents([self CGColor]);
	switch (numComponents) 
	{
		case 2:
		{
			//grayscale
			newComponents[0] = MIN(oldComponents[0]*multiplier, 1.0);
			newComponents[1] = MIN(oldComponents[0]*multiplier, 1.0);
			newComponents[2] = MIN(oldComponents[0]*multiplier, 1.0);
			newComponents[3] = oldComponents[1];
			break;
		}
		case 4:
		{
			//RGBA
			newComponents[0] = MIN(oldComponents[0]*multiplier, 1.0);
			newComponents[1] = MIN(oldComponents[1]*multiplier, 1.0);
			newComponents[2] = MIN(oldComponents[2]*multiplier, 1.0);
			newComponents[3] = oldComponents[3];
			break;
		}
	}
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
	CGColorSpaceRelease(colorSpace);
	UIColor *retColor = [UIColor colorWithCGColor:newColor];
	CGColorRelease(newColor);
	return retColor;
}
- (UIColor *)colorByChangingAlphaTo:(CGFloat)newAlpha;
{
	// oldComponents is the array INSIDE the original color
	// changing these changes the original, so we copy it
	CGFloat *oldComponents = (CGFloat *)CGColorGetComponents([self CGColor]);
	int numComponents = CGColorGetNumberOfComponents([self CGColor]);
	CGFloat newComponents[4];
	switch (numComponents) 
	{
		case 2:
		{
			//grayscale
			newComponents[0] = oldComponents[0];
			newComponents[1] = oldComponents[0];
			newComponents[2] = oldComponents[0];
			newComponents[3] = newAlpha;
			break;
		}
		case 4:
		{
			//RGBA
			newComponents[0] = oldComponents[0];
			newComponents[1] = oldComponents[1];
			newComponents[2] = oldComponents[2];
			newComponents[3] = newAlpha;
			break;
		}
	}
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
	CGColorSpaceRelease(colorSpace);
	UIColor *retColor = [UIColor colorWithCGColor:newColor];
	CGColorRelease(newColor);
	return retColor;
}

@end
