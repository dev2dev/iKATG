//
//  UIWebViewOpaque.m
//  KATG Big
//
//  Created by Doug Russell on 5/5/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "UIWebViewOpaque.h"

@implementation UIWebView (Opaque)
- (void)decoration
{
	[self setBackgroundColor:[UIColor clearColor]];
	[self setOpaque:NO];
}
@end
