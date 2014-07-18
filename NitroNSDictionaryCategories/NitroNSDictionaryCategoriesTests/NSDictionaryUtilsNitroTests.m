//
//  NSDictionaryUtilsNitroTests.m
//  NitroNSDictionaryCategoriesTests
//
//  Created by Daniel L. Alves on 28/05/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

#import <XCTest/XCTest.h>

// ios
#import <UIKit/UIKit.h>

// NitroNSDictionaryCategories
#import "NSDictionary+Utils_Nitro.h"

#pragma mark - Assert Helpers

#define XCTAssertValidPlist( plist ) [self assertValidPlistForAllFormats: plist]

#pragma mark - Interface

@interface NSDictionaryUtilsNitroTests : XCTestCase
{
    NSString *key;
    NSMutableDictionary *dict;
}
@end

#pragma mark - Implementation

@implementation NSDictionaryUtilsNitroTests

#pragma mark - Tests lifecycle

-( void )setUp
{
    key = @"key";
    dict = [[NSMutableDictionary alloc] init];
}

#pragma mark - hasKey: tests

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

#pragma mark - keyForObject: tests

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

#pragma mark - getFirstNonNullValueOfKeys: Tests

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

#pragma mark - getFirstNonNullValueOfKeysAsString: Tests

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

@end































































