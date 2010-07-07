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
@synthesize liveShowStatusLabel;
@synthesize guestLabel;

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[self setupAudioAssets];
	
	model = [DataModel sharedDataModel];
	[model addDelegate:self];
	
//	[model liveShowStatus];
//	// this timer should really be in the model
//	[NSTimer scheduledTimerWithTimeInterval:180.0 
//									 target:self 
//								   selector:@selector(updateLiveShowStatusTimer:) 
//								   userInfo:nil 
//									repeats:YES];
//	
//	[model events];
//	[model shows];
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
}
- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[model removeDelegate:self];
	
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
			NSDate *date = [event DateTime];
			NSInteger since = [date timeIntervalSinceNow];
			if (since > 0 && [[event ShowType] boolValue])
			{
				timeSince = since;
				NSInteger d = timeSince / 86400;
				NSInteger h = timeSince / 3600 - d * 24;
				NSInteger m = timeSince / 60 - d * 1440 - h * 60;
				[[self nextLiveShowLabel] setText:[NSString stringWithFormat:@"%02d : %02d : %02d", d, h, m]];
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
	NSDate *date = [timer userInfo];
	NSInteger since = [date timeIntervalSinceNow];
	if (since > 0)
	{
		timeSince = since;
		NSInteger d = timeSince / 86400;
		NSInteger h = timeSince / 3600 - d * 24;
		NSInteger m = timeSince / 60 - d * 1440 - h * 60;
		[[self nextLiveShowLabel] setText:[NSString stringWithFormat:@"%02d : %02d : %02d", d, h, m]];
	}
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
	[self performSelectorOnMainThread:@selector(updateLiveShowStatus:) 
						   withObject:[NSNumber numberWithBool:live] 
						waitUntilDone:NO];
}
- (void)updateLiveShowStatus:(NSNumber *)live
{
	if ([live boolValue])
	{
		[liveShowStatusLabel setText:@"Live"];
	}
	else
	{
		[liveShowStatusLabel setText:@"Not Live"];
	}
}

@end
