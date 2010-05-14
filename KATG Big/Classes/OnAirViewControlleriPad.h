//
//  OnAirViewControlleriPad.h
//  KATG Big
//
//  Created by Doug Russell on 4/26/10.
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
