//
//  NSDictionaryParsingNitroTests.m
//  NitroNSDictionaryCategoriesTests
//
//  Created by Daniel L. Alves on 28/05/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import <XCTest/XCTest.h>

// c
#import <float.h>
#import <stdint.h>
#import <limits.h>

// NitroNSDictionaryCategories
#import "NSDictionary+Parsing_Nitro.h"

#pragma mark - Defines

#define STRINGIFY( x ) #x
#define NSSTRINGIFY( x ) @"" STRINGIFY( x ) ""
#define RESOLVE_PARENTHESES_ISSUE_AND_NSTRINGIFY( f, x ) [NSString stringWithFormat: f, x ]

#define SECONDS_IN_HOUR ( 60 * 60 )
#define BRASILIA_GMT_SECS ( -3 * SECONDS_IN_HOUR )

#pragma mark - Interface

@interface NSDictionaryParsingNitroTests : XCTestCase
{
    NSString *key;
    NSMutableDictionary *dict;
}
@end

#pragma mark - Implementation

@implementation NSDictionaryParsingNitroTests

#pragma mark - Tests lifecycle

-( void )setUp
{
    key = @"key";
    dict = [[NSMutableDictionary alloc] init];
}

#pragma mark - boolForKey: tests

-( void )test_boolForKey_returns_YES_for_positive_numeric_integer_values
{
    dict[ key ] = @( ( char )1 );
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = @( SHRT_MAX );
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = @( INT_MAX );
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = @( LONG_MAX );
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = @( LONG_LONG_MAX );
    XCTAssertTrue( [dict boolForKey: key] );
}

-( void )test_boolForKey_returns_YES_for_negative_numeric_integer_values
{
    dict[ key ] = @( ( signed char )-1 );
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = @( SHRT_MIN );
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = @( INT_MIN );
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = @( LONG_MIN );
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = @( LONG_LONG_MIN );
    XCTAssertTrue( [dict boolForKey: key] );
}

-( void )test_boolForKey_returns_NO_for_integer_value_zero
{
    dict[ key ] = @( 0 );
    XCTAssertFalse( [dict boolForKey: key] );
}

-( void )test_boolForKey_returns_YES_for_positive_numeric_floating_point_values
{
    dict[ key ] = @( 1.0f );
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = @( 1.0 );
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = @( FLT_MAX );
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = @( DBL_MAX );
    XCTAssertTrue( [dict boolForKey: key] );
}

-( void )test_boolForKey_returns_YES_for_negative_numeric_floating_point_values
{
    dict[ key ] = @( -1.0f );
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = @( -1.0 );
    XCTAssertTrue( [dict boolForKey: key] );

    dict[ key ] = @( -FLT_MAX );
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = @( -DBL_MAX );
    XCTAssertTrue( [dict boolForKey: key] );
}

-( void )test_boolForKey_returns_NO_for_floating_point_value_zero
{
    dict[ key ] = @( 0.0f );
    XCTAssertFalse( [dict boolForKey: key] );
    
    dict[ key ] = @( -0.0f );
    XCTAssertFalse( [dict boolForKey: key] );
    
    dict[ key ] = @( 0.0 );
    XCTAssertFalse( [dict boolForKey: key] );
    
    dict[ key ] = @( -0.0 );
    XCTAssertFalse( [dict boolForKey: key] );
}

-( void )test_boolForKey_returns_NO_when_key_does_not_exist
{
    XCTAssertFalse( [dict boolForKey: key] );
}

-( void )test_boolForKey_returns_NO_when_key_is_nil
{
    XCTAssertFalse( [dict boolForKey: nil] );
}

-( void )test_boolForKey_returns_NO_when_key_has_a_value_which_is_not_accepted
{
    dict[ key ] = [NSNull null];
    XCTAssertFalse( [dict boolForKey: key] );
    
    dict[ key ] = @[];
    XCTAssertFalse( [dict boolForKey: key] );
    
    dict[ key ] = @[ @1, @2, @3 ];
    XCTAssertFalse( [dict boolForKey: key] );

    dict[ key ] = @{};
    XCTAssertFalse( [dict boolForKey: key] );
    
    dict[ key ] = @{ @"1" : @1, @"2" : @2, @"3" : @3 };
    XCTAssertFalse( [dict boolForKey: key] );
}

