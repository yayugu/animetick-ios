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

- (void)assignValuesWithDictionary:(NSDictionary*)dic
{
    self.titleId = [(NSNumber*)NSNullToNil(dic[@"title_id"]) intValue];
    self.count = [(NSNumber*)NSNullToNil(dic[@"count"]) intValue];
    self.title = NSNullToNil(dic[@"title"]);
    self.iconPath = NSNullToNil(dic[@"icon_path"]);
    self.subTitle = NSNullToNil(dic[@"sub_title"]);
    
    NSString *startAt = NSNullToNil(dic[@"start_at"]);
    self.startAt = startAt ? [NSDate dateWithATDateFormatString:startAt] : nil;
    
    self.chName = NSNullToNil(dic[@"ch_name"]);
    self.chNumber = [(NSNumber*)NSNullToNil(dic[@"chNumber"]) intValue];
    
    NSNumber *watched = NSNullToNil(dic[@"watched"]);
    self.watched = watched ? [watched boolValue] : NO;
}

- (NSURL*)iconURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ATAnimetickURLString, self.iconPath]];
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

- (NSString*)nearDateLabelText
{
    int daysDifference = [ATDateUtils daysDifferenceConsiderMidnight:[NSDate date] with:self.startAt];
    if (daysDifference == 1) {
        return @"明日";
    } else if (daysDifference == 0) {
        return @"今晩";
    } else if (daysDifference == -1) {
        return @"昨晩";
    }
    
    return @"";
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
