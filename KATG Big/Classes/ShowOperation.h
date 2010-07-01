//
//  ShowOperation.h
//  KATG Big
//
//  Created by Doug Russell on 6/25/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ShowOperationDelegate;

@interface ShowOperation : NSOperation 
{
@public
	id<ShowOperationDelegate> delegate;
@private
	NSArray * _shows;
}

@property (nonatomic, assign) id<ShowOperationDelegate> delegate;
@property (nonatomic, copy)   NSArray * shows;

- (id)initWithShows:(NSArray *)shws;

@end

@protocol ShowOperationDelegate
- (NSManagedObjectContext *)managedObjectContext;
@end