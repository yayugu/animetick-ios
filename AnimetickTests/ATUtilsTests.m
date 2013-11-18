//
//  ATUtilsTests.m
//  Animetick
//
//  Created by Yuya Yaguchi on 11/18/13.
//  Copyright (c) 2013 yayugu. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface ATUtilsTests : XCTestCase

@end

@implementation ATUtilsTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testNSNullToNil
{
    id value = [NSArray array];
    XCTAssertEqual(value, NSNullToNil(value));
    
    id nNull = [NSNull null];
    XCTAssertEqual((id)nil, NSNullToNil(nNull));
    
    XCTAssertEqual((id)nil, NSNullToNil(nil));
}

@end
