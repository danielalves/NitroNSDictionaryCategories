//
//  NSDictionary+Utils_Nitro.m
//  nitro
//
//  Created by Daniel L. Alves on 4/20/11.
//  Copyright (c) 2011 nitro. All rights reserved.
//

#import "NSDictionary+Utils_Nitro.h"

// nitro
#import "NSString+Logger_Nitro.h"
#import "UIColor+Utils_Nitro.h"

#pragma mark - NSDictionary Implementation

@implementation NSDictionary( Utils_Nitro )

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
	id temp = [NSDictionary objectForKey: key fromDictionaryNode: node];
	if( ![temp isKindOfClass: klass] ) 
        temp = nil;

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
	return [obj isKindOfClass: [NSString class]];
}

#pragma mark - BOOL Parsing

-( BOOL )boolForKey:( id )key
{
	NSNumber *temp = [self numberForKey: key];
	if( temp )
		return [temp intValue] != 0;
	
	return NO;
}

-( BOOL )boolForKeyPath:( NSString * )keyPath
{
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
	// TODO : Do as in numberForKeyPath:
	if( ![NSDictionary isKindOfNSString: key] )
		return [NSDictionary objectForKey: key fromDictionaryNode: self checkForKind: [NSNumber class]];
	
	return [self numberForKeyPath: key];
}

-( NSNumber * )numberForKeyPath:( NSString * )keyPath
{    
    NSNumber *ret = ( NSNumber * )[self nilCheckedObjectForKeyPath: keyPath];
    if( ret )
    {
        if( ![ret isKindOfClass: [NSNumber class]] )
		{
			static NSNumberFormatter *formatter = nil;
			if( !formatter ) 
				formatter = [[NSNumberFormatter alloc] init];
			
            ret = [formatter numberFromString: [NSString stringWithFormat: @"%@", ret]];
		}
    }
	return ret;
}

#pragma mark - NSDate Parsing

-( NSDate * )dateForKey:( id )key withFormatter:( NSDateFormatter * )dateFormatter
{
	if( ![NSDictionary isKindOfNSString: key] )
	{
		id temp = [NSDictionary objectForKey: key fromDictionaryNode: self];
		if( [temp isKindOfClass: [NSDate class]] )
			return temp;
		
		NSString *tempStr = [NSString stringWithFormat: @"%@", temp];
		if( tempStr )
			[dateFormatter dateFromString: tempStr];
		
		return nil;
	}
	
	return [self dateForKeyPath: key withFormatter: dateFormatter];
}

-( NSDate * )dateForKeyPath:( NSString * )keyPath withFormatter:( NSDateFormatter * )dateFormatter
{
	// TODO : Do as in dateForKey:withFormatter:
	NSString *dateStr = [self stringForKeyPath: keyPath];
	
	if( dateStr )
		return [dateFormatter dateFromString: dateStr];
	
	return nil;
}

#pragma mark - UIColor Parsing

-( UIColor * )colorForKey:( id )key
{
    // TODO : Check 3 formats:
    // 1 - [122, 186, 109]
    // 2 - { "r": 122, "g": 186, "b": 109 }
    // 3 - "rgb(122, 186, 109)"
    
    
//    NSString *colorFunc = [self stringForKey: key];
//    if( !colorFunc )
//        return nil;
//    
//    NSError *error = nil;
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: @"rgb\\(.*\\)"
//                                                                           options: NSRegularExpressionCaseInsensitive
//                                                                             error: &error];
//    if( error )
//        return nil;
//    
//    NSTextCheckingResult *result = [regex firstMatchInString: colorFunc
//                                                     options: 0
//                                                       range: NSMakeRange( 0, [colorFunc length])];
//    
//    if( !result || result.range.location == NSNotFound )
//        return nil;
//    
//    colorFunc = [colorFunc substringWithRange: result.range];
//    colorFunc = [colorFunc substringWithRange: NSMakeRange(4, [colorFunc length] - 4 - 1)];
//    
//    NSArray *comps = [colorFunc componentsSeparatedByString: @", "];
//    NSDictionary *colorDict = @{ COLOR_DICT_COMPONENT_KEY_RED : [comps objectAtIndex: 0],
//                                 COLOR_DICT_COMPONENT_KEY_GREEN : [comps objectAtIndex: 1],
//                                 COLOR_DICT_COMPONENT_KEY_BLUE : [comps objectAtIndex: 2],
//                                 COLOR_DICT_COMPONENT_KEY_ALPHA : @"255" };
//    NSDictionary *colorDict = [self dictionaryForKey: key];
    
    NSArray *colorComponents = [self arrayForKey: key];
    if([colorComponents count] < 3)
        return nil;

    return [UIColor colorFromARGBHex: ARGB_TO_HEX( 255,
                                                  [(( NSNumber * )[colorComponents objectAtIndex: 0]) unsignedIntegerValue],
                                                  [(( NSNumber * )[colorComponents objectAtIndex: 1]) unsignedIntegerValue],
                                                  [(( NSNumber * )[colorComponents objectAtIndex: 2]) unsignedIntegerValue] )];
}

#pragma mark - Helpers

-( NSDictionary * )toPropertyList
{
	NSMutableDictionary *propList = [NSMutableDictionary dictionary];
	
	NSArray *allKeys = [self allKeys];
	for( id key in allKeys )
	{
		NSObject *value = self[key];
		if( value != [NSNull null] )
		{
			if( [value isKindOfClass: [NSDictionary class]] )
				value = [( NSDictionary * )value toPropertyList];
			
			[propList setObject: value forKey: key];
		}
	}

	return propList;
}

-( BOOL )hasKey:( id )keyToSearch
{
    return self[keyToSearch] != nil;
}

-( id )getFirstNonNullValueOfParamsList:( va_list )paramsList withFirstParam:( id )param
{
	id ret = nil;
	
	@try
	{
		id key = param;	
		while( key != nil )
		{
			ret = self[key];
			if( ret && ( ( NSNull * )ret != [NSNull null] ) )
				break;
			
			key = va_arg( paramsList, id );
		};
	}
	@catch( NSException *exception )
	{
		LOGI( "%@", [exception reason] );
	}
	
	return ret;
}

-( id )getFirstNonNullValueOfKeys:( NSString * )firstKey, ...
{
	va_list params;
	va_start( params, firstKey );
	
	id ret = [self getFirstNonNullValueOfParamsList: params withFirstParam: firstKey];
	
	va_end( params );
	
	return ret;
}

-( NSString * )getFirstNonNullValueOfKeysAsString:( NSString * )firstKey, ...
{
	va_list params;
	va_start( params, firstKey );
	
	id ret = [self getFirstNonNullValueOfParamsList: params withFirstParam: firstKey];
	
	va_end( params );
	
	if( ( ret == nil ) || ( ( NSNull * )ret == [NSNull null] ) )
		return nil;
	return [NSString stringWithFormat: @"%@", ret];
}


-( id )keyForObject:( id )object
{
	__block id found = nil;
	
	[self keysOfEntriesPassingTest:^BOOL( id key, id obj, BOOL *stop ){
		
		*stop = ( obj == object );
		
		if( *stop )
			found = key;
		
		return *stop;
	}];
	
	return found;
}

@end
