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

//
//  In order to avoid mutation during Enumeration
//  notify methods add dlgts to a retaining array
//  if they are able to respond and then enumerate
//  accross that array.
//  Notify methods are also pushed to the main
//  thread so that there's no need for view to 
//  check for thread safety as it uses data returned.
//

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
/******************************************************************************/
#pragma mark -
#pragma mark Live Show Status
#pragma mark -
/******************************************************************************/
- (void)notifyLiveShowStatus:(NSString *)status
{
	if ([NSThread isMainThread])
	{
		BOOL onAir	=	[status boolValue];
		if (notifier)
		{
			//[[NSNotificationCenter defaultCenter] 
			// postNotificationName: 
			// object:];
		}
		NSMutableArray *dlgts = [[NSMutableArray alloc] init];
		for (id delegate in delegates)
		{
			if ([(NSObject *)delegate respondsToSelector:@selector(liveShowStatus:)])
			{
				[dlgts addObject:delegate];
			}
		}
		for (id delegate in dlgts)
		{
			[delegate liveShowStatus:onAir];
		}
		[dlgts release];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(notifyLiveShowStatus:) 
							   withObject:status 
							waitUntilDone:NO];
	}
}

@end
