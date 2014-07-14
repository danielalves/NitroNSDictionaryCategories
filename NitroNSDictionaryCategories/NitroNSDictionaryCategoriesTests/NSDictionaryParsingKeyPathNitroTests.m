//
//  NSDictionaryParsingKeyPathNitroTests.m
//  NitroNSDictionaryCategoriesTests
//
//  Created by Daniel L. Alves on 28/5/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import <XCTest/XCTest.h>

// nitro
#import "NSDictionary+Parsing_Nitro.h"

// c
#import <float.h>
#import <stdint.h>
#import <limits.h>

#pragma mark - Defines

#define STRINGIFY( x ) #x
#define NSSTRINGIFY( x ) @"" STRINGIFY( x ) ""
#define RESOLVE_PARENTHESES_ISSUE_AND_NSTRINGIFY( f, x ) [NSString stringWithFormat: f, x ]

#define SECONDS_IN_HOUR ( 60 * 60 )
#define BRASILIA_GMT_SECS ( -3 * SECONDS_IN_HOUR )

#pragma mark - Interface

@interface NSDictionaryParsingKeyPathNitroTests : XCTestCase
{
    NSString *key;
    NSMutableDictionary *dict;
}
@end

#pragma mark - Implementation

@implementation NSDictionaryParsingKeyPathNitroTests

#pragma mark - Tests lifecycle

-( void )setUp
{
    key = @"key";
    dict = [[NSMutableDictionary alloc] init];
}

#pragma mark - boolForKeyPath: tests

-( void )test_boolForKeyPath_returns_YES_for_positive_numeric_integer_values
{
    dict[ key ] = @( ( char )1 );
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = @( SHRT_MAX );
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = @( INT_MAX );
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = @( LONG_MAX );
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = @( LONG_LONG_MAX );
    XCTAssertTrue( [dict boolForKeyPath: key] );
}

-( void )test_boolForKeyPath_returns_YES_for_negative_numeric_integer_values
{
    dict[ key ] = @( ( signed char )-1 );
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = @( SHRT_MIN );
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = @( INT_MIN );
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = @( LONG_MIN );
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = @( LONG_LONG_MIN );
    XCTAssertTrue( [dict boolForKeyPath: key] );
}

-( void )test_boolForKeyPath_returns_NO_for_integer_value_zero
{
    dict[ key ] = @( 0 );
    XCTAssertFalse( [dict boolForKeyPath: key] );
}

-( void )test_boolForKeyPath_returns_YES_for_positive_numeric_floating_point_values
{
    dict[ key ] = @( 1.0f );
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = @( 1.0 );
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = @( FLT_MAX );
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = @( DBL_MAX );
    XCTAssertTrue( [dict boolForKeyPath: key] );
}

-( void )test_boolForKeyPath_returns_YES_for_negative_numeric_floating_point_values
{
    dict[ key ] = @( -1.0f );
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = @( -1.0 );
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = @( -FLT_MAX );
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = @( -DBL_MAX );
    XCTAssertTrue( [dict boolForKeyPath: key] );
}

-( void )test_boolForKeyPath_returns_NO_for_floating_point_value_zero
{
    dict[ key ] = @( 0.0f );
    XCTAssertFalse( [dict boolForKeyPath: key] );
    
    dict[ key ] = @( -0.0f );
    XCTAssertFalse( [dict boolForKeyPath: key] );
    
    dict[ key ] = @( 0.0 );
    XCTAssertFalse( [dict boolForKeyPath: key] );
    
    dict[ key ] = @( -0.0 );
    XCTAssertFalse( [dict boolForKeyPath: key] );
}

-( void )test_boolForKeyPath_returns_NO_when_key_does_not_exist
{
    XCTAssertFalse( [dict boolForKeyPath: key] );
}

-( void )test_boolForKeyPath_returns_NO_when_key_is_nil
{
    XCTAssertFalse( [dict boolForKeyPath: nil] );
}

-( void )test_boolForKeyPath_returns_NO_when_key_has_a_value_which_is_not_accepted
{
    dict[ key ] = [NSNull null];
    XCTAssertFalse( [dict boolForKeyPath: key] );
    
    dict[ key ] = @[];
    XCTAssertFalse( [dict boolForKeyPath: key] );
    
    dict[ key ] = @[ @1, @2, @3 ];
    XCTAssertFalse( [dict boolForKeyPath: key] );
    
    dict[ key ] = @{};
    XCTAssertFalse( [dict boolForKeyPath: key] );
    
    dict[ key ] = @{ @"1" : @1, @"2" : @2, @"3" : @3 };
    XCTAssertFalse( [dict boolForKeyPath: key] );
}

-( void )test_boolForKeyPath_returns_NO_for_strings_that_do_not_represent_a_number
{
    dict[ key ] = @"";
    XCTAssertFalse( [dict boolForKeyPath: key] );
    
    dict[ key ] = @"a";
    XCTAssertFalse( [dict boolForKeyPath: key] );
    
    dict[ key ] = @"A";
    XCTAssertFalse( [dict boolForKeyPath: key] );
    
    dict[ key ] = @"aadsd";
    XCTAssertFalse( [dict boolForKeyPath: key] );
    
    dict[ key ] = @"KSJDNKFJ";
    XCTAssertFalse( [dict boolForKeyPath: key] );
}

