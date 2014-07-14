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
    dict[ @"0" ] = @"y";
    XCTAssertTrue( [dict boolForKeyPath: @"0"] );
    
    dict[ @"a" ] = @{ @"b": @"true" };
    XCTAssertTrue( [dict boolForKeyPath: @"a/b"] );
    
    dict[ @"a" ] = @[ @{ @"b": @"false" }, @{ @"b": @"t" } ];
    XCTAssertTrue( [dict boolForKeyPath: @"a/1/b"] );
    
    dict[ @"a" ] = @[ @[ @{ @"b": @"false" } ], @[ @{ @"b": @"yes" } ] ];
    XCTAssertTrue( [dict boolForKeyPath: @"a/1/0/b"] );
    

    dict[ @"0" ] = @"n";
    XCTAssertFalse( [dict boolForKeyPath: @"0"] );
    
    dict[ @"a" ] = @{ @"b": @"false" };
    XCTAssertFalse( [dict boolForKeyPath: @"a/b"] );
    
    dict[ @"a" ] = @[ @{ @"b": @"false" }, @{ @"b": @"f" } ];
    XCTAssertFalse( [dict boolForKeyPath: @"a/1/b"] );
    
    dict[ @"a" ] = @[ @[ @{ @"b": @"false" } ], @[ @{ @"b": @"no" } ] ];
    XCTAssertFalse( [dict boolForKeyPath: @"a/1/0/b"] );
    
    
    dict[ @"0" ] = @1;
    XCTAssertTrue( [dict boolForKeyPath: @"0"] );
    
    dict[ @"a" ] = @{ @"b": @10 };
    XCTAssertTrue( [dict boolForKeyPath: @"a/b"] );
    
    dict[ @"a" ] = @[ @{ @"b": @"false" }, @{ @"b": @100 } ];
    XCTAssertTrue( [dict boolForKeyPath: @"a/1/b"] );
    
    dict[ @"a" ] = @[ @[ @{ @"b": @"false" } ], @[ @{ @"b": @1000 } ] ];
    XCTAssertTrue( [dict boolForKeyPath: @"a/1/0/b"] );
    

    dict[ @"0" ] = @0;
    XCTAssertFalse( [dict boolForKeyPath: @"0"] );
    
    dict[ @"a" ] = @{ @"b": @0 };
    XCTAssertFalse( [dict boolForKeyPath: @"a/b"] );
    
    dict[ @"a" ] = @[ @{ @"b": @"false" }, @{ @"b": @"0" } ];
    XCTAssertFalse( [dict boolForKeyPath: @"a/1/b"] );
    
    dict[ @"a" ] = @[ @[ @{ @"b": @"false" } ], @[ @{ @"b": @"0.0f" } ] ];
    XCTAssertFalse( [dict boolForKeyPath: @"a/1/0/b"] );
}

#pragma mark - stringForKeyPath: tests

-( void )test_stringForKeyPath_returns_object_string_representation_if_key_exists
{
    dict[ key ] = @1;
    XCTAssertEqualObjects( [dict stringForKeyPath: key], @"1" );
    
    dict[ key ] = @( -1 );
    XCTAssertEqualObjects( [dict stringForKeyPath: key], @"-1" );
    
    dict[ key ] = @"test";
    XCTAssertEqualObjects( [dict stringForKeyPath: key], @"test" );
    
    NSObject *temp = [[NSObject alloc] init];
    dict[ key ] = temp;
    XCTAssertEqualObjects( [dict stringForKeyPath: key], [temp description] );
}

-( void )test_stringForKeyPath_returns_nil_when_key_does_not_exist
{
    XCTAssertNil( [dict stringForKeyPath: @"kjsabdjhbsd"] );
}

-( void )test_stringForKeyPath_returns_nil_when_key_is_nil
{
    XCTAssertNil( [dict stringForKeyPath: nil] );
}

-( void )test_stringForKeyPath_returns_nil_when_object_cannot_be_converted_to_string
{
    dict[ key ] = [NSNull null];
    XCTAssertNil( [dict stringForKeyPath: key] );
}