-( void )test_boolForKey_returns_NO_for_strings_that_do_not_represent_a_number
{
    dict[ key ] = @"";
    XCTAssertFalse( [dict boolForKey: key] );
    
    dict[ key ] = @"a";
    XCTAssertFalse( [dict boolForKey: key] );
    
    dict[ key ] = @"A";
    XCTAssertFalse( [dict boolForKey: key] );
    
    dict[ key ] = @"aadsd";
    XCTAssertFalse( [dict boolForKey: key] );
    
    dict[ key ] = @"KSJDNKFJ";
    XCTAssertFalse( [dict boolForKey: key] );
}

-( void )test_boolForKey_returns_YES_for_strings_that_represent_a_positive_numeric_integer
{
    dict[ key ] = @"1";
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = NSSTRINGIFY( SHRT_MAX );
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = NSSTRINGIFY( INT_MAX );
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = NSSTRINGIFY( LONG_MAX );
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = NSSTRINGIFY( LONG_LONG_MAX );
    XCTAssertTrue( [dict boolForKey: key] );
}

-( void )test_boolForKey_returns_YES_for_strings_that_represent_a_negative_numeric_integer
{
    dict[ key ] = @"-1";
    XCTAssertTrue( [dict boolForKey: key] );

    dict[ key ] = RESOLVE_PARENTHESES_ISSUE_AND_NSTRINGIFY( @"%hd", (short)SHRT_MIN );
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = RESOLVE_PARENTHESES_ISSUE_AND_NSTRINGIFY( @"%d", INT_MIN );
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = RESOLVE_PARENTHESES_ISSUE_AND_NSTRINGIFY( @"%ldL", LONG_MIN );
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = RESOLVE_PARENTHESES_ISSUE_AND_NSTRINGIFY( @"%lldLL", LONG_LONG_MIN );
    XCTAssertTrue( [dict boolForKey: key] );
}

-( void )test_boolForKey_returns_NO_for_strings_that_represent_integer_value_zero
{
    dict[ key ] = @"0";
    XCTAssertFalse( [dict boolForKey: key] );
}

-( void )test_boolForKey_returns_YES_for_strings_that_represent_a_positive_floating_point_value
{
    dict[ key ] = @"1.0f";
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = @"1.0";
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = NSSTRINGIFY( FLT_MAX );
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = NSSTRINGIFY( DBL_MAX );
    XCTAssertTrue( [dict boolForKey: key] );
}

-( void )test_boolForKey_returns_YES_for_strings_that_represent_a_negative_floating_point_value
{
    dict[ key ] = @"-1.0f";
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = @"-1.0";
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = NSSTRINGIFY( -FLT_MAX );
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = NSSTRINGIFY( -DBL_MAX );
    XCTAssertTrue( [dict boolForKey: key] );
}

-( void )test_boolForKey_returns_NO_for_strings_that_represent_floating_point_value_zero
{
    dict[ key ] = @"0.0f";
    XCTAssertFalse( [dict boolForKey: key] );
    
    dict[ key ] = @"-0.0f";
    XCTAssertFalse( [dict boolForKey: key] );
    
    dict[ key ] = @"0.0";
    XCTAssertFalse( [dict boolForKey: key] );
    
    dict[ key ] = @"-0.0";
    XCTAssertFalse( [dict boolForKey: key] );
}

-( void )test_boolForKey_returns_YES_for_strings_meaning_true
{
    dict[ key ] = @"y";
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = @"Y";
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = @"yes";
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = @"YES";
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = @"t";
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = @"T";
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = @"true";
    XCTAssertTrue( [dict boolForKey: key] );
    
    dict[ key ] = @"TRUE";
    XCTAssertTrue( [dict boolForKey: key] );
}

-( void )test_boolForKey_returns_NO_for_strings_meaning_false
{
    dict[ key ] = @"n";
    XCTAssertFalse( [dict boolForKey: key] );
    
    dict[ key ] = @"N";
    XCTAssertFalse( [dict boolForKey: key] );
    
    dict[ key ] = @"no";
    XCTAssertFalse( [dict boolForKey: key] );
    
    dict[ key ] = @"NO";
    XCTAssertFalse( [dict boolForKey: key] );
    
    dict[ key ] = @"f";
    XCTAssertFalse( [dict boolForKey: key] );
    
    dict[ key ] = @"F";
    XCTAssertFalse( [dict boolForKey: key] );
    
    dict[ key ] = @"false";
    XCTAssertFalse( [dict boolForKey: key] );
    
    dict[ key ] = @"FALSE";
    XCTAssertFalse( [dict boolForKey: key] );
}

-( void )test_boolForKey_works_with_non_string_keys
{
     NSNumber *nonStringKey = @666;
    
    dict[ nonStringKey ] = @"no";
    XCTAssertFalse( [dict boolForKey: nonStringKey] );
    
    dict[ nonStringKey ] = @"false";
    XCTAssertFalse( [dict boolForKey: nonStringKey] );
    
    dict[ nonStringKey ] = @"yes";
    XCTAssertTrue( [dict boolForKey: nonStringKey] );
    
    dict[ nonStringKey ] = @"true";
    XCTAssertTrue( [dict boolForKey: nonStringKey] );
    
    dict[ nonStringKey ] = @0;
    XCTAssertFalse( [dict boolForKey: nonStringKey] );
    
    dict[ nonStringKey ] = @1001;
    XCTAssertTrue( [dict boolForKey: nonStringKey] );
}

-( void )test_boolForKey_does_not_follow_key_paths
{
    dict[ @"a" ] = @{ @"b": @"true" };
    XCTAssertFalse( [dict boolForKey: @"a/b"] );
    
    dict[ @"a/b" ] = @"true";
    XCTAssertTrue( [dict boolForKey: @"a/b"] );
    
    dict[ @"a" ] = @[ @{ @"b": @"false" }, @{ @"b": @"true" } ];
    XCTAssertFalse( [dict boolForKey: @"a/1/b"] );
    
    dict[ @"a/1/b" ] = @"true";
    XCTAssertTrue( [dict boolForKey: @"a/1/b"] );
}

#pragma mark - stringForKey: tests

-( void )test_stringForKey_returns_object_string_representation_if_key_exists
{
    dict[ key ] = @1;
    XCTAssertEqualObjects( [dict stringForKey: key], @"1" );
    
    dict[ key ] = @( -1 );
    XCTAssertEqualObjects( [dict stringForKey: key], @"-1" );
    
    dict[ key ] = @"test";
    XCTAssertEqualObjects( [dict stringForKey: key], @"test" );
    
    NSObject *temp = [[NSObject alloc] init];
    dict[ key ] = temp;
    XCTAssertEqualObjects( [dict stringForKey: key], [temp description] );
}

-( void )test_stringForKey_works_with_non_string_keys
{
    NSNumber *nonStringKey = @666;
    
    dict[ nonStringKey ] = @1;
    XCTAssertEqualObjects( [dict stringForKey: nonStringKey], @"1" );
    
    dict[ nonStringKey ] = @( -1 );
    XCTAssertEqualObjects( [dict stringForKey: nonStringKey], @"-1" );
    
    dict[ nonStringKey ] = @"test";
    XCTAssertEqualObjects( [dict stringForKey: nonStringKey], @"test" );
    
    NSObject *temp = [[NSObject alloc] init];
    dict[ nonStringKey ] = temp;
    XCTAssertEqualObjects( [dict stringForKey: nonStringKey], [temp description] );
}

-( void )test_stringForKey_returns_nil_when_key_does_not_exist
{
    XCTAssertNil( [dict stringForKey: @"kjsabdjhbsd"] );
}