-( void )test_boolForKeyPath_returns_YES_for_strings_that_represent_a_positive_numeric_integer
{
    dict[ key ] = @"1";
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = NSSTRINGIFY( SHRT_MAX );
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = NSSTRINGIFY( INT_MAX );
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = NSSTRINGIFY( LONG_MAX );
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = NSSTRINGIFY( LONG_LONG_MAX );
    XCTAssertTrue( [dict boolForKeyPath: key] );
}

-( void )test_boolForKeyPath_returns_YES_for_strings_that_represent_a_negative_numeric_integer
{
    dict[ key ] = @"-1";
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = RESOLVE_PARENTHESES_ISSUE_AND_NSTRINGIFY( @"%hd", (short)SHRT_MIN );
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = RESOLVE_PARENTHESES_ISSUE_AND_NSTRINGIFY( @"%d", INT_MIN );
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = RESOLVE_PARENTHESES_ISSUE_AND_NSTRINGIFY( @"%ldL", LONG_MIN );
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = RESOLVE_PARENTHESES_ISSUE_AND_NSTRINGIFY( @"%lldLL", LONG_LONG_MIN );
    XCTAssertTrue( [dict boolForKeyPath: key] );
}

-( void )test_boolForKeyPath_returns_NO_for_strings_that_represent_integer_value_zero
{
    dict[ key ] = @"0";
    XCTAssertFalse( [dict boolForKeyPath: key] );
}

-( void )test_boolForKeyPath_returns_YES_for_strings_that_represent_a_positive_floating_point_value
{
    dict[ key ] = @"1.0f";
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = @"1.0";
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = NSSTRINGIFY( FLT_MAX );
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = NSSTRINGIFY( DBL_MAX );
    XCTAssertTrue( [dict boolForKeyPath: key] );
}

-( void )test_boolForKeyPath_returns_YES_for_strings_that_represent_a_negative_floating_point_value
{
    dict[ key ] = @"-1.0f";
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = @"-1.0";
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = NSSTRINGIFY( -FLT_MAX );
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = NSSTRINGIFY( -DBL_MAX );
    XCTAssertTrue( [dict boolForKeyPath: key] );
}

-( void )test_boolForKeyPath_returns_NO_for_strings_that_represent_floating_point_value_zero
{
    dict[ key ] = @"0.0f";
    XCTAssertFalse( [dict boolForKeyPath: key] );
    
    dict[ key ] = @"-0.0f";
    XCTAssertFalse( [dict boolForKeyPath: key] );
    
    dict[ key ] = @"0.0";
    XCTAssertFalse( [dict boolForKeyPath: key] );
    
    dict[ key ] = @"-0.0";
    XCTAssertFalse( [dict boolForKeyPath: key] );
}

-( void )test_boolForKeyPath_returns_YES_for_strings_meaning_true
{
    dict[ key ] = @"y";
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = @"Y";
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = @"yes";
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = @"YES";
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = @"t";
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = @"T";
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = @"true";
    XCTAssertTrue( [dict boolForKeyPath: key] );
    
    dict[ key ] = @"TRUE";
    XCTAssertTrue( [dict boolForKeyPath: key] );
}

-( void )test_boolForKeyPath_returns_NO_for_strings_meaning_false
{
    dict[ key ] = @"n";
    XCTAssertFalse( [dict boolForKeyPath: key] );
    
    dict[ key ] = @"N";
    XCTAssertFalse( [dict boolForKeyPath: key] );
    
    dict[ key ] = @"no";
    XCTAssertFalse( [dict boolForKeyPath: key] );
    
    dict[ key ] = @"NO";
    XCTAssertFalse( [dict boolForKeyPath: key] );
    
    dict[ key ] = @"f";
    XCTAssertFalse( [dict boolForKeyPath: key] );
    
    dict[ key ] = @"F";
    XCTAssertFalse( [dict boolForKeyPath: key] );
    
    dict[ key ] = @"false";
    XCTAssertFalse( [dict boolForKeyPath: key] );
    
    dict[ key ] = @"FALSE";
    XCTAssertFalse( [dict boolForKeyPath: key] );
}

-( void )test_boolForKeyPath_follows_key_paths
{
    dict[ @"a" ] = @{ @"b": @"true" };
    XCTAssertTrue( [dict boolForKeyPath: @"a/b"] );
    
    dict[ @"a" ] = @[ @{ @"b": @"false" }, @{ @"b": @"true" } ];
    XCTAssertTrue( [dict boolForKeyPath: @"a/1/b"] );
    
    dict[ @"a" ] = @[ @[ @{ @"b": @"false" } ], @[ @{ @"b": @"true" } ] ];
    XCTAssertTrue( [dict boolForKeyPath: @"a/1/0/b"] );
}

#pragma mark - stringForKeyPath: tests

#pragma mark - arrayForKeyPath: tests

#pragma mark - dictionaryForKeyPath: tests

#pragma mark - numberForKeyPath: tests

#pragma mark - dateForKeyPath:withFormatter: tests

#pragma mark - Helpers

+( NSDateFormatter * )dateFormatter
{
    static NSDateFormatter *formatter = nil;
    if( !formatter )
    {
        formatter = [[NSDateFormatter alloc] init];
		formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier: @"pt_BR"];
		formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT: BRASILIA_GMT_SECS];
		formatter.dateFormat = @"dd/MM/yyyy HH:mm";
    }
    return formatter;
}

@end































































