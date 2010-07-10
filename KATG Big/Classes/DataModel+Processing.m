//
//  DataModel+Processing.m
//  KATG Big
//
//  Created by Doug Russell on 5/5/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//  http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  

#import "DataModel+Processing.h"
#import "DataModel+Notification.h"
#import "Event.h"
#import "Show.h"
#import "Guest.h"

@implementation DataModel (Processing)

/******************************************************************************/
#pragma mark -
#pragma mark Events
#pragma mark -
/******************************************************************************/
- (void)processEventsList:(NSArray *)entries
{
	//
	// Use data formatters to create localized event
	// strings and store them in core data store
	//
	//
	// Since they're running serially then
	// maybe jusr one event operation would be more
	// efficient to loop through all events
	//
	if (entries && entries.count > 0)
	{
		eventCount += entries.count;
		for (NSDictionary *event in entries)
		{
			EventOperation *op = [[EventOperation alloc] initWithEvent:event];
			[op setDelegate:self];
			//
			// Setters are (nonatomic, assign)
			// NSDateFormatters are not thread safe
			// but coreDataOperationQueue has
			// a max concurrent operations count
			// of 1 because core data is not thread
			// safe
			//
			[op setFormatter:formatter];
			[op setDayFormatter:dayFormatter];
			[op setDateFormatter:dateFormatter];
			[op setTimeFormatter:timeFormatter];
			[coreDataOperationQueue addOperation:op];
			[op release];
		}
	}
}
- (void)eventOperationDidFinishSuccesfully:(EventOperation *)op;
{
	//
	// Monitor active eventOperations
	// and trigger fetch when count drops
	// to zero
	//
	eventCount -= 1;
	if (eventCount == 0)
	{
		[self fetchEvents];
	}
}
- (void)eventOperationDidFail
{
	
}
- (void)fetchEvents
{
	//
	// Fetch events from Core Data store
	// sorted by NSDate object DateTime
	//
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = 
	[NSEntityDescription entityForName:@"Event" 
				inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	NSSortDescriptor *sortDescriptor = 
	[[NSSortDescriptor alloc] initWithKey:@"DateTime" ascending:YES];
	NSArray *sortDescriptors = 
	[[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	NSError *error;
	NSMutableArray *fetchResults = 
	[[managedObjectContext executeFetchRequest:request 
										 error:&error] mutableCopy];
	if (fetchResults == nil)
	{	// Handle Error
		NSLog(@"Core Data Error %@", error);
	}
	//
	// Remove any duplicate events
	//
	NSArray *uniquedResults = 
	[self removeEventDuplicates:fetchResults];
	//
	// Notify delegates that event data
	// is available
	//
	[self performSelectorOnMainThread:@selector(notifyEvents:) 
						   withObject:uniquedResults 
						waitUntilDone:NO];
	
	[fetchResults release];
	[request release];
}
- (NSArray *)removeEventDuplicates:(NSMutableArray *)array
{
	//
	// Remove any duplicate events
	// and any events in the past
	// more than 12 hours
	//
	//
	// Might be worth testing
	// using just a set and
	// using sortwithdescriptors
	// and DateTime to put things
	// back in order
	//
	NSMutableArray	*	eventArray = 
	[[NSMutableArray alloc] initWithCapacity:array.count];
	NSMutableSet	*	eventSet =
	[[NSMutableSet alloc] initWithCapacity:array.count];
#ifdef __IPHONE_4_0
	//
	// Need to test that performing future test is
	// actually faster than just doing it in the loop
	// checking for inSet
	//
	BOOL (^futureTest)(id obj, NSUInteger idx, BOOL *stop);
	futureTest	=	^ (id obj, NSUInteger idx, BOOL *stop) 
	{
		NSInteger timeSince		=	[[(Event *)obj DateTime] timeIntervalSinceNow];
		NSInteger threshHold	=	-(60/*Seconds*/ * 60 /*Minutes*/ * 12 /*Hours*/);
		BOOL inFuture			=	timeSince > threshHold;
		return inFuture;
	};
	NSIndexSet	*	futureIndexes	=	[array indexesOfObjectsWithOptions:NSEnumerationConcurrent 
														passingTest:futureTest];
	for (Event *event in [array objectsAtIndexes:futureIndexes])
	{
		BOOL inSet = [eventSet containsObject:event.EventID];
		if (!inSet)
		{
			[eventSet addObject:event.EventID];
			[eventArray addObject:event];
		}
		else
		{
			//NSLog(@"Delete: %@", [event EventID]);
			[managedObjectContext deleteObject:event];
			NSError *error;
			if (![managedObjectContext save:&error])
			{	// Handle Error
				NSLog(@"Core Data Error %@", error);
			}
		}
	}
#else
	//
	// Loop for the sad sad life before
	// blocks
	//
	for (Event *event in array)
	{
		BOOL inSet		=	[eventSet containsObject:event.EventID];
		BOOL inFuture	=	[[event DateTime] timeIntervalSinceNow] < -(60/*Seconds*/ * 60 /*Minutes*/ * 12 /*Hours*/);
		if (!inSet && !inFuture)
		{
			[eventSet addObject:event.EventID];
			[eventArray addObject:event];
		}
		else
		{
			//NSLog(@"Delete: %@", [event EventID]);
			[managedObjectContext deleteObject:event];
			NSError *error;
			if (![managedObjectContext save:&error])
			{	// Handle Error
				NSLog(@"Core Data Error %@", error);
			}
		}
	}
#endif
	[eventSet release];
	return [(NSArray *)eventArray autorelease];
}
/******************************************************************************/
#pragma mark -
#pragma mark Live Show Status
#pragma mark -
/******************************************************************************/
- (void)processLiveShowStatus:(NSArray *)entries
{
	//
	// Shoutcast feed status
	//
	if (entries && entries.count > 0)
	{
		NSDictionary *status = [entries objectAtIndex:0];
		if (status)
		{
			NSString *onAir = [status objectForKey:@"OnAir"];
			[self performSelectorOnMainThread:@selector(notifyLiveShowStatus:) 
								   withObject:onAir 
								waitUntilDone:NO];
		}
	}
}
/******************************************************************************/
#pragma mark -
#pragma mark Shows
#pragma mark -
/******************************************************************************/
- (void)procesShowsList:(NSArray *)entries
{
	if (entries && entries.count > 0)
	{
		ShowOperation	*	op	=
		[[ShowOperation alloc] initWithShows:entries];
		op.delegate = self;
		[coreDataOperationQueue addOperation:op];
		[op release];
	}
}
- (void)showOperationDidFinishSuccesfully:(ShowOperation *)op
{
	[self fetchShows];
}
- (void)showOperationDidFail
{
	
}
- (void)fetchShows
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = 
	[NSEntityDescription entityForName:@"Show" 
				inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	NSSortDescriptor *sortDescriptor = 
	[[NSSortDescriptor alloc] initWithKey:@"Number" ascending:YES];
	NSArray *sortDescriptors = 
	[[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	NSError *error;
	NSMutableArray *fetchResults = 
	[[managedObjectContext executeFetchRequest:request 
										 error:&error] mutableCopy];
	if (fetchResults == nil)
	{	// Handle Error
		NSLog(@"%@", error);
	}
	
	[fetchResults release];
	[request release];
}

@end
