@interface NSDate (ATAdditions)

+ dateWithATDateFormatString:(NSString*)dateString;
- (BOOL)isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;

@end
