//
//  UIColor+Additions.m
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

#import "UIColor+Additions.h"

CGFloat MIN3(CGFloat one, CGFloat two, CGFloat three) {
	CGFloat min1 = MIN(one, two);
	CGFloat min2 = MIN(two, three);
	return MIN(min1, min2);
};
CGFloat MAX3(CGFloat one, CGFloat two, CGFloat three) {
	CGFloat max1 = MAX(one, two);
	CGFloat max2 = MAX(two, three);
	return MAX(max1, max2);
};

@implementation UIColor (Additions)

#pragma mark -
#pragma mark Brightness
#pragma mark -
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
#pragma mark -
#pragma mark Alpha
#pragma mark -
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
#pragma mark -
#pragma mark HSV
#pragma mark -
+ (struct hsv_color)HSVfromRGB:(struct rgba_color)rgb
{
	struct hsv_color hsv;
	
	CGFloat rgb_min, rgb_max;
	
	hsv.val = rgb_max;
	if (hsv.val == 0) {
		hsv.hue = hsv.sat = 0;
		return hsv;
	}
	
	rgb.r /= hsv.val;
	rgb.g /= hsv.val;
	rgb.b /= hsv.val;
	rgb_min = MIN3(rgb.r, rgb.g, rgb.b);
	rgb_max = MAX3(rgb.r, rgb.g, rgb.b);
	
	hsv.sat = rgb_max - rgb_min;
	if (hsv.sat == 0) {
		hsv.hue = 0;
		return hsv;
	}
	
	if (rgb_max == rgb.r) {
		hsv.hue = 0.0 + 60.0*(rgb.g - rgb.b);
		if (hsv.hue < 0.0) {
			hsv.hue += 360.0;
		}
	} else if (rgb_max == rgb.g) {
		hsv.hue = 120.0 + 60.0*(rgb.b - rgb.r);
	} else /* rgb_max == rgb.b */ {
		hsv.hue = 240.0 + 60.0*(rgb.r - rgb.g);
	}
	
	return hsv;
}
+ (struct rgba_color)RGBAWithColor:(UIColor *)color 
{
	struct rgba_color rgba;
	rgba.r = 0; rgba.g = 0; rgba.b = 0; rgba.a = 0;
	CGColorSpaceRef colorSpace = CGColorGetColorSpace([color CGColor]);
	// need to release rgb color space
	CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
	if (colorSpace == rgbColorSpace)
	{
		const CGFloat *components = (CGFloat *)CGColorGetComponents([color CGColor]);
		int numComponents = CGColorGetNumberOfComponents([color CGColor]);
		if (numComponents == 4)
		{
			rgba.r = components[0];
			rgba.g = components[1];
			rgba.b = components[2];
			rgba.a = components[3];
		}
	}
	CFRelease(rgbColorSpace);
	return rgba;
}
- (CGFloat)hue
{
	struct hsv_color hsv;
	struct rgba_color rgba;
	rgba = [UIColor RGBAWithColor:self];
	if (rgba.r + rgba.g +rgba.b + rgba.a != 0)
	{
		hsv = [UIColor HSVfromRGB:rgba];
		return (hsv.hue / 360.0);
	}
	return 0;
}
- (CGFloat)saturation
{
	struct hsv_color hsv;
	struct rgba_color rgba;
	rgba = [UIColor RGBAWithColor:self];
	if (rgba.r + rgba.g +rgba.b + rgba.a != 0)
	{
		hsv = [UIColor HSVfromRGB:rgba];
		return hsv.sat;
	}
	return 0;
}
- (CGFloat)brightness
{
	struct hsv_color hsv;
	struct rgba_color rgba;
	rgba = [UIColor RGBAWithColor:self];
	if (rgba.r + rgba.g +rgba.b + rgba.a != 0)
	{
		hsv = [UIColor HSVfromRGB:rgba];
		return hsv.val;
	}
	return 0;
}
- (CGFloat)value
{
	return [self brightness];
}

@end
