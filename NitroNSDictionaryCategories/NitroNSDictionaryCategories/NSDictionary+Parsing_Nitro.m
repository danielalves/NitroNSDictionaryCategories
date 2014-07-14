//
//  NSDictionary+Parsing_Nitro.m
//  NitroNSDictionaryCategories
//
//  Created by Daniel L. Alves on 2/6/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import "NSDictionary+Parsing_Nitro.h"

// nitro
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

+( BOOL )isKindOfNSString:( id )obj
{
    // TODO : Test other string classes
    
	return [obj isKindOfClass: [NSString class]];
}

#pragma mark - BOOL Parsing

-( BOOL )boolForKey:( id )key
{
    if( ![self hasKey: key] )
        return NO;
    
    NSString *tempLowercaseNSString = [[self stringForKey: key] lowercaseString];
    if( tempLowercaseNSString.length == 0 )
        return NO;
    
    if( [tempLowercaseNSString isEqualToString: @"f"]
       || [tempLowercaseNSString isEqualToString: @"n"]
       || [tempLowercaseNSString isEqualToString: @"false"]
       || [tempLowercaseNSString isEqualToString: @"no"] )
        return NO;
    
    if( [tempLowercaseNSString isEqualToString: @"t"]
       || [tempLowercaseNSString isEqualToString: @"y"]
       || [tempLowercaseNSString isEqualToString: @"true"]
       || [tempLowercaseNSString isEqualToString: @"yes"] )
        return YES;
    
	NSNumber *tempNSNumber = [self numberForKey: key];
	if( !tempNSNumber )
        return NO;
    
    const char *underlyingNumberTypeIdentifierStr = [tempNSNumber objCType];
    if( underlyingNumberTypeIdentifierStr == NULL )
        return NO;
    
    char underlyingNumberTypeIdentifier = underlyingNumberTypeIdentifierStr[0];
    
    if( underlyingNumberTypeIdentifier == @encode( float )[0] )
        return [tempNSNumber floatValue] != 0.0f;
    
    if( underlyingNumberTypeIdentifier == @encode( double )[0] )
        return [tempNSNumber doubleValue] != 0.0;
    
    // Long double not supported
    // ...
    
    return [tempNSNumber longLongValue] != 0;
}

-( BOOL )boolForKeyPath:( NSString * )keyPath
{
    // TODO : Rewrite based on boolForKey !!!!
    
	NSNumber *temp = [self numberForKeyPath: keyPath];
	if( temp )
		return [temp intValue] != 0;
	
	return NO;
}

#pragma mark - NSString Parsing

-( NSString * )stringForKey:( id )key
{
	if( ![NSDictionary isKindOfNSString: key] )
	{
		id temp = [NSDictionary objectForKey: key fromDictionaryNode: self];
		if( temp )
			return [NSString stringWithFormat: @"%@", temp];
		
		return nil;
	}
	
	return [self stringForKeyPath: key];
}

-( NSString * )stringForKeyPath:( NSString * )keyPath
{
	NSString *ret = nil;
    
    id obj = [self nilCheckedObjectForKeyPath: keyPath];
    if( obj )
        ret = [NSString stringWithFormat: @"%@", obj];
    
	return ret;
}

#pragma mark - NSArray Parsing

-( NSArray * )arrayForKey:( id )key
{
	if( ![NSDictionary isKindOfNSString: key] )
		return [NSDictionary objectForKey: key fromDictionaryNode: self checkForKind: [NSArray class]];
	
	return [self arrayForKeyPath: key];
}

-( NSArray * )arrayForKeyPath:( NSString * )keyPath
{
	id temp = [self nilCheckedObjectForKeyPath: keyPath];
    
    if( ![temp isKindOfClass: [NSArray class]] )
        temp = nil;
    
    return temp;
}

#pragma mark - NSDictionary Parsing

-( NSDictionary * )dictionaryForKey:( id )key
{
	if( ![NSDictionary isKindOfNSString: key] )
		return [NSDictionary objectForKey: key fromDictionaryNode: self checkForKind: [NSDictionary class]];
	
	return [self dictionaryForKeyPath: key];
}

-( NSDictionary * )dictionaryForKeyPath:( NSString * )keyPath
{
	id temp = [self nilCheckedObjectForKeyPath: keyPath];
    
    if( ![temp isKindOfClass: [NSDictionary class]] )
        temp = nil;
    
    return temp;
}

#pragma mark - NSNumber Parsing

-( NSNumber * )numberForKey:( id )key
{
	if( ![NSDictionary isKindOfNSString: key] )
    {
		return [NSDictionary objectForKey: key
                       fromDictionaryNode: self
                             checkForKind: [NSNumber class]
                          alternateParser:^id( id obj ) {
            return [NSDictionary tryParsingNumberFromObject: obj];
        }];
    }
	
	return [self numberForKeyPath: key];
}

-( NSNumber * )numberForKeyPath:( NSString * )keyPath
{
    id ret = [self nilCheckedObjectForKeyPath: keyPath];
    if( ret )
    {
        if( ![ret isKindOfClass: [NSNumber class]] )
            ret = [NSDictionary tryParsingNumberFromObject: ret];
    }
	return ( NSNumber * )ret;
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
    
	if( ![NSDictionary isKindOfNSString: key] )
	{
        id temp = [NSDictionary objectForKey: key fromDictionaryNode: self];
		return ( NSDate * )[NSDictionary tryParsingDateFromObject: temp withDateFormatter: dateFormatter];
	}
	
	return [self dateForKeyPath: key withFormatter: dateFormatter];
}

-( NSDate * )dateForKeyPath:( NSString * )keyPath withFormatter:( NSDateFormatter * )dateFormatter
{
    id ret = [self nilCheckedObjectForKeyPath: keyPath];
    if( ret )
        return ( NSDate * )[NSDictionary tryParsingDateFromObject: ret withDateFormatter: dateFormatter];

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