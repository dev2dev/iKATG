//
//  UtilityFunctions.m
//  PartyCamera
//
//  Created by Doug Russell on 6/18/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "UtilityFunctions.h"

const double	kRadPerDeg	= 0.0174532925199433;	// pi / 180

double	ToRadians(double degrees)
{
	return (degrees * kRadPerDeg);
}

NSString * AppDirectoryCachePath()
{
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, 
														  NSUserDomainMask, 
														  YES) lastObject];
	return path;
}
NSString * AppDirectoryCachePathAppended(NSString * pathToAppend)
{
	return [AppDirectoryCachePath() stringByAppendingPathComponent:pathToAppend];
}
NSString * TempFileName()
{
	return [NSString stringWithFormat:@"%f.bin", CFAbsoluteTimeGetCurrent()];
}
NSString * TempFolderName()
{
	return [NSString stringWithFormat:@"%f", CFAbsoluteTimeGetCurrent()];
}
NSString * AppDirectoryDocumentsPath()
{
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
														  NSUserDomainMask, 
														  YES) lastObject];
	return path;
}
NSString * AppDirectoryDocumentsPathAppended(NSString * pathToAppend)
{
	return [AppDirectoryDocumentsPath() stringByAppendingPathComponent:pathToAppend];
}
NSString * AppDirectoryLibraryPath()
{
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, 
														  NSUserDomainMask, 
														  YES) lastObject];
	return path;
}
NSString * AppDirectoryLibraryPathAppended(NSString * pathToAppend)
{
	return [AppDirectoryDocumentsPath() stringByAppendingPathComponent:pathToAppend];
}