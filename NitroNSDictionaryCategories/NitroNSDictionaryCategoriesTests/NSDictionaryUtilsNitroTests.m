//
//  NitroNSDictionaryCategoriesTests.m
//  NitroNSDictionaryCategoriesTests
//
//  Created by Daniel L. Alves on 28/5/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import <XCTest/XCTest.h>

// nitro
#import "NSDictionary+Parsing_Nitro.h"
#import "NSDictionary+Utils_Nitro.h"

// c
#import <float.h>
#import <stdint.h>
#import <limits.h>

// ios
#import <UIKit/UIKit.h>

#pragma mark - Defines

#define STRINGIFY( x ) #x
#define NSSTRINGIFY( x ) @"" STRINGIFY( x ) ""
#define RESOLVE_PARENTHESES_ISSUE_AND_NSTRINGIFY( f, x ) [NSString stringWithFormat: f, x ]

#define SECONDS_IN_HOUR ( 60 * 60 )
#define BRASILIA_GMT_SECS ( -3 * SECONDS_IN_HOUR )

#pragma mark - Assert Helpers

#define XCTAssertValidPlist( plist ) [self assertValidPlistForAllFormats: plist]

#pragma mark - Interface

@interface NitroNSDictionaryCategoriesTests : XCTestCase
{
    NSString *key;
    NSMutableDictionary *dict;
}
@end

#pragma mark - Implementation

@implementation NitroNSDictionaryCategoriesTests

#pragma mark - Tests lifecycle

-( void )setUp
{
    key = @"key";
    dict = [[NSMutableDictionary alloc] init];
}

#pragma mark - boolForKey tests

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

#pragma mark - stringForKey tests

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

#pragma mark - arrayForKey Tests

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

#pragma mark - dictionaryForKey Tests

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

#pragma mark - numberForKey Tests

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
    NSDate *date = [[NitroNSDictionaryCategoriesTests dateFormatter] dateFromString: dict[ key ]];
    XCTAssertEqualObjects( [dict dateForKey: key withFormatter:[NitroNSDictionaryCategoriesTests dateFormatter]], date );

    // After 12:00
    dict[ key ] = @"10/11/2013 13:32";
    date = [[NitroNSDictionaryCategoriesTests dateFormatter] dateFromString: dict[ key ]];
    XCTAssertEqualObjects( [dict dateForKey: key withFormatter:[NitroNSDictionaryCategoriesTests dateFormatter]], date );
}

-( void )test_dateForKey_withFormatter_works_with_non_string_keys
{
     NSNumber *nonStringKey = @666;
    
    dict[ nonStringKey ] = [[NitroNSDictionaryCategoriesTests dateFormatter] dateFromString: @"08/09/1983 08:00"];
    NSDate *date = [[NitroNSDictionaryCategoriesTests dateFormatter] dateFromString: @"08/09/1983 08:00"];
    XCTAssertEqualObjects( [dict dateForKey: nonStringKey withFormatter:[NitroNSDictionaryCategoriesTests dateFormatter]], date );
    
    dict[ nonStringKey ] = @"10/11/2013 13:32";
    date = [[NitroNSDictionaryCategoriesTests dateFormatter] dateFromString: dict[ nonStringKey ]];
    XCTAssertEqualObjects( [dict dateForKey: nonStringKey withFormatter:[NitroNSDictionaryCategoriesTests dateFormatter]], date );
}

-( void )test_dateForKey_withFormatter_works_with_date_values
{
    dict[ key ] = [[NitroNSDictionaryCategoriesTests dateFormatter] dateFromString: @"08/09/1983 08:00"];
    NSDate *expected = [[NitroNSDictionaryCategoriesTests dateFormatter] dateFromString: @"08/09/1983 08:00"];
    
    XCTAssertEqualObjects( [dict dateForKey: key withFormatter: [NitroNSDictionaryCategoriesTests dateFormatter]], expected );
    
}

-( void )test_dateForKey_withFormatter_returns_nil_when_key_does_not_exist
{
    XCTAssertNil( [dict dateForKey: @"kjsabdjhbsd" withFormatter: [NitroNSDictionaryCategoriesTests dateFormatter]] );
}

-( void )test_dateForKey_withFormatter_returns_nil_when_key_is_nil
{
    XCTAssertNil( [dict dateForKey: nil withFormatter: [NitroNSDictionaryCategoriesTests dateFormatter]] );
}

-( void )test_dateForKey_withFormatter_throws_NSInvalidArgumentException_if_dateFormatter_is_nil
{
    dict[ key ] = @"25/10/1984";
    XCTAssertThrowsSpecificNamed( [dict dateForKey: key withFormatter: nil], NSException, NSInvalidArgumentException );
}

-( void )test_dateForKey_withFormatter_returns_nil_when_object_cannot_be_converted_to_date
{
    dict[ key ] = [NSNull null];
    XCTAssertNil( [dict dateForKey: key withFormatter: [NitroNSDictionaryCategoriesTests dateFormatter]] );
    
    dict[ key ] = @5;
    XCTAssertNil( [dict dateForKey: key withFormatter: [NitroNSDictionaryCategoriesTests dateFormatter]] );
    
    dict[ key ] = @23.876;
    XCTAssertNil( [dict dateForKey: key withFormatter: [NitroNSDictionaryCategoriesTests dateFormatter]] );
    
    dict[ key ] = @( -5 );
    XCTAssertNil( [dict dateForKey: key withFormatter: [NitroNSDictionaryCategoriesTests dateFormatter]] );
    
    dict[ key ] = @( -23.876 );
    XCTAssertNil( [dict dateForKey: key withFormatter: [NitroNSDictionaryCategoriesTests dateFormatter]] );

    dict[ key ] = @"";
    XCTAssertNil( [dict dateForKey: key withFormatter: [NitroNSDictionaryCategoriesTests dateFormatter]] );
    
    dict[ key ] = @"Yuyu Hakusho";
    XCTAssertNil( [dict dateForKey: key withFormatter: [NitroNSDictionaryCategoriesTests dateFormatter]] );
    
    dict[ key ] = @{};
    XCTAssertNil( [dict dateForKey: key withFormatter: [NitroNSDictionaryCategoriesTests dateFormatter]] );
    
    dict[ key ] = @{ @"key-0": @0 };
    XCTAssertNil( [dict dateForKey: key withFormatter: [NitroNSDictionaryCategoriesTests dateFormatter]] );
    
    dict[ key ] = @[];
    XCTAssertNil( [dict dateForKey: key withFormatter: [NitroNSDictionaryCategoriesTests dateFormatter]] );
    
    dict[ key ] = @[ @0, @1, @2 ];
    XCTAssertNil( [dict dateForKey: key withFormatter: [NitroNSDictionaryCategoriesTests dateFormatter]] );
}

-( void )test_dateForKey_withFormatter_does_not_follow_key_paths
{
    dict[ @"a" ] = @{ @"b": @"13/03/1973 15:32" };
    XCTAssertNil( [dict dateForKey: @"a/b" withFormatter: [NitroNSDictionaryCategoriesTests dateFormatter]] );
    
    dict[ @"a/b" ] = @"13/03/1973 15:32";
    NSDate *expected = [[NitroNSDictionaryCategoriesTests dateFormatter] dateFromString: dict[ @"a/b" ]];
    XCTAssertEqualObjects( [dict dateForKey: @"a/b" withFormatter: [NitroNSDictionaryCategoriesTests dateFormatter]], expected );
    
    dict[ @"a" ] = @[ @{ @"b": @"10/01/1947 01:44" }, @{ @"b": @"23/07/1953 03:17" } ];
    XCTAssertNil( [dict dateForKey: @"a/1/b" withFormatter: [NitroNSDictionaryCategoriesTests dateFormatter]] );
    
    dict[ @"a/1/b" ] = @"23/07/1953 03:17";
    expected = [[NitroNSDictionaryCategoriesTests dateFormatter] dateFromString: dict[ @"a/1/b" ]];
    XCTAssertEqualObjects( [dict dateForKey: @"a/1/b" withFormatter: [NitroNSDictionaryCategoriesTests dateFormatter]], expected );
}

#pragma mark - hasKey tests

-( void )test_hasKey_returns_YES_if_contains_key
{
    dict[ key ] = @"A value";
    XCTAssertTrue( [dict hasKey: key] );
}

-( void )test_hasKey_returns_NO_if_does_not_contain_key
{
    XCTAssertFalse( [dict hasKey: @"jkasbdjksbd"] );
}

-( void )test_hasKey_returns_NO_on_nil_keys
{
    XCTAssertFalse( [dict hasKey: nil] );
}

#pragma mark - keyForObject tests

