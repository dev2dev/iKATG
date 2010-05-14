//
//  Request.m
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

#import "Request.h"
#import "RequestLogging.h"

static NSString *const kBaseURL = @"http://www.keithandthegirl.com";
//static NSString *const kUserAgent = @"KATG.com/1.20 CFNetwork/467.12 Darwin/10.3.1";
static NSString *const kUserAgent = @"KATG.com";

@interface Request (PrivateMethods)
- (NSData *)formBody:(NSDictionary *)bufferDict;
- (NSData *)multipartFormBody:(NSDictionary *)bufferDict data:(NSDictionary *)data stringBoundary:(NSString *)stringBoundary;
- (NSString *)urlEncodeString:(NSString *)string;
- (NSData *)retrieveData:(NSURLRequest *)request retry:(BOOL *)rtry;
@end

@implementation Request
@synthesize delegate, baseURL, URI, userInfo, instanceCode;

#pragma mark -
#pragma mark SetupCleanup
#pragma mark -
- (id)init
{
	if (self = [super init])
	{
		[self setBaseURL:kBaseURL];
		userDefaults = [NSUserDefaults standardUserDefaults];
	}
	return self;
}
- (void)dealloc
{
	[baseURL release];
	[URI release];
	[userInfo release];
	[super dealloc];
}
#pragma mark -
#pragma mark Public Interface
#pragma mark -
- (void)get
{
	if (![self delegate].isCancelled)
	{
		NSString *urlString = [NSString stringWithFormat:@"%@%@", baseURL, URI];
		
		if (![self delegate].isCancelled && urlString)
		{
			NSURL *url = [NSURL URLWithString:urlString];
			
			if (![self delegate].isCancelled && url)
			{
				NSMutableURLRequest *getRequest = [NSMutableURLRequest requestWithURL:url];				
				// Drop this logic into post method
				BOOL rtry = NO;
				NSData *responseData = [self retrieveData:getRequest retry:&rtry];
				if (responseData != nil && ![self delegate].isCancelled)
				{
					if ([(NSObject *)[self delegate] respondsToSelector:@selector(requestDidReturnData:instance:)]  && ![self delegate].isCancelled)
					{
						[[self delegate] requestDidReturnData:responseData instance:instanceCode];
					}
				} else if (rtry) {
					rtry = NO;
					NSData *responseData = [self retrieveData:getRequest retry:&retry];
					if (responseData != nil && ![self delegate].isCancelled)
					{
						if ([(NSObject *)[self delegate] respondsToSelector:@selector(requestDidReturnData:instance:)]  && ![self delegate].isCancelled)
						{
							[[self delegate] requestDidReturnData:responseData instance:instanceCode];
						}
					}
					else
					{
						//failed
					}
				}
				else
				{
					//failed
				}
			}
		}
	}
}
- (void)post:(NSDictionary *)bufferDict
{
	[self post:bufferDict data:nil];
}
- (void)post:(NSDictionary *)bufferDict data:(NSDictionary *)data
{
	if (![self delegate].isCancelled)
	{
		NSString *urlString = [NSString stringWithFormat:@"%@%@", baseURL, URI];
		
		if (![self delegate].isCancelled && urlString)
		{
			NSURL *url = [NSURL URLWithString:urlString];
			
			if (![self delegate].isCancelled && url)
			{
				NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:url];
				
				[postRequest setHTTPMethod:@"POST"];
				
				NSData *postBody;
				if (data == nil)
				{
					postBody = [self formBody:bufferDict];
				}
				else
				{
					NSString *stringBoundary = 
					[NSString stringWithString:@"---------------------------0xKhTmLbOuNdArY"];
					
					NSString *contentType = 
					[NSString stringWithFormat:@"multipart/form-data; boundary=%@", stringBoundary];
					
					[postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
					
					postBody = [self multipartFormBody:bufferDict 
												  data:data 
										stringBoundary:stringBoundary];
				}
				
				[postRequest setHTTPBody:postBody];
				
				//NSLog(@"%@", [postBody base64EncodedString]);
				
				if (![self delegate].isCancelled && [NSURLConnection canHandleRequest:postRequest])
				{
					NSError *error; NSHTTPURLResponse *response;
					NSData *responseData;
					responseData = [NSURLConnection sendSynchronousRequest:postRequest 
														 returningResponse:&response 
																	 error:&error];
					if (responseData && ![self delegate].isCancelled)
					{
						long long length = [response expectedContentLength];
						//NSString *fileName = [response suggestedFilename];
						//NSString *mimeType = [response MIMEType];
						//NSString *textEncoding = [response textEncodingName];
						if ([responseData length] == length)
						{
							if (responseData && ![self delegate].isCancelled)
							{
								if ([(NSObject *)[self delegate] respondsToSelector:@selector(requestDidReturnData:instance:)]  && ![self delegate].isCancelled)
								{
									[[self delegate] requestDidReturnData:responseData instance:instanceCode];
								}
							}
						}
						else
						{
							retry = YES;
						}
					}
					else if (error)
					{
						NSInteger errorCode = [error code];
						if (errorCode == NSURLErrorTimedOut ||
							errorCode == NSURLErrorCannotFindHost ||
							errorCode == NSURLErrorCannotConnectToHost ||
							errorCode == NSURLErrorNetworkConnectionLost ||
							errorCode == NSURLErrorHTTPTooManyRedirects ||
							errorCode == NSURLErrorNotConnectedToInternet ||
							errorCode == NSURLErrorBadServerResponse)
						{
							retry = YES;
						}
					}
				}
			}
		}
		if (![self delegate].isCancelled && retry && !secondAttempt)
		{
			retry = NO;
			secondAttempt = YES;
			[self post:bufferDict data:data];
		} 
		else if (![self delegate].isCancelled && retry && secondAttempt)
		{
			if (![self delegate].isCancelled)
			{
				[[self delegate] requestFailed:self error:nil];
			}
		}
		else
		{
			if (![self delegate].isCancelled)
			{
				[[self delegate] requestDone:self];
			}
		}
	}
}
#pragma mark -
#pragma mark Post Body
#pragma mark -
- (NSData *)formBody:(NSDictionary *)bufferDict
{
	NSString *buffer = @"";
	NSArray *keys = [bufferDict allKeys];
	NSString *value;
	/*******************/
	// USER AGENT STUB //
	/*******************/
	value = [NSString stringWithFormat:@"%@=%@&", @"User-Agent", [self urlEncodeString:kUserAgent]];
	buffer = [buffer stringByAppendingString:value];
	/*******************/
	// USER AGENT STUB //
	/*******************/
	for (NSString *key in keys) 
	{
		value = [self urlEncodeString:[bufferDict objectForKey:key]];
		value = [NSString stringWithFormat:@"&%@=%@", key, value];
		if (value)
		{
			buffer = [buffer stringByAppendingString:value];
		}
	}
#if LogBuffer
	NSLog(@"\nPost Buffer\n\n%@\n\n", buffer);
#endif
	NSData *postBody = [NSData dataWithBytes:[buffer UTF8String] length:[buffer length]];
	return postBody;
}
- (NSData *)multipartFormBody:(NSDictionary *)bufferDict data:(NSDictionary *)data stringBoundary:(NSString *)stringBoundary
{	
	NSMutableData *postBody = [NSMutableData data];
	
	NSArray *keys = [bufferDict allKeys];
	NSString *value;
	/*******************/
	// USER AGENT STUB //
	/*******************/
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"User-Agent"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:kUserAgent] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	/*******************/
	// USER AGENT STUB //
	/*******************/
	for (NSString *key in keys) 
	{
		if (![self delegate].isCancelled)
		{
			value = [bufferDict objectForKey:key];
			if (value)
			{
				[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
				[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
				[postBody appendData:[[NSString stringWithString:value] dataUsingEncoding:NSUTF8StringEncoding]];
				[postBody appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
			}
		} 
		else 
		{
			break;
		}
		
	}
	
#if LogDataBuffer
	NSLog(@"\nPost Buffer\n\n%@\n\n", [[[NSString alloc] initWithData:postBody encoding:NSUTF8StringEncoding] autorelease]);
#endif
	
	keys = [data allKeys];
	NSData *dataValue;
	for (NSString *key in keys) 
	{
		if (![self delegate].isCancelled)
		{
			dataValue = [data objectForKey:key];
			if (dataValue)
			{
				[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
				[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"fileupload\"; filename=\"%@\"\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
				[postBody appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
				[postBody appendData:dataValue];
				[postBody appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
			}
		}
		else
		{
			break;
		}
	}
	
	[postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	return (NSData *)postBody;
}
#pragma mark -
#pragma mark URL Encoding
#pragma mark -
- (NSString *)urlEncodeString:(NSString *)string
{
	NSString *encodedString = @"";
	if (![self delegate].isCancelled)
	{
		CFStringRef escapeChars = CFSTR("/&?=+");
		CFStringRef encodedText = CFURLCreateStringByAddingPercentEscapes(NULL, 
																		  (CFStringRef)string, 
																		  NULL, 
																		  escapeChars, 
																		  kCFStringEncodingUTF8);
		encodedString = [NSString stringWithFormat:@"%@", (NSString *)encodedText];
		CFRelease(encodedText);
		CFRelease(escapeChars);
	}
	return encodedString;
}
#pragma mark -
#pragma mark NSURLConnection
#pragma mark -
- (NSData *)retrieveData:(NSURLRequest *)request retry:(BOOL *)rtry
{
	if (![self delegate].isCancelled && [NSURLConnection canHandleRequest:request])
	{
		NSError *error; NSHTTPURLResponse *response;
		NSData *responseData;
		responseData = [NSURLConnection sendSynchronousRequest:request 
											 returningResponse:&response 
														 error:&error];
		if (responseData && ![self delegate].isCancelled)
		{
			long long length = [response expectedContentLength];
			//NSString *fileName = [response suggestedFilename];
			//NSString *mimeType = [response MIMEType];
			//NSString *textEncoding = [response textEncodingName];
			if ([responseData length] == length)
			{
				if (responseData && ![self delegate].isCancelled)
				{
					return responseData;
				}
			}
			else
			{
				*rtry = YES;
			}
		}
		else if (error)
		{
			NSInteger errorCode = [error code];
			if (errorCode == NSURLErrorTimedOut ||
				errorCode == NSURLErrorCannotFindHost ||
				errorCode == NSURLErrorCannotConnectToHost ||
				errorCode == NSURLErrorNetworkConnectionLost ||
				errorCode == NSURLErrorHTTPTooManyRedirects ||
				errorCode == NSURLErrorNotConnectedToInternet ||
				errorCode == NSURLErrorBadServerResponse)
			{
				*rtry = YES;
			}
		}
	}
	return nil;
}

@end
