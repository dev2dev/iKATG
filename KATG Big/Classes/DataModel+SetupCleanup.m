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
#pragma mark -
#pragma mark SetupCleanup
#pragma mark -
- (id)init
{
	if (self = [super init])
	{
		delegates         = [[NSArray alloc] init];
		
		connected         = NO;
		connectionType    = 0;
		notifier          = NO;
		
		dataPath          = [self newDataPath];
		
		events            = [[NSMutableArray alloc] init];
		
		[self dateFormatters];
		
		operationQueue    = [[NSOperationQueue alloc] init];
		[operationQueue setMaxConcurrentOperationCount:[[NSProcessInfo processInfo] activeProcessorCount] + 1];
		delayedOperations = [[NSMutableArray alloc] init];
		
		[self registerNotifications];
		userDefaults = [NSUserDefaults standardUserDefaults];
	}
	return self;
}
- (void)dateFormatters
{
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle: NSDateFormatterLongStyle];
	[formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[formatter setDateFormat: @"MM/dd/yyyy HH:mm zzz"];
	NSLocale *us = [[NSLocale alloc] initWithLocaleIdentifier:@"US"];
	[formatter setLocale:us];
	[us release];
	
	dayFormatter = [[NSDateFormatter alloc] init];
	[dayFormatter setDateStyle: NSDateFormatterLongStyle];
	[dayFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dayFormatter setDateFormat: @"EEE"];
	[dayFormatter setLocale:[NSLocale currentLocale]];
	
	dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle: NSDateFormatterLongStyle];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dateFormatter setDateFormat: @"MM/dd"];
	[dateFormatter setLocale:[NSLocale currentLocale]];
	
	timeFormatter = [[NSDateFormatter alloc] init];
	[timeFormatter setDateStyle: NSDateFormatterLongStyle];
	[timeFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[timeFormatter setDateFormat: @"h:mm aa"];
	[timeFormatter setLocale:[NSLocale currentLocale]];
	
	eventCount = 0;
}
- (NSString *)newDataPath
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, 
														  NSUserDomainMask, 
														  YES) lastObject];
	path = [[path stringByAppendingPathComponent:@"pictures"] retain];
	NSError *error;
	[fileManager removeItemAtPath:path error:&error];
	[fileManager createDirectoryAtPath:path attributes:nil];
	return path;
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
- (void)dealloc
{
	[self cleanup];
	[self cleanupOperations];
	[self cleanupImages];
	[super dealloc];
}
- (void)cleanup
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[delegates release];
	[dataPath release];
	[formatter release];
	[dayFormatter release];
	[dateFormatter release];
	[timeFormatter release];
	[events release];
}
- (void)cleanupOperations
{
	[operationQueue cancelAllOperations];
	[operationQueue release]; operationQueue = nil;
	[delayedOperations release];
}
- (void)cleanupImages
{
	
}
- (void)releaseSingleton
{
	[super release];
}
#pragma mark -
#pragma mark Reachability
#pragma mark -
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
		for (DataOperation *op in delayedOperations)
		{
			[operationQueue addOperation:op];
		}
		[delayedOperations removeAllObjects];
	}
}
- (void)setDefaultObject:(id)object forKey:(id)key
{
	@synchronized(self)
	{
		[userDefaults setObject:object forKey:key];
	}
}
- (void)syncDefaults
{
	@synchronized(self)
	{
		[userDefaults synchronize];
	}
}

@end
