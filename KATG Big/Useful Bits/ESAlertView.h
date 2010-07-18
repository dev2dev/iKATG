//
//  ESAlertView.h
//  KATG Big
//
//  Created by Doug Russell on 7/17/10.
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

@protocol ESAlertViewDelegate;

@interface ESAlertView : UIView 
{
	id<ESAlertViewDelegate> _delegate;
	NSString	*	_title;
	NSString	*	_message;
	NSString	*	_cancelButtonTitle;
	NSString	*	_otherButtonTitle;
}

@property (nonatomic, assign) id<ESAlertViewDelegate> delegate;
@property (nonatomic, retain) NSString	*	title;
@property (nonatomic, retain) NSString	*	message;
@property (nonatomic, retain) NSString	*	cancelButtonTitle;
@property (nonatomic, retain) NSString	*	otherButtonTitle;

- (id)initWithTitle:(NSString *)title 
			message:(NSString *)message 
		   delegate:(id <ESAlertViewDelegate>)delegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle 
   otherButtonTitle:(NSString *)otherButtonTitle;
- (void)show;
- (void)dismiss;

@end

@protocol ESAlertViewDelegate <NSObject>
@optional
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(ESAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
//- (void)alertViewCancel:(ESAlertView *)alertView;

- (void)willPresentAlertView:(ESAlertView *)alertView;  // before animation and showing view
- (void)didPresentAlertView:(ESAlertView *)alertView;  // after animation

- (void)alertView:(ESAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
- (void)alertView:(ESAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation
@end
