//
//  EventsTableViewControlleriPhone.h
//  KATG Big
//
//  Created by Doug Russell on 6/9/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import <iAd/iAd.h>

@interface EventsTableViewControlleriPhone : UITableViewController 
<DataModelDelegate, ADBannerViewDelegate>
{
	DataModel		*	model;
	NSArray			*	eventsList;
	ADBannerView	*	adView;
}

@property (nonatomic, retain)	NSArray			*	eventsList;
@property (nonatomic, retain)	ADBannerView	*	adView;

@end
