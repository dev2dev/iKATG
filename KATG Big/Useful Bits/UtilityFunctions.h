//
//  UtilityFunctions.h
//  PartyCamera
//
//  Created by Doug Russell on 6/18/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import <Foundation/Foundation.h>

double			ToRadians(double degrees);
NSString * 		AppDirectoryCachePath();
NSString * 		AppDirectoryCachePathAppended(NSString * pathToAppend);
NSString * 		TempFileName();
NSString * 		TempFolderName();
NSString * 		AppDirectoryDocumentsPath();
NSString * 		AppDirectoryDocumentsPathAppended(NSString * pathToAppend);
NSString * 		AppDirectoryLibraryPath();
NSString * 		AppDirectoryLibraryPathAppended(NSString * pathToAppend);