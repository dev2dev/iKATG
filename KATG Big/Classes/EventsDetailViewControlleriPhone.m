//
//  EventsDetailViewControlleriPhone.m
//  KATG Big
//
//  Created by Doug Russell on 6/9/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "EventsDetailViewControlleriPhone.h"
#import "ModalWebViewController.h"

@implementation EventsDetailViewControlleriPhone

- (void)modalWebViewController:(NSURLRequest *)request
{
	ModalWebViewController *modalWebViewController = 
	[[ModalWebViewController alloc] initWithNibName:@"ModalWebViewiPhone" 
											 bundle:nil];
	[modalWebViewController setRequest:request];
	[modalWebViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	[self presentModalViewController:modalWebViewController 
							animated:YES];
	[modalWebViewController release];
}

@end
