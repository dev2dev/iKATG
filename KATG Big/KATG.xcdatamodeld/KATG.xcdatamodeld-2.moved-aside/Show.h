//
//  Show.h
//  KATG Big
//
//  Created by Doug Russell on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Show :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * Number;
@property (nonatomic, retain) NSString * Guests;
@property (nonatomic, retain) NSString * FileURL;
@property (nonatomic, retain) NSNumber * TV;
@property (nonatomic, retain) NSNumber * Pictures;
@property (nonatomic, retain) NSString * Details;
@property (nonatomic, retain) NSString * Title;
@property (nonatomic, retain) NSNumber * ID;

@end