-( void )test_stringForKey_returns_nil_when_key_is_nil
{
    XCTAssertNil( [dict stringForKey: nil] );
}

-( void )test_stringForKey_returns_nil_when_object_cannot_be_converted_to_string
{
    dict[ key ] = [NSNull null];
    XCTAssertNil( [dict stringForKey: key] );
}

-( void )test_stringForKey_does_not_follow_key_paths
{
    dict[ @"a" ] = @{ @"b": @"a string" };
    XCTAssertNil( [dict stringForKey: @"a/b"] );

    dict[ @"a/b" ] = @"a string";
    XCTAssertEqualObjects( [dict stringForKey: @"a/b"], @"a string" );
    
    dict[ @"a" ] = @[ @{ @"b": @"a string" }, @{ @"b": @"another string" } ];
    XCTAssertNil( [dict stringForKey: @"a/1/b"] );
    
    dict[ @"a/1/b" ] = @"another string";
    XCTAssertEqualObjects( [dict stringForKey: @"a/1/b"], @"another string" );
}

#pragma mark - arrayForKey: Tests

-( void )test_arrayForKey_returns_array_if_key_exists
{
    dict[ key ] = @[];
    XCTAssertEqualObjects( [dict arrayForKey: key], @[] );
    
    dict[ key ] = @[ @0 ];
    XCTAssertEqualObjects( [dict arrayForKey: key], @[ @0 ] );
    
    dict[ key ] = @[ @0, @1, @2 ];
    NSArray *expected = @[ @0, @1, @2 ];
    XCTAssertEqualObjects( [dict arrayForKey: key], expected );
    
    dict[ key ] = @[ [NSNull null] ];
    XCTAssertEqualObjects( [dict arrayForKey: key], @[ [NSNull null] ] );
}

-( void )test_arrayForKey_works_with_non_string_keys
{
    NSNumber *nonStringKey = @666;
    
    dict[ nonStringKey ] = @[];
    XCTAssertEqualObjects( [dict arrayForKey: nonStringKey], @[] );
    
    dict[ nonStringKey ] = @[ @0 ];
    XCTAssertEqualObjects( [dict arrayForKey: nonStringKey], @[ @0 ] );
    
    dict[ nonStringKey ] = @[ @0, @1, @2 ];
    NSArray *expected = @[ @0, @1, @2 ];
    XCTAssertEqualObjects( [dict arrayForKey: nonStringKey], expected );
    
    dict[ nonStringKey ] = @[ [NSNull null] ];
    XCTAssertEqualObjects( [dict arrayForKey: nonStringKey], @[ [NSNull null] ] );
}

-( void )test_arrayForKey_returns_nil_when_key_does_not_exist
{
    XCTAssertNil( [dict arrayForKey: @"kjsabdjhbsd"] );
}

-( void )test_arrayForKey_returns_nil_when_key_is_nil
{
    XCTAssertNil( [dict arrayForKey: nil] );
}

-( void )test_arrayForKey_returns_nil_when_object_cannot_be_converted_to_array
{
    dict[ key ] = [NSNull null];
    XCTAssertNil( [dict arrayForKey: key] );

    dict[ key ] = @"";
    XCTAssertNil( [dict arrayForKey: key] );
    
    dict[ key ] = @"TMNT Teenage Mutant Ninja Turtles";
    XCTAssertNil( [dict arrayForKey: key] );
                   
    dict[ key ] = @100;
    XCTAssertNil( [dict arrayForKey: key] );

    dict[ key ] = @{};
    XCTAssertNil( [dict arrayForKey: key] );
    
    dict[ key ] = @{ @"0" : @1000 };
    XCTAssertNil( [dict arrayForKey: key] );
}

