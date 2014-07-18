NitroNSDictionaryCategories
===========================
[![Cocoapods](https://cocoapod-badges.herokuapp.com/v/NitroNSDictionaryCategories/badge.png)](http://cocoapods.org/?q=NitroNSDictionaryCategories)
[![Platform](http://cocoapod-badges.herokuapp.com/p/NitroNSDictionaryCategories/badge.png)](http://cocoadocs.org/docsets/NitroNSDictionaryCategories)
[![TravisCI](https://travis-ci.org/danielalves/NitroNSDictionaryCategories.svg?branch=master)](https://travis-ci.org/danielalves/NitroNSDictionaryCategories)

**NitroNSDictionaryCategories** offers parsing and utility categories for iOS `NSDictionary` type.

Parsing methods try to parse specifc types from dictionary values. If a value cannot be parsed, methods return nil, so there's a kind of type safety. These methods come in two flavors: the ones which handle `key` as a final value and the ones which handle `key` as a key path.

Following a key path is a powerful functionality which lets the user traverse nested dictionaries and arrays with a single command. For example, lets say we have this structure:

```objc
NSDictionary *backpack = @{ @"items": @[
   // Items 0 - 4
   // ...
   @{
       @"type": @"sword",
       @"name": @"Ultra Lightning Sword of Slashing",
       @"description": @"It slashes and shocks!",
       @"properties": @[
           @{
               @"name": @"lightning",
               @"bonus-damage": @150
           },
           // Other properties
           // ...
       ]
   },
   // Other items
   // ...
]}
```

We would parse the lightning bonus damage of Ultra Lightning Sword of Slashing with a single call:
 
```objc
NSNumber *damage = [backpack numberForKeyPath: @"items/5/properties/0/bonus-damage"];
```

**Available parsing methods are:**

- `boolForKey:`: Tries to parse a boolean from the value referenced by key. It supports numeric values and strings.
- `stringForKey:`: Returns the string representation of the value referenced by key.
- `arrayForKey:`: Tries to parse an array from the value referenced by key.
- `dictionaryForKey:`: Tries to parse a dictionary from the value referenced by key.
- `numberForKey:`: Tries to parse a number from the value referenced by key.
- `dateForKey:withFormatter:`: Tries to parse a date from the value referenced by key.
- `boolForKeyPath:`: The same as `boolForKey:`, but handles `key` as a key path.
- `stringForKeyPath:`: The same as `stringForKey:`, but handles `key` as a key path.
- `arrayForKeyPath:`: The same as `arrayForKey:`, but handles `key` as a key path.
- `dictionaryForKeyPath:`: The same as `dictionaryForKey:`, but handles `key` as a key path.
- `numberForKeyPath:`: The same as `numberForKey:`, but handles `key` as a key path.
- `dateForKeyPath:withFormatter:`: The same as `dateForKey:withFormatter:`, but handles `key` as a key path.

**Utility methods are:**

- `toPropertyListCompliantDictionary`: Recursively creates a new dictionary which is property list compliant.
- `hasKey:`: Returns if the dictionary contains the specified key.
- `keyForObject:`: Returns the key of a given object contained in the dictionary.
- `getFirstNonNullValueOfKeys:`: Searches the dictionary for the first object which is not nil and not equal to NSNull.

Requirements
------------

iOS 4.3 or higher, ARC only

Installation
------------

**NitroNSDictionaryCategories** is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

```ruby
pod "NitroNSDictionaryCategories"
```

**NitroNSDictionaryCategories** adds the `-ObjC` linker flag to targets using it. Without it, categories code would be stripped out, resulting in linker errors. For more info about categories inside static libraries, see: [Building Objective-C static libraries with categories](https://developer.apple.com/library/mac/qa/qa1490/_index.html)

Author
------

- [Daniel L. Alves](http://github.com/danielalves) ([@alveslopesdan](https://twitter.com/alveslopesdan))

License
-------

**NitroNSDictionaryCategories** is available under the MIT license. See the LICENSE file for more info.
