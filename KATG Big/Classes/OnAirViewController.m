    //
//  OnAirViewController.m
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

#import "OnAirViewController.h"
#import "OnAirViewController+AudioStreamer.h"
#import "OnAirViewController+Feedback.h"
#import "NSString+Regex.h"
#import "Event.h"

@interface OnAirViewController (Private)

@end

@implementation OnAirViewController
@synthesize feedbackView, nameField, locationField, commentView, submitButton;
@synthesize audioButton;
@synthesize volumeView;
@synthesize nextLiveShowLabel;
@synthesize live = _live;
@synthesize liveShowStatusLabel;
@synthesize guestLabel;

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[self setupAudioAssets];
	
	model = [DataModel sharedDataModel];
	[model addDelegate:self];
	
	[model liveShowStatus];
	
	//	this timer should really be in the model
	[NSTimer scheduledTimerWithTimeInterval:180.0 
									 target:self 
								   selector:@selector(updateLiveShowStatusTimer:) 
								   userInfo:nil 
									repeats:YES];
	
	[model events];
	
#ifdef __IPHONE_4_0
	[[NSNotificationCenter defaultCenter] 
	 addObserver:self
	 selector:@selector(writeDefaults) 
	 name:UIApplicationDidEnterBackgroundNotification 
	 object:nil];
#elif __IPHONE_3_2
	[[NSNotificationCenter defaultCenter] 
	 addObserver:self
	 selector:@selector(writeDefaults) 
	 name:UIApplicationWillTerminateNotification 
	 object:nil];
#endif
	
	[self loadDefaults];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload 
{
    [super viewDidUnload];
	
	[model removeDelegate:self];
}
- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
		
	[feedbackView release];
	[nameField release];
	[locationField release];
	[commentView release];
	[submitButton release];
	
	[audioButton release];
	
	[volumeView release];
	
	[nextLiveShowLabel release];
	[liveShowStatusLabel release];
	[guestLabel release];
	
    [super dealloc];
}
#pragma mark -
#pragma mark Feedback Button
#pragma mark -
- (IBAction)submitButtonPressed:(id)sender
{
	[self sendFeedback];
}
#pragma mark -
#pragma mark UserDefaultss
#pragma mark -
- (void)loadDefaults
{
	NSUserDefaults	*	userDefaults	=	[NSUserDefaults standardUserDefaults];
	NSString		*	name			=	[userDefaults objectForKey:@"Name"];
	[nameField setText:name];
	NSString *location = [userDefaults objectForKey:@"Location"];
	[locationField setText:location];
	NSString *comment = [userDefaults objectForKey:@"Comment"];
	if (comment && ![comment isEqualToString:@"Comment"])
	{
		[commentView setTextColor:[UIColor blackColor]];
		[commentView setText:comment];
	}
	if ([userDefaults boolForKey:@"playing"] && [model isConnected]) 
		[self audioButtonPressed:nil];
	//else if ([userDefaults boolForKey:@"playing"] && ![model isConnected]) 
	//	playOnConnection = YES;
}
- (void)writeDefaults  
{
	NSUserDefaults	*	userDefaults	=	[NSUserDefaults standardUserDefaults];
	if ([[nameField text] length] > 0) 
		[userDefaults setObject:[nameField text] forKey:@"Name"];
	if ([[locationField text] length] > 0) 
		[userDefaults setObject:[locationField text] forKey:@"Location"];
	if ([[commentView text] length] > 0) 
		[userDefaults setObject:[commentView text] forKey:@"Comment"];
	if (streamer) 
		[userDefaults setBool:YES forKey:@"Playing"];
	else
		[userDefaults setBool:NO forKey:@"Playing"];
	[userDefaults synchronize];
}
#pragma mark -
#pragma mark Data Delegates
#pragma mark -
//**********************//
// guests, timesince,   //
// and feed status      //
// update logic should  //
// be in the model      //
//**********************//
- (void)updateLiveShowStatusTimer:(NSTimer *)timer
{
	[model liveShowStatus];
}
- (void)events:(NSArray *)events
{
	if (events && events.count > 0)
	{
		for (Event *event in events)
		{
			//
			// Make sure event is a live show
			// is scheduled within the
			// last 12 hours or in the future,
			// if in the past 
			//
			NSDate	*	date		=	[event DateTime];
			NSInteger	since		=	[date timeIntervalSinceNow];
			NSInteger	threshHold	=	-(60/*Seconds*/ * 60 /*Minutes*/ * 12 /*Hours*/);
			if (since > threshHold && [[event ShowType] boolValue])
			{
				NSString *timeString = nil;
				if (since < 0 && self.live)
				{
					timeString = @"NOW!";
				}
				else if (since >= 0)
				{
					NSInteger d	=	since / 86400;
					NSInteger h	=	since / 3600 - d * 24;
					NSInteger m	=	since / 60 - d * 1440 - h * 60;
					timeString	=	[NSString stringWithFormat:@"%02d : %02d : %02d", d, h, m];
				}
				else
				{
					continue;
				}
				[[self nextLiveShowLabel] setText:timeString];
				[NSTimer scheduledTimerWithTimeInterval:60.0 
												 target:self 
											   selector:@selector(updateTimeSince:) 
											   userInfo:date 
												repeats:YES];
				NSString *title = [event Title];
				if (title)
					[self findGuest:title];
				break;
			}
		}
	}
}
- (void)updateTimeSince:(NSTimer *)timer
{
	NSDate		*	date		=	[timer userInfo];
	NSString	*	timeString	=	nil;
	NSInteger		since		=	[date timeIntervalSinceNow];
	if (since < 0 && self.live)
	{
		timeString = @"NOW!";
	}
	else
	{
		NSInteger d	=	since / 86400;
		NSInteger h	=	since / 3600 - d * 24;
		NSInteger m	=	since / 60 - d * 1440 - h * 60;
		timeString	=	[NSString stringWithFormat:@"%02d : %02d : %02d", d, h, m];
	}
	[[self nextLiveShowLabel] setText:timeString];
}
- (void)findGuest:(NSString *)eventTitle
{
	NSRange range = [eventTitle rangeOfString:@"Live Show with " 
									  options:(NSAnchoredSearch | 
											   NSCaseInsensitiveSearch)];
	if (range.location != NSNotFound)
	{
		NSString *guest = 
		[eventTitle stringByReplacingOccurrencesOfString:@"Live Show with " 
											  withString:@"" 
												 options:(NSAnchoredSearch | 
														  NSCaseInsensitiveSearch)
												   range:NSMakeRange(0, eventTitle.length)];
		if (guest)
			[guestLabel setText:guest];
	}
	else
	{
		[guestLabel setText:@"No Guest(s)"];
	}
}
- (void)liveShowStatus:(BOOL)live
{
	self.live = live;
	liveShowStatusLabel.text = [NSString stringWithFormat:@"%@", self.live ? @"Live" : @"Not Live"];
}

@end
