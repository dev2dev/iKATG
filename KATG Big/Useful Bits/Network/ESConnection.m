//
//  ESConnection.m
//
//  Created by Doug Russell on 5/28/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "ESConnection.h"

@implementation ESConnection
@synthesize delegate;
@synthesize connection = _connection;
@synthesize data = _data;
@synthesize response = _response;
@synthesize error = _error;
@synthesize connectionID = _connectionID;
@synthesize finished = _finished;

@class Scale_Upload;
- (id)initWithRequest:(NSURLRequest *)aRequest 
		 connectionID:(NSString *)aConnectionID
			 delegate:(id)aDelegate
{
	if (self = [super init])
	{
		[self setDelegate:aDelegate];
		[self setConnectionID:aConnectionID];
		NSURLConnection *aConnection = 
		[[NSURLConnection alloc] 
		 initWithRequest:aRequest 
		 delegate:self];
		if (aConnection)
		{
			[self setConnection:aConnection];
			[aConnection release];
			NSMutableData *aData = 
			[[NSMutableData alloc] init];
			[self setData:aData];
			[aData release];
			while(![self finished]) 
			{
				NSOperation *op = [delegate delegate];
				BOOL cancelled = [op isCancelled];
				if (cancelled && [op isKindOfClass:NSClassFromString(@"ImageUploadOperation")])
				{
					[[self connection] cancel];
					[self setFinished:YES];
					[self setData:nil]; // replace this with error xml
					NSLog(@"connection %@ canceled", [self connectionID]);
				}
				else {
					//NSLog(@"connection %@", [self connectionID]);
				}
				[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
			}
		}
	}
	return self;
}
- (id)initWithRequest:(NSURLRequest *)aRequest 
		 connectionID:(NSString *)aConnectionID
{
	if (self = [super init])
	{
		[self setConnectionID:aConnectionID];
		NSURLConnection *aConnection = 
		[[NSURLConnection alloc] 
		 initWithRequest:aRequest 
		 delegate:self];
		if (aConnection)
		{
			[self setConnection:aConnection];
			[aConnection release];
			NSMutableData *aData = 
			[[NSMutableData alloc] init];
			[self setData:aData];
			[aData release];
			while(![self finished]) 
			{
				[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
			}
		}
	}
	return self;
}
- (NSData *)initWithRequest:(NSURLRequest *)aRequest 
			   connectionID:(NSString *)aConnectionID 
				   response:(NSURLResponse **)aResponse 
					  error:(NSError **)anError
{
	if (self = [super init])
	{
		[self setConnectionID:aConnectionID];
		NSURLConnection *aConnection = 
		[[NSURLConnection alloc] 
		 initWithRequest:aRequest 
		 delegate:self];
		if (aConnection)
		{
			[self setConnection:aConnection];
			[aConnection release];
			NSMutableData *aData = 
			[[NSMutableData alloc] init];
			[self setData:aData];
			[aData release];
			while(![self finished]) 
			{
				[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
			}
		}
		// Should add a null check for these pointers
		*anError = [self error];
		*aResponse = [self response];
	}
	return [[self data] retain];
}
- (void)dealloc
{
	[_connection release];
	[_data release];
	[_response release];
	[_error release];
	[super dealloc];
}
- (void)connection:(NSURLConnection *)connection 
   didSendBodyData:(NSInteger)bytesWritten 
 totalBytesWritten:(NSInteger)totalBytesWritten 
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
	NSNumber *percent = 
	[[NSNumber alloc] initWithFloat:(float)totalBytesWritten/(float)totalBytesExpectedToWrite];
	NSDictionary *noteDict = 
	[[NSDictionary alloc] initWithObjectsAndKeys:
	 percent, @"percent",
	 [self connectionID], @"connectionID", nil];
	[percent release];
	[[NSNotificationCenter defaultCenter] 
	 postNotificationName:ESConnectionProgressNotification 
	 object:noteDict];
	[noteDict release];
}
- (void)connection:(NSURLConnection *)connection 
  didFailWithError:(NSError *)error
{
	[self setError:error];
	[self setFinished:YES];
}
- (void)connection:(NSURLConnection *)connection 
didReceiveResponse:(NSURLResponse *)response
{
	[[self data] setLength:0];
	[self setResponse:response];
}
- (void)connection:(NSURLConnection *)connection 
	didReceiveData:(NSData *)data
{
	[[self data] appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[self setFinished:YES];
}

@end
