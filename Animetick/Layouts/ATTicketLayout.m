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

static const CGFloat ATTicketLayoutTopPadding = 12;
static const CGFloat ATTicketLayoutBottomPadding = 14;
static const CGFloat ATTicketLayoutLeftPadding = 69;
static const CGFloat ATTicketLayoutRightPadding = 5;
static const CGFloat ATTicketLayoutRightPaddingForStartAt = 10;
static const CGFloat ATTicketLayoutChannelAndTitleSpace = 4;
static const CGFloat ATTicketLayoutTitleAndSubTitleSpace = 5;

@interface ATTicketLayout()
@property (nonatomic, strong) ATTicket *ticket;
@property (nonatomic) CGFloat cellWidth;
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
    return [self subTitleY]
        + [self subTitleHeight]
        + ATTicketLayoutBottomPadding;
}

- (CGRect)channelRect
{
    return ((CGRect) {
        .origin.x = ATTicketLayoutLeftPadding,
        .origin.y = ([self channelY]) * -1,
        .size.width = [self subTitleWidth],
        .size.height = [self channelHeight],
    });
}

- (CGRect)startAtRect
{
    return ((CGRect) {
        .origin.x = 0,
        .origin.y = ([self channelY]) * -1,
        .size.width = [self startAtWidth],
        .size.height = [self channelHeight],
    });
}

- (CGRect)titleRect
{
    return ((CGRect) {
        .origin.x = ATTicketLayoutLeftPadding,
        .origin.y = ([self titleY]) * -1,
        .size.width = [self titleWidth],
        .size.height = [self titleHeight],
    });
}

- (CGRect)subTitleRect
{
    return ((CGRect) {
        .origin.x = ATTicketLayoutLeftPadding,
        .origin.y = ([self subTitleY]) * -1,
        .size.width = [self subTitleWidth],
        .size.height = [self subTitleHeight],
    });
}

- (NSAttributedString*)channelAttrString
{
    return [[NSAttributedString alloc]
            initWithString:self.ticket.channelText
            attributes:@{NSFontAttributeName: [self channelFont]}];
}

- (NSAttributedString*)startAtAttrString
{
    return [[NSAttributedString alloc]
            initWithString:self.ticket.startAtText
            attributes:@{NSFontAttributeName: [self channelFont],
                         NSParagraphStyleAttributeName: (id)[self paragraphStyleWithSpacing:1.0 align:kCTTextAlignmentRight]}];
}

- (NSAttributedString*)titleAttrString
{
    return [[NSAttributedString alloc]
            initWithString:self.ticket.titleWithEpisodeNumberText
            attributes:@{NSFontAttributeName: [self titleFont],
                         NSParagraphStyleAttributeName: (id)[self paragraphStyleWithSpacing:1.0 align:kCTTextAlignmentLeft]}];
}

- (NSAttributedString*)subTitleAttrString
{
    return [[NSAttributedString alloc]
            initWithString:self.ticket.subTitleText
            attributes:@{NSFontAttributeName: [self subTitleFont],
                         NSParagraphStyleAttributeName: (id)[self paragraphStyleWithSpacing:1.0 align:kCTTextAlignmentLeft]}];
}

#pragma mark - Internal methods

- (CGFloat)channelY
{
    return ATTicketLayoutTopPadding;
}

- (CGFloat)titleY
{
    return [self channelY]
        + [self channelHeight]
        + ATTicketLayoutChannelAndTitleSpace;
}

- (CGFloat)subTitleY
{
    return [self titleY]
        + [self titleHeight]
        + ATTicketLayoutTitleAndSubTitleSpace;
}

- (UIFont*)channelFont
{
    return [UIFont fontWithName:@".HiraKakuInterface-W1" size:12.0];
}

- (UIFont*)titleFont
{
    return [UIFont fontWithName:@"HiraKakuProN-W6" size:16.0];
}

- (UIFont*)subTitleFont
{
    return [UIFont fontWithName:@"HiraKakuProN-W3" size:14.0];
}

- (CTParagraphStyleRef)paragraphStyleWithSpacing:(CGFloat)spacing align:(CTTextAlignment)align
{
    CGFloat floatValue[5];
    floatValue[0] = 0.0;
    floatValue[1] = 0.0;
    floatValue[2] = 0.0;
    floatValue[3] = spacing; // Line spacing (必要に応じて行間調整)
    floatValue[4] = floatValue[3]; // Same as kCTParagraphStyleSpecifierMinimumLineSpacing
    CTParagraphStyleSetting settings[] = {
        {kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &floatValue[0]},
        {kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &floatValue[1]},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &floatValue[2]},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &floatValue[3]},
        {kCTParagraphStyleSpecifierAlignment, sizeof(align), &align},
    };
    return CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(CTParagraphStyleSetting));
}

- (CGFloat)startAtWidth
{
    return self.cellWidth - ATTicketLayoutRightPaddingForStartAt;
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
    return 12.0;
}

- (CGSize)constraintSizeWithWidth:(CGFloat)width
{
    return ((CGSize) {
        .width = width,
        .height = CGFLOAT_MAX,
    });
}

- (CGFloat)textHeightWithAttributedString:(NSAttributedString*)attrString width:(CGFloat)width font:(UIFont*)font
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
    CGSize size =
        CTFramesetterSuggestFrameSizeWithConstraints(framesetter,
                                                     CFRangeMake(0, 0),
                                                     nil,
                                                     [self constraintSizeWithWidth:width],
                                                     nil);
    CFRelease(framesetter);
    return size.height + ceilf(font.descender);
}

@end