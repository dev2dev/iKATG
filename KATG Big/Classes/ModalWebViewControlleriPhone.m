//
//  ModalWebViewControlleriPhone.m
//  KATG Big
//
//  Created by Doug Russell on 6/23/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "ModalWebViewControlleriPhone.h"

@implementation ModalWebViewControlleriPhone
@synthesize adBanner;

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
        self.adBanner.currentContentSizeIdentifier =
		ADBannerContentSizeIdentifier480x32;
    else
        self.adBanner.currentContentSizeIdentifier =
		ADBannerContentSizeIdentifier320x50;
}
- (void)dealloc
{
	[adBanner release];
	[super dealloc];
}
@end
