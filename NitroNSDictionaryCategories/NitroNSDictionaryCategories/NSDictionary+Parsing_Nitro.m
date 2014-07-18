//
//  NSDictionary+Parsing_Nitro.m
//  NitroNSDictionaryCategories
//
//  Created by Daniel L. Alves on 02/06/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import "NSDictionary+Parsing_Nitro.h"

// NitroNSDictionaryCategories
#import "NSDictionary+Utils_Nitro.h"

#pragma mark - Macros

// Just to get compilation errors and to be refactoring compliant. But this way we can't concat strings at compilation time =/
#define EVAL_AND_STRINGIFY(x) (x ? __STRING(x) : __STRING(x))

#pragma mark - Implementation

@implementation NSDictionary( Parsing_Nitro )

#pragma mark - Key Path Parsing

-( NSArray * )stripEmptyPathComponents:( NSArray * )pathComponents
{
	return [pathComponents objectsAtIndexes: [pathComponents indexesOfObjectsPassingTest: ^( id obj, NSUInteger idx, BOOL *stop )
                                              {
                                                  *stop = NO;
                                                  return ( BOOL )((( NSString * )obj ).length > 0 );
                                              }]];
}

+( id )objectAtStrIndex:( NSString * )objIndexStr fromArrayNode:( NSArray * )node
{
	NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
	if( !numFormatter )
		return nil;
	
	NSNumber *parsedIndex = [numFormatter numberFromString: objIndexStr];
	
	if( !parsedIndex || [parsedIndex unsignedIntegerValue] >= [node count] )
		return nil;
	
	id temp = [node objectAtIndex: [parsedIndex unsignedIntegerValue]];
	if( !temp || ( ( NSNull * )temp == [NSNull null] ) )
		return nil;
	
	return temp;
}

+( id )objectForKey:( NSString * )key fromDictionaryNode:( NSDictionary * )node checkForKind:( Class )klass
{
    return [self objectForKey: key fromDictionaryNode: node checkForKind: klass alternateParser: nil];
}

+( id )objectForKey:( NSString * )key fromDictionaryNode:( NSDictionary * )node checkForKind:( Class )klass alternateParser:( id(^)(id obj) )alternateParser
{
	id temp = [NSDictionary objectForKey: key fromDictionaryNode: node];
	if( ![temp isKindOfClass: klass] )
    {
        if( alternateParser )
            temp = alternateParser( temp );
        else
            temp = nil;
    }
    
    return temp;
}

+( id )objectForKey:( NSString * )key fromDictionaryNode:( NSDictionary * )node
{
	id temp = node[key];
	if( !temp || ( ( NSNull * )temp == [NSNull null] ) )
		return nil;
	return temp;
}

-( id )nilCheckedObjectForKeyPath:( NSString * )keyPath
{
	NSArray *keyPathComponents = [self stripEmptyPathComponents: [keyPath componentsSeparatedByString: @"/"]];
	NSUInteger nKeys = [keyPathComponents count];
	
	if( !nKeys )
		return nil;
    
	id currNode = self;
    
	for( NSUInteger currKeyIndex = 0 ; currKeyIndex < nKeys ; ++currKeyIndex )
	{
		id currKey = [keyPathComponents objectAtIndex: currKeyIndex];
		
		if( [currNode isKindOfClass: [NSArray class]] )
		{
			currNode = [NSDictionary objectAtStrIndex: currKey fromArrayNode: currNode];
		}
		else if( [currNode isKindOfClass: [NSDictionary class]] )
		{
			currNode = [NSDictionary objectForKey: currKey fromDictionaryNode: currNode];
		}
		else
		{
			currNode = nil;
			break;
		}
	}
	
	return currNode;
}

#pragma mark - BOOL Parsing

-( BOOL )boolForKey:( id )key
{
    if( ![self hasKey: key] )
        return NO;
    
    NSString *tempNSString = [self stringForKey: key];
    if( tempNSString.length == 0 )
        return NO;
    
    NSNumber *boolFromString = [NSDictionary boolFromNSString: tempNSString];
    if( boolFromString )
        return [boolFromString boolValue];
    
	NSNumber *tempNSNumber = [self numberForKey: key];
	if( !tempNSNumber )
        return NO;
    
    return [NSDictionary boolFromNSNumber: tempNSNumber];
}

-( BOOL )boolForKeyPath:( NSString * )keyPath
{
    NSString *tempNSString = [self stringForKeyPath: keyPath];
    if( tempNSString.length == 0 )
        return NO;
    
    NSNumber *boolFromString = [NSDictionary boolFromNSString: tempNSString];
    if( boolFromString )
        return [boolFromString boolValue];

    NSNumber *tempNSNumber = [self numberForKeyPath: keyPath];
	if( !tempNSNumber )
        return NO;
    
    return [NSDictionary boolFromNSNumber: tempNSNumber];
}

+( NSNumber * )boolFromNSString:( NSString * )string
{
    NSString *lowercaseString = [string lowercaseString];
    
    if( [lowercaseString isEqualToString: @"f"]
       || [lowercaseString isEqualToString: @"n"]
       || [lowercaseString isEqualToString: @"false"]
       || [lowercaseString isEqualToString: @"no"] )
        return [NSNumber numberWithBool: NO];
    
    if( [lowercaseString isEqualToString: @"t"]
       || [lowercaseString isEqualToString: @"y"]
       || [lowercaseString isEqualToString: @"true"]
       || [lowercaseString isEqualToString: @"yes"] )
        return [NSNumber numberWithBool: YES];
    
    return nil;
}

