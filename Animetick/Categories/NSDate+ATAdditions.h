@interface NSDate (ATAdditions)

+ dateWithATDateFormatString:(NSString*)dateString;
- (BOOL)isEalryThanDate:(NSDate*)date;
- (BOOL)isLaterThanDate:(NSDate*)date;
- (BOOL)isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;

@end
