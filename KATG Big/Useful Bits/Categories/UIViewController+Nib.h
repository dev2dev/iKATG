//
//  UIViewController+Nib.h
//  PartyCamera
//
//  Created by Doug Russell on 6/17/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Nib)
+ (id)loadFromNibName:(NSString *)nibNameOrNil owner:(id)owner;
@end

@interface UIView (Nib)
+ (id)loadFromNibName:(NSString *)nibNameOrNil owner:(id)owner;
@end
