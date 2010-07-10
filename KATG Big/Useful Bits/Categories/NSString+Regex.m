//
//  NSString+Regex.m
//
//  Created by Doug Russell on 4/2/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "NSString+Regex.h"

@implementation NSString (Regex)

int rreplace (char *buf, int size, regex_t *re, char *rp)  
{
	char *pos;
	int sub, so, n;
	regmatch_t pmatch [10]; /* regoff_t is int so size is int */
	
	if (regexec (re, buf, 10, pmatch, 0)) return 0;
	for (pos = rp; *pos; pos++)
		if (*pos == '\\' && *(pos + 1) > '0' && *(pos + 1) <= '9') {
			so = pmatch [*(pos + 1) - 48].rm_so;
			n = pmatch [*(pos + 1) - 48].rm_eo - so;
			if (so < 0 || strlen (rp) + n - 1 > size) return 1;
			memmove (pos + n, pos + 2, strlen (pos) - 1);
			memmove (pos, buf + so, n);
			pos = pos + n - 2;
		}
	sub = pmatch [1].rm_so; /* no repeated replace when sub >= 0 */
	for (pos = buf; !regexec (re, pos, 1, pmatch, 0); ) {
		n = pmatch [0].rm_eo - pmatch [0].rm_so;
		pos += pmatch [0].rm_so;
		if (strlen (buf) - n + strlen (rp) > size) return 1;
		memmove (pos + strlen (rp), pos + n, strlen (pos) - n + 1);
		memmove (pos, rp, strlen (rp));
		pos += strlen (rp);
		if (sub >= 0) break;
	}
	return 0;
}

int rmatch (char *buf, int size, regex_t *re)  
{
	regmatch_t pmatch [10]; /* regoff_t is int so size is int */
	
	int result = regexec (re, buf, 10, pmatch, 0);
	
	return result;
}

- (NSString *)stringByReplacingOccurencesOfRegularExpressions:(NSString *)regex 
													 inString:(NSString *)string 
												   withString:(NSString *)replace 
{
	const char *cex = [regex cStringUsingEncoding:[NSString defaultCStringEncoding]];
	char *ex = malloc(strlen(cex) + 1);
	strcpy(ex, cex);
	
	const char *cbuf= [string cStringUsingEncoding:[NSString defaultCStringEncoding]];
	char *buf = malloc(strlen(cbuf) + 1);
	strcpy(buf, cbuf);
	
	const char *crp = [replace cStringUsingEncoding:[NSString defaultCStringEncoding]];
	char *rp = malloc(strlen(crp) + 1);
	strcpy(rp, crp);
	
	regex_t re;
	if(regcomp(&re, ex, REG_EXTENDED) == 0) {	
		rreplace(buf, [string length], &re, rp);
	}
	NSString *result = [NSString stringWithCString:buf encoding:[NSString defaultCStringEncoding]];
	
	regfree(&re);
	free(ex);
	free(buf);
	free(rp);
	
	return result;
}

- (NSString *)stringByReplacingOccurencesOfRegularExpressions:(NSString *)regex 
												   withString:(NSString *)replace 
{
	const char *cex = [regex cStringUsingEncoding:[NSString defaultCStringEncoding]];
	char *ex = malloc(strlen(cex) + 1);
	strcpy(ex, cex);
	
	const char *cbuf= [self cStringUsingEncoding:[NSString defaultCStringEncoding]];
	char *buf = malloc(strlen(cbuf) + 1);
	strcpy(buf, cbuf);
	
	const char *crp = [replace cStringUsingEncoding:[NSString defaultCStringEncoding]];
	char *rp = malloc(strlen(crp) + 1);
	strcpy(rp, crp);
	
	regex_t re;
	if(regcomp(&re, ex, REG_EXTENDED) == 0) {	
		rreplace(buf, [self length], &re, rp);
	}
	NSString *result = [NSString stringWithCString:buf encoding:[NSString defaultCStringEncoding]];
	
	regfree(&re);
	free(ex);
	free(buf);
	free(rp);
	
	return result;
}
- (BOOL)matchesRegularExpression:(NSString *)regex
{
	const char *cex = [regex cStringUsingEncoding:[NSString defaultCStringEncoding]];
	char *ex = malloc(strlen(cex) + 1);
	strcpy(ex, cex);
	
	const char *cbuf= [self cStringUsingEncoding:[NSString defaultCStringEncoding]];
	char *buf = malloc(strlen(cbuf) + 1);
	strcpy(buf, cbuf);
	
	int result = 1;
	regex_t re;
	if(regcomp(&re, ex, REG_EXTENDED) == 0) {	
		result = rmatch(buf, [self length], &re);
	}
	
	if (result == 0)
		return YES;
	else
		return NO;
}



@end
