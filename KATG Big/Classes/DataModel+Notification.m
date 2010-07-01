//
//  DataModel+Notification.m
//  KATG Big
//
//  Created by Doug Russell on 6/30/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "DataModel+Notification.h"
#import "DataModel+Processing.h"

@implementation DataModel (Notification)

/******************************************************************************/
#pragma mark -
#pragma mark Events
#pragma mark -
/******************************************************************************/
- (void)notifyEvents:(NSArray *)events
{
	if ([NSThread isMainThread])
	{
		if (notifier)
		{
			//[[NSNotificationCenter defaultCenter] 
			// postNotificationName: 
			// object:];
		}
		NSMutableArray *dlgts = [[NSMutableArray alloc] init];
		for (id delegate in delegates)
		{
			if ([(NSObject *)delegate respondsToSelector:@selector(events:)])
			{
				[dlgts addObject:delegate];
			}
		}
		for (id delegate in dlgts)
		{
			[delegate events:events];
		}
		[dlgts release];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(notifyEvents:) 
							   withObject:events 
							waitUntilDone:NO];
	}
}

@end
