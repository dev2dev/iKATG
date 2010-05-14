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

#import "OrderedDictionary.h"

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark Private Methods. 
NSString *DescriptionForObject(NSObject *object, id locale, NSUInteger indent)
{
	NSString *objectString;
	if ([object isKindOfClass:[NSString class]])
	{
		objectString = (NSString *)[[object retain] autorelease];
	}
	else if ([object respondsToSelector:@selector(descriptionWithLocale:indent:)])
	{
		objectString = [(NSDictionary *)object descriptionWithLocale:locale indent:indent];
	}
	else if ([object respondsToSelector:@selector(descriptionWithLocale:)])
	{
		objectString = [(NSSet *)object descriptionWithLocale:locale];
	}
	else
	{
		objectString = [object description];
	}
	return objectString;
}

@implementation OrderedDictionary

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark Init Methods. 
- (id)init
{
	return [self initWithCapacity:0];
}

//// //// //// //// //// //// //// //// //// //// //// ////// //// //// //// //// //// //// //// //// //// //// //

- (id)initWithCapacity:(NSUInteger)capacity
{
	self = [super init];
	if (self != nil)
	{
		[dictionary release]; [array release];	// Avoid Memory Leak.
		
		///////
		
		dictionary = [[NSMutableDictionary alloc] initWithCapacity:capacity];
		array = [[NSMutableArray alloc] initWithCapacity:capacity];
	}
	return self;
}

//// //// //// //// //// //// //// //// //// //// //// ////// //// //// //// //// //// //// //// //// //// //// //

// Init with other NSDictionary and an Index of Array. 
- (id)initWithObject:(NSMutableDictionary*)anObject withArray:(NSMutableArray*)anArray {
	
	self = [super init];
	if (self != nil)
	{
		dictionary = [anObject retain];
		array = [anArray retain];
	}
	return self;
	
}

//// //// //// //// //// //// //// //// //// //// //// ////// //// //// //// //// //// //// //// //// //// //// //

// Init with object without an Index. Create internal index from this object.
- (id)initWithDictionary:(NSMutableDictionary*)anObject {
	
	// Init.
	[self initWithCapacity:0];
	
	// Loop on all elements.
	for (id key in anObject) {
		
		// Use setObject to insert every element. 
		[self setObject:[anObject objectForKey:key] forKey:key ];

	}

	return self;
}

- (id)initWithContentsOfFile:(NSString *)path
{
	NSArray *storedOrderedDict = [NSArray arrayWithContentsOfFile:path];
	if (storedOrderedDict)
	{
		NSMutableDictionary *dict = [storedOrderedDict objectAtIndex:0];
		NSMutableArray      *aray = [storedOrderedDict objectAtIndex:1];
		if (dict && aray)
		{
			if (self = [self initWithObject:dict withArray:aray])
			{
				return self;
			}
		}
	}
	return [self initWithCapacity:0];
}
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile
{
	NSArray *aray = 
	[NSArray arrayWithObjects:dictionary, array, nil];
	if (aray)
	{
		BOOL success = [aray writeToFile:path atomically:useAuxiliaryFile];
		return success;
	}
	return NO;
}

//// //// //// //// //// //// //// //// //// //// //// //

// This method is similar to initWithDictionary, the difference is: This method will Scan the all Dictionary tree converting internal elements too.
- (id)convertFromDictionary:(id)anObject {
	
	// Init.
	[self initWithCapacity:0];					
	
	// Loop on all elements.
	for ( id key in anObject ) {

		//// //// //// //// //// //// //// //// //// //// //// //
		
		// Test if this element are one class of Dictionary.
		if ( [ [anObject objectForKey:key] isMemberOfClass: NSClassFromString( @"NSDictionary" ) ] ||
		   	 [ [anObject objectForKey:key] isMemberOfClass: NSClassFromString( @"NSMutableDictionary" ) ] ||
			 [ [anObject objectForKey:key] isMemberOfClass: NSClassFromString( @"NSCFDictionary" ) ] ) {
			
			// Call this same method to convert this class of Dictionary.
			OrderedDictionary *convertedObject = [[OrderedDictionary alloc] convertFromDictionary:[anObject objectForKey:key] ]; 
			
			//// //// //// //// //// //// //// //// //// //// //// //
			
			// Use setObject to set this converted element.
			[self setObject:convertedObject forKey:key ];
			
		// If not, just add on the new Dictionary.
		} else {
			
			// Use setObject to set this object. 
			[self setObject:[anObject objectForKey:key] forKey:key ]; 
		}
	}
	
	// Return converted dictionary.
	return self;
}


//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark Sorting Methods. 

/// Reorder the Dictionary using one giving function.
- (void)sortUsingFunction:(NSInteger (*)(id, id, void *))comparator context:(void *)context {
	
	array = [[NSMutableArray alloc] initWithArray:[array sortedArrayUsingFunction:comparator context:context ] ];

}

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark Insert Methods. 

- (void)setObject:(id)anObject forKey:(id)aKey
{
	// Check for duplicated key.
	if (![dictionary objectForKey:aKey])
	{
		[array addObject:aKey];
	}
	[dictionary setObject:anObject forKey:aKey];
}

//// //// //// //// //// //// //// //// //// //// //// ////// //// //// //// //// //// //// //// //// //// //// //

- (void)insertObject:(id)anObject forKey:(id)aKey atIndex:(NSUInteger)anIndex
{
	if (![dictionary objectForKey:aKey])
	{
		[self removeObjectForKey:aKey];
	}
	[array insertObject:aKey atIndex:anIndex];
	[dictionary setObject:anObject forKey:aKey];
}

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark Remove Methods. 