-( void )test_stringForKeyPath_follows_key_paths
{
    dict[ @"0" ] = @"test";
    XCTAssertEqualObjects( [dict stringForKeyPath: @"0"], @"test" );
    
    dict[ @"a" ] = @{ @"b": @"test" };
    XCTAssertEqualObjects( [dict stringForKeyPath: @"a/b"], @"test" );
    
    dict[ @"a" ] = @[ @{ @"b": @"test" }, @{ @"b": @"a string" } ];
    XCTAssertEqualObjects( [dict stringForKeyPath: @"a/1/b"], @"a string" );
    
    dict[ @"a" ] = @[ @[ @{ @"b": @"test" } ], @[ @{ @"b": @"a string" } ] ];
    XCTAssertEqualObjects( [dict stringForKeyPath: @"a/1/0/b"], @"a string" );
}

#pragma mark - arrayForKeyPath: tests

-( void )test_arrayForKeyPath_returns_array_if_key_exists
{
    dict[ key ] = @[];
    XCTAssertEqualObjects( [dict arrayForKeyPath: key], @[] );
    
    dict[ key ] = @[ @0 ];
    XCTAssertEqualObjects( [dict arrayForKeyPath: key], @[ @0 ] );
    
    dict[ key ] = @[ @0, @1, @2 ];
    NSArray *expected = @[ @0, @1, @2 ];
    XCTAssertEqualObjects( [dict arrayForKeyPath: key], expected );
    
    dict[ key ] = @[ [NSNull null] ];
    XCTAssertEqualObjects( [dict arrayForKeyPath: key], @[ [NSNull null] ] );
}

-( void )test_arrayForKeyPath_returns_nil_when_key_does_not_exist
{
    XCTAssertNil( [dict arrayForKeyPath: @"kjsabdjhbsd"] );
}

-( void )test_arrayForKeyPath_returns_nil_when_key_is_nil
{
    XCTAssertNil( [dict arrayForKeyPath: nil] );
}

-( void )test_arrayForKeyPath_returns_nil_when_object_cannot_be_converted_to_array
{
    dict[ key ] = [NSNull null];
    XCTAssertNil( [dict arrayForKeyPath: key] );
    
    dict[ key ] = @"";
    XCTAssertNil( [dict arrayForKeyPath: key] );
    
    dict[ key ] = @"TMNT Teenage Mutant Ninja Turtles";
    XCTAssertNil( [dict arrayForKeyPath: key] );
    
    dict[ key ] = @100;
    XCTAssertNil( [dict arrayForKeyPath: key] );
    
    dict[ key ] = @{};
    XCTAssertNil( [dict arrayForKeyPath: key] );
    
    dict[ key ] = @{ @"0" : @1000 };
    XCTAssertNil( [dict arrayForKeyPath: key] );
}

-( void )test_arrayForKeyPath_follows_key_paths
{
    dict[ @"0" ] = @[ @1, @2, @3 ];
    NSArray *expected = @[ @1, @2, @3 ];
    XCTAssertEqualObjects( [dict arrayForKeyPath: @"0"], expected );

    dict[ @"a" ] = @{ @"b": @[ @1, @2, @3 ] };
    expected = @[ @1, @2, @3 ];
    XCTAssertEqualObjects( [dict arrayForKeyPath: @"a/b"], expected );
    
    dict[ @"a" ] = @[ @{ @"b": @[ @1, @2, @3 ] }, @{ @"b": @[ @4, @5, @6 ] } ];
    expected = @[ @4, @5, @6 ];
    XCTAssertEqualObjects( [dict arrayForKeyPath: @"a/1/b"], expected );
    
    dict[ @"a" ] = @[ @[ @{ @"b": @[ @1, @2, @3 ] } ], @[ @{ @"b": @[ @4, @5, @6 ] } ] ];
    XCTAssertEqualObjects( [dict arrayForKeyPath: @"a/1/0/b"], expected );
}

#pragma mark - dictionaryForKeyPath: tests

