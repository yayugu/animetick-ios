#import "ATTicket.h"
#import "NSDate+ATAdditions.h"
#import "ATAPI.h"
#import "ATDateUtils.h"

// FIXME: 本当にviewを呼んでしまっていいのかよくよくかんがえる
#import "ATAlertView.h"

@implementation ATTicket

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        [self assignValuesWithDictionary:dictionary];
    }
    return self;
}

- (NSUInteger)hash
{
    return (NSUInteger)self.titleId ^ self.title.hash ^ self.startAt.hash ^ self.chName.hash;
}

- (NSString*)hashString
{
    return [NSString stringWithFormat:@"%lu", (unsigned long)[self hash]];
}

- (void)assignValuesWithDictionary:(NSDictionary*)dic
{
    self.titleId = [(NSNumber*)NSNullToNil(dic[@"title_id"]) intValue];
    self.count = [(NSNumber*)NSNullToNil(dic[@"count"]) intValue];
    self.title = NSNullToNil(dic[@"title"]);
    self.iconPath = NSNullToNil(dic[@"icon_path"]);
    self.subTitle = NSNullToNil(dic[@"sub_title"]);
    
    NSString *startAt = NSNullToNil(dic[@"start_at"]);
    self.startAt = startAt ? [NSDate dateWithATDateFormatString:startAt] : nil;
    NSString *endAt = NSNullToNil(dic[@"end_at"]);
    self.endAt = endAt ? [NSDate dateWithATDateFormatString:endAt] : nil;
    
    self.chName = NSNullToNil(dic[@"ch_name"]);
    self.chNumber = [(NSNumber*)NSNullToNil(dic[@"chNumber"]) intValue];
    
    NSNumber *watched = NSNullToNil(dic[@"watched"]);
    self.watched = watched ? [watched boolValue] : NO;
    
    [self createSectionTextAndHash];
}

- (NSURL*)iconURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ATAnimetickURLString, self.iconPath]];
}

- (NSString*)titleWithEpisodeNumberText
{
    return [NSString stringWithFormat:@"%@ #%d",
            (self.title ? self.title : @""),
            self.count];
}

- (NSString*)subTitleText
{
    return self.subTitle ? self.subTitle : @"";
}

- (NSString*)episondeNumberWithSubTitle
{
    return [NSString stringWithFormat:@"#%d %@", self.count, self.subTitle];
}

- (NSString*)channelText
{
    return
        (self.chName && self.chNumber)
            ? [NSString stringWithFormat:@"%@ / %dch", self.chName, self.chNumber]
        :(self.chName)
            ? self.chName
            : @"";
}

- (NSString*)startAtText
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    formatter.dateFormat = @"MM/dd HH:mm〜";
    return
        self.startAt
            ? [formatter stringFromDate:self.startAt]
            : @"";
}

- (void)createSectionTextAndHash
{
    NSDate *date = [NSDate date];
    
    NSInteger daysDifference = [ATDateUtils daysDifferenceConsiderMidnight:date with:self.startAt];
    if (daysDifference > 1) {
        _nearDateText = @"";
        _sectionHash = @"before more than 1 day".hash;
    } else if (daysDifference == 1) {
        if ([date isEalryThanDate:_startAt]) {
            _nearDateText = @"明日";
            _sectionHash = @"1 day after / before start".hash;
        } else if ([date isLaterThanDate:_endAt]) {
            _nearDateText = @"明日";
            _sectionHash = @"1 day after / after end".hash;
        } else {
            _nearDateText = @"放送中";
            _sectionHash = @"on air".hash;
        }
    } else if (daysDifference == 0) {
        if ([date isEalryThanDate:_startAt]) {
            _nearDateText = @"今晩";
            _sectionHash = @"today / before start".hash;
        } else if ([date isLaterThanDate:_endAt]) {
            _nearDateText = @"今晩";
            _sectionHash = @"today / after end".hash;
        } else {
            _nearDateText = @"放送中";
            _sectionHash = @"on air".hash;
        }
    } else if (daysDifference == -1) {
        if ([date isEalryThanDate:_startAt]) {
            _nearDateText = @"昨晩";
            _sectionHash = @"1 day before / before start".hash;
        } else if ([date isLaterThanDate:_endAt]) {
            _nearDateText = @"昨晩";
            _sectionHash = @"1 day before / after end".hash;
        } else {
            _nearDateText = @"放送中";
            _sectionHash = @"on air".hash;
        }
    } else {
        _nearDateText = @"";
        _sectionHash = @"after more than 1 day".hash;
    }
}

- (void)watch
{
    self.watched = YES;
    [ATAPI postTicketWatchWithTitleId:self.titleId episodeCount:self.count completion:^(NSDictionary *dictionary, NSError *error) {
        if (error || [dictionary[@"success"] intValue] == 0) {
            ATAlertView *alertView = [[ATAlertView alloc] initWithTitle:@"送信エラー"
                                                                message:@"Watchの送信に失敗しました。（まだ放送されていない番組をWatchしようとしていたのであればそれが原因かもしれません）"
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView showWithCompletion:^(NSUInteger buttonIndex) {
            }];
            self.watched = NO;
            return;
         };
    }];
}

- (void)unwatch
{
    self.watched = NO;
    [ATAPI postTicketUnwatchWithTitleId:self.titleId episodeCount:self.count completion:^(NSDictionary *dictionary, NSError *error) {
    }];
}

@end
