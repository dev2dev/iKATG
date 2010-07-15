//
//  ESConnection.h
//
//  Created by Doug Russell on 5/28/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

// 
//  Simple Implementation of NSURLConnection where the
//  asynchronous request is made synchronous by blocking
//  the thread while it finishes it work. This is useful
//  to allow use of the various delegate methods in 
//  asynchronous NSURLConnection in a threaded environment
//  where a thread may finish and clean up before the 
//  delegate methods can be called. As a sample
//  the ESConnectionProgressNotification is used to 
//  notify users of the percentage completion of the
//  upload portion of a post. Something similar could
//  be done easily by taking advantage of the NSURLResponse
//  and tracking downloaded bytes against expected size
//

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

static NSString *const ESConnectionProgressNotification = @"ESConnectionProgressNotification";

@interface ESConnection : NSObject 
{
	id delegate;
	NSURLConnection *_connection;
	NSMutableData *_data;
	NSURLResponse *_response;
	NSError       *_error;
	NSString      *_connectionID;
	BOOL          _finished;
}

@property (readwrite, assign) id delegate;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *data;
@property (nonatomic, retain) NSURLResponse *response;
@property (nonatomic, retain) NSError       *error;
@property (nonatomic, retain) NSString      *connectionID;
@property (readwrite)         BOOL          finished;

- (id)initWithRequest:(NSURLRequest *)aRequest 
		 connectionID:(NSString *)aConnectionID
			 delegate:(id)aDelegate;

- (id)initWithRequest:(NSURLRequest *)aRequest 
		 connectionID:(NSString *)aConnectionID;

//- (NSData *)initWithRequest:(NSURLRequest *)aRequest 
//			   connectionID:(NSString *)aConnectionID 
//				   response:(NSURLResponse **)aResponse 
//					  error:(NSError **)anError;

@end
