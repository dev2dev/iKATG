//
//  OnAirViewControlleriPad.h
//  KATG Big
//
//  Created by Doug Russell on 4/26/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "OnAirViewController.h"

@interface OnAirViewControlleriPad : OnAirViewController 
<UITableViewDelegate>
{
	//
	// Chat
	//
	RoundedView     *chatContainerView;
	UIWebView       *chatView;
	UIBarButtonItem *logout;
	NSMutableData   *responseData;
	//
	//  Events Table View
	//
	UITableView *tableView;
	NSArray     *eventsList;
	//
	//
	//
	UIPopoverController *popOverController;
}
//
// Chat
//
@property (nonatomic, retain) IBOutlet RoundedView     *chatContainerView;
@property (nonatomic, retain) IBOutlet UIWebView       *chatView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *logout;
//
//  Events Table View
//
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (retain)                     NSArray     *eventsList;

- (IBAction)logoutButtonPressed:(id)sender;

@end
