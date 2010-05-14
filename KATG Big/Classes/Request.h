//
//  Request.h
//  DataModel
//
//  Created by Doug Russell on 3/22/10.
//  Copyright 2010 Doug Russell. All rights reserved.
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
