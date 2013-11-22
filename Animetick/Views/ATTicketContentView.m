//
//  ATTicketContentView.m
//  Animetick
//
//  Created by yayugu on 2013/10/19.
//  Copyright (c) 2013年 yayugu. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <CoreText/CoreText.h>
#import "ATTicketContentView.h"
#import "ATTicket.h"
#import "ATTicketLayout.h"

@interface ATTicketContentView ()

@property (nonatomic, strong)ATTicketLayout *layout;

@end

@implementation ATTicketContentView

- (void)setTicket:(ATTicket *)ticket
{
    self.ticket = ticket;
    self.layout = [[ATTicketLayout alloc] initWithTicket:ticket];
}

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    [self drawTitleWithContext:context];
    

    
    /*
    {
    // フォント属性を設定して文字列を生成
    CTFontRef font = CTFontCreateWithName(CFSTR("HiraKakuProN-W6"), 20.f, NULL);
    CFStringRef keys[] = { kCTFontAttributeName };
    CFTypeRef values[] = { font };
    CFDictionaryRef attributes = CFDictionaryCreate(kCFAllocatorDefault, (const void**)&keys,
                                                    (const void**)&values, sizeof(keys) / sizeof(keys[0]),
                                                    &kCFTypeDictionaryKeyCallBacks,
                                                    &kCFTypeDictionaryValueCallBacks);
    CFAttributedStringRef attrString = CFAttributedStringCreate(kCFAllocatorDefault, CFSTR("吾輩は猫である。"), attributes);
    CFRelease(font);
    CFRelease(attributes);
    // 文字列を渡してCTLineを生成
    CTLineRef line = CTLineCreateWithAttributedString(attrString);
    CFRelease(attrString);
    // 描画
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetTextPosition(ctx, 10.0, 10.0);
    CTLineDraw(line, ctx);
    CFRelease(line);
    }
    */
}

- (void)drawTitleWithContext:(CGContextRef)context;
{
    CGRect bounds = (CGRect) {
        .origin.x = ATTicketLayoutLeftPadding,
        .origin.y = ATTicketLayoutTopPadding * -1,
        .size.width = self.bounds.size.width - ATTicketLayoutLeftPadding - ATTicketLayoutRightPadding,
        .size.height = self.bounds.size.height,
    };
    CGPathRef path = CGPathCreateWithRect(bounds, &CGAffineTransformIdentity);
    
    NSAttributedString *attrString =
        [[NSAttributedString alloc] initWithString:self.ticket.title
                                        attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HiraKakuProN-W6" size:15.0]}];
    CFAttributedStringRef attrStringRef = (__bridge_retained CFAttributedStringRef)attrString;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrStringRef);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                                                CFRangeMake(0, CFAttributedStringGetLength(attrStringRef)),
                                                path,
                                                NULL);
    CFRelease(frame);
    
    CTFrameDraw(frame, context);
    
    CFRelease(attrStringRef);
    CFRelease(path);
    CFRelease(framesetter);
}

@end
