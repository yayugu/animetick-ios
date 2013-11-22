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

@interface ATTicketLayout()
@property (nonatomic, strong)ATTicket *ticket;
@end

@implementation ATTicketLayout

- (instancetype)initWithTicket:(ATTicket*)ticket
{
    self = [super init];
    if (self) {
        self.ticket = ticket;
    }
    return self;
}

- (CGFloat)heigthWithCellWidth:(CGFloat)cellWidth
{
    return ATTicketLayoutTopPadding
        + [self titleHeightWithCellWidth:cellWidth]
        + [self subTitleHeightWithCellWidth:cellWidth]
        + [self channelHeight]
        + ATTicketLayoutBottomPadding;
}

#pragma mark - Internal methods

- (CGFloat)titleHeightWithCellWidth:(CGFloat)cellWidth
{
    NSAttributedString *attrString =
    [[NSAttributedString alloc] initWithString:self.ticket.title
                                    attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HiraKakuProN-W6" size:15.0]}];
    CGFloat width = cellWidth - ATTicketLayoutLeftPadding - ATTicketLayoutRightPadding;
    return [self textHeightWithAttributedString:attrString width:width];
}

- (CGFloat)subTitleHeightWithCellWidth:(CGFloat)cellWidth
{
    NSAttributedString *attrString =
    [[NSAttributedString alloc] initWithString:self.ticket.title
                                    attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HiraKakuProN-W3" size:12.0]}];
    CGFloat width = cellWidth - ATTicketLayoutLeftPadding - ATTicketLayoutRightPadding;
    return [self textHeightWithAttributedString:attrString width:width];
}

- (CGFloat)channelHeight
{
    return 15.0;
}

- (void)drawTitleWithContext:(CGContextRef)context
{
    
}

- (CGFloat)textHeightWithAttributedString:(NSAttributedString*)attrString width:(CGFloat)width
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
    CGSize constraint = (CGSize) {
        .width = width,
        .height = CGFLOAT_MAX,
    };
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, constraint, nil);
    CFRelease(framesetter);
    return size.height;
}

@end