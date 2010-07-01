//
//  Picture.h
//  KATG Big
//
//  Created by Doug Russell on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Picture :  NSManagedObject  
{
}

@property (nonatomic, retain) NSData * Data;
@property (nonatomic, retain) NSString * URL;
@property (nonatomic, retain) NSString * Description;
@property (nonatomic, retain) NSString * Title;
@property (nonatomic, retain) NSString * ShowID;

@end



