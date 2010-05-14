//
//  DataModelDelegate.h
//  KATG Big
//
//  Created by Doug Russell on 5/5/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DataModelDelegate
@optional
- (void)events:(NSArray *)events;
- (void)liveShowStatus:(BOOL)live;
@end
