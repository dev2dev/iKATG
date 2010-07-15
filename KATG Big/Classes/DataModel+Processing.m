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
#ifdef __IPHONE_4_0
	if (entries && entries.count > 0)
	{
		BOOL (^futureTest)(NSDate *date);
		futureTest	=	^ (NSDate *date) {
			NSInteger	timeSince	=	[date timeIntervalSinceNow];
			NSInteger	threshHold	=	-(60/*Seconds*/ * 60 /*Minutes*/ * 12 /*Hours*/);
			BOOL		inFuture	=	(timeSince > threshHold);
			return inFuture;
		};
		NSDictionary * (^dateFormatters)(NSDictionary *event);
		dateFormatters	=	^ (NSDictionary *event) {
			NSDictionary	*	dateTimes = nil;
			NSString		*	eventTimeString	=	[event objectForKey:@"StartDate"];
			NSDate			*	eventDateTime	=	[formatter dateFromString:eventTimeString];
			NSString		*	eventDay		=	[dayFormatter stringFromDate:eventDateTime];
			NSString		*	eventDate		=	[dateFormatter stringFromDate:eventDateTime];
			NSString		*	eventTime		=	[timeFormatter stringFromDate:eventDateTime];
			if (eventDateTime &&
				eventDay &&
				eventDate &&
				eventTime)
			{
				dateTimes =
				[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
													 eventDateTime, 
													 eventDay, 
													 eventDate, 
													 eventTime, nil] 
											forKeys:[NSArray arrayWithObjects:
													 @"DateTime",
													 @"Day",
													 @"Date",
													 @"Time", nil]];
			}
			else
			{
				ESLog(@"Date Formatting Failed");
			}
			return dateTimes;
		};
		NSNumber * (^detectShowType)(NSDictionary *event);
		detectShowType	=	^(NSDictionary *event) {
			if ([[event objectForKey:@"Title"] rangeOfString:@"Live Show"].location != NSNotFound)
				return [NSNumber numberWithBool:YES];
			else
				return [NSNumber numberWithBool:NO];
		};
		BOOL (^hasEvent)(NSFetchRequest *request, NSString *eventID);
		hasEvent		=	^(NSFetchRequest *request, NSString *eventID) {
			if (eventID == nil)
				return NO;
			NSPredicate	*	predicate		=
			[NSPredicate predicateWithFormat:@"EventID like %@", eventID];
			[request setPredicate:predicate];
			NSError		*	error;
			NSArray		*	fetchResults	=
			[managedObjectContext executeFetchRequest:request 
												error:&error];
			if (fetchResults == nil)
			{	// Handle Error
				ESLog(@"Core Data Error %@", error);
			}
			if (fetchResults.count > 0)
				return YES;
			return NO;
		};
		
		NSFetchRequest		*	request	=	[[NSFetchRequest alloc] init];
		NSEntityDescription	*	entity	=
		[NSEntityDescription entityForName:@"Event" 
					inManagedObjectContext:managedObjectContext];
		[request setEntity:entity];
		[request setFetchLimit:1];
		
		[coreDataOperationQueue addOperationWithBlock:^(void) {
			for (NSDictionary *event in entries)
			{
				NSDictionary*	dateTimes		=	dateFormatters(event);
				NSDate		*	dateTime		=	[dateTimes objectForKey:@"DateTime"];
				NSString	*	title			=	[event objectForKey:@"Title"];
				NSString	*	eventID			=	[event objectForKey:@"EventId"];
				
				if (futureTest(dateTime) &&
					title != nil &&
					!hasEvent(request, eventID))
				{
					Event		*	managedEvent	=
					(Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" 
														   inManagedObjectContext:managedObjectContext];
					[managedEvent setTitle:title];
					[managedEvent setEventID:eventID];
					[managedEvent setDateTime:dateTime];
					
					NSString	*	details		=	[event objectForKey:@"Details"];
					if (!details || [details isEqualToString:@"NULL"]) details	=	@"";
					[managedEvent setDetails:details];
					
					NSString	*	day			=	[dateTimes objectForKey:@"Day"];
					if (!day)		day			=	@"";
					[managedEvent setDay:day];
					
					NSString	*	date		=	[dateTimes objectForKey:@"Date"];
					if (!date)		date		=	@"";
					[managedEvent setDate:date];
					
					NSString	*	time		=	[dateTimes objectForKey:@"Time"];
					if (!time)		time		=	@"";
					[managedEvent setTime:time];
					
					NSNumber	*	showType	=	detectShowType(event);
					if (!showType)	showType	=	[NSNumber numberWithBool:YES];
					[managedEvent setShowType:showType];
					
					NSError *error;
					if (![managedObjectContext save:&error])
					{	// Handle Error
						NSLog(@"Core Data Error %@", error);
					}
				}
			}
		}];
	}
