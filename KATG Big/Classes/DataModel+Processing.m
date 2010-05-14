//
//  DataModel+Processing.m
//  KATG Big
//
//  Created by Doug Russell on 5/5/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "DataModel+Processing.h"
#import "EventOperation.h"

@implementation DataModel (Processing)

- (void)processEventsList:(NSArray *)entries
{
	if (entries && entries.count > 0)
	{
		eventCount += entries.count;
		for (NSDictionary *event in entries)
		{
			EventOperation *op = [[EventOperation alloc] initWithEvent:event];
			[op setDelegate:self];
			// Setters are (nonatomic, copy)
			// each op will get their own
			// instance of each formatter
			[op setFormatter:formatter];
			[op setDayFormatter:dayFormatter];
			[op setDateFormatter:dateFormatter];
			[op setTimeFormatter:timeFormatter];
			[operationQueue addOperation:op];
			[op release];
		}
//		[self performSelectorOnMainThread:@selector(startTimer) 
//							   withObject:nil 
//							waitUntilDone:NO];
	}
}
- (void)eventOperationDidFinishSuccesfully:(EventOperation *)op;
{
	[self performSelectorOnMainThread:@selector(addToEvents:) 
						   withObject:[[op event] copy] 
						waitUntilDone:NO];
}
- (void)addToEvents:(NSDictionary *)event
{
	[events addObject:event];
	eventCount -= 1;
	if (eventCount == 0)
	{
		[events sortUsingSelector:@selector(compareByDateAscending:)];
		if (notifier)
		{
			//[[NSNotificationCenter defaultCenter] 
			// postNotificationName: 
			// object:];
		}
		for (id delegate in delegates)
		{
			if ([(NSObject *)delegate respondsToSelector:@selector(events:)])
			{
				[delegate events:[events copy]];
			}
		}
	}
}
- (void)processLiveShowStatus:(NSArray *)entries
{
	if (entries && entries.count > 0)
	{
		NSDictionary *status = [entries objectAtIndex:0];
		if (status)
		{
			BOOL onAir = [[status objectForKey:@"OnAir"] boolValue];
			if (notifier)
			{
				//[[NSNotificationCenter defaultCenter] 
				// postNotificationName: 
				// object:];
			}
			for (id delegate in delegates)
			{
				if ([(NSObject *)delegate respondsToSelector:@selector(liveShowStatus:)])
				{
					[delegate liveShowStatus:onAir];
				}
			}
		}
	}
}

@end

@interface NSMutableArray (eventsorting)
- (NSComparisonResult)compareByDateAscending:(id)event;
- (NSComparisonResult)compareByDateDescending:(id)event;
@end

@implementation NSDictionary (EventSorting)
- (NSComparisonResult)compareByDateAscending:(id)event 
{
	int selfTime = [[self objectForKey:@"DateTime"] timeIntervalSinceNow];
	int otherTime = [[event objectForKey:@"DateTime"] timeIntervalSinceNow];
	NSComparisonResult result = NSOrderedSame;
	if (selfTime < otherTime) {
		result = NSOrderedAscending;
	} else if (selfTime > otherTime) {
		result = NSOrderedDescending;
	}
	return result;
}
- (NSComparisonResult)compareByDateDescending:(id)event 
{
	int selfTime = [[self objectForKey:@"DateTime"] timeIntervalSinceNow];
	int otherTime = [[event objectForKey:@"DateTime"] timeIntervalSinceNow];
	NSComparisonResult result = NSOrderedSame;
	if (selfTime < otherTime) {
		result = NSOrderedDescending;
	} else if (selfTime > otherTime) {
		result = NSOrderedAscending;
	}
	return result;
}
@end
