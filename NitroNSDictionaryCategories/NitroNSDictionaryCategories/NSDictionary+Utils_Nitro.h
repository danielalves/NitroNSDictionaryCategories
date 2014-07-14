//
//  NSDictionary+Utils_Nitro.h
//  NitroNSDictionaryCategories
//
//  Created by Daniel L. Alves on 20/04/11.
//  Copyright (c) 2011 Daniel L. Alves. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @category NSDictionary( Utils_Nitro )
 *
 *  Adds many utility methods to the NSDicionary class.
 */
@interface NSDictionary( Utils_Nitro )

/**
 *  Returns if the dictionary contains the specified key.
 *
 *  @param keyToSearch The key we want to check.
 *
 *  @return YES if the dictionary contains key. NO otherwise or if key is nil.
 */
-( BOOL )hasKey:( id )keyToSearch;

/**
 *  Returns the key of a given object contained in the dictionary. This methods checks for object addresses
 *  equality (it does not use -isEqual: for comparison). So, for example, if object is a NSString with value
 *  @"a" and there is another NSString object in the dictionary whose value is also @"a", but with a different
 *  address, the method will not consider them a match.
 *
 *  @param object The object whose key is needed.
 *
 *  @return The key of the object or nil if object is nil or if object is not contained in the dictionary.
 */
-( id )keyForObject:( id )object;

/**
 *  Recursively creates a new dictionary by stripping all values which are not property list
 *  compliant. That means:
 *
 *  Values of the classes below (or one of their subclasses ) will be kept:
 *    - NSArray
 *    - NSDictionary
 *    - NSString
 *    - NSData
 *    - NSDate
 *    - NSNumber (intValue)
 *    - NSNumber (floatValue)
 *    - NSNumber (boolValue == YES or boolValue == NO)
 *
 *  Besides them, values which conform to the NSCoding protocol will be converted to NSData an then 
 *  kept (i.e. UIColor).
 *
 *  @return A property list compliant dictionary. Returns an empty dictionary if all keys are stripped
 *          or if the original dictionary was also empty.
 */
-( NSDictionary * )toPropertyListCompliantDictionary;

/**
 *  Searches the dictionary for the first object which is not nil and not equal to [NSNull null]
 *
 *  @param firstKey A comma-separated list of keys, ending with nil.
 *
 *  @return The first object which is not nil and not equal to [NSNull null]. Returns nil
 *          if all keys contain null objects or if the dictionary is empty.
 */
-( id )getFirstNonNullValueOfKeys:( NSString * )firstKey, ...;

/**
 *  Searches the dictionary for the first object which is not nil and not equal to [NSNull null]
 *  and returns its description.
 *
 *  @param firstKey A comma-separated list of keys, ending with nil.
 *
 *  @return The description of the first object which is not nil and not equal to [NSNull null]. Returns nil
 *          if all keys contain null objects or if the dictionary is empty.
 */
-( NSString * )getFirstNonNullValueOfKeysAsString:( NSString * )firstKey, ...;

@end
