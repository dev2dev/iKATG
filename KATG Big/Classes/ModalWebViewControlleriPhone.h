//
//  ModalWebViewControlleriPhone.h
//  KATG Big
//
//  Created by Doug Russell on 6/23/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "ModalWebViewController.h"
#import <iAd/iAd.h>

@interface ModalWebViewControlleriPhone : ModalWebViewController 
{
	ADBannerView *adBanner;
}

@property (nonatomic, retain) IBOutlet ADBannerView *adBanner;

@end
