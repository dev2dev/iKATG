#import <Foundation/Foundation.h>

NSMutableArray * CreateNonRetainingArray();

@interface NSMutableArray (MyAdditions)

- (void)addObjectIfAbsent:(id)anObject;
- (void)addObjectIfNotNil:(id)anObject;
- (void)reverse;

@end