-( void )test_dictionaryForKeyPath_returns_dictionary_if_key_exists
{
    dict[ key ] = @{};
    XCTAssertEqualObjects( [dict dictionaryForKeyPath: key], @{} );
    
    dict[ key ] = @{ @"key-0": @0 };
    XCTAssertEqualObjects( [dict dictionaryForKeyPath: key], @{ @"key-0": @0 } );
    
    dict[ key ] = @{ @"key-0": @0,
                     @"key-1": @1,
                     @"key-2": @2 };
    NSDictionary *expected = @{ @"key-0": @0,
                                @"key-1": @1,
                                @"key-2": @2 };
    XCTAssertEqualObjects( [dict dictionaryForKeyPath: key], expected );
    
    dict[ key ] = @{ @"key-0": [NSNull null] };
    XCTAssertEqualObjects( [dict dictionaryForKeyPath: key], @{ @"key-0": [NSNull null] } );
}

-( void )test_dictionaryForKeyPath_returns_nil_when_key_does_not_exist
{
    XCTAssertNil( [dict dictionaryForKeyPath: @"kjsabdjhbsd"] );
}

-( void )test_dictionaryForKeyPath_returns_nil_when_key_is_nil
{
    XCTAssertNil( [dict dictionaryForKeyPath: nil] );
}

-( void )test_dictionaryForKeyPath_returns_nil_when_object_cannot_be_converted_to_dictionary
{
    dict[ key ] = [NSNull null];
    XCTAssertNil( [dict dictionaryForKeyPath: key] );
    
    dict[ key ] = @"";
    XCTAssertNil( [dict dictionaryForKeyPath: key] );
    
    dict[ key ] = @"Samurai Jack";
    XCTAssertNil( [dict dictionaryForKeyPath: key] );
    
    dict[ key ] = @100;
    XCTAssertNil( [dict dictionaryForKeyPath: key] );
    
    dict[ key ] = @[];
    XCTAssertNil( [dict dictionaryForKeyPath: key] );
    
    dict[ key ] = @[ @0, @1, @2 ];
    XCTAssertNil( [dict dictionaryForKeyPath: key] );
}

-( void )test_dictionaryForKeyPath_follows_key_paths
{
    dict[ @"0" ] = @{ @"b": @6 };
    XCTAssertEqualObjects( [dict dictionaryForKeyPath: @"0"], @{ @"b": @6 } );
    
    dict[ @"a" ] = @{ @"b": @{ @"c" : @90 } };
    XCTAssertEqualObjects( [dict dictionaryForKeyPath: @"a/b"], @{ @"c" : @90 } );
    
    dict[ @"a" ] = @[ @{ @"b": @{ @"bla": @1 } }, @{ @"b": @{ @"ble": @33 } } ];
    XCTAssertEqualObjects( [dict dictionaryForKeyPath: @"a/1/b"], @{ @"ble": @33 } );
    
    dict[ @"a" ] = @[ @[ @{ @"b": @{ @"bla": @1 } } ], @[ @{ @"b": @{ @"ble": @33 } } ] ];
    XCTAssertEqualObjects( [dict dictionaryForKeyPath: @"a/1/0/b"], @{ @"ble": @33 } );
}

#pragma mark - numberForKeyPath: tests

-( void )test_numberForKeyPath_returns_number_if_key_exists
{
    dict[ key ] = @(-90);
    XCTAssertEqualObjects( [dict numberForKeyPath: key], @(-90) );
    
    dict[ key ] = @5;
    XCTAssertEqualObjects( [dict numberForKeyPath: key], @5 );
    
    dict[ key ] = @(-8.554);
    XCTAssertEqualObjects( [dict numberForKeyPath: key], @(-8.554) );
    
    dict[ key ] = @3.71;
    XCTAssertEqualObjects( [dict numberForKeyPath: key], @3.71 );
    
    dict[ key ] = @9.76e10;
    XCTAssertEqualObjects( [dict numberForKeyPath: key], @9.76e10 );
    
    dict[ key ] = @"-90";
    XCTAssertEqualObjects( [dict numberForKeyPath: key], @(-90) );
    
    dict[ key ] = @"5";
    XCTAssertEqualObjects( [dict numberForKeyPath: key], @5 );
    
    dict[ key ] = @"-8.554";
    XCTAssertEqualObjects( [dict numberForKeyPath: key], @(-8.554) );
    
    dict[ key ] = @"3.71";
    XCTAssertEqualObjects( [dict numberForKeyPath: key], @3.71 );
    
    dict[ key ] = @"9.76e10";
    XCTAssertEqualObjects( [dict numberForKeyPath: key], @9.76e10 );
}