-( void )test_keyForObject_returns_object_key_if_object_in_dictionary
{
    NSString *test1 = @"test1";

    dict[ key ] = test1;
    
    XCTAssertEqualObjects( [dict keyForObject: test1], key );
}

-( void )test_keyForObject_returns_object_key_only_if_objects_have_the_same_address
{
    NSString *test1 = @"test1";
    NSString *test2 = [NSMutableString stringWithString: test1];
    NSString *test3 = [NSString stringWithFormat: @"%@", @"test1"];
    
    dict[ key ] = test1;
    
    XCTAssertNotNil( [dict keyForObject: test1] );
    XCTAssertNil( [dict keyForObject: test2] );
    XCTAssertNil( [dict keyForObject: test3] );
}

-( void )test_keyForObject_returns_nil_if_object_is_nil
{
    XCTAssertNil( [dict keyForObject: nil] );
    
    dict[ key ] = @"test";
    XCTAssertNil( [dict keyForObject: nil] );
}

-( void )test_keyForObject_returns_nil_if_object_is_not_in_the_dictionary
{
    NSString *test1 = @"test1";
    NSString *test2 = @"test2";
    
    dict[ key ] = test1;
    
    XCTAssertNil( [dict keyForObject: test2] );
}

#pragma mark - toPropertyList tests

-( void )test_toPropertyListCompliantDictionary_keeps_NSArray_objects_unchanged
{
    dict[ key ] = @[ @1, @2, @3 ];
    
    XCTAssertTrue( [(( NSObject * )dict[ key ]) isKindOfClass: [NSArray class]] );
    
    NSDictionary *plistDict = [dict toPropertyListCompliantDictionary];
    
    XCTAssertEqual( (( NSObject * )plistDict[ key ]).class, (( NSObject * )dict[ key ]).class );
    XCTAssertTrue( [dict[ key ] isEqualToArray: plistDict[key]] );
    XCTAssertValidPlist( plistDict );
}

-( void )test_toPropertyListCompliantDictionary_keeps_NSDictionary_objects
{
    dict[ key ] = @{ @"a": @1, @"b": @2, @"c": @3 };
    
    XCTAssertTrue( [(( NSObject * )dict[ key ]) isKindOfClass: [NSDictionary class]] );
    
    NSDictionary *plistDict = [dict toPropertyListCompliantDictionary];
    
    // Since we recursively parse dictionaries, these objects will be converted to
    // property list compliant dictionaries. So it's possible for them to change classes. Hence
    // we use isKindOfClass: instead of the equality operator
    XCTAssertTrue( [(( NSObject * )plistDict[ key ]) isKindOfClass: [NSDictionary class]] );
    XCTAssertTrue( [dict[ key ] isEqualToDictionary: plistDict[key]] );
    XCTAssertValidPlist( plistDict );
}

-( void )test_toPropertyListCompliantDictionary_keeps_NSString_objects_unchanged
{
    dict[ key ] = @"test";
    
    XCTAssertTrue( [(( NSObject * )dict[ key ]) isKindOfClass: [NSString class]] );
    
    NSDictionary *plistDict = [dict toPropertyListCompliantDictionary];
    
    XCTAssertEqual( (( NSObject * )plistDict[ key ]).class, (( NSObject * )dict[ key ]).class );
    XCTAssertTrue( [dict[ key ] isEqualToString: plistDict[key]] );
    XCTAssertValidPlist( plistDict );
}

-( void )test_toPropertyListCompliantDictionary_keeps_NSData_objects_unchanged
{
    const uint8_t data[] = { 0xFF, 0xDB, 0x43, 0x00 };
    dict[ key ] = [NSData dataWithBytes: data length: 4];
    
    XCTAssertTrue( [(( NSObject * )dict[ key ]) isKindOfClass: [NSData class]] );
    
    NSDictionary *plistDict = [dict toPropertyListCompliantDictionary];
    
    XCTAssertEqual( (( NSObject * )plistDict[ key ]).class, (( NSObject * )dict[ key ]).class );
    XCTAssertTrue( [dict[ key ] isEqualToData: plistDict[key]] );
    XCTAssertValidPlist( plistDict );
}

