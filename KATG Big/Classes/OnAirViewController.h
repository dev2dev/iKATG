//
//  OnAirViewController.h
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

#import <UIKit/UIKit.h>
#import "DataModel.h"

@class MPVolumeView;
@class AudioStreamer;
@class RoundedView, RoundedTextView, GradButton, RoundedTextField;
@interface OnAirViewController : UIViewController
<UITextViewDelegate, DataModelDelegate>
{
	//
	//  Data Model
	//
	DataModel			*	model;
	//
	//  Feedback
	//
	UIView				*	feedbackView;
	RoundedTextField	*	nameField;
	RoundedTextField	*	locationField;
	RoundedTextView		*	commentView;
	GradButton			*	submitButton;
	//
	//  Audio Playback
	//
	UIButton			*	audioButton;
	AudioStreamer		*	streamer;
	//
	//  Volume Slider
	//
	MPVolumeView		*	volumeView;
	//
	//  Countdown to next live show
	//
	UILabel				*	nextLiveShowLabel;
	//
	//  
	//
	BOOL					_live;
	UILabel				*	liveShowStatusLabel;
	//
	//
	//
	UILabel				*	guestLabel;
}
//
//  Feedback
//
@property (nonatomic, retain) IBOutlet UIView			*	feedbackView;
@property (nonatomic, retain) IBOutlet RoundedTextField	*	nameField;
@property (nonatomic, retain) IBOutlet RoundedTextField	*	locationField;
@property (nonatomic, retain) IBOutlet RoundedTextView	*	commentView;
@property (nonatomic, retain) IBOutlet GradButton		*	submitButton;
//
//
//
@property (nonatomic, retain) IBOutlet UIButton			*	audioButton;
//
//
//
@property (nonatomic, retain) IBOutlet MPVolumeView		*	volumeView;
//
//
//
@property (nonatomic, retain) IBOutlet UILabel			*	nextLiveShowLabel;
//
//
//
@property (nonatomic, assign, getter=isLive) BOOL			live;
@property (nonatomic, retain) IBOutlet	UILabel			*	liveShowStatusLabel;
//
//
//
@property (nonatomic, retain) IBOutlet UILabel			*	guestLabel;


- (IBAction)submitButtonPressed:(id)sender;
- (void)findGuest:(NSString *)eventTitle;

@end
