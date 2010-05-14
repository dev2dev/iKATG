//
//  DataModel.h
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

#import <Foundation/Foundation.h>
#import "DataModelDelegate.h"
#import "DataOperation.h"

@interface DataModel : NSObject <DataOperationDelegate>
{
	//
	//  Delegate array for returning data asynchronously
	//
	NSArray *delegates;
	////
	//  BOOL to indicate internet connectivity
	//
	BOOL connected;
	//
	//
	//
	NSInteger connectionType;
	//
	//  BOOL to determine use of NSNotifications for returned data
	//
	BOOL notifier;
	//
	//  Default location for storing data
	//
	NSString *dataPath;
	//
	//  *UNREVISEDCOMMENTS*
	//
	NSUserDefaults *userDefaults;
	//
	//  NSOperations queue to handle threading of data requests
	//  All server communication is done using a data operation
	//  in the operationQueue and any ongoing communication
	//  can be canceled by cancelling the queue
	//
	NSOperationQueue  *operationQueue;
	//
	//  When connectivity is not available, operations are added to
	//  delayedOperations and then when connectivity returns delayedOperations
	//  contents is added to the operationQueue
	//
	NSMutableArray *delayedOperations;
	//
	//
	//
	NSDateFormatter *formatter;
	NSDateFormatter *dayFormatter;
	NSDateFormatter *dateFormatter;
	NSDateFormatter *timeFormatter;
	//
	//
	//
	NSMutableArray *events;
	NSInteger      eventCount;
}

/*****************************************/
//  Accessors
/*****************************************/
@property (retain)                       NSArray *delegates;
@property (readwrite, assign, getter=isConnected)  BOOL connected;
@property (readwrite, assign, getter=isNotifiying) BOOL notifier;

/*****************************************/
//  Setup Methods
/*****************************************/
//
//  DataModel *modelSingleton = [DataModel sharedDataModel];
//  Return party camera data model singleton
//
+ (DataModel *)sharedDataModel;
//
//  [modelSingleton addDelegate:self];
//  Add a delegate to the delegate array 
//  (register as a delegate to receive methods from the PartyCameraDataModelDelegate protocol)
//
- (void)addDelegate:(id)delegate;
//
//  [modelSingleton removeDelegate:self];
//  Remove a delegate from the delegate array
//  (It is critical to that any add delegate call is matched with a 
//  remove delegate call in order to ensure accurate retain counts)
//
- (void)removeDelegate:(id)delegate;
//
//  [modelSingleton startNotifier];
//  [modelSingleton isNotifying];
//  Start data model notifications
//  (this can be checked with @property (readwrite, assign, getter=isNotifiying) BOOL notifier;)
//
- (void)startNotifier;
//
//  [modelSingleton stopNotifier];
//  [modelSingleton isNotifying];
//  Stop data model notification
//  (this can be checked with @property (readwrite, assign, getter=isNotifiying) BOOL notifier;)
//
- (void)stopNotifier;

/*****************************************/
//  Data Methods
/*****************************************/
//
//  *UNREVISEDCOMMENTS*
//	@"Title",
//	@"EventId",
//	@"Details",
//	@"DateTime",
//	@"Day",
//	@"Date",
//	@"Time", 
//	@"ShowType"
//  *UNREVISEDCOMMENTS*
//
- (void)events;
//
//  *UNREVISEDCOMMENTS*
//
- (void)liveShowStatus;
//
//  *UNREVISEDCOMMENTS*
//
- (void)feedback:(NSString *)name location:(NSString *)location comment:(NSString *)comment;
//
//  *UNREVISEDCOMMENTS*
//
- (void)chatLogin:(NSURLRequest *)request;

@end
