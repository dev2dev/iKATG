    //
//  OnAirViewController.m
//  KATG Big
//
//  Created by Doug Russell on 5/5/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "OnAirViewController.h"
#import "OnAirViewController+AudioStreamer.h"
#import "OnAirViewController+Feedback.h"
#import "NSString+Regex.h"

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
	
	[model liveShowStatus];
	
	[model events];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return NO;
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
- (void)events:(NSArray *)events
{
	if ([NSThread isMainThread])
	{
		if (events && events.count > 0)
		{
			for (NSDictionary *event in events)
			{
				NSDate *date = [event objectForKey:@"DateTime"];
				NSInteger since = [date timeIntervalSinceNow];
				if (since > 0 && [[event objectForKey:@"ShowType"] boolValue])
				{
					timeSince = since;
					NSInteger d = timeSince / 86400;
					NSInteger h = timeSince / 3600 - d * 24;
					NSInteger m = timeSince / 60 - d * 1440 - h * 60;
					[[self nextLiveShowLabel] setText:[NSString stringWithFormat:@"%02d : %02d : %02d", d, h, m]];
					NSString *title = [event objectForKey:@"Title"];
					if (title)
						[self findGuest:title];
					break;
				}
			}
		}
	}
	else
	{
		[self performSelectorOnMainThread:@selector(events:) 
							   withObject:events 
							waitUntilDone:NO];
	}
}
- (void)findGuest:(NSString *)eventTitle
{
	if ([NSThread isMainThread])
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
	else
	{
		[self performSelectorOnMainThread:@selector(findGuest:) 
							   withObject:eventTitle 
							waitUntilDone:NO];
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
