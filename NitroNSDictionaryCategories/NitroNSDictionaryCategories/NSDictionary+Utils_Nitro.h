//
//  NSDictionary+Utils_Nitro.h
//  nitro
//
//  Created by Daniel L. Alves on 4/20/11.
//  Copyright (c) 2011 nitro. All rights reserved.
//

@interface NSDictionary( Utils_Nitro )

-( BOOL )boolForKey:( id )key;
-( NSString * )stringForKey:( id )key;
-( NSArray * )arrayForKey:( id )key;
-( NSDictionary * )dictionaryForKey:( id )key;
-( NSNumber * )numberForKey:( id )key;
-( NSDate * )dateForKey:( id )key withFormatter:( NSDateFormatter * )dateFormatter;
-( UIColor * )colorForKey:( id )key;

-( BOOL )boolForKeyPath:( NSString * )keyPath;
-( NSString * )stringForKeyPath:( NSString * )keyPath;
-( NSArray * )arrayForKeyPath:( NSString * )keyPath;
-( NSDictionary * )dictionaryForKeyPath:( NSString * )keyPath;
-( NSNumber * )numberForKeyPath:( NSString * )keyPath;
-( NSDate * )dateForKeyPath:( NSString * )keyPath withFormatter:( NSDateFormatter * )dateFormatter;

-( BOOL )hasKey:( id )keyToSearch;
-( id )keyForObject:( id )object;

-( NSDictionary * )toPropertyList;

-( id )getFirstNonNullValueOfKeys:( NSString * )firstKey, ...;
-( NSString * )getFirstNonNullValueOfKeysAsString:( NSString * )firstKey, ...;

@end
