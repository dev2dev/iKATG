#import "NSArray+MyAdditions.h"

@implementation NSArray (MyAdditions)

- (NSArray *)reversedArray 
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return [NSArray arrayWithArray:array];
}

@end