-( void )test_arrayForKey_does_not_follow_key_paths
{
    dict[ @"a" ] = @{ @"b": @[ @1, @2, @3 ] };
    XCTAssertNil( [dict arrayForKey: @"a/b"] );
    
    dict[ @"a/b" ] = @[ @1, @2, @3 ];
    NSArray *expected = @[ @1, @2, @3 ];
    XCTAssertEqualObjects( [dict arrayForKey: @"a/b"], expected );
    
    dict[ @"a" ] = @[ @{ @"b": @[ @1, @2, @3 ] }, @{ @"b": @[ @4, @5, @6 ] } ];
    XCTAssertNil( [dict arrayForKey: @"a/1/b"] );
    
    dict[ @"a/1/b" ] = @[ @4, @5, @6 ];
    expected = @[ @4, @5, @6 ];
    XCTAssertEqualObjects( [dict arrayForKey: @"a/1/b"], expected );
}

#pragma mark - dictionaryForKey: Tests

-( void )test_dictionaryForKey_returns_dictionary_if_key_exists
{
    dict[ key ] = @{};
    XCTAssertEqualObjects( [dict dictionaryForKey: key], @{} );
    
    dict[ key ] = @{ @"key-0": @0 };
    XCTAssertEqualObjects( [dict dictionaryForKey: key], @{ @"key-0": @0 } );
    
    dict[ key ] = @{ @"key-0": @0,
                     @"key-1": @1,
                     @"key-2": @2 };
    NSDictionary *expected = @{ @"key-0": @0,
                                @"key-1": @1,
                                @"key-2": @2 };
    XCTAssertEqualObjects( [dict dictionaryForKey: key], expected );
    
    dict[ key ] = @{ @"key-0": [NSNull null] };
    XCTAssertEqualObjects( [dict dictionaryForKey: key], @{ @"key-0": [NSNull null] } );
}

-( void )test_dictionaryForKey_works_with_non_string_keys
{
    NSNumber *nonStringKey = @666;
    
    dict[ nonStringKey ] = @{};
    XCTAssertEqualObjects( [dict dictionaryForKey: nonStringKey], @{} );
    
    dict[ nonStringKey ] = @{ @"key-0": @0 };
    XCTAssertEqualObjects( [dict dictionaryForKey: nonStringKey], @{ @"key-0": @0 } );
    
    dict[ nonStringKey ] = @{ @"key-0": @0,
                     @"key-1": @1,
                     @"key-2": @2 };
    NSDictionary *expected = @{ @"key-0": @0,
                                @"key-1": @1,
                                @"key-2": @2 };
    XCTAssertEqualObjects( [dict dictionaryForKey: nonStringKey], expected );
    
    dict[ nonStringKey ] = @{ @"key-0": [NSNull null] };
    XCTAssertEqualObjects( [dict dictionaryForKey: nonStringKey], @{ @"key-0": [NSNull null] } );
}

-( void )test_dictionaryForKey_returns_nil_when_key_does_not_exist
{
    XCTAssertNil( [dict dictionaryForKey: @"kjsabdjhbsd"] );
}

-( void )test_dictionaryForKey_returns_nil_when_key_is_nil
{
    XCTAssertNil( [dict dictionaryForKey: nil] );
}

-( void )test_dictionaryForKey_returns_nil_when_object_cannot_be_converted_to_dictionary
{
    dict[ key ] = [NSNull null];
    XCTAssertNil( [dict dictionaryForKey: key] );

    dict[ key ] = @"";
    XCTAssertNil( [dict dictionaryForKey: key] );
    
    dict[ key ] = @"Samurai Jack";
    XCTAssertNil( [dict dictionaryForKey: key] );
    
    dict[ key ] = @100;
    XCTAssertNil( [dict dictionaryForKey: key] );

    dict[ key ] = @[];
    XCTAssertNil( [dict dictionaryForKey: key] );
    
    dict[ key ] = @[ @0, @1, @2 ];
    XCTAssertNil( [dict dictionaryForKey: key] );
}