#elif __IPHONE_3_2
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
#endif
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
#pragma mark Show Archives
#pragma mark -
/******************************************************************************/
- (void)procesShowsList:(NSArray *)entries
{
	NSFetchRequest		*	request	=	[[NSFetchRequest alloc] init];
	NSEntityDescription	*	entity	=
	[NSEntityDescription entityForName:@"Show" 
				inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	[request setFetchLimit:1];
	
	if (entries && entries.count > 0)
	{
		[coreDataOperationQueue addOperationWithBlock: ^(void) {
			for (NSDictionary *show in entries)
			{
				NSString	*	ID				=	[show objectForKey:@"I"];
				
				if ([self hasShow:request forID:[NSNumber numberWithInt:[ID intValue]]])
					continue;
				
				Show	*	managedShow = 
				(Show *)[NSEntityDescription insertNewObjectForEntityForName:@"Show" 
													  inManagedObjectContext:self.managedObjectContext];
				
				NSString	*	guests			=	[show objectForKey:@"G"];
				NSString	*	number			=	[show objectForKey:@"N"];
				NSString	*	pictureCount	=	[show objectForKey:@"P"];
				NSString	*	hasShowNotes	=	[show objectForKey:@"SN"];
				NSString	*	title			=	[show objectForKey:@"T"];
				NSString	*	isKATGTV		=	[show objectForKey:@"TV"];
				
				if (guests)
				{
					NSArray	*	guestArray	=	[guests componentsSeparatedByString:@","];
					if (guestArray)
					{
						for (NSString *guest in guestArray)
						{
							Guest	*	managedGuest	=
							(Guest *)[NSEntityDescription insertNewObjectForEntityForName:@"Guest" 
																   inManagedObjectContext:self.managedObjectContext];
							
							[managedGuest addShowObject:managedShow];
							
							[managedGuest setGuest:guest];
							
							[managedShow addGuestsObject:managedGuest];
						}
					}
				}
				if (ID)
				{
					NSInteger	idInt	=	[ID intValue];
					[managedShow setID:[NSNumber numberWithInt:idInt]];
				}
				if (number)
				{
					NSInteger	numInt	=	[number intValue];
					[managedShow setNumber:[NSNumber numberWithInt:numInt]];
				}
				if (pictureCount)
				{
					NSInteger	picCnt	=	[pictureCount intValue];
					[managedShow setPictureCount:[NSNumber numberWithInt:picCnt]];
				}
				if (hasShowNotes)
				{
					BOOL	hasShwNts	=	[hasShowNotes boolValue];
					[managedShow setHasNotes:[NSNumber numberWithBool:hasShwNts]];
				}
				if (title)
				{
					[managedShow setTitle:title];
				}
				if (isKATGTV)
				{
					BOOL	isTV	=	[isKATGTV boolValue];
					[managedShow setTV:[NSNumber numberWithBool:isTV]];
				}
				
				NSError	*	error;
				if (![self.managedObjectContext save:&error])
				{	// Handle Error
					ESLog(@"Core Data Error %@", error);
				}
			}
			[self fetchShows];
		}];
	}
	[request release];
}
- (BOOL)hasShow:(NSFetchRequest *)request forID:(NSNumber *)ID
{
	NSPredicate	*	predicate	=
	[NSPredicate predicateWithFormat:@"ID == %@", ID];
	[request setPredicate:predicate];
	NSError		*	error;
	NSArray		*	fetchResults	=
	[managedObjectContext executeFetchRequest:request 
										 error:&error];
	if (fetchResults == nil)
	{	// Handle Error
		NSLog(@"%@", error);
	}
	if (fetchResults.count > 0)
		return YES;
	return NO;
}
- (void)fetchShows
{
	NSFetchRequest		*	request	=	[[NSFetchRequest alloc] init];
	NSEntityDescription	*	entity	=
	[NSEntityDescription entityForName:@"Show" 
				inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	NSSortDescriptor	*	sortDescriptor	=
	[[NSSortDescriptor alloc] initWithKey:@"ID" ascending:NO];
	NSArray				*	sortDescriptors	=
	[[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	NSError				*	error;
	NSMutableArray		*	fetchResults	=
	[[managedObjectContext executeFetchRequest:request 
										 error:&error] mutableCopy];
	if (fetchResults == nil)
	{	// Handle Error
		NSLog(@"%@", error);
	}
	
	[self performSelectorOnMainThread:@selector(notifyShows:) 
						   withObject:(NSArray *)fetchResults
						waitUntilDone:NO];
	
	[fetchResults release];
	[request release];
}

@end
