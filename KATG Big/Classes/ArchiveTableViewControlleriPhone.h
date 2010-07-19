//
//  ArchiveViewControlleriPhone.h
//  KATG Big
//
//  Created by Doug Russell on 7/11/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "ArchiveTableViewController.h"

@interface ArchiveTableViewControlleriPhone : ArchiveTableViewController 
{
	UIActivityIndicatorView	*	activityIndicator;
}

@property (nonatomic, retain)	UIActivityIndicatorView	*	activityIndicator;

@end
