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
			[coreDataOperationQueue addOperation:op];
			[op release];
		}
	}
}
- (void)eventOperationDidFinishSuccesfully:(EventOperation *)op;
{
	eventCount -= 1;
	if (eventCount == 0)
	{
		[self fetchEvents];
	}
}
- (void)fetchEvents
{
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
		NSLog(@"%@", error);
	}
	
	NSArray *uniquedResults = [self removeDuplicates:fetchResults];
	[self performSelectorOnMainThread:@selector(notifyEvents:) 
						   withObject:uniquedResults 
						waitUntilDone:NO];
	
	[fetchResults release];
	[request release];
}
- (NSArray *)removeDuplicates:(NSMutableArray *)array
{
	NSMutableSet *eventSet;
	eventSet = [[NSMutableSet alloc] initWithCapacity:[array count]];
	NSMutableArray *newArray;
	newArray = [[NSMutableArray alloc] init];
	for (Event *event in array)
	{
		BOOL inSet = [eventSet containsObject:[event EventID]];
		BOOL inFuture =  [[event DateTime] timeIntervalSinceNow] < 0;
		if (!inSet && !inFuture)
		{
			[eventSet addObject:[event EventID]];
			[newArray addObject:event];
		}
		else
		{
			//NSLog(@"Delete: %@", [event EventID]);
			[managedObjectContext deleteObject:event];
			NSError *error;
			if (![managedObjectContext save:&error])
			{	// Handle Error
				
			}
		}
	}
	NSArray *eventArray = [NSArray arrayWithArray:newArray];
	[newArray release];
	[eventSet release];
	return eventArray;
}
/******************************************************************************/
#pragma mark -
#pragma mark Live Show Status
#pragma mark -
/******************************************************************************/
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
/******************************************************************************/
#pragma mark -
#pragma mark Shows
#pragma mark -
/******************************************************************************/
- (void)procesShowsList:(NSArray *)entries
{
	if (entries && entries.count > 0)
	{
		
	}
	[self fetchShows];
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
	
	NSLog(@"%@", [fetchResults objectAtIndex:0]);
	
	[fetchResults release];
	[request release];
}

@end
