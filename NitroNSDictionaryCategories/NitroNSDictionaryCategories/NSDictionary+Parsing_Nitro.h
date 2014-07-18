//
//  NSDictionary+Parsing_Nitro.h
//  NitroNSDictionaryCategories
//
//  Created by Daniel L. Alves on 02/06/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @category NSDictionary( Parsing_Nitro )
 *
 *  Provides methods to parse specifc types from dictionary values. If a value cannot be parsed, methods return nil, so
 *  there's a kind of type safety. Other powerful functionality is the ability to traverse nested dictionaries and arrays
 *  using the *KeyPath: methods. For example, lets say you have this structure:
 *
 *  // Backpack
 *  {[
 *
 *    // Items 0 - 4
 *    // ...
 *
 *    {
 *        "type": "sword",
 *        "name": "Ultra Lightning Sword of Slashing",
 *        "description": "It slashes and shocks!",
 *        "properties": [
 *            {
 *                "name": "lightning",
 *                "bonus-damage": 150
 *            },
 *
 *            // Other properties
 *            // ...
 *        ]
 *    },
 *
 *    // Other items
 *    // ...
 *  ]}
 *
 *  We would parse the lightning bonus damage of Ultra Lightning Sword of Slashing with a single call:
 * 
 *  NSNumber *lightningBonusDamage = [backpack numberForKeyPath: @"5/properties/0/bonus-damage"];
 * 
 */
@interface NSDictionary( Parsing_Nitro )

/**
 *  Tries to parse a boolean from the value referenced by key. It supports numeric values
 *  and strings.
 *
 *  @param key The key from which the boolean value must be parsed.
 *
 *  @return YES if key has a numeric value different from 0, a string representing a number different from 0 or one of the string values
 *          (in any case combination): @"t", @"true", @"y", @"yes". Format specifiers in number strings, like 'L', 'LL' and 'f', are ignored.
 *          NO if key has a numeric value equal to 0, a string representing the number 0 or one of the string values (in any case
 *          combination): @"f", @"false", @"n", @"no". Format specifiers in number strings, like 'L', 'LL' and 'f', are ignored.
 *          This method also returns NO if key is nil, does not exist or if it has a value which cannot be converted to one of the accepted
 *          values.
 *
 *  @see stringForKey:
 *  @see arrayForKey:
 *  @see dictionaryForKey:
 *  @see numberForKey:
 *  @see dateForKey:withFormatter:
 *  @see boolForKeyPath:
 */
-( BOOL )boolForKey:( id )key;

/**
 *  Returns the string representation of the value referenced by key.
 *
 *  @param key The key from which the string value must be parsed.
 *
 *  @return A NString representing the value referenced by key.
 *          Returns nil if key is nil, does not exist or if it has a value which cannot be converted to a NSString.
 *
 *  @see boolForKey:
 *  @see arrayForKey:
 *  @see dictionaryForKey:
 *  @see numberForKey:
 *  @see dateForKey:withFormatter:
 *  @see stringForKeyPath:
 */
-( NSString * )stringForKey:( id )key;

/**
 *  Tries to parse an array from the value referenced by key.
 *
 *  @param key The key from which the array must be parsed.
 *
 *  @return The parsed array or nil if key is nil, does not exist or if it has a value which cannot be converted to
 *          an array
 *
 *  @see boolForKey:
 *  @see stringForKey:
 *  @see dictionaryForKey:
 *  @see numberForKey:
 *  @see dateForKey:withFormatter:
 *  @see arrayForKeyPath:
 */
-( NSArray * )arrayForKey:( id )key;

/**
 *  Tries to parse a dictionary from the value referenced by key.
 *
 *  @param key The key from which the dictionary must be parsed.
 *
 *  @return The parsed dictionary or nil if key is nil, does not exist or if it has a value which cannot be converted to
 *          a dictionary
 *
 *  @see boolForKey:
 *  @see stringForKey:
 *  @see arrayForKey:
 *  @see numberForKey:
 *  @see dateForKey:withFormatter:
 *  @see dictionaryForKeyPath:
 */
-( NSDictionary * )dictionaryForKey:( id )key;

/**
 *  Tries to parse a number from the value referenced by key.
 *
 *  @param key The key from which the number must be parsed.
 *
 *  @return The parsed number or nil if key is nil, does not exist or if it has a value which cannot be converted to
 *          a number
 *
 *  @see boolForKey:
 *  @see stringForKey:
 *  @see arrayForKey:
 *  @see dictionaryForKey:
 *  @see dateForKey:withFormatter:
 *  @see numberForKeyPath:
 */
-( NSNumber * )numberForKey:( id )key;

/**
 *  Tries to parse a date from the value referenced by key.
 *
 *  @param key The key from which the date must be parsed.
 *  @param dateFormatter The date formatter used to specify accepted date formats
 *
 *  @return The parsed date or nil if key is nil, does not exist or if it has a value which cannot be converted to
 *          a date using the specified dateFormatter
 *
 *  @throws NSInvalidArgumentException if dateFormatter is nil
 *
 *  @see boolForKey:
 *  @see stringForKey:
 *  @see arrayForKey:
 *  @see dictionaryForKey:
 *  @see numberForKey:
 *  @see dateForKeyPath:withFormatter:
 */
