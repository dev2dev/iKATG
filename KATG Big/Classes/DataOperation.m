//
//  DataOperation.m
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

#import "DataOperation.h"
#import "DataOperationCodes.h"
#import "DataOperationLogging.h"

@implementation DataOperation
@synthesize delegate, code, baseURL, URI, bufferDict, dataDict, userInfo;

#pragma mark -
#pragma mark SetupCleanup
- (id)init
{
	if (self = [super init])
	{
		
	}
	return self;
}
- (void)dealloc
{
	delegate = nil;
	[URI release];
	[baseURL release];
	[bufferDict release];
	[dataDict release];
	[userInfo release];
	[request release];
	[aParser release];
	[super dealloc];
}
#pragma mark -
#pragma mark 
#pragma mark -
- (void)main
{
	if (!self.isCancelled)
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		request = [[Request alloc] init];
		[request setDelegate:self];
		[request setInstanceCode:code];
		[request setURI:URI];
		
		if (baseURL != nil)
		{
			[request setBaseURL:baseURL];
		}
		
		if (userInfo != nil)
		{
			[request setUserInfo:userInfo];
		}
		
		if (!self.isCancelled && dataDict == nil && bufferDict == nil)
		{
			[request get];
		}
		else if (!self.isCancelled && dataDict == nil && bufferDict != nil)
		{
			[request post:bufferDict];
		}
		else if (!self.isCancelled && dataDict != nil && bufferDict != nil)
		{
			[request post:bufferDict data:dataDict];
		} 
		else 
		{
			//failed
		}
		
		[URI release]; URI = nil;
		[bufferDict release]; bufferDict = nil;
		[dataDict release]; dataDict = nil;
		[userInfo release]; userInfo = nil;
		[request release]; request = nil;
		[aParser release]; aParser = nil;
		
		[pool drain];
	}
}
#pragma mark -
#pragma mark Post Delegates
#pragma mark -
- (void)requestDone:(Request *)rqst
{
	[request release];
	request = nil;
}
- (void)requestFailed:(Request *)rqst error:(NSError *)error
{
	//NSLog(@"Request Failed");
}
- (void)requestDidReturnData:(NSData *)data instance:(NSInteger)instanceCode
{
#if LogAllReturnedData
	NSLog(@"\nReturned Data for Instance %d: \n\n%@\n\n", instanceCode, [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
#endif
	switch (instanceCode) 
	{
		case kEventsListCode:
#if LogEventsXML
			NSLog(@"\nEvents XML for Instance %d: \n\n%@\n\n", instanceCode, [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
#endif
			aParser = [[GrabXMLFeed alloc] initWithData:data xPath:@"//Event"];
			[aParser setDelegate:self];
			[aParser setInstanceNumber:code];
			[aParser parse];
			break;
		case kLiveShowStatusCode:
#if LogFeedStatusXML
			NSLog(@"\nFeed Status XML for Instance %d: \n\n%@\n\n", instanceCode, [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
#endif
			aParser = [[GrabXMLFeed alloc] initWithData:data xPath:@"//root"];
			[aParser setDelegate:self];
			[aParser setInstanceNumber:code];
			[aParser parse];
			break;
		case kShowArchivesCode:
#if LogShowArchiveXML
			NSLog(@"\nFeed Status XML for Instance %d: \n\n%@\n\n", instanceCode, [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
#endif
			aParser = [[GrabXMLFeed alloc] initWithData:data xPath:@"//S"];
			[aParser setDelegate:self];
			[aParser setInstanceNumber:code];
			[aParser parse];
			break;
		default:
			break;
	}
}
#pragma mark -
#pragma mark GrabXMLFeed Delegates
#pragma mark -
- (void)parsingDidCompleteForNode:(NSDictionary *)node parser:(GrabXMLFeed *)parser
{
	if (self.isCancelled)
	{
		[parser cancel];
	}
}
- (void)parsingDidCompleteSuccessfully:(GrabXMLFeed *)parser
{
	NSArray *entries;
	entries = [[parser feedEntries] copy];
#if LogAllParsed
	NSLog(@"\nParsed XML with Instance %d \n\n%@\n\n", [parser instanceNumber], entries);
#endif
	switch ([parser instanceNumber]) 
	{
		case kEventsListCode:
#if LogEventsParsed
			NSLog(@"\nParsed Events XML with Instance %d \n\n%@\n\n", [parser instanceNumber], entries);
#endif
			[[self delegate] processEventsList:(NSArray *)entries];
			break;
		case kLiveShowStatusCode:
#if LogFeedStatusXML
			NSLog(@"\nParsed Feed Status XML with Instance %d \n\n%@\n\n", [parser instanceNumber], entries);
#endif
			[[self delegate] processLiveShowStatus:entries];
			break;
		case kShowArchivesCode:
#if LogShowArchiveParsed
			NSLog(@"\nParsed Feed Status XML with Instance %d \n\n%@\n\n", [parser instanceNumber], entries);
#endif
			[[self delegate] procesShowsList:entries];
			break;
		default:
			break;
	}
	[entries release];
	[[self delegate] dataOperationDidFinish:self];
}

@end
