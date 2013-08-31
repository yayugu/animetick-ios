//
//  UIColor+ATAdditions.m
//  Animetick
//
//  Created by yayugu on 2013/08/31.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "UIColor+ATAdditions.h"

@implementation UIColor (ATAdditions)

+ (UIColor*)colorWithHex:(UInt32)hexadecimal
{
    CGFloat red, green, blue, alpha;
    
    red = ( hexadecimal >> 24 ) & 0xFF;
    green = ( hexadecimal >> 16 ) & 0xFF;
    blue = ( hexadecimal >> 8 ) & 0xFF;
    alpha = hexadecimal & 0xFF;
    
    UIColor *color = [UIColor colorWithRed: red / 255.0f green: green / 255.0f blue: blue / 255.0f alpha: alpha / 255.0f];
    return color;
}

+ (UIColor*)atTintColor
{
    return [UIColor colorWithHex:0xFF500FFF];
}

+ (UIColor*)atWatchedCellColor
{
    return [UIColor colorWithHex:0xFFA05FFF];
}

@end
