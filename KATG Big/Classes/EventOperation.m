//
//  EventOperation.m
//  KATG.com
//
//  Copyright 2009 Doug Russell
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

#import "EventOperation.h"
#import "Event.h"

@interface EventOperation (Private)
- (void)_processEvent;
- (NSDictionary *)_dateFormatting;
- (NSNumber *)_showType;
@end

@implementation EventOperation

@synthesize delegate;
@synthesize event = _event;
@synthesize formatter = _formatter;
@synthesize dayFormatter = _dayFormatter;
@synthesize dateFormatter = _dateFormatter;
@synthesize timeFormatter = _timeFormatter;

- (id)initWithEvent:(NSDictionary *)anEvent 
{
	if( self = [super init] )
	{
		[self setEvent:anEvent];
	}
	return self;
}
- (void)dealloc 
{
	[_event release];
	[super dealloc];
}
- (void)main 
{
	if(!self.isCancelled)
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		[self _processEvent];
		if (self.delegate && !self.isCancelled) 
		{
			[self.delegate eventOperationDidFinishSuccesfully:self];
		}
		[pool drain];
	}
}
- (void)_processEvent 
{
	if(!self.isCancelled)
	{
		if(!self.isCancelled)
		{
			Event *managedEvent = 
			(Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" 
												   inManagedObjectContext:delegate.managedObjectContext];
			
			NSString *title = [self.event objectForKey:@"Title"];
			if (!title) title = @"";
			[managedEvent setTitle:title];
			
			NSString *eventID = [self.event objectForKey:@"EventId"];
			if (!eventID) eventID = @"";
			[managedEvent setEventID:eventID];
			
			NSString *details = [self.event objectForKey:@"Details"];
			if (!details || [details isEqualToString:@"NULL"]) details = @"";
			[managedEvent setDetails:details];
			
			NSDictionary * dateTimes = [self _dateFormatting];
			
			NSDate *dateTime = [dateTimes objectForKey:@"DateTime"];
			if (dateTime)
				[managedEvent setDateTime:dateTime];
			
			NSString *day = [dateTimes objectForKey:@"Day"];
			if (day)
				[managedEvent setDay:day];
			
			NSString *date = [dateTimes objectForKey:@"Date"];
			if (date)
				[managedEvent setDate:date];
			
			NSString *time = [dateTimes objectForKey:@"Time"];
			if (time)
				[managedEvent setTime:time];
			
			NSNumber *showType = [self _showType];
			if (showType)
				[managedEvent setShowType:showType];
			
			//NSLog(@"\n\nEvent : \n\n%@\n\n%@", managedEvent, self.event);
			
			if (!self.isCancelled)
			{
				NSError *error;
				if (![delegate.managedObjectContext save:&error])
				{	// Handle Error
					
				}
			}
		}
	}
}
- (NSDictionary *)_dateFormatting 
{
	NSDictionary * dateTimes = nil;
	if (!self.isCancelled)
	{
		NSString *eventTimeString = [self.event objectForKey:@"StartDate"];
		NSDate *eventDateTime = [self.formatter dateFromString:eventTimeString];
		NSString *eventDay = [self.dayFormatter stringFromDate:eventDateTime];
		NSString *eventDate = [self.dateFormatter stringFromDate:eventDateTime];
		NSString *eventTime = [self.timeFormatter stringFromDate:eventDateTime];
		if (eventDateTime &&
			eventDay &&
			eventDate &&
			eventTime &&
			!self.isCancelled)
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
			[[ESLogger sharedESLogger] log:@"Date Formatting Failed"];
		}
	}
	return dateTimes;
}
- (NSNumber *)_showType 
{
	if ([[self.event objectForKey:@"Title"] rangeOfString:@"Live Show"].location != NSNotFound)
		return [NSNumber numberWithBool:YES];
	else
		return [NSNumber numberWithBool:NO];
}

@end