-( void )test_toPropertyListCompliantDictionary_keeps_NSDate_objects_unchanged
{
    dict[ key ] = [NSDate date];
    
    XCTAssertTrue( [(( NSObject * )dict[ key ]) isKindOfClass: [NSDate class]] );
    
    NSDictionary *plistDict = [dict toPropertyListCompliantDictionary];
    
    XCTAssertEqual( (( NSObject * )plistDict[ key ]).class, (( NSObject * )dict[ key ]).class );
    XCTAssertTrue( [dict[ key ] isEqualToDate: plistDict[key]] );
    XCTAssertValidPlist( plistDict );
}

-( void )test_toPropertyListCompliantDictionary_keeps_NSNumber_objects_holding_ints_unchanged
{
    dict[ key ] = [NSNumber numberWithInt: 10];
    
    XCTAssertTrue( [(( NSObject * )dict[ key ]) isKindOfClass: [NSNumber class]] );
    XCTAssertEqual( strcmp( (( NSNumber * )dict[ key ]).objCType, "i" ), 0 );
    
    NSDictionary *plistDict = [dict toPropertyListCompliantDictionary];
    
    XCTAssertEqual( (( NSObject * )plistDict[ key ]).class, (( NSObject * )dict[ key ]).class );
    XCTAssertTrue( [dict[ key ] isEqualToNumber: plistDict[key]] );
    XCTAssertValidPlist( plistDict );
}

-( void )test_toPropertyListCompliantDictionary_keeps_NSNumber_objects_holding_floats_unchanged
{
    dict[ key ] = [NSNumber numberWithDouble: 10.0];
    
    XCTAssertTrue( [(( NSObject * )dict[ key ]) isKindOfClass: [NSNumber class]] );
    XCTAssertEqual( strcmp( (( NSNumber * )dict[ key ]).objCType, "d" ), 0 );
    
    NSDictionary *plistDict = [dict toPropertyListCompliantDictionary];
    
    XCTAssertEqual( (( NSObject * )plistDict[ key ]).class, (( NSObject * )dict[ key ]).class );
    XCTAssertTrue( [dict[ key ] isEqualToNumber: plistDict[key]] );
    XCTAssertValidPlist( plistDict );
}

-( void )test_toPropertyListCompliantDictionary_keeps_NSNumber_objects_holding_bools_unchanged
{
    dict[ key ] = [NSNumber numberWithBool: YES];

    XCTAssertTrue( [(( NSObject * )dict[ key ]) isKindOfClass: [NSNumber class]] );
    XCTAssertEqual( strcmp( (( NSNumber * )dict[ key ]).objCType, "c" ), 0 );
    
    NSDictionary *plistDict = [dict toPropertyListCompliantDictionary];
    
    XCTAssertEqual( (( NSObject * )plistDict[ key ]).class, (( NSObject * )dict[ key ]).class );
    XCTAssertTrue( [dict[ key ] isEqualToNumber: plistDict[key]] );
    XCTAssertValidPlist( plistDict );
}

-( void )test_toPropertyListCompliantDictionary_keeps_objects_conforming_to_NSCoding_protocol_as_NSData
{
    dict[ key ] = [NSSet setWithArray: @[ @1, @2, @3 ]];
    NSDictionary *plistDict = [dict toPropertyListCompliantDictionary];

    XCTAssertTrue( [(( NSObject * )plistDict[ key ]) isKindOfClass: [NSData class]] );
    XCTAssertValidPlist( plistDict );
    
    dict[ key ] = [NSMapTable strongToStrongObjectsMapTable];
    plistDict = [dict toPropertyListCompliantDictionary];
    
    XCTAssertTrue( [(( NSObject * )plistDict[ key ]) isKindOfClass: [NSData class]] );
    XCTAssertValidPlist( plistDict );
    
    dict[ key ] = [UIColor blackColor];
    plistDict = [dict toPropertyListCompliantDictionary];
    
    XCTAssertTrue( [(( NSObject * )plistDict[ key ]) isKindOfClass: [NSData class]] );
    XCTAssertValidPlist( plistDict );
    
    dict[ key ] = [[UIView alloc] initWithFrame: CGRectMake( 0.0f, 0.0f, 200.0f, 200.0f )];
    plistDict = [dict toPropertyListCompliantDictionary];
    
    XCTAssertTrue( [(( NSObject * )plistDict[ key ]) isKindOfClass: [NSData class]] );
    XCTAssertValidPlist( plistDict );
}

