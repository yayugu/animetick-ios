#import <UIKit/UIKit.h>

@interface UIColor (ATAdditions)

+ (UIColor*)colorWithHex:(UInt32)hexadecimal;
+ (UIColor*)atTintColor;
+ (UIColor*)atWatchedCellColor;

@end
