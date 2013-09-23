#import "NSDate+ATAdditions.h"

@implementation NSDate (ATAdditions)

//
// example: 2011-01-21T12:26:47+09:00
//
+ dateWithATDateFormatString:(NSString*)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

@end