-( void )test_toPropertyListCompliantDictionary_removes_not_compliant_objects
{
    dict[ key ] = [NSNull null];
    NSDictionary *plistDict = [dict toPropertyListCompliantDictionary];
    
    XCTAssertEqual( plistDict.count, 0 );
    XCTAssertValidPlist( plistDict );
    
    dict[ key ] = [NSObject new];
    plistDict = [dict toPropertyListCompliantDictionary];
    
    XCTAssertEqual( plistDict.count, 0 );
    XCTAssertValidPlist( plistDict );
    
    dict[ key ] = [UIFont fontWithName: @"Helvetica" size: 20];
    plistDict = [dict toPropertyListCompliantDictionary];
    
    XCTAssertEqual( plistDict.count, 0 );
    XCTAssertValidPlist( plistDict );
}

#pragma mark - getFirstNonNullValueOfKeys Tests

-( void )test_getFirstNonNullValueOfKeys_returns_first_non_null_value
{
    dict[ @"0" ] = [NSNull null];
    dict[ @"1" ] = [NSNull null];
    dict[ @"2" ] = @"Hello";
    dict[ @"3" ] = @"World";
    dict[ @"4" ] = [NSNull null];
    dict[ @"5" ] = @"!!!";
    
    for( int i = 0 ; i < 2 ; ++i )
    {
        NSString *object = [dict getFirstNonNullValueOfKeys: @"0", @"1", @"3", nil];
        XCTAssertEqualObjects( object, @"World" );
        
        [dict removeObjectForKey: [NSString stringWithFormat: @"%d", i]];
    }
}

-( void )test_getFirstNonNullValueOfKeys_returns_nil_if_dictionary_is_empty
{
    id obj = [dict getFirstNonNullValueOfKeys: @"first name", @"full name", nil];
    XCTAssertNil( obj );
}

-( void )test_getFirstNonNullValueOfKeys_returns_nil_if_all_keys_contain_null_objects
{
    dict[ @"0" ] = [NSNull null];
    dict[ @"1" ] = [NSNull null];
    dict[ @"2" ] = [NSNull null];
    
    id obj = [dict getFirstNonNullValueOfKeys: @"0", @"1", @"2", nil];
    XCTAssertNil( obj );
}

#pragma mark - getFirstNonNullValueOfKeysAsString Tests

-( void )test_getFirstNonNullValueOfKeysAsString_returns_first_non_null_value_as_a_string
{
    dict[ @"0" ] = [NSNull null];
    dict[ @"1" ] = [NSNull null];
    dict[ @"2" ] = @5;
    dict[ @"3" ] = @55;
    dict[ @"4" ] = [NSNull null];
    dict[ @"5" ] = @555;
    
    for( int i = 0 ; i < 2 ; ++i )
    {
        NSString *object = [dict getFirstNonNullValueOfKeysAsString: @"0", @"1", @"3", nil];
        XCTAssertEqualObjects( object, @"55" );
        XCTAssertEqualObjects( dict[ @"3" ], @55 );
        
        [dict removeObjectForKey: [NSString stringWithFormat: @"%d", i]];
    }
}

-( void )test_getFirstNonNullValueOfKeysAsString_returns_nil_if_dictionary_is_empty
{
    id obj = [dict getFirstNonNullValueOfKeysAsString: @"first name", @"full name", nil];
    XCTAssertNil( obj );
}

-( void )test_getFirstNonNullValueOfKeysAsString_returns_nil_if_all_keys_contain_null_objects
{
    dict[ @"0" ] = [NSNull null];
    dict[ @"1" ] = [NSNull null];
    dict[ @"2" ] = [NSNull null];
    
    id obj = [dict getFirstNonNullValueOfKeysAsString: @"0", @"1", @"2", nil];
    XCTAssertNil( obj );
}

#pragma mark - Helpers
    
-( void )assertValidPlistForAllFormats:( id )plist
{
    // We'll not test NSPropertyListOpenStepFormat
    // From the docs:
    // "The NSPropertyListOpenStepFormat constant is not supported for writing. It can be used only for reading old-style property lists."
//    XCTAssertTrue( [NSPropertyListSerialization propertyList: plist isValidForFormat: NSPropertyListOpenStepFormat] );
    XCTAssertTrue( [NSPropertyListSerialization propertyList: plist isValidForFormat: NSPropertyListXMLFormat_v1_0] );
    XCTAssertTrue( [NSPropertyListSerialization propertyList: plist isValidForFormat: NSPropertyListBinaryFormat_v1_0] );
}

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































































