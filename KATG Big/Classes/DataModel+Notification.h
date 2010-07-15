//
//  DataModel+Notification.h
//  KATG Big
//
//  Created by Doug Russell on 6/30/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "DataModel.h"

@interface DataModel (Notification)

- (void)notifyEvents:(NSArray *)events;
- (void)notifyLiveShowStatus:(NSString *)status;
- (void)notifyShows:(NSArray *)shows;

@end
