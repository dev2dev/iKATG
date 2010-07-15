//
//  ArchiveViewControlleriPhone.m
//  KATG Big
//
//  Created by Doug Russell on 7/11/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "ArchiveViewControlleriPhone.h"

@implementation ArchiveViewControlleriPhone

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	activityIndicator = 
	[[UIActivityIndicatorView alloc] 
	 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[activityIndicator setHidesWhenStopped:YES];
	UIBarButtonItem *button = 
	[[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	[activityIndicator release];
	[self.navigationItem setRightBarButtonItem:button];
	[button release];
	
	[activityIndicator startAnimating];
}

- (void)shows:(NSArray *)shows
{
	[super shows:shows];
	if (shows.count > 0)
		[activityIndicator stopAnimating];
}

@end
