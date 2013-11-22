//
//  ATTicketLayout.m
//  Animetick
//
//  Created by Yuya Yaguchi on 11/22/13.
//  Copyright (c) 2013 yayugu. All rights reserved.
//

#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>
#import "ATTicketLayout.h"
#import "ATTicket.h"

static const CGFloat ATTicketLayoutTopPadding = 10;
static const CGFloat ATTicketLayoutBottomPadding = 5;
static const CGFloat ATTicketLayoutLeftPadding = 65;
static const CGFloat ATTicketLayoutRightPadding = 5;

@interface ATTicketLayout()
@property (nonatomic, strong)ATTicket *ticket;
@property (nonatomic)CGFloat cellWidth;
@end

@implementation ATTicketLayout

- (instancetype)initWithTicket:(ATTicket*)ticket cellWidth:(CGFloat)cellWidth
{
    self = [super init];
    if (self) {
        self.ticket = ticket;
        self.cellWidth = cellWidth;
    }
    return self;
}

- (CGFloat)height
{
    return ATTicketLayoutTopPadding
        + [self titleHeight]
        + [self subTitleHeight]
        + [self channelHeight]
        + ATTicketLayoutBottomPadding;
}

- (CGRect)titleRect
{
    return ((CGRect) {
        .origin.x = ATTicketLayoutLeftPadding,
        .origin.y = ATTicketLayoutTopPadding * -1,
        .size.width = [self titleWidth],
        .size.height = [self titleHeight],
    });
}

- (CGRect)subTitleRect
{
    return ((CGRect) {
        .origin.x = ATTicketLayoutLeftPadding,
        .origin.y = (ATTicketLayoutTopPadding + [self titleHeight]) * -1,
        .size.width = [self subTitleWidth],
        .size.height = [self subTitleHeight],
    });
}

- (NSAttributedString*)titleAttrString
{
    return [[NSAttributedString alloc] initWithString:self.ticket.title
                                           attributes:@{NSFontAttributeName: [self titleFont]}];
}

- (NSAttributedString*)subTitleAttrString
{
    return [[NSAttributedString alloc] initWithString:self.ticket.subTitle
                                           attributes:@{NSFontAttributeName: [self subTitleFont]}];
}

#pragma mark - Internal methods

- (CGSize)constraintSizeWithWidth:(CGFloat)width
{
    return ((CGSize) {
        .width = width,
        .height = CGFLOAT_MAX,
    });
}

- (UIFont*)titleFont
{
    return [UIFont fontWithName:@"HiraKakuProN-W6" size:15.0];
}

- (UIFont*)subTitleFont
{
    return [UIFont fontWithName:@"HiraKakuProN-W3" size:12.0];
}

- (CGFloat)titleWidth
{
    return self.cellWidth - ATTicketLayoutLeftPadding - ATTicketLayoutRightPadding;
}

- (CGFloat)subTitleWidth
{
    return self.cellWidth - ATTicketLayoutLeftPadding - ATTicketLayoutRightPadding;
}

- (CGFloat)titleHeight
{
    return [self textHeightWithAttributedString:[self titleAttrString] width:[self titleWidth] font:[self titleFont]];
}

- (CGFloat)subTitleHeight
{
    return [self textHeightWithAttributedString:[self subTitleAttrString] width:[self subTitleWidth] font:[self titleFont]];
}

- (CGFloat)channelHeight
{
    return 15.0;
}

- (CGFloat)textHeightWithAttributedString:(NSAttributedString*)attrString width:(CGFloat)width font:(UIFont*)font
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, [self constraintSizeWithWidth:width], nil);
    CFRelease(framesetter);
    return size.height + ceilf(font.descender);
}

@end