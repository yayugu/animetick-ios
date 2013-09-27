#import <Foundation/Foundation.h>

@interface ATDateUtils : NSObject

// 深夜アニメ用 日付差分取得ロジック
+ (NSInteger)daysDifferenceConsiderMidnight:(NSDate*)currentDate with:(NSDate*)animeStartAt;

@end
