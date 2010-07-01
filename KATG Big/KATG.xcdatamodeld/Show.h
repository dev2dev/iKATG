//
//  Show.h
//  KATG Big
//
//  Created by Doug Russell on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Guest;
@class Picture;

@interface Show :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * Number;
@property (nonatomic, retain) NSNumber * TV;
@property (nonatomic, retain) NSString * URL;
@property (nonatomic, retain) NSString * Notes;
@property (nonatomic, retain) NSString * Title;
@property (nonatomic, retain) NSNumber * HasNotes;
@property (nonatomic, retain) NSNumber * PictureCount;
@property (nonatomic, retain) NSNumber * ID;
@property (nonatomic, retain) NSSet* Guests;
@property (nonatomic, retain) NSSet* Pictures;

@end


@interface Show (CoreDataGeneratedAccessors)
- (void)addGuestsObject:(Guest *)value;
- (void)removeGuestsObject:(Guest *)value;
- (void)addGuests:(NSSet *)value;
- (void)removeGuests:(NSSet *)value;

- (void)addPicturesObject:(Picture *)value;
- (void)removePicturesObject:(Picture *)value;
- (void)addPictures:(NSSet *)value;
- (void)removePictures:(NSSet *)value;

@end

