//
//  KATG_BigAppDelegate.h
//  KATG Big
//
//  Created by Doug Russell on 4/26/10.
//  Copyright Doug Russell 2010. All rights reserved.
//
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

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Reachability;
@interface KATG_BigAppDelegate : NSObject 
<UIApplicationDelegate, UITabBarControllerDelegate> 
{
	NSManagedObjectModel			*	managedObjectModel;
    NSManagedObjectContext			*	managedObjectContext;	    
    NSPersistentStoreCoordinator	*	persistentStoreCoordinator;
	
    UIWindow						*	window;
    UITabBarController				*	tabBarController;
	Reachability					*	hostReach;
	BOOL								connected;
}

@property (nonatomic, retain) IBOutlet UIWindow				*	window;
@property (nonatomic, retain) IBOutlet UITabBarController	*	tabBarController;
@property (readwrite, getter=isConnected) BOOL					connected;

- (NSString *)applicationDocumentsDirectory;

// Send in Token for Push Notifications
- (void)sendProviderDeviceToken:(id)deviceTokenBytes;
// Set up reachability object
- (void)checkReachability;
// Respond to changes in reachability status
- (void)updateReachability:(Reachability*)curReach;
- (void)reachabilityChanged:(NSNotification* )notification;

@end
