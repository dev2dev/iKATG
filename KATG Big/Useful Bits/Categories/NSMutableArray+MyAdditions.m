#import "NSMutableArray+MyAdditions.h"

const void * MyRetainNoOp(CFAllocatorRef allocator, const void *value) { return value; }
void MyReleaseNoOp(CFAllocatorRef allocator, const void * value) { }
NSMutableArray * CreateNonRetainingArray() 
{
	CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
	callbacks.retain = MyRetainNoOp;
	callbacks.release = MyReleaseNoOp;
	return (NSMutableArray*)CFArrayCreateMutable(nil, 0, &callbacks);
}

@implementation NSMutableArray (MYAdditions)

- (void)addObjectIfAbsent:(id)anObject
	// Adds anObject to the receiver if and only if anObject
	// is not nil and not already contained by the reciever
{
	if ((nil != anObject) && ![self containsObject:anObject]) {
		[self addObject:anObject];
	}
}

- (void)addObjectIfNotNil:(id)anObject 
	// Adds anObject to the receiver if and only if anObject
	// is not nil
{
	if (nil != anObject) {
		[self addObject:anObject];
	}
}

- (void)reverse 
// Reverse order of object in array
{
	NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:j];
        i++;
        j--;
    }
}

@end