-( void )test_numberForKeyPath_returns_nil_when_key_does_not_exist
{
    XCTAssertNil( [dict numberForKeyPath: @"kjsabdjhbsd"] );
}

-( void )test_numberForKeyPath_returns_nil_when_key_is_nil
{
    XCTAssertNil( [dict numberForKeyPath: nil] );
}

-( void )test_numberForKeyPath_returns_nil_when_object_cannot_be_converted_to_number
{
    dict[ key ] = [NSNull null];
    XCTAssertNil( [dict numberForKeyPath: key] );
    
    dict[ key ] = @"";
    XCTAssertNil( [dict numberForKeyPath: key] );
    
    dict[ key ] = @"Swat Katz";
    XCTAssertNil( [dict numberForKeyPath: key] );
    
    dict[ key ] = @{};
    XCTAssertNil( [dict numberForKeyPath: key] );
    
    dict[ key ] = @{ @"key-0": @0 };
    XCTAssertNil( [dict numberForKeyPath: key] );
    
    dict[ key ] = @[];
    XCTAssertNil( [dict numberForKeyPath: key] );
    
    dict[ key ] = @[ @0, @1, @2 ];
    XCTAssertNil( [dict numberForKeyPath: key] );
}

-( void )test_numberForKeyPath_follows_key_paths
{
    dict[ @"0" ] = @67.22;
    XCTAssertEqualObjects( [dict numberForKeyPath: @"0"], @67.22 );
    
    dict[ @"a" ] = @{ @"b": @25.12 };
    XCTAssertEqualObjects( [dict numberForKeyPath: @"a/b"], @25.12 );
    
    dict[ @"a" ] = @[ @{ @"b": @1009 }, @{ @"b": @13 } ];
    XCTAssertEqualObjects( [dict numberForKeyPath: @"a/1/b"], @13 );
    
    dict[ @"a" ] = @[ @[ @{ @"b": @97000 } ], @[ @{ @"b": @2103.77 } ] ];
    XCTAssertEqualObjects( [dict numberForKeyPath: @"a/1/0/b"], @2103.77 );
}

#pragma mark - dateForKeyPath:withFormatter: tests

-( void )test_dateForKeyPath_withFormatter_returns_date_if_key_exists
{
    // Before 12:00
    dict[ key ] = @"08/09/1983 08:00";
    NSDate *date = [[NSDictionaryParsingKeyPathNitroTests dateFormatter] dateFromString: dict[ key ]];
    XCTAssertEqualObjects( [dict dateForKeyPath: key withFormatter:[NSDictionaryParsingKeyPathNitroTests dateFormatter]], date );
    
    // After 12:00
    dict[ key ] = @"10/11/2013 13:32";
    date = [[NSDictionaryParsingKeyPathNitroTests dateFormatter] dateFromString: dict[ key ]];
    XCTAssertEqualObjects( [dict dateForKeyPath: key withFormatter:[NSDictionaryParsingKeyPathNitroTests dateFormatter]], date );
}

-( void )test_dateForKeyPath_withFormatter_works_with_date_values
{
    dict[ key ] = [[NSDictionaryParsingKeyPathNitroTests dateFormatter] dateFromString: @"08/09/1983 08:00"];
    NSDate *expected = [[NSDictionaryParsingKeyPathNitroTests dateFormatter] dateFromString: @"08/09/1983 08:00"];
    
    XCTAssertEqualObjects( [dict dateForKeyPath: key withFormatter: [NSDictionaryParsingKeyPathNitroTests dateFormatter]], expected );
    
}

-( void )test_dateForKeyPath_withFormatter_returns_nil_when_key_does_not_exist
{
    XCTAssertNil( [dict dateForKeyPath: @"kjsabdjhbsd" withFormatter: [NSDictionaryParsingKeyPathNitroTests dateFormatter]] );
}

-( void )test_dateForKeyPath_withFormatter_returns_nil_when_key_is_nil
{
    XCTAssertNil( [dict dateForKeyPath: nil withFormatter: [NSDictionaryParsingKeyPathNitroTests dateFormatter]] );
}

