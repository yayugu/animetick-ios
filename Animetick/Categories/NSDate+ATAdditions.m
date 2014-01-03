#import "NSDate+ATAdditions.h"

@implementation NSDate (ATAdditions)

//
// example: 2011-01-21T12:26:47+09:00
//
+ dateWithATDateFormatString:(NSString*)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

- (BOOL)isEalryThanDate:(NSDate*)date
{
    return [self compare:date] == NSOrderedAscending;
}

- (BOOL)isLaterThanDate:(NSDate*)date
{
    return [self compare:date] == NSOrderedDescending;
}

- (BOOL)isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    return
        beginDate != nil &&
        endDate != nil &&
        [self compare:beginDate] != NSOrderedAscending &&
        [self compare:endDate] != NSOrderedDescending;
}

@end