-( void )test_dictionaryForKey_does_not_follow_key_paths
{
    dict[ @"a" ] = @{ @"b": @{ @"bla": @6 } };
    XCTAssertNil( [dict dictionaryForKey: @"a/b"] );
    
    dict[ @"a/b" ] = @{ @"b": @6 };
     XCTAssertEqualObjects( [dict dictionaryForKey: @"a/b"], @{ @"b": @6 } );
    
    dict[ @"a" ] = @[ @{ @"b": @{ @"bla": @6 } }, @{ @"b": @{ @"ble": @7 } } ];
    XCTAssertNil( [dict dictionaryForKey: @"a/1/b"] );

    dict[ @"a/1/b" ] = @{ @"b": @7 };
    XCTAssertEqualObjects( [dict dictionaryForKey: @"a/1/b"], @{ @"b": @7 } );
}

#pragma mark - numberForKey: Tests

-( void )test_numberForKey_returns_number_if_key_exists
{
    dict[ key ] = @(-90);
    XCTAssertEqualObjects( [dict numberForKey: key], @(-90) );
    
    dict[ key ] = @5;
    XCTAssertEqualObjects( [dict numberForKey: key], @5 );

    dict[ key ] = @(-8.554);
    XCTAssertEqualObjects( [dict numberForKey: key], @(-8.554) );
    
    dict[ key ] = @3.71;
    XCTAssertEqualObjects( [dict numberForKey: key], @3.71 );
    
    dict[ key ] = @9.76e10;
    XCTAssertEqualObjects( [dict numberForKey: key], @9.76e10 );

    dict[ key ] = @"-90";
    XCTAssertEqualObjects( [dict numberForKey: key], @(-90) );
    
    dict[ key ] = @"5";
    XCTAssertEqualObjects( [dict numberForKey: key], @5 );

    dict[ key ] = @"-8.554";
    XCTAssertEqualObjects( [dict numberForKey: key], @(-8.554) );
    
    dict[ key ] = @"3.71";
    XCTAssertEqualObjects( [dict numberForKey: key], @3.71 );
    
    dict[ key ] = @"9.76e10";
    XCTAssertEqualObjects( [dict numberForKey: key], @9.76e10 );
}

-( void )test_numberForKey_works_with_non_string_keys
{
    NSNumber *nonStringKey = @666;
    
    dict[ nonStringKey ] = @(-90);
    XCTAssertEqualObjects( [dict numberForKey: nonStringKey], @(-90) );
    
    dict[ nonStringKey ] = @5;
    XCTAssertEqualObjects( [dict numberForKey: nonStringKey], @5 );
    
    dict[ nonStringKey ] = @(-8.554);
    XCTAssertEqualObjects( [dict numberForKey: nonStringKey], @(-8.554) );
    
    dict[ nonStringKey ] = @3.71;
    XCTAssertEqualObjects( [dict numberForKey: nonStringKey], @3.71 );
    
    dict[ nonStringKey ] = @9.76e10;
    XCTAssertEqualObjects( [dict numberForKey: nonStringKey], @9.76e10 );
    
    dict[ nonStringKey ] = @"-90";
    XCTAssertEqualObjects( [dict numberForKey: nonStringKey], @(-90) );
    
    dict[ nonStringKey ] = @"5";
    XCTAssertEqualObjects( [dict numberForKey: nonStringKey], @5 );
    
    dict[ nonStringKey ] = @"-8.554";
    XCTAssertEqualObjects( [dict numberForKey: nonStringKey], @(-8.554) );
    
    dict[ nonStringKey ] = @"3.71";
    XCTAssertEqualObjects( [dict numberForKey: nonStringKey], @3.71 );
    
    dict[ nonStringKey ] = @"9.76e10";
    XCTAssertEqualObjects( [dict numberForKey: nonStringKey], @9.76e10 );
}

-( void )test_numberForKey_returns_nil_when_key_does_not_exist
{
    XCTAssertNil( [dict numberForKey: @"kjsabdjhbsd"] );
}

-( void )test_numberForKey_returns_nil_when_key_is_nil
{
    XCTAssertNil( [dict numberForKey: nil] );
}

