//
//  DataModel+SetupCleanup.h
//  KATG Big
//
//  Created by Doug Russell on 5/5/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "DataModel.h"

@class Reachability;
@interface DataModel (SetupCleanup)

- (void)dateFormatters;
//  Return path to applications documents directory
- (NSString *)newDataPath;
//  Register notifications for reachabilty and app termination
- (void)registerNotifications;
//  Cleanup Memory
- (void)cleanup;
- (void)cleanupOperations;
- (void)cleanupImages;
//  Handle app termination by calling
//  super release
- (void)releaseSingleton;
//  Handle changes in reachability
- (void)reachabilityChanged:(NSNotification* )note;
- (void)updateReachability:(Reachability*)curReach;
- (void)setDefaultObject:(id)object forKey:(id)key;
- (void)syncDefaults;

@end
