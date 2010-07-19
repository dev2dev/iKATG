//
//  DataModel+SetupCleanup.m
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

#import "DataModel+SetupCleanup.h"
#import "DataOperation.h"
#import "OrderedDictionary.h"
#import "Reachability.h"
#import "NSMutableArray+MyAdditions.h"

@implementation DataModel (SetupCleanup)

#pragma mark -
#pragma mark Singleton Methods
#pragma mark -
- (id)copyWithZone:(NSZone *)zone
{
	return self;
}
- (id)retain
{
	return self;
}
- (NSUInteger)retainCount
{
	return NSUIntegerMax;
}
- (void)release
{
}
- (id)autorelease
{
	return self;
}
/******************************************************************************/
#pragma mark -
#pragma mark Setup
#pragma mark -
/******************************************************************************/
- (id)init
{
	if (self = [super init])
	{
		// Non retaining array
		// to prevent delegates
		// from ending up in retain
		// loops
		delegates			= CreateNonRetainingArray();
		// bool to indicate if
		// data should be returned
		// by NSNotifications 
		// (currently not implemented)
		notifier			= NO;
		// Connection Status
		// 0 - Not Connected
		// 1 - 3G/Edge
		// 2 - Wifi
		connected			= NO;
		connectionType		= 0;
		// Applications Cache Directory
		cacheDirectoryPath	= [AppDirectoryCachePath() retain];
		// NSDateFormatters for events
		[self dateFormatters];
		// Data Api Operations queue
		operationQueue    = [[NSOperationQueue alloc] init];
		[operationQueue setMaxConcurrentOperationCount:[[NSProcessInfo processInfo] activeProcessorCount] + 1];
		// Storage for operations waiting for connectivity
		delayedOperations = [[NSMutableArray alloc] init];
		// Operations queue for CoreData operations
		coreDataOperationQueue = [[NSOperationQueue alloc] init];
		[coreDataOperationQueue setMaxConcurrentOperationCount:1];
		// NSNotifications for reachability and app termination
		[self registerNotifications];
		// User Defaults
		userDefaults = [NSUserDefaults standardUserDefaults];
	}
	return self;
}
- (void)dateFormatters
{
	// Initial formatter for creating data object for event
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle: NSDateFormatterLongStyle];
	[formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[formatter setDateFormat: @"MM/dd/yyyy HH:mm"];
	NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"America/New_York"];
	[formatter setTimeZone:timeZone];
	// Create localized data string for Day of the Week
	dayFormatter = [[NSDateFormatter alloc] init];
	[dayFormatter setDateStyle: NSDateFormatterLongStyle];
	[dayFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dayFormatter setDateFormat: @"EEE"];
	[dayFormatter setLocale:[NSLocale currentLocale]];
	// Create localized data string for Month and Day of the Month
	dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle: NSDateFormatterLongStyle];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dateFormatter setDateFormat: @"MM/dd"];
	[dateFormatter setLocale:[NSLocale currentLocale]];
	// Create localized data string for Time of Day
	timeFormatter = [[NSDateFormatter alloc] init];
	[timeFormatter setDateStyle: NSDateFormatterLongStyle];
	[timeFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[timeFormatter setDateFormat: @"h:mm aa"];
	[timeFormatter setLocale:[NSLocale currentLocale]];
}
- (void)registerNotifications
{
	// Respond to changes in reachability
	[[NSNotificationCenter defaultCenter] 
	 addObserver:self 
	 selector:@selector(reachabilityChanged:) 
	 name:kReachabilityChangedNotification 
	 object:nil];
	// When app is closed attempt to release object
	[[NSNotificationCenter defaultCenter] 
	 addObserver:self 
	 selector:@selector(releaseSingleton) 
	 name:UIApplicationWillTerminateNotification 
	 object:nil];
}
/******************************************************************************/
#pragma mark -
#pragma mark Cleanup
#pragma mark -
/******************************************************************************/
- (void)dealloc
{
	[self cleanup];
	[self cleanupDateFormatters];
	[self cleanupOperations];
	[super dealloc];
}
- (void)cleanup
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[delegates release];
	[cacheDirectoryPath release];
	[managedObjectContext release];
}
- (void)cleanupDateFormatters
{
	[formatter release];
	[dayFormatter release];
	[dateFormatter release];
	[timeFormatter release];
}
- (void)cleanupOperations
{
	[operationQueue cancelAllOperations];
	[operationQueue release]; operationQueue = nil;
	[delayedOperations release];
	[coreDataOperationQueue cancelAllOperations];
	[coreDataOperationQueue release]; coreDataOperationQueue = nil;
}
- (void)releaseSingleton
{
	[super release];
}
/******************************************************************************/
#pragma mark -
#pragma mark Reachability
#pragma mark -
/******************************************************************************/
- (void)reachabilityChanged:(NSNotification* )note
{
	Reachability *curReach = [note object];
	//NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
	[self updateReachability:curReach];
}
- (void)updateReachability:(Reachability*)curReach
{
	NetworkStatus netStatus = [curReach currentReachabilityStatus];
	switch (netStatus) {
		case NotReachable:
		{
			//NSLog(@"Model Disconnected");
			connected = NO;
			connectionType = 0;
			break;
		}
		case ReachableViaWWAN:
		{
			//NSLog(@"Model Connected");
			connected = YES;
			connectionType = 1;
			break;
		}
		case ReachableViaWiFi:
		{
			//NSLog(@"Model Connected");
			connected = YES;
			connectionType = 2;
			break;
		}
	}
	
	if (connected)
	{
		// add any delayed operations to data operations queue
		for (DataOperation *op in delayedOperations)
		{
			[operationQueue addOperation:op];
		}
		[delayedOperations removeAllObjects];
	}
}

@end