-( void )test_numberForKey_returns_nil_when_object_cannot_be_converted_to_number
{
    dict[ key ] = [NSNull null];
    XCTAssertNil( [dict numberForKey: key] );

    dict[ key ] = @"";
    XCTAssertNil( [dict numberForKey: key] );
    
    dict[ key ] = @"Swat Katz";
    XCTAssertNil( [dict numberForKey: key] );
    
    dict[ key ] = @{};
    XCTAssertNil( [dict numberForKey: key] );
    
    dict[ key ] = @{ @"key-0": @0 };
    XCTAssertNil( [dict numberForKey: key] );
    
    dict[ key ] = @[];
    XCTAssertNil( [dict numberForKey: key] );
    
    dict[ key ] = @[ @0, @1, @2 ];
    XCTAssertNil( [dict numberForKey: key] );
}

-( void )test_numberForKey_does_not_follow_key_paths
{
    dict[ @"a" ] = @{ @"b": @"9.33" };
    XCTAssertNil( [dict numberForKey: @"a/b"] );
    
    dict[ @"a/b" ] = @"9.33";
    XCTAssertEqualObjects( [dict numberForKey: @"a/b"], @9.33 );
    
    dict[ @"a" ] = @[ @{ @"b": @"7.46" }, @{ @"b": @"7.77" } ];
    XCTAssertNil( [dict numberForKey: @"a/1/b"] );
    
    dict[ @"a/1/b" ] = @"7.77";
    XCTAssertEqualObjects( [dict numberForKey: @"a/1/b"], @7.77 );
}

#pragma mark - dateForKey:withFormatter: Tests

-( void )test_dateForKey_withFormatter_returns_date_if_key_exists
{
    // Before 12:00
    dict[ key ] = @"08/09/1983 08:00";
    NSDate *date = [[NSDictionaryParsingNitroTests dateFormatter] dateFromString: dict[ key ]];
    XCTAssertEqualObjects( [dict dateForKey: key withFormatter:[NSDictionaryParsingNitroTests dateFormatter]], date );

    // After 12:00
    dict[ key ] = @"10/11/2013 13:32";
    date = [[NSDictionaryParsingNitroTests dateFormatter] dateFromString: dict[ key ]];
    XCTAssertEqualObjects( [dict dateForKey: key withFormatter:[NSDictionaryParsingNitroTests dateFormatter]], date );
}

-( void )test_dateForKey_withFormatter_works_with_non_string_keys
{
     NSNumber *nonStringKey = @666;
    
    dict[ nonStringKey ] = [[NSDictionaryParsingNitroTests dateFormatter] dateFromString: @"08/09/1983 08:00"];
    NSDate *date = [[NSDictionaryParsingNitroTests dateFormatter] dateFromString: @"08/09/1983 08:00"];
    XCTAssertEqualObjects( [dict dateForKey: nonStringKey withFormatter:[NSDictionaryParsingNitroTests dateFormatter]], date );
    
    dict[ nonStringKey ] = @"10/11/2013 13:32";
    date = [[NSDictionaryParsingNitroTests dateFormatter] dateFromString: dict[ nonStringKey ]];
    XCTAssertEqualObjects( [dict dateForKey: nonStringKey withFormatter:[NSDictionaryParsingNitroTests dateFormatter]], date );
}

-( void )test_dateForKey_withFormatter_works_with_date_values
{
    dict[ key ] = [[NSDictionaryParsingNitroTests dateFormatter] dateFromString: @"08/09/1983 08:00"];
    NSDate *expected = [[NSDictionaryParsingNitroTests dateFormatter] dateFromString: @"08/09/1983 08:00"];
    
    XCTAssertEqualObjects( [dict dateForKey: key withFormatter: [NSDictionaryParsingNitroTests dateFormatter]], expected );
    
}

-( void )test_dateForKey_withFormatter_returns_nil_when_key_does_not_exist
{
    XCTAssertNil( [dict dateForKey: @"kjsabdjhbsd" withFormatter: [NSDictionaryParsingNitroTests dateFormatter]] );
}

