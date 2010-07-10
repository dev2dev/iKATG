//
//  KATG_BigAppDelegate.m
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

#import "KATG_BigAppDelegate.h"
#import "DataModel.h"
#import "Reachability.h"

@interface KATG_BigAppDelegate (PrivateCoreDataStack)
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

#define kReachabilityURL @"www.keithandthegirl.com"

@implementation KATG_BigAppDelegate
@synthesize window, tabBarController, connected;

#pragma mark -
#pragma mark Application Lifecycle
#pragma mark -
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
	NSLog(@"Application Launch With Options: %@", launchOptions);
	
	NSManagedObjectContext *context = [self managedObjectContext];
	if (!context)
	{	// error
		
	}
	
	DataModel *model = [DataModel sharedDataModel];
	[model setManagedObjectContext:managedObjectContext];
	
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
	
	NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithFile:AppDirectoryCachePathAppended(@"cookies")];
	//NSLog(@"Cookies Startup :%@", cookies);
	if (cookies != nil)
	{
		[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
		for (NSHTTPCookie *cookie in cookies)
		{
			[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
		}
	}
	// APNS
	// Register for push notifications
	[application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | 
													 UIRemoteNotificationTypeBadge | 
													 UIRemoteNotificationTypeSound)];
	// If app is launched from a notification, display that notification in an alertview
	if ([launchOptions count] > 0) 
	{
		NSString *alertMessage = 
		[[[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] 
		  objectForKey:@"aps"] 
		 objectForKey:@"alert"];
		if (alertMessage)
		{
			UIAlertView *alert = [[UIAlertView alloc] 
								  initWithTitle:@"Notification"
								  message:alertMessage 
								  delegate:nil
								  cancelButtonTitle:@"Continue" 
								  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}
	
	// Register reachability object
	[self checkReachability];
    
    return YES;
}
- (void)applicationWillTerminate:(UIApplication *)application
{
	NSLog(@"Application Termination");
	
	NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
	//NSLog(@"Cookies Shutdown :%@", cookies);
	if (cookies != nil)
	{
		//BOOL success = 
		[NSKeyedArchiver archiveRootObject:cookies 
									toFile:AppDirectoryCachePathAppended(@"cookies")];
	}
	
	NSError *error = nil;
    if (managedObjectContext != nil) 
	{
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) 
		{
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
	NSLog(@"Application Did Become Active");
}
- (void)applicationWillResignActive:(UIApplication *)application
{
	NSLog(@"Application Will Resign Active");
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
	NSLog(@"Application Did Enter Background");
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
	NSLog(@"Application Will Enter Foreground");
}
#pragma mark -
#pragma mark Core Data stack
#pragma mark -
- (NSManagedObjectContext *) managedObjectContext 
{
    if (managedObjectContext != nil)
        return managedObjectContext;
    
	NSPersistentStoreCoordinator *coordinator = 
	[self persistentStoreCoordinator];
    
	if (coordinator != nil) 
	{
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
	
    return managedObjectContext;
}
- (NSManagedObjectModel *)managedObjectModel 
{
    if (managedObjectModel != nil)
        return managedObjectModel;
    
	managedObjectModel = 
	[[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    
	return managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator 
{
	if (persistentStoreCoordinator != nil)
        return persistentStoreCoordinator;
    
	NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"KATG.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = 
	[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) 
	{
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}
#pragma mark -
#pragma mark Application's Documents directory
#pragma mark -
- (NSString *)applicationDocumentsDirectory 
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
#pragma mark -
#pragma mark Custom URL
#pragma mark -
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//	return NO;
//}
- (void)applicationSignificantTimeChange:(UIApplication *)application
{
	
}
#pragma mark -
#pragma mark Status Bar
#pragma mark -
- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration
{
	
}
- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation
{
	
}
- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame
{
	
}
- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame
{
	
}
#pragma mark -
#pragma mark Notifications
#pragma mark -
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	// This should be in the model and use DataOperation
	NSString *token = [NSString stringWithFormat: @"%@", deviceToken];
	[NSThread detachNewThreadSelector:@selector(sendProviderDeviceToken:) 
							 toTarget:self 
						   withObject:token];
}
- (void)sendProviderDeviceToken:(NSString *)token 
{ // This needs some attention, seems awkward
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *myRequestString = 
	@"http://app.keithandthegirl.com/app/tokenserver/tokenserver.php?dev=";
	token = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)token, NULL, NULL, kCFStringEncodingUTF8);
	myRequestString = [myRequestString stringByAppendingString:token];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:myRequestString]]; 
	[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	[request autorelease];
	[token release];
	[pool release];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	
}
@class UILocalNotification;
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
	
}
#pragma mark -
#pragma mark Memory Management
#pragma mark -
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	
}
- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[hostReach release];
	
	[managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	
    [tabBarController release];
    [window release];
    
	[super dealloc];
}
#pragma mark -
#pragma mark Reachability
#pragma mark -
// Access user defaults, register for changes in reachability an start reachability object
- (void)checkReachability 
{
	[[NSNotificationCenter defaultCenter] 
	 addObserver:self 
	 selector:@selector(reachabilityChanged:) 
	 name:kReachabilityChangedNotification 
	 object:nil];
	hostReach = 
	[[Reachability reachabilityWithHostName:kReachabilityURL] retain];
	[hostReach startNotifier];
}
// Respond to changes in reachability
- (void)reachabilityChanged:(NSNotification* )notification
{
	Reachability *curReach = [notification object];
	//NSParameterAssert([curReach isKindOfClaGss:[Reachability class]]);
	[self updateReachability:curReach];
}
- (void)updateReachability:(Reachability*)curReach
{
	NetworkStatus netStatus = [curReach currentReachabilityStatus];
	switch (netStatus) {
		case NotReachable:
		{
			connected = NO;
			[NSTimer scheduledTimerWithTimeInterval:4.0 
											 target:self 
										   selector:@selector(noConnectionAlert:) 
										   userInfo:nil 
											repeats:NO];
			break;
		}
		case ReachableViaWWAN:
		{
			connected = YES;
			break;
		}
		case ReachableViaWiFi:
		{
			connected = YES;
			break;
		}
	}
}
- (void)noConnectionAlert:(NSTimer *)timer
{
	if (connected == NO)
	{
		UIAlertView *alert = 
		[[UIAlertView alloc]
		 initWithTitle:@"NO INTERNET CONNECTION"
		 message:@"This Application requires an active internet connection. Please connect to wifi or cellular data network for full application functionality." 
		 delegate:nil
		 cancelButtonTitle:@"Continue" 
		 otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

@end