-( void )test_dateForKeyPath_withFormatter_throws_NSInvalidArgumentException_if_dateFormatter_is_nil
{
    dict[ key ] = @"25/10/1984";
    XCTAssertThrowsSpecificNamed( [dict dateForKeyPath: key withFormatter: nil], NSException, NSInvalidArgumentException );
}

-( void )test_dateForKeyPath_withFormatter_returns_nil_when_object_cannot_be_converted_to_date
{
    dict[ key ] = [NSNull null];
    XCTAssertNil( [dict dateForKeyPath: key withFormatter: [NSDictionaryParsingKeyPathNitroTests dateFormatter]] );
    
    dict[ key ] = @5;
    XCTAssertNil( [dict dateForKeyPath: key withFormatter: [NSDictionaryParsingKeyPathNitroTests dateFormatter]] );
    
    dict[ key ] = @23.876;
    XCTAssertNil( [dict dateForKeyPath: key withFormatter: [NSDictionaryParsingKeyPathNitroTests dateFormatter]] );
    
    dict[ key ] = @( -5 );
    XCTAssertNil( [dict dateForKeyPath: key withFormatter: [NSDictionaryParsingKeyPathNitroTests dateFormatter]] );
    
    dict[ key ] = @( -23.876 );
    XCTAssertNil( [dict dateForKeyPath: key withFormatter: [NSDictionaryParsingKeyPathNitroTests dateFormatter]] );
    
    dict[ key ] = @"";
    XCTAssertNil( [dict dateForKeyPath: key withFormatter: [NSDictionaryParsingKeyPathNitroTests dateFormatter]] );
    
    dict[ key ] = @"Yuyu Hakusho";
    XCTAssertNil( [dict dateForKeyPath: key withFormatter: [NSDictionaryParsingKeyPathNitroTests dateFormatter]] );
    
    dict[ key ] = @{};
    XCTAssertNil( [dict dateForKeyPath: key withFormatter: [NSDictionaryParsingKeyPathNitroTests dateFormatter]] );
    
    dict[ key ] = @{ @"key-0": @0 };
    XCTAssertNil( [dict dateForKeyPath: key withFormatter: [NSDictionaryParsingKeyPathNitroTests dateFormatter]] );
    
    dict[ key ] = @[];
    XCTAssertNil( [dict dateForKeyPath: key withFormatter: [NSDictionaryParsingKeyPathNitroTests dateFormatter]] );
    
    dict[ key ] = @[ @0, @1, @2 ];
    XCTAssertNil( [dict dateForKeyPath: key withFormatter: [NSDictionaryParsingKeyPathNitroTests dateFormatter]] );
}

-( void )test_dateForKeyPath_withFormatter_follows_key_paths
{
    NSDate *expected = [[NSDictionaryParsingKeyPathNitroTests dateFormatter] dateFromString: @"25/06/1888 11:10"];
    
    dict[ @"0" ] = @"25/06/1888 11:10";
    XCTAssertEqualObjects( [dict dateForKeyPath: @"0" withFormatter: [NSDictionaryParsingKeyPathNitroTests dateFormatter]], expected );
    
    dict[ @"a" ] = @{ @"b": @"25/06/1888 11:10" };
    XCTAssertEqualObjects( [dict dateForKeyPath: @"a/b" withFormatter: [NSDictionaryParsingKeyPathNitroTests dateFormatter]], expected );
    
    expected = [[NSDictionaryParsingKeyPathNitroTests dateFormatter] dateFromString: @"23/08/1991 20:08"];
    
    dict[ @"a" ] = @[ @{ @"b": @"25/06/1888 11:10" }, @{ @"b": @"23/08/1991 20:08" } ];
    XCTAssertEqualObjects( [dict dateForKeyPath: @"a/1/b" withFormatter: [NSDictionaryParsingKeyPathNitroTests dateFormatter]], expected );
    
    dict[ @"a" ] = @[ @[ @{ @"b": @"25/06/1888 11:10" } ], @[ @{ @"b": @"23/08/1991 20:08" } ] ];
    XCTAssertEqualObjects( [dict dateForKeyPath: @"a/1/0/b" withFormatter: [NSDictionaryParsingKeyPathNitroTests dateFormatter]], expected );
}

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































































