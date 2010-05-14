//
//  Request.h
//  DataModel
//
//  Created by Doug Russell on 3/22/10.
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

#import <UIKit/UIKit.h>

@protocol RequestDelegate;
@interface Request : NSObject 
{
	id<RequestDelegate> delegate;
	NSString *baseURL;
	NSString *URI;
	NSDictionary *userInfo;
	NSInteger instanceCode;
	BOOL retry;
	BOOL secondAttempt;
	NSUserDefaults *userDefaults;
}

@property (nonatomic, assign) id<RequestDelegate> delegate;
@property (nonatomic, retain) NSString *baseURL;
@property (nonatomic, retain) NSString *URI;
@property (nonatomic, retain) NSDictionary *userInfo;
@property (readwrite, assign) NSInteger instanceCode;

- (void)get;
- (void)post:(NSDictionary *)bufferDict;
- (void)post:(NSDictionary *)bufferDict data:(NSDictionary *)data;

@end

@protocol RequestDelegate
- (void)requestDone:(Request *)rqst;
- (void)requestFailed:(Request *)rqst error:(NSError *)error;
- (BOOL)isCancelled;
@optional
- (void)requestDidReturnData:(NSData *)data instance:(NSInteger)instanceCode;
@end
