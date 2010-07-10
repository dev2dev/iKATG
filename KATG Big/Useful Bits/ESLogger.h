//
//  ESLogger.h
//
//  Created by Doug Russell on 6/24/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ESLog(args...) _ESLog(__FILE__,__LINE__,args);

void _ESLog(const char *file, int lineNumber, NSString *logStatementFormat, ... );

@interface ESLogger : NSObject 
{
	NSString *_logPath;
}

@property (nonatomic, retain) NSString *logPath;

+ (ESLogger *)sharedESLogger;
+ (void)log:(NSString *)string;
- (void)log:(NSString *)string;

@end
