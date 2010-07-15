//
//  ArchiveTableViewCell.h
//  KATG Big
//
//  Created by Doug Russell on 7/11/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchiveTableViewCell : UITableViewCell 
{
	UIImageView	*	_showTypeImageView;
	UILabel		*	_showTitleLabel;
	UILabel		*	_showGuestsLabel;
	UIImageView	*	_showNotesImageView;
	UIImageView	*	_showPicsImageView;
}

@property (nonatomic, retain) IBOutlet 	UIImageView	*	showTypeImageView;
@property (nonatomic, retain) IBOutlet 	UILabel		*	showTitleLabel;
@property (nonatomic, retain) IBOutlet 	UILabel		*	showGuestsLabel;
@property (nonatomic, retain) IBOutlet 	UIImageView	*	showNotesImageView;
@property (nonatomic, retain) IBOutlet 	UIImageView	*	showPicsImageView;

@end
