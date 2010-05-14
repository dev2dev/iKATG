//
//  UIColor+Additions.h
//  KATG Big
//
//  Created by Doug Russell on 5/11/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import <UIKit/UIKit.h>

struct hsv_color {
	CGFloat hue;
	CGFloat sat;
	CGFloat val;
};
struct rgba_color {
	CGFloat r;
	CGFloat g;
	CGFloat b;
	CGFloat a;
};

@interface UIColor (Additions)

+ (struct hsv_color)HSVfromRGB:(struct rgba_color)rgb;
+ (struct rgba_color)RGBAWithColor:(UIColor *)color;

//Based on http://www.drobnik.com/touch/2009/10/manipulating-uicolors/

- (UIColor *)colorByDarkeningColor;
- (UIColor *)colorByLighteningColor;
- (UIColor *)colorByChangingBrightness:(CGFloat)multiplier;
- (UIColor *)colorByChangingAlphaTo:(CGFloat)newAlpha;

@end
