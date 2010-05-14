//
//  KATG_BigAppDelegate.h
//  KATG Big
//
//  Created by Doug Russell on 4/26/10.
//  Copyright Doug Russell 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;
@interface KATG_BigAppDelegate : NSObject 
<UIApplicationDelegate, UITabBarControllerDelegate> 
{
    UIWindow *window;
    UITabBarController *tabBarController;
	Reachability *hostReach;
	BOOL connected;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (readwrite, getter=isConnected) BOOL connected;

// Send in Token for Push Notifications
//- (void)sendProviderDeviceToken:(id)deviceTokenBytes;
// Set up reachability object
- (void)checkReachability;
// Respond to changes in reachability status
- (void)updateReachability:(Reachability*)curReach;
- (void)reachabilityChanged:(NSNotification* )notification;

@end
