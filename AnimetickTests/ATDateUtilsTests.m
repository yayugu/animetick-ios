//
//  ATDateUtilsTests.m
//  Animetick
//
//  Created by yayugu on 2013/09/28.
//  Copyright (c) 2013年 yayugu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ATDateUtils.h"
#import "NSDate+ATAdditions.h"

@interface ATDateUtilsTests : XCTestCase

@end

@implementation ATDateUtilsTests

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

- (void)testDaysDifferenceConsiderMidnight
{
    NSDate *now, *animeStart;
    
    // same
    now        = [NSDate dateWithATDateFormatString:@"2011-01-21T12:26:47+09:00"];
    animeStart = [NSDate dateWithATDateFormatString:@"2011-01-21T12:26:47+09:00"];
    XCTAssertEqual(0, [ATDateUtils daysDifferenceConsiderMidnight:now with:animeStart]);
    
    // same day
    now        = [NSDate dateWithATDateFormatString:@"2011-01-21T12:26:47+09:00"];
    animeStart = [NSDate dateWithATDateFormatString:@"2011-01-21T23:26:47+09:00"];
    XCTAssertEqual(0, [ATDateUtils daysDifferenceConsiderMidnight:now with:animeStart]);
    
    // next day midnight
    now        = [NSDate dateWithATDateFormatString:@"2011-01-21T12:26:47+09:00"];
    animeStart = [NSDate dateWithATDateFormatString:@"2011-01-22T03:26:47+09:00"];
    XCTAssertEqual(0, [ATDateUtils daysDifferenceConsiderMidnight:now with:animeStart]);
    
    // same day midnight
    now        = [NSDate dateWithATDateFormatString:@"2011-01-21T12:26:47+09:00"];
    animeStart = [NSDate dateWithATDateFormatString:@"2011-01-21T03:26:47+09:00"];
    XCTAssertEqual(-1, [ATDateUtils daysDifferenceConsiderMidnight:now with:animeStart]);
    
    // 2 days after midnight
    now        = [NSDate dateWithATDateFormatString:@"2011-01-21T12:26:47+09:00"];
    animeStart = [NSDate dateWithATDateFormatString:@"2011-01-23T03:26:47+09:00"];
    XCTAssertEqual(1, [ATDateUtils daysDifferenceConsiderMidnight:now with:animeStart]);
}

@end
