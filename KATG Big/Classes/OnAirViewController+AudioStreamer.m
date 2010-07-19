//
//  OnAirViewController+AudioStreamer.m
//  KATG.com
//
//  Copyright 2009 Doug Russell
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

#define testFeed 1
#if testFeed
static NSString *urlString = @"http://scfire-mtc-aa05.stream.aol.com:80/stream/1010";
#else
static NSString *urlString = @"http://liveshow.keithandthegirl.com:8004";
#endif

#import "OnAirViewController+AudioStreamer.h"
#import "AudioStreamer.h"
#import <QuartzCore/CoreAnimation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIImage+MyAdditions.h"

@implementation OnAirViewController (AudioStreamer)

#pragma mark -
#pragma mark Setup
#pragma mark -
- (void)setupAudioAssets 
{
	[self setAudioButtonImage:[UIImage imageNamed:@"Play"]];
	[self drawVolumeSlider];
}
#pragma mark -
#pragma mark Shoutcast
#pragma mark -
- (void)setAudioButtonImage:(UIImage *)image 
{
	[self.audioButton.imageView stopAnimating];
	if (!image)
	{
		[audioButton setImage:[UIImage imageNamed:@"Play"] forState:0];
	}
	else
	{
		[audioButton setImage:image forState:0];
		
		if ([audioButton.currentImage isEqual:[UIImage imageNamed:@"LoadStage0"]])
		{
			[self pulseButton];
		}
	}
}
//
//
//
- (void)pulseButton
{
	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
	{
		if (self.audioButton.imageView.animationImages == nil)
		{
			NSArray	*	imageArray	=
			[[NSArray alloc] initWithObjects:
			 [UIImage imageNamed:@"LoadStage0"],
			 [UIImage imageNamed:@"LoadStage1"],
			 [UIImage imageNamed:@"LoadStage2"],
			 [UIImage imageNamed:@"LoadStage3"], nil];
			self.audioButton.imageView.animationImages		=	imageArray;
			self.audioButton.imageView.animationDuration	=	0.8;
			[imageArray release];		
		}
		[self.audioButton.imageView startAnimating];
	}
}
//
// buttonPressed:
//
// Handles the play/stop button. Creates, observes and starts the
// audio streamer when it is a play button. Stops the audio streamer when
// it isn't.
//
// Parameters:
//    sender - normally, the play/stop button.
//
- (IBAction)audioButtonPressed:(id)sender
{
	if ([audioButton.currentImage isEqual:[UIImage imageNamed:@"Play"]])
	{
		[self setAudioButtonImage:[UIImage imageNamed:@"LoadStage0"]];
		[self createStreamer];
		[streamer start];
	}
	else
	{
		[streamer stop];
	}
}
//
// playbackStateChanged:
//
// Invoked when the AudioStreamer
// reports that its playback status has changed.
//
- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([streamer isWaiting])
	{
		[self setAudioButtonImage:[UIImage imageNamed:@"LoadStage0"]];
	}
	else if ([streamer isPlaying])
	{
		[self setAudioButtonImage:[UIImage imageNamed:@"Stop"]];
	}
	else if ([streamer isIdle])
	{
		[self destroyStreamer];
		[self setAudioButtonImage:[UIImage imageNamed:@"Play"]];
	}
}
//
// destroyStreamer
//
// Removes the streamer, the UI update timer and the change notification
//
- (void)destroyStreamer
{
	if (streamer)
	{
		[[NSNotificationCenter defaultCenter]
		 removeObserver:self
		 name:ASStatusChangedNotification
		 object:streamer];
		[streamer stop];
		[streamer release];
		streamer = nil;
	}
}
// 
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
- (void)createStreamer
{
	if (streamer)
	{
		return;
	}
	
	[self destroyStreamer];
	
	NSURL *url = [NSURL URLWithString:urlString];
	
	streamer = [[AudioStreamer alloc] initWithURL:url];
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(playbackStateChanged:)
	 name:ASStatusChangedNotification
	 object:streamer];
}

#pragma mark -
#pragma mark Volume
#pragma mark -
- (void)drawVolumeSlider 
{
	UISlider	*	volumeViewSlider	=	nil;
	for (UIView *view in [volumeView subviews]) 
	{
		if ([view isKindOfClass:NSClassFromString(@"MPVolumeSlider")])
		//if ([[[view class] description] isEqualToString:@"MPVolumeSlider"]) 
			volumeViewSlider			=	(UISlider *)view;
	}
	UIImage		*	left				=	[UIImage imageNamed:@"LeftSlide"];
	UIImage		*	right				=	[UIImage imageNamed:@"RightSlide"];
	[volumeViewSlider setMinimumTrackImage:
	 [left stretchableImageWithLeftCapWidth:10.0 
							   topCapHeight:0.0] 
								  forState:UIControlStateNormal];
	[volumeViewSlider setMaximumTrackImage:
	 [right stretchableImageWithLeftCapWidth:10.0 
								topCapHeight:0.0] 
								  forState:UIControlStateNormal];
}

@end
