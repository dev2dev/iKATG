//
//  KATG_BigAppDelegate.m
//  KATG Big
//
//  Created by Doug Russell on 4/26/10.
//  Copyright Doug Russell 2010. All rights reserved.
//

#import "KATG_BigAppDelegate.h"
#import "Reachability.h"

#define kReachabilityURL @"www.keithandthegirl.com"

@implementation KATG_BigAppDelegate
@synthesize window, tabBarController, connected;

#pragma mark -
#pragma mark Application Lifecycle
#pragma mark -
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
	NSLog(@"Application Launch With Options: %@", launchOptions);
	
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
	
	NSString *dataPath =
	[[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, 
										  NSUserDomainMask, 
										  YES) lastObject] retain] autorelease];
	
	NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithFile:[dataPath stringByAppendingPathComponent:@"cookies"]];
	//NSLog(@"Cookies Startup :%@", cookies);
	if (cookies != nil)
	{
		[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
		for (NSHTTPCookie *cookie in cookies)
		{
			[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
		}
	}
	
	// Register reachability object
	[self checkReachability];
    
    return YES;
}
- (void)applicationWillTerminate:(UIApplication *)application
{
	NSLog(@"Application Termination");
	
	NSString *dataPath =
	[[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, 
										   NSUserDomainMask, 
										   YES) lastObject] retain] autorelease];
	
	NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
	//NSLog(@"Cookies Shutdown :%@", cookies);
	if (cookies != nil)
	{
		//BOOL success = 
		[NSKeyedArchiver archiveRootObject:cookies 
									toFile:[dataPath stringByAppendingPathComponent:@"cookies"]];
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
	[super applicationDidReceiveMemoryWarning:application];
}
- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[hostReach release];
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

