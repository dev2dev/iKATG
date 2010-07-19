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
#import <CoreData/CoreData.h>
#import "DataModelDelegate.h"
#import "DataOperation.h"

@interface DataModel : NSObject <DataOperationDelegate>
{
	//
	//  Delegate array for returning data asynchronously
	//
	NSMutableArray *delegates;
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
	//  Core Data Context
	//
	NSManagedObjectContext *managedObjectContext;
	//
	//  Default location for storing data
	//
	NSString *cacheDirectoryPath;
	//
	//  Application Defaults
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
	//  Operation Queue with max operations set to
	//  to allow core data to operate off main thread
	//
	NSOperationQueue  *coreDataOperationQueue;
	//
	//  When connectivity is not available, operations are added to
	//  delayedOperations and then when connectivity returns delayedOperations
	//  contents is added to the operationQueue
	//
	NSMutableArray *delayedOperations;
	//
	//  Date Formatters to make datetime
	//  human readable and localized
	//
	NSDateFormatter *formatter;
	NSDateFormatter *dayFormatter;
	NSDateFormatter *dateFormatter;
	NSDateFormatter *timeFormatter;
}
/******************************************************************************/
#pragma mark -
#pragma mark Accessors
#pragma mark -
/******************************************************************************/
@property (nonatomic, retain) NSMutableArray *delegates;
@property (readwrite, assign, getter=isConnected)  BOOL connected;
@property (readwrite, assign, getter=isNotifiying) BOOL notifier;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
/******************************************************************************/
#pragma mark -
#pragma mark Setup Methods
#pragma mark -
/******************************************************************************/
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
- (void)addDelegate:(id<DataModelDelegate>)delegate;
//
//  [modelSingleton removeDelegate:self];
//  Remove a delegate from the delegate array
//  (It is critical to that any add delegate call is matched with a 
//  remove delegate call in order to ensure accurate retain counts)
//
- (void)removeDelegate:(id<DataModelDelegate>)delegate;
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
/******************************************************************************/
#pragma mark -
#pragma mark Data Methods
#pragma mark -
/******************************************************************************/
//
//	Retrieve list of events
//  Returns on - (void)events:(NSArray *)events;
//  NSArray of 
//  NSManagedObject subclass Event:
//  @property (nonatomic, retain) NSString * Title;
//  @property (nonatomic, retain) NSString * EventID;
//  @property (nonatomic, retain) NSDate   * DateTime;
//  @property (nonatomic, retain) NSString * Day;
//  @property (nonatomic, retain) NSString * Date;
//  @property (nonatomic, retain) NSString * Time;
//  @property (nonatomic, retain) NSNumber * ShowType; (BOOL: YES for Show, No for Event)
//  @property (nonatomic, retain) NSString * Details;
//
- (void)events;			// Events from coredata store initially, then updated from web
- (void)eventsNoPoll;	// Events only from coredata store
//
//  Check live show status 
//  (this is set by the hosts, not an actual check of the shoutcast feeds status)
//  Returns on - (void)liveShowStatus:(BOOL)live;
//
- (void)liveShowStatus;
//
//  Submit feedback to hosts
//  Doesn't return any confirmation of success
//
- (void)feedback:(NSString *)name location:(NSString *)location comment:(NSString *)comment;
//
//  Retrieve list of shows in archive
//  Returns on - (void)shows:(NSArray *)shows;
//  NSArray of
//  NSManagedObject subclass Show
//  @property (nonatomic, retain) NSNumber * ID;
//  @property (nonatomic, retain) NSNumber * Number;
//  @property (nonatomic, retain) NSNumber * TV;
//  @property (nonatomic, retain) NSString * URL;
//  @property (nonatomic, retain) NSString * Title;
//  @property (nonatomic, retain) NSNumber * HasNotes;
//  @property (nonatomic, retain) NSString * Notes;
//  @property (nonatomic, retain) NSSet* Guests;
//  @property (nonatomic, retain) NSNumber * PictureCount;
//  @property (nonatomic, retain) NSSet* Pictures;
//
- (void)shows;
- (void)showsNoPoll;

@end
