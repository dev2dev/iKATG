//
//  RoundedButton.h
//  KATG Big
//
//  Created by Doug Russell on 5/10/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundedButton : UIButton 
{
	UIColor *initialBackgroundColor;
	UIColor *highlightColor;
}

@property (nonatomic, copy) UIColor *highlightColor;

@end
