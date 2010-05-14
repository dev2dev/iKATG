//
//  OnAirViewController.h
//  KATG Big
//
//  Created by Doug Russell on 5/5/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@class MPVolumeView;
@class AudioStreamer;
@class RoundedView, RoundedTextView, RoundedButton, RoundedTextField;
@interface OnAirViewController : UIViewController
<UITextViewDelegate, DataModelDelegate>
{
	//
	//  Data Model
	//
	DataModel       *model;
	//
	//  Feedback
	//
	UIView          *feedbackView;
	RoundedTextField *nameField;
	RoundedTextField *locationField;
	RoundedTextView *commentView;
	RoundedButton   *submitButton;
	//
	//  Audio Playback
	//
	UIButton		 *audioButton;
	AudioStreamer    *streamer;
	//
	//  Volume Slider
	//
	MPVolumeView     *volumeView;
	//
	//  Countdown to next live show
	//
	UILabel          *nextLiveShowLabel;
	NSInteger        timeSince;
	//
	//  
	//
	UILabel          *liveShowStatusLabel;
	//
	//
	//
	UILabel          *guestLabel;
}
//
//  Feedback
//
@property (nonatomic, retain) IBOutlet UIView          *feedbackView;
@property (nonatomic, retain) IBOutlet RoundedTextField *nameField;
@property (nonatomic, retain) IBOutlet RoundedTextField *locationField;
@property (nonatomic, retain) IBOutlet RoundedTextView *commentView;
@property (nonatomic, retain) IBOutlet RoundedButton   *submitButton;
//
//
//
@property (nonatomic, retain) IBOutlet UIButton        *audioButton;
//
//
//
@property (nonatomic, retain) IBOutlet MPVolumeView    *volumeView;
//
//
//
@property (nonatomic, retain) IBOutlet UILabel         *nextLiveShowLabel;
//
//
//
@property (nonatomic, retain) IBOutlet UILabel         *liveShowStatusLabel;
//
//
//
@property (nonatomic, retain) IBOutlet UILabel         *guestLabel;


- (IBAction)submitButtonPressed:(id)sender;
- (void)findGuest:(NSString *)eventTitle;

@end
