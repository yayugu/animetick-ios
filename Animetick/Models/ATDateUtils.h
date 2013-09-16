//
//  ATDateUtils.h
//  Animetick
//
//  Created by yayugu on 2013/09/16.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATDateUtils : NSObject

// 深夜アニメ用 日付差分取得ロジック
+ (NSInteger)daysDifferenceConsiderMidnight:(NSDate*)currentDate with:(NSDate*)animeStartDate;

@end
