//
//  DataModel.m
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

#import "DataModel.h"
#import "DataModel+Processing.h"
#import "DataModel+Notification.h"
#import "DataOperationCodes.h"
#import "DataModelURIList.h"
#import "ModelLogging.h"

static DataModel	*	sharedDataModel	=	nil;

@implementation DataModel
@synthesize delegates, connected, notifier;
@synthesize managedObjectContext;

/******************************************************************************/
#pragma mark -
#pragma mark Singleton Methods
#pragma mark -
/******************************************************************************/
+ (DataModel *)sharedDataModel
{
	@synchronized(self)
	{
		if (sharedDataModel == nil)
		{
			sharedDataModel = [[self alloc] init];
		}
	}
	return sharedDataModel;
}
+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if (sharedDataModel == nil)
		{
			sharedDataModel = [super allocWithZone:zone];
			return sharedDataModel;
		}
	}
	return nil;
}
/******************************************************************************/
#pragma mark -
#pragma mark Delegates
#pragma mark -
/******************************************************************************/
- (void)addDelegate:(id<DataModelDelegate>)delegate
{
	if ([NSThread isMainThread])
	{
		if (![delegates containsObject:delegate])
		{
#if LogDelegateAdding
			NSLog(@"Delegate Added: %@", delegate);
#endif
			[delegates addObject:delegate];
		}
#if LogDelegateAdding
		else 
		{
			NSLog(@"Delegate Already Added: %@", delegate);
		}
#endif
	}
	else
	{
		[self performSelectorOnMainThread:@selector(addDelegate:) 
							   withObject:delegate 
							waitUntilDone:NO];
	}
}
- (void)removeDelegate:(id<DataModelDelegate>)delegate
{
	if ([NSThread isMainThread])
	{
#if LogDelegateRemoval
		NSLog(@"Delegate Removed %@", delegate);
#endif
		[delegates removeObject:delegate];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(removeDelegate:) 
							   withObject:delegate 
							waitUntilDone:NO];
	}
}
/******************************************************************************/
#pragma mark -
#pragma mark Notifications
#pragma mark -
/******************************************************************************/
- (void)startNotifier
{
	[self setNotifier:YES];
}
- (void)stopNotifier
{
	[self setNotifier:NO];
}
/******************************************************************************/
#pragma mark -
#pragma mark Data Methods
#pragma mark -
/******************************************************************************/
- (void)events
{
	//
	//  Retrieve events already in Core Data Store
	//
	[self eventsNoPoll];
	//
	//  Break off thread to get updated events
	//
	DataOperation	*	op	=	[[DataOperation alloc] init];
	[op setDelegate:self];
	// Object setters are (nonatomic, copy)
	[op setCode:kEventsListCode];
	[op setURI:kEventsFeedAddress];
	if (connected)
		[operationQueue addOperation:op];
	else
		[delayedOperations addObject:op];
	[op release];
}
- (void)eventsNoPoll
{
	//
	//  Retrieve events already in Core Data Store
	//
#ifdef __IPHONE_4_0
	[coreDataOperationQueue addOperationWithBlock:^{[[DataModel sharedDataModel] fetchEvents];}];
#else
	// write some 3.0 code :(
#endif
}
- (void)liveShowStatus
{
	//
	//  *UNREVISEDCOMMENTS*
	//
	DataOperation	*	op	=	[[DataOperation alloc] init];
	[op setDelegate:self];
	// Object setters are (nonatomic, copy)
	[op setCode:kLiveShowStatusCode];
	[op setURI:kLiveShowStatusAddress];
	if (connected)
		[operationQueue addOperation:op];
	else
		[delayedOperations addObject:op];
	[op release];
}
- (void)feedback:(NSString *)name 
		location:(NSString *)location 
		 comment:(NSString *)comment
{
	//
	//  *UNREVISEDCOMMENTS*
	//
	DataOperation	*	op	=	[[DataOperation alloc] init];
	[op setDelegate:self];
	// Object setters are (nonatomic, copy)
	[op setCode:kFeedbackCode];
	[op setBaseURL:kFeedbackURLAddress];
	[op setURI:kFeedbackURIAddress];
	// Pretty sure these copies are unnecessary
	NSString	*	nameCopy		=	[name copy];
	NSString	*	locationCopy	=	[location copy];
	NSString	*	commentCopy		=	[comment copy];
	NSDictionary *bufferDict = 
	[NSDictionary dictionaryWithObjectsAndKeys:
	 nameCopy, @"Name",
	 locationCopy, @"Location",
	 commentCopy, @"Comment",
	 @"Send+Comment", @"ButtonSubmit",
	 @"3", @"HiddenVoxbackId",
	 @"IEOSE", @"HiddenMixerCode", nil];
	[nameCopy release];
	[locationCopy release];
	[commentCopy release];
	[op setBufferDict:bufferDict];
	if (connected)
		[operationQueue addOperation:op];
	else
		[delayedOperations addObject:op];
	[op release];
}
- (void)shows
{
	//
	//  *UNREVISEDCOMMENTS*
	//
	[self showsNoPoll];
	//
	//  *UNREVISEDCOMMENTS*
	//
	DataOperation	*	op	=	[[DataOperation alloc] init];
	[op setDelegate:self];
	// Object setters are (nonatomic, copy)
	[op setCode:kShowArchivesCode];
	[op setURI:kShowListURIAddress];
	if (connected)
		[operationQueue addOperation:op];
	else
		[delayedOperations addObject:op];
	[op release];
}
- (void)showsNoPoll
{
	//
	//  Retrieve events already in Core Data Store
	//
#ifdef __IPHONE_4_0
	[coreDataOperationQueue addOperationWithBlock:^{[[DataModel sharedDataModel] fetchShows];}];
#else
	// write some 3.0 code :(
#endif
}
/******************************************************************************/
#pragma mark -
#pragma mark Data Operation Delegates
#pragma mark -
/******************************************************************************/
- (void)dataOperationDidFinish:(DataOperation *)op
{
	
}
- (void)dataOperationDidFail:(DataOperation *)op withError:(NSError *)error
{
	
}

@end
