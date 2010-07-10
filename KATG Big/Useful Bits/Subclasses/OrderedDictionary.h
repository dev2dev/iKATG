/// /// /// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ///
//
//	SEQOY™ Development and Consulting
//	http://www.seqoy.com
//
///////////////
//
//	History:
//
//	19/12/08 --- Created by Matt Gallagher (http://cocoawithlove.com/)
//	20/09/09 --- Several changes by Paulo Oliveira
//
//	OrderedDictionary.h 
// 
/// /// /// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ///
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//
/// /// /// ////// ////// ////// ////// ////// ////// //
#import <Foundation/Foundation.h> 

@interface OrderedDictionary : NSMutableDictionary <NSCopying>
{
	NSMutableDictionary *dictionary;
	NSMutableArray *array;
}

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark Init Methods. 

- (id)initWithDictionary:(NSMutableDictionary*)anObject ;

- (id)initWithObject:(NSMutableDictionary*)anObject withArray:(NSMutableArray*)anArray;

- (id)initWithContentsOfFile:(NSString *)path;

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;

/// This method is similar to initWithDictionary, the difference is: This method will Scan the all Dictionary tree converting internal elements too.
- (id)convertFromDictionary:(id)anObject;

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark Sorting Methods. 

/// Reorder the Dictionary using one giving function.
- (void)sortUsingFunction:(NSInteger (*)(id, id, void *))comparator context:(void *)context;

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark Insert Methods. 

- (void)insertObject:(id)anObject forKey:(id)aKey atIndex:(NSUInteger)anIndex;

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark Remove Methods. 

- (void)removeLastObject;

- (void)removeObjectAtIndex:(NSUInteger)anIndex;  

- (BOOL)removeObjectFromIndex:(NSUInteger)from To:(NSUInteger)to;	// This method could be slow on large dictionaries.

- (void)removeObjectsInRange:(NSRange)aRange; // This method could be slow on large dictionaries.

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark Retrieve Methods. 

- (id)objectAtIndex:(NSUInteger)anIndex;

- (int)indexOfKey:(id)aKey;

- (id)keyAtIndex:(NSUInteger)anIndex;

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark Manipulate Methods. 

- (void)swipeIndex:(NSUInteger)from with:(NSUInteger)to; 

- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2; 	// This is the same of swipeIndex, this method is just for compatibility.

- (void)moveFromIndex:(NSUInteger)from To:(NSUInteger)to; 

- (NSEnumerator *)reverseKeyEnumerator;

@end