+( BOOL )boolFromNSNumber:( NSNumber * )number
{
    const char *underlyingNumberTypeIdentifierStr = [number objCType];
    if( underlyingNumberTypeIdentifierStr == NULL )
        return NO;
    
    char underlyingNumberTypeIdentifier = underlyingNumberTypeIdentifierStr[0];
    
    if( underlyingNumberTypeIdentifier == @encode( float )[0] )
        return [number floatValue] != 0.0f;
    
    if( underlyingNumberTypeIdentifier == @encode( double )[0] )
        return [number doubleValue] != 0.0;
    
    // Long double not supported
    // ...
    
    return [number longLongValue] != 0;
}

#pragma mark - NSString Parsing

-( NSString * )stringForKey:( id )key
{
    id obj = [NSDictionary objectForKey: key fromDictionaryNode: self];
    if( obj )
        return [NSString stringWithFormat: @"%@", obj];
    
    return nil;
}

-( NSString * )stringForKeyPath:( NSString * )keyPath
{
    id obj = [self nilCheckedObjectForKeyPath: keyPath];
    if( obj )
        return [NSString stringWithFormat: @"%@", obj];
    
	return nil;
}

#pragma mark - NSArray Parsing

-( NSArray * )arrayForKey:( id )key
{
    // TODO : Class clusters!!!
    return [NSDictionary objectForKey: key
                   fromDictionaryNode: self
                         checkForKind: [NSArray class]];
}

-( NSArray * )arrayForKeyPath:( NSString * )keyPath
{
	id obj = [self nilCheckedObjectForKeyPath: keyPath];
    
    if( [obj isKindOfClass: [NSArray class]] )
        return obj;
    
    return nil;
}

#pragma mark - NSDictionary Parsing

-( NSDictionary * )dictionaryForKey:( id )key
{
    // TODO : Class clusters!!!
    return [NSDictionary objectForKey: key
                   fromDictionaryNode: self
                         checkForKind: [NSDictionary class]];
}

-( NSDictionary * )dictionaryForKeyPath:( NSString * )keyPath
{
	id obj = [self nilCheckedObjectForKeyPath: keyPath];
    
    if( [obj isKindOfClass: [NSDictionary class]] )
        return obj;
    
    return nil;
}

#pragma mark - NSNumber Parsing

-( NSNumber * )numberForKey:( id )key
{
    // TODO : Class clusters!!!
    return [NSDictionary objectForKey: key
                   fromDictionaryNode: self
                         checkForKind: [NSNumber class]
                      alternateParser: ^id( id obj ) {
                          return [NSDictionary tryParsingNumberFromObject: obj];
                      }];
}

-( NSNumber * )numberForKeyPath:( NSString * )keyPath
{
    id obj = [self nilCheckedObjectForKeyPath: keyPath];
    
    if( [obj isKindOfClass: [NSNumber class]] )
        return obj;
    
    return [NSDictionary tryParsingNumberFromObject: obj];
}

+( id )tryParsingNumberFromObject:( id )obj
{
    // Static so we do not have to allocate a new formatter everytime what,
    // as noted in the docs, is an expensive operation
    static NSNumberFormatter *formatter = nil;
    if( !formatter )
        formatter = [[NSNumberFormatter alloc] init];
    
    // Try to parse a number from obj string representation
    NSString *strRepresentation = [NSString stringWithFormat: @"%@", obj];
    strRepresentation = [strRepresentation stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: @"lLfF"]];
    
    return [formatter numberFromString: strRepresentation];
}

#pragma mark - NSDate Parsing

-( NSDate * )dateForKey:( id )key withFormatter:( NSDateFormatter * )dateFormatter
{
    if( ![self hasKey: key] )
        return nil;
    
    if( !dateFormatter )
        [NSException raise: NSInvalidArgumentException format: @"%s must not be nil", EVAL_AND_STRINGIFY(dateFormatter)];

    id obj = [NSDictionary objectForKey: key fromDictionaryNode: self];
    return [NSDictionary tryParsingDateFromObject: obj withDateFormatter: dateFormatter];
}

-( NSDate * )dateForKeyPath:( NSString * )keyPath withFormatter:( NSDateFormatter * )dateFormatter
{
    if( !dateFormatter )
        [NSException raise: NSInvalidArgumentException format: @"%s must not be nil", EVAL_AND_STRINGIFY(dateFormatter)];
    
    id obj = [self nilCheckedObjectForKeyPath: keyPath];
    if( obj )
        return [NSDictionary tryParsingDateFromObject: obj withDateFormatter: dateFormatter];

	return nil;
}

+( id )tryParsingDateFromObject:( id )obj withDateFormatter:( NSDateFormatter * )dateFormatter
{
    if( [obj isKindOfClass: [NSDate class]] )
        return obj;
    
    NSString *tempStr = [NSString stringWithFormat: @"%@", obj];
    if( tempStr )
        return [dateFormatter dateFromString: tempStr];
    
    return nil;
}

@end
