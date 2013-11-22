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

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    self.layout = [[ATTicketLayout alloc] initWithTicket:self.ticket cellWidth:self.bounds.size.width];
    [self drawTextWithContext:context Rect:[self.layout titleRect] attributedString:[self.layout titleAttrString]];
    [self drawTextWithContext:context Rect:[self.layout subTitleRect] attributedString:[self.layout subTitleAttrString]];
}

- (void)drawTextWithContext:(CGContextRef)context Rect:(CGRect)rect attributedString:(NSAttributedString*)attrString
{
    CGPathRef path = CGPathCreateWithRect(rect, &CGAffineTransformIdentity);
    CFAttributedStringRef attrStringRef = (__bridge_retained CFAttributedStringRef)attrString;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrStringRef);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                                                CFRangeMake(0, CFAttributedStringGetLength(attrStringRef)),
                                                path,
                                                NULL);
    CTFrameDraw(frame, context);
    
    CFRelease(frame);
    CFRelease(attrStringRef);
    CFRelease(path);
    CFRelease(framesetter);
}

@end
