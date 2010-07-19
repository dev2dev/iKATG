//
//  ArchiveViewControlleriPhone.m
//  KATG Big
//
//  Created by Doug Russell on 7/11/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "ArchiveTableViewControlleriPhone.h"

@implementation ArchiveTableViewControlleriPhone
@synthesize activityIndicator;

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	UIActivityIndicatorView	*	anActivityIndicator	=	[[UIActivityIndicatorView alloc] 
														 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	if (anActivityIndicator)
	{
		self.activityIndicator						=	anActivityIndicator;
		[anActivityIndicator release];
		[self.activityIndicator setHidesWhenStopped:YES];
		UIBarButtonItem		*	button				=	[[UIBarButtonItem alloc] 
														 initWithCustomView:activityIndicator];
		[self.navigationItem setRightBarButtonItem:button];
		[button release];
		
		[self.activityIndicator startAnimating];
	}
}

- (void)shows:(NSArray *)shows
{
	[super shows:shows];
	if (shows.count > 0)
		[self.activityIndicator stopAnimating];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	self.activityIndicator	=	nil;
}
- (void)dealloc
{
	[activityIndicator release];
	[super dealloc];
}

@end
