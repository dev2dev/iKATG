//
//  DataOperation.h
//  DataModel
//
//  Created by Doug Russell on 3/20/10.
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
- (void)procesShowsList:(NSArray *)entries;

@end
