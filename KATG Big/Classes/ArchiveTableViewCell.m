//
//  ArchiveTableViewCell.m
//  KATG Big
//
//  Created by Doug Russell on 7/11/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "ArchiveTableViewCell.h"
#import <Quartzcore/QuartzCore.h>

@implementation ArchiveTableViewCell
@synthesize showTypeImageView;
@synthesize showTitleLabel;
@synthesize showGuestsLabel;
@synthesize showNotesImageView;
@synthesize showPicsImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) 
	{
		[self setup];
	}
	return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:(NSCoder *)aDecoder]) 
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
		if ([self.showTypeImageView.image isEqual:[UIImage imageNamed:@"TVShow"]])
			self.showTypeImageView.image	=	[UIImage imageNamed:@"TVShowSelected"];
		else if ([self.showTypeImageView.image isEqual:[UIImage imageNamed:@"AudioShow"]])
			self.showTypeImageView.image	=	[UIImage imageNamed:@"AudioShowSelected"];
		if (self.showNotesImageView.image != nil)
			self.showNotesImageView.image	=	[UIImage imageNamed:@"HasNotesSelected"];
		if (self.showPicsImageView.image != nil)
			self.showPicsImageView.image	=	[UIImage imageNamed:@"HasPicsSelected"];
		[self.showTitleLabel setTextColor:[UIColor blackColor]];
		[self.showTitleLabel setShadowColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5]];
		[self.showGuestsLabel setTextColor:[UIColor blackColor]];
	}
	else 
	{
		if ([self.showTypeImageView.image isEqual:[UIImage imageNamed:@"TVShowSelected"]])
			self.showTypeImageView.image	=	[UIImage imageNamed:@"TVShow"];
		else if ([self.showTypeImageView.image isEqual:[UIImage imageNamed:@"AudioShowSelected"]])
			self.showTypeImageView.image	=	[UIImage imageNamed:@"AudioShow"];
		if (self.showNotesImageView.image != nil)
			self.showNotesImageView.image	=	[UIImage imageNamed:@"HasNotes"];
		if (self.showPicsImageView.image != nil)
			self.showPicsImageView.image	=	[UIImage imageNamed:@"HasPics"];
		[self.showTitleLabel setTextColor:[UIColor whiteColor]];
		[self.showTitleLabel setShadowColor:[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:0.5]];
		[self.showGuestsLabel setTextColor:[UIColor whiteColor]];
	}

}
- (void)dealloc 
{
	[_showTypeImageView release];
	[_showTitleLabel release];
	[_showGuestsLabel release];
	[_showNotesImageView release];
	[_showPicsImageView release];
	[super dealloc];
}

@end