- (void)removeLastObject {
	
	[self removeObjectAtIndex:[array count]-1 ];
	
}

//// //// //// //// //// //// //// //// //// //// //// ////// //// //// //// //// //// //// //// //// //// //// //

- (void)removeObjectAtIndex:(NSUInteger)anIndex {
	
	[self removeObjectForKey:[self keyAtIndex:anIndex] ];
	
}

//// //// //// //// //// //// //// //// //// //// //// ////// //// //// //// //// //// //// //// //// //// //// //

- (void)removeObjectForKey:(id)aKey
{
	[dictionary removeObjectForKey:aKey];
	[array removeObject:aKey];
}

//// //// //// //// //// //// //// //// //// //// //// ////// //// //// //// //// //// //// //// //// //// //// //

// This method could be slow on large dictionaries. ///

- (void)removeObjectsInRange:(NSRange)aRange {     
	
	[self removeObjectFromIndex:aRange.location To:(aRange.location + aRange.length - 1 ) ];
	
}

// This method could be slow on large dictionaries. ///

- (BOOL)removeObjectFromIndex:(NSUInteger)from To:(NSUInteger)to {	
	
	// TO bigger trahn FROM is not allowed.
	if ( from > to ) return NO;
	
	// Duplicate the Array Index.
	NSMutableArray *duplicated = [ [array copy] autorelease];
	
	// Loop to remove this itens.
	for( int counter_remove = from; counter_remove <= to; counter_remove++ )
		
		[self removeObjectForKey:[duplicated objectAtIndex:counter_remove] ]; 
	
	// Everything ok.
	return YES;
	
}

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark Retrieve Methods. 

- (id)keyAtIndex:(NSUInteger)anIndex
{
	return [array objectAtIndex:anIndex];
}

//// //// //// //// //// //// //// //// //// //// //// ////// //// //// //// //// //// //// //// //// //// //// //

- (int)indexOfKey:(id)aKey {
	
	return [array indexOfObject:aKey ];
	
}

//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
//// //// //// //// //// //// //// //// //// //// //// ////// //// //// //// //// //// //// //// //// //// //// //

- (id)objectAtIndex:(NSUInteger)anIndex {
	
	return [dictionary objectForKey:[array objectAtIndex:anIndex] ];
	
}

//// //// //// //// //// //// //// //// //// //// //// ////// //// //// //// //// //// //// //// //// //// //// //

- (id)objectForKey:(id)aKey
{
	return [dictionary objectForKey:aKey];
}


//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
//// //// //// //// //// //// //// //// //// //// //// ////// //// //// //// //// //// //// //// //// //// //// //

-(NSArray*)allKeys 
{
	return [NSArray arrayWithArray:array];
}

- (NSEnumerator *)keyEnumerator
{
	return [array objectEnumerator];
}

//// //// //// //// //// //// //// //// //// //// //// ////// //// //// //// //// //// //// //// //// //// //// //

- (NSEnumerator *)reverseKeyEnumerator
{
	return [array reverseObjectEnumerator];
}


//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark Info Methods. 

- (NSUInteger)count
{
	return [dictionary count];
}

//// //// //// //// //// //// //// //// //// //// //// ////// //// //// //// //// //// //// //// //// //// //// //

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
	NSMutableString *indentString = [NSMutableString string];
	NSUInteger i, count = level;
	for (i = 0; i < count; i++)
	{
		[indentString appendFormat:@"    "];
	}
	
	NSMutableString *description = [NSMutableString string];
	[description appendFormat:@"%@{\n", indentString];
	for (NSObject *key in self)
	{
		[description appendFormat:@"%@    %@ = %@;\n",
		 indentString,
		 DescriptionForObject(key, locale, level),
		 DescriptionForObject([self objectForKey:key], locale, level)];
	}
	[description appendFormat:@"%@}\n", indentString];
	return description;
}




//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark Manipulate Methods. 

- (void)moveFromIndex:(NSUInteger)from To:(NSUInteger)to {
	
	// Duplicate the Array Index.
	NSMutableArray *duplicated = [ [array copy] autorelease];
	
	// Insert on new position.
	[array insertObject:[duplicated objectAtIndex:from] atIndex:( to > from ? to+1 : to )];

	// Remove from the old position.
	[array removeObjectAtIndex:( to < from ? from+1 : from ) ];

}

//// //// //// //// //// //// //// //// //// //// //// ////// //// //// //// //// //// //// //// //// //// //// //

-(void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 { [self swipeIndex:idx1 with:idx2]; }

-(void)swipeIndex:(NSUInteger)from with:(NSUInteger)to {
	
	// If is equal, do nothing.
	if ( from == to ) return;
	
	// Exchange.
	[array exchangeObjectAtIndex:from withObjectAtIndex:to];
	
}


//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark -
//// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// //// 
#pragma mark Memory Management Methods. 
- (void)dealloc
{
	[dictionary release];
	[array release];
	[super dealloc];
}

//// //// //// //// //// //// //// //// //// //// //// ////// //// //// //// //// //// //// //// //// //// //// //

- (id)copyWithZone:(NSZone *)zone {
	
	return [[[self class] allocWithZone: zone] initWithObject:[[dictionary mutableCopy] autorelease] withArray:[[array mutableCopy] autorelease] ];

}

@end
///// ////// ////// ////// ////// ////// ////// ////// ////// ////// /// /// /// /// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ////// ///

