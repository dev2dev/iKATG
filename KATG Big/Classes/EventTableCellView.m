//
//  EventTableCellView.m
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

#import "EventTableCellView.h"
#import <QuartzCore/QuartzCore.h>

@interface EventTableCellView ()
- (void)setup;
@end

@implementation EventTableCellView
@synthesize eventTypeImageView;
@synthesize eventTitleLabel;
@synthesize eventDayLabel;
@synthesize eventDateLabel;
@synthesize eventTimeLabel;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:(NSCoder *)aDecoder]) 
	{
		[self setup];
    }
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) 
	{
		[self setup];
	}
	return self;
}
- (void)setup
{
	UIView			*	view		=	[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
	CAGradientLayer	*	gradient	=	[CAGradientLayer layer];
	gradient.frame					=	view.bounds;
	gradient.colors					=	[NSArray arrayWithObjects:
										 (id)[[UIColor colorWithRed:(CGFloat)(112.0/255.0) 
															  green:(CGFloat)(174.0/255.0) 
															   blue:(CGFloat)(36.0/255.0) 
															  alpha:1.0] CGColor], 
										 (id)[[UIColor colorWithRed:(CGFloat)(57.0/255.0) 
															  green:(CGFloat)(143.0/255.0) 
															   blue:(CGFloat)(47.0/255.0) 
															  alpha:1.0] CGColor], nil];
	[view.layer insertSublayer:gradient atIndex:0];
	self.backgroundView				=	view;
	[view release];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
	[super setSelected:selected animated:animated];
	if (selected)
	{
		[self.eventTitleLabel setTextColor:[UIColor blackColor]];
		[self.eventTitleLabel setShadowColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5]];\
		[self.eventDayLabel setTextColor:[UIColor blackColor]];
		[self.eventDateLabel setTextColor:[UIColor blackColor]];
		[self.eventTimeLabel setTextColor:[UIColor blackColor]];
	}
	else 
	{
		[self.eventTitleLabel setTextColor:[UIColor whiteColor]];
		[self.eventTitleLabel setShadowColor:[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:0.5]];
		[self.eventDayLabel setTextColor:[UIColor whiteColor]];
		[self.eventDateLabel setTextColor:[UIColor whiteColor]];
		[self.eventTimeLabel setTextColor:[UIColor whiteColor]];
	}
}
- (void)dealloc 
{
	[eventTypeImageView release];
	[eventTitleLabel release];
	[eventDayLabel release];
	[eventDateLabel release];
	[eventTimeLabel release];
    [super dealloc];
}

@end
