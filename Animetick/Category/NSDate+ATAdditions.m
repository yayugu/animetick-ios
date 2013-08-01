//
//  NSDate+ATDateFormat.m
//  Animetick
//
//  Created by Yuya Yaguchi on 7/31/13.
//  Copyright (c) 2013 Kazuki Akamine. All rights reserved.
//

#import "NSDate+ATAdditions.h"

@implementation NSDate (ATAdditions)

//
// example: 2011-01-21T12:26:47-05:00
//
+ dateWithATDateFormatString:(NSString*)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

@end