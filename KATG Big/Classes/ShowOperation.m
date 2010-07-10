//
//  ShowOperation.m
//  KATG Big
//
//  Created by Doug Russell on 6/25/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "ShowOperation.h"
#import "Show.h"
#import "Guest.h"

@implementation ShowOperation
@synthesize delegate;
@synthesize shows = _shows;

- (id)initWithShows:(NSArray *)shows
{
	if ((self = [super init]))
	{
		[self setShows:shows];
	}
	return self;
}

- (void)main
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	for (NSDictionary *show in self.shows)
	{
		Show *managedShow = 
		(Show *)[NSEntityDescription insertNewObjectForEntityForName:@"Show" 
											  inManagedObjectContext:delegate.managedObjectContext];
		
		NSString * guests       = [show objectForKey:@"G"];
		NSString * ID           = [show objectForKey:@"I"];
		NSString * number       = [show objectForKey:@"N"];
		NSString * pictureCount = [show objectForKey:@"P"];
		NSString * hasShowNotes = [show objectForKey:@"SN"];
		NSString * title        = [show objectForKey:@"T"];
		NSString * isKATGTV     = [show objectForKey:@"TV"];
		
		if (guests)
		{
			NSArray *guestArray = [guests componentsSeparatedByString:@","];
			if (guestArray)
			{
				for (NSString *guest in guestArray)
				{
					Guest *managedGuest = 
					(Guest *)[NSEntityDescription insertNewObjectForEntityForName:@"Guest" 
														   inManagedObjectContext:delegate.managedObjectContext];
					
					[managedGuest addShowObject:managedShow];
					
					[managedGuest setGuest:guest];
					
					//NSLog(@"Guest: %@", managedGuest);
					
					[managedShow addGuestsObject:managedGuest];
				}
			}
		}
		if (ID)
		{
			NSInteger idInt = [ID intValue];
			[managedShow setID:[NSNumber numberWithInt:idInt]];
		}
		if (number)
		{
			NSInteger numInt = [number intValue];
			[managedShow setNumber:[NSNumber numberWithInt:numInt]];
		}
		if (pictureCount)
		{
			NSInteger picCnt = [pictureCount intValue];
			[managedShow setPictureCount:[NSNumber numberWithInt:picCnt]];
		}
		if (hasShowNotes)
		{
			BOOL hasShwNts = [hasShowNotes boolValue];
			[managedShow setHasNotes:[NSNumber numberWithBool:hasShwNts]];
		}
		if (title)
		{
			[managedShow setTitle:title];
		}
		if (isKATGTV)
		{
			BOOL isTV = [isKATGTV boolValue];
			[managedShow setTV:[NSNumber numberWithBool:isTV]];
		}
		
		//NSLog(@"Show: %@", managedShow);
		
		NSError *error;
		if (![delegate.managedObjectContext save:&error])
		{	// Handle Error
			
		}
	}
	
	if (self.delegate && !self.isCancelled)
	{
		[self.delegate showOperationDidFinishSuccesfully:self];
	}
	
	[pool drain];
}

- (void)dealloc
{
	[_shows release];
	[super dealloc];
}

@end
