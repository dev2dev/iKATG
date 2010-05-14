//
//  DataOperation.h
//  DataModel
//
//  Created by Doug Russell on 3/20/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"
#import "GrabXMLFeed.h"

@protocol DataOperationDelegate;

@interface DataOperation : NSOperation <RequestDelegate, GrabXMLFeedDelegate> 
{
	id<DataOperationDelegate> delegate;
	NSInteger code;
	NSString *baseURL;
	NSString *URI;
	NSDictionary *bufferDict;
	NSDictionary *dataDict;
	NSDictionary *userInfo;
	Request *request;
	GrabXMLFeed *aParser;
	BOOL retryAttempt;
}

@property (nonatomic, assign) id<DataOperationDelegate> delegate;
@property (readwrite, assign) NSInteger                 code;
@property (nonatomic, copy)   NSString                  *baseURL;
@property (nonatomic, copy)   NSString                  *URI;
@property (nonatomic, copy)   NSDictionary              *bufferDict;
@property (nonatomic, copy)   NSDictionary              *dataDict;
@property (nonatomic, copy)   NSDictionary              *userInfo;

@end

@protocol DataOperationDelegate

@optional

- (void)dataOperationDidFinish:(DataOperation *)op;
- (void)dataOperationDidFail:(DataOperation *)op withError:(NSError *)error;

@optional
- (void)processEventsList:(NSArray *)entries;
- (void)processLiveShowStatus:(NSArray *)entries;
@end