-( NSDate * )dateForKey:( id )key withFormatter:( NSDateFormatter * )dateFormatter;

/**
 *  Tries to parse a boolean from the value referenced by key. It supports numeric values
 *  and strings.
 *
 *  This method is able to follow a path in nested dictionaries and arrays. Check this category header documentation for
 *  more info.
 *
 *  @param key The key from which the boolean value must be parsed.
 *
 *  @return YES if key has a numeric value different from 0, a string representing a number different from 0 or one of the string values
 *          (in any case combination): @"t", @"true", @"y", @"yes". Format specifiers in number strings, like 'L', 'LL' and 'f', are ignored.
 *          NO if key has a numeric value equal to 0, a string representing the number 0 or one of the string values (in any case
 *          combination): @"f", @"false", @"n", @"no". Format specifiers in number strings, like 'L', 'LL' and 'f', are ignored.
 *          This method also returns NO if key is nil, does not exist or if it has a value which cannot be converted to one of the accepted
 *          values.
 *
 *  @see boolForKey:
 *  @see stringForKeyPath:
 *  @see arrayForKeyPath:
 *  @see dictionaryForKeyPath:
 *  @see numberForKeyPath:
 *  @see dateForKeyPath:withFormatter:
 */
-( BOOL )boolForKeyPath:( NSString * )keyPath;

/**
 *  Returns the string representation of the value referenced by key.
 *
 *  This method is able to follow a path in nested dictionaries and arrays. Check this category header documentation for
 *  more info.
 *
 *  @param key The key from which the string value must be parsed.
 *
 *  @return A NString representing the value referenced by key.
 *          Returns nil if key is nil, does not exist or if it has a value which cannot be converted to a NSString.
 *
 *  @see stringForKey:
 *  @see boolForKeyPath:
 *  @see arrayForKeyPath:
 *  @see dictionaryForKeyPath:
 *  @see numberForKeyPath:
 *  @see dateForKeyPath:withFormatter:
 */
-( NSString * )stringForKeyPath:( NSString * )keyPath;

/**
 *  Tries to parse an array from the value referenced by key.
 *
 *  This method is able to follow a path in nested dictionaries and arrays. Check this category header documentation for
 *  more info.
 *
 *  @param key The key from which the array must be parsed.
 *
 *  @return The parsed array or nil if key is nil, does not exist or if it has a value which cannot be converted to
 *          an array
 *
 *  @see arrayForKey:
 *  @see boolForKeyPath:
 *  @see stringForKeyPath:
 *  @see dictionaryForKeyPath:
 *  @see numberForKeyPath:
 *  @see dateForKeyPath:withFormatter:
 */
-( NSArray * )arrayForKeyPath:( NSString * )keyPath;

/**
 *  Tries to parse a dictionary from the value referenced by key.
 *
 *  This method is able to follow a path in nested dictionaries and arrays. Check this category header documentation for
 *  more info.
 *
 *  @param key The key from which the dictionary must be parsed.
 *
 *  @return The parsed dictionary or nil if key is nil, does not exist or if it has a value which cannot be converted to
 *          a dictionary
 *
 *  @see dictionaryForKey:
 *  @see boolForKeyPath:
 *  @see stringForKeyPath:
 *  @see arrayForKeyPath:
 *  @see numberForKeyPath:
 *  @see dateForKeyPath:withFormatter:
 */
-( NSDictionary * )dictionaryForKeyPath:( NSString * )keyPath;

/**
 *  Tries to parse a number from the value referenced by key.
 *
 *  This method is able to follow a path in nested dictionaries and arrays. Check this category header documentation for
 *  more info.
 *
 *  @param key The key from which the number must be parsed.
 *
 *  @return The parsed number or nil if key is nil, does not exist or if it has a value which cannot be converted to
 *          a number
 *
 *  @see numberForKey:
 *  @see boolForKeyPath:
 *  @see stringForKeyPath:
 *  @see arrayForKeyPath:
 *  @see dictionaryForKeyPath:
 *  @see dateForKeyPath:withFormatter:
 */
-( NSNumber * )numberForKeyPath:( NSString * )keyPath;

/**
 *  Tries to parse a date from the value referenced by key.
 *
 *  This method is able to follow a path in nested dictionaries and arrays. Check this category header documentation for
 *  more info.
 *
 *  @param key The key from which the date must be parsed.
 *  @param dateFormatter The date formatter used to specify accepted date formats
 *
 *  @return The parsed date or nil if key is nil, does not exist or if it has a value which cannot be converted to
 *          a date using the specified dateFormatter
 *
 *  @throws NSInvalidArgumentException if dateFormatter is nil
 *
 *  @see dateForKey:withFormatter:
 *  @see boolForKeyPath:
 *  @see stringForKeyPath:
 *  @see arrayForKeyPath:
 *  @see dictionaryForKeyPath:
 *  @see numberForKeyPath:
 */
-( NSDate * )dateForKeyPath:( NSString * )keyPath withFormatter:( NSDateFormatter * )dateFormatter;

@end
