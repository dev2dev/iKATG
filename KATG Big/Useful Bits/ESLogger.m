//
//  ESLogger.m
//
//  Created by Doug Russell on 6/24/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#define ESLOGDEBUG

#import "ESLogger.h"
#import "SynthesizeSingleton.h"

void _ESLog(const char *file, int lineNumber, NSString *logStatementFormat, ... )ESLOGDEBUG
{
	va_list ap;
	va_start (ap, logStatementFormat);
	
	NSString *logStatement = nil;
	if (logStatementFormat != nil)
	{
		logStatement = [[NSString alloc] initWithFormat:logStatementFormat arguments:ap];
	}
	else
	{
		logStatement = [[NSString alloc] initWithString:@"Attempted to log nil statement"];
	}
	
	va_end (ap);
	
	NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
	
	[ESLogger log:[NSString stringWithFormat:@"%f - %@:%d, %@", 
				   CFAbsoluteTimeGetCurrent(),
				   fileName, 
				   lineNumber, 
				   logStatement]];
	
	[logStatement release];
}

@implementation ESLogger
@synthesize logPath = _logPath;

SYNTHESIZE_SINGLETON_FOR_CLASS(ESLogger);

+ (void)log:(NSString *)string
{
	[[ESLogger sharedESLogger] log:string];
}
- (id)init
{
	if ((self = [super init]))
	{
		NSString *path = AppDirectoryDocumentsPathAppended(@"LogFile.log");
		if (path)
			self.logPath = path;
	}
	return self;
}
- (void)dealloc
{
	[_logPath release];
	[super dealloc];
}
- (void)log:(NSString *)string
{
	if (![[NSFileManager defaultManager] fileExistsAtPath:self.logPath])
		[[NSFileManager defaultManager] createFileAtPath:self.logPath contents:[NSData data] attributes:nil];
	
	NSFileHandle *output = [NSFileHandle fileHandleForWritingAtPath:self.logPath];
	NSInteger size = [output seekToEndOfFile];
	if (size > 5000000)
	{
		[output truncateFileAtOffset:0];
		[output seekToFileOffset:0];
	}
	NSString *newLogStatement = [NSString stringWithFormat:@"%@ %@", [[NSDate date] description], string];
	if (![newLogStatement hasSuffix: @"\n"])
		newLogStatement = [newLogStatement stringByAppendingString:@"\n"];
#ifdef ESLOGDEBUG
	if (newLogStatement.length > 1000)
	{
		fprintf(stderr,"%s",[[newLogStatement substringToIndex:1000] UTF8String]);
	}
	else 
	{
		fprintf(stderr,"%s",[newLogStatement UTF8String]);
	}
#endif
	[output writeData:[newLogStatement dataUsingEncoding:NSUTF8StringEncoding]];
	[output closeFile];
}

@end