-( void )test_dateForKey_withFormatter_returns_nil_when_key_is_nil
{
    XCTAssertNil( [dict dateForKey: nil withFormatter: [NSDictionaryParsingNitroTests dateFormatter]] );
}

-( void )test_dateForKey_withFormatter_throws_NSInvalidArgumentException_if_dateFormatter_is_nil
{
    dict[ key ] = @"25/10/1984";
    XCTAssertThrowsSpecificNamed( [dict dateForKey: key withFormatter: nil], NSException, NSInvalidArgumentException );
}

-( void )test_dateForKey_withFormatter_returns_nil_when_object_cannot_be_converted_to_date
{
    dict[ key ] = [NSNull null];
    XCTAssertNil( [dict dateForKey: key withFormatter: [NSDictionaryParsingNitroTests dateFormatter]] );
    
    dict[ key ] = @5;
    XCTAssertNil( [dict dateForKey: key withFormatter: [NSDictionaryParsingNitroTests dateFormatter]] );
    
    dict[ key ] = @23.876;
    XCTAssertNil( [dict dateForKey: key withFormatter: [NSDictionaryParsingNitroTests dateFormatter]] );
    
    dict[ key ] = @( -5 );
    XCTAssertNil( [dict dateForKey: key withFormatter: [NSDictionaryParsingNitroTests dateFormatter]] );
    
    dict[ key ] = @( -23.876 );
    XCTAssertNil( [dict dateForKey: key withFormatter: [NSDictionaryParsingNitroTests dateFormatter]] );

    dict[ key ] = @"";
    XCTAssertNil( [dict dateForKey: key withFormatter: [NSDictionaryParsingNitroTests dateFormatter]] );
    
    dict[ key ] = @"Yuyu Hakusho";
    XCTAssertNil( [dict dateForKey: key withFormatter: [NSDictionaryParsingNitroTests dateFormatter]] );
    
    dict[ key ] = @{};
    XCTAssertNil( [dict dateForKey: key withFormatter: [NSDictionaryParsingNitroTests dateFormatter]] );
    
    dict[ key ] = @{ @"key-0": @0 };
    XCTAssertNil( [dict dateForKey: key withFormatter: [NSDictionaryParsingNitroTests dateFormatter]] );
    
    dict[ key ] = @[];
    XCTAssertNil( [dict dateForKey: key withFormatter: [NSDictionaryParsingNitroTests dateFormatter]] );
    
    dict[ key ] = @[ @0, @1, @2 ];
    XCTAssertNil( [dict dateForKey: key withFormatter: [NSDictionaryParsingNitroTests dateFormatter]] );
}

-( void )test_dateForKey_withFormatter_does_not_follow_key_paths
{
    dict[ @"a" ] = @{ @"b": @"13/03/1973 15:32" };
    XCTAssertNil( [dict dateForKey: @"a/b" withFormatter: [NSDictionaryParsingNitroTests dateFormatter]] );
    
    dict[ @"a/b" ] = @"13/03/1973 15:32";
    NSDate *expected = [[NSDictionaryParsingNitroTests dateFormatter] dateFromString: dict[ @"a/b" ]];
    XCTAssertEqualObjects( [dict dateForKey: @"a/b" withFormatter: [NSDictionaryParsingNitroTests dateFormatter]], expected );
    
    dict[ @"a" ] = @[ @{ @"b": @"10/01/1947 01:44" }, @{ @"b": @"23/07/1953 03:17" } ];
    XCTAssertNil( [dict dateForKey: @"a/1/b" withFormatter: [NSDictionaryParsingNitroTests dateFormatter]] );
    
    dict[ @"a/1/b" ] = @"23/07/1953 03:17";
    expected = [[NSDictionaryParsingNitroTests dateFormatter] dateFromString: dict[ @"a/1/b" ]];
    XCTAssertEqualObjects( [dict dateForKey: @"a/1/b" withFormatter: [NSDictionaryParsingNitroTests dateFormatter]], expected );
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































































