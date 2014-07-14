//
//  NSDictionary+Utils_Nitro.m
//  NitroNSDictionaryCategories
//
//  Created by Daniel L. Alves on 20/04/11.
//  Copyright (c) 2011 Daniel L. Alves. All rights reserved.
//

#import "NSDictionary+Utils_Nitro.h"

#pragma mark - NSDictionary Implementation

@implementation NSDictionary( Utils_Nitro )

#pragma mark - Utilities

-( BOOL )hasKey:( id )keyToSearch
{
    return self[keyToSearch] != nil;
}

-( id )keyForObject:( id )object
{
	__block id found = nil;
	
	[self keysOfEntriesPassingTest: ^BOOL( id key, id obj, BOOL *stop ){
		
		*stop = ( obj == object );
		
		if( *stop )
			found = key;
		
		return *stop;
	}];
	
	return found;
}

-( NSDictionary * )toPropertyListCompliantDictionary
{
	NSMutableDictionary *propList = [NSMutableDictionary dictionary];
	
	NSArray *allKeys = [self allKeys];
	for( id key in allKeys )
	{
		NSObject *value = self[key];
		if( value != [NSNull null] )
		{
			if( [value isKindOfClass: [NSDictionary class]] )
            {
				value = [( NSDictionary * )value toPropertyListCompliantDictionary];
            }
            else if( ![value isKindOfClass: [NSArray class]]
                     && ![value isKindOfClass: [NSString class]]
                     && ![value isKindOfClass: [NSData class]]
                     && ![value isKindOfClass: [NSDate class]]
                     && ![value isKindOfClass: [NSNumber class]] )
            {
                if( [value conformsToProtocol: @protocol( NSCoding )] )
                    value = [NSKeyedArchiver archivedDataWithRootObject: value];
                else
                    value = nil;
            }
			
            if( value )
                [propList setObject: value forKey: key];
		}
	}
    
	return propList;
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

#pragma mark - Helpers

-( id )getFirstNonNullValueOfParamsList:( va_list )paramsList withFirstParam:( id )param
{
	@try
	{
		id key = param;	
		while( key != nil )
		{
			id temp = self[key];
			if( temp && ( ( NSNull * )temp != [NSNull null] ) )
                return temp;
			
			key = va_arg( paramsList, id );
		};
	}
	@catch( NSException *exception )
	{
        // MUST NOT THROW !!!
	}
	
	return nil;
}

@end
