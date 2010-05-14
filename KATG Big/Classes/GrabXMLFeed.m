//
//  GrabXMLFeed.m
//  KATG.com
//
//  Copyright 2009 Doug Russell
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

#import "GrabXMLFeed.h"
#import "TouchXML.h"

@interface GrabXMLFeed (PrivateMethods)

- (void)_performParse;

@end

@implementation GrabXMLFeed
@synthesize delegate;
@synthesize feedEntries;
@synthesize userDictionary;
@synthesize instanceNumber;
@synthesize cancelled;
@synthesize _data;

- (id)initWithData:(NSData *)data xPath:(NSString *)xPath
{
	if (self = [super init]) 
	{
		// Initialize the feedEntries MutableArray that we declared in the header
		feedEntries = [[NSMutableArray alloc] init];
		
		// Convert the supplied URL string into a usable URL object
		_data = [data retain];
		
		_xpath = [xPath retain];
	}
	return self;
}

- (void)dealloc
{
	delegate = nil;
	[feedEntries release];
	[userDictionary release];
	[_data release];
	[_xpath release];
	[super dealloc];
}

- (void)parse
{
	[self _performParse];
}

- (void)cancel
{
	cancelled = YES;
}

- (void)_performParse 
{
	if (![self isCancelled]) 
	{
		// Create a new rssParser object based on the TouchXML "CXMLDocument" class, this is the
		// object that actually grabs and processes the RSS data
		CXMLDocument *rssParser = [[[CXMLDocument alloc] initWithData:_data options:0 error:nil] autorelease];
		
		// Create a new Array object to be used with the looping of the results from the rssParser
		NSArray *resultNodes = NULL;
		
		// Set the resultNodes Array to contain an object for every instance of an  node in our RSS feed	
		resultNodes = [rssParser nodesForXPath:_xpath error:nil];
		
		if (![self isCancelled]) 
		{
			// Loop through the resultNodes to access each items actual data
			for (CXMLElement *resultElement in resultNodes) 
			{
				NSDictionary *feedItem = [self processNode:(CXMLElement *)resultElement];
				if (feedItem)
					[feedEntries addObject:feedItem];
			}
			if ([(NSObject *)[self delegate] respondsToSelector:@selector(parsingDidCompleteSuccessfully:)] && ![self isCancelled]) 
			{
				[[self delegate] parsingDidCompleteSuccessfully:self];
			}
		}
	}
}

- (NSDictionary *)processNode:(CXMLNode *)node
{
	if ([self isCancelled]) return nil;
	
	// Create a temporary MutableDictionary to store the items fields in, 
	// which will eventually end up in feedEntries
	NSMutableDictionary *feedItem = [[[NSMutableDictionary alloc] init] autorelease];
	
	// Create a counter variable as type "int"
	int counter;
	
	id strVal;
	// Loop through the children of the current  node
	for(counter = 0; counter < [node childCount]; counter++) 
	{
		CXMLNode *child = [node childAtIndex:counter];
		strVal = [child stringValue];

		if (!strVal) 
		{
			strVal = [self processNode:child];
			if ([[strVal allKeys] count] == 0)
				strVal = @"NULL";
		}
		if (strVal)
		{
			// Add each field to the feedItem Dictionary with the node name as key and node value as the value
			[feedItem setObject:strVal forKey:[child name]];
		}
	}
	
	if ([(NSObject *)[self delegate] respondsToSelector:@selector(parsingDidCompleteForNode:parser:)] && ![self isCancelled]) 
	{
		[[self delegate] parsingDidCompleteForNode:feedItem parser:self];
	}
	
	return (NSDictionary *)feedItem;
}


@end