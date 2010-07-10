//
//  NSString+Regex.h
//
//  Created by Doug Russell on 4/2/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <regex.h>

@interface NSString (Regex)
int rreplace (char *buf, int size, regex_t *re, char *rp);
- (NSString *)stringByReplacingOccurencesOfRegularExpressions:(NSString *)regex 
													 inString:(NSString *)string 
												   withString:(NSString *)replace;
- (NSString *)stringByReplacingOccurencesOfRegularExpressions:(NSString *)regex 
												   withString:(NSString *)replace;
- (BOOL)matchesRegularExpression:(NSString *)regex;

@end
