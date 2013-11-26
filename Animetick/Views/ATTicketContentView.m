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

- (void)awakeFromNib
{
    // call drawRect: when the bounds change.
    self.contentMode = UIViewContentModeRedraw;
    
    [self.icon layer].borderColor = [[UIColor lightGrayColor] CGColor];
    [self.icon layer].borderWidth = 1.0;
    //self.icon.layer.masksToBounds = YES;
    //self.icon.layer.cornerRadius = 3.0;
    self.nearDateLabel.font = [UIFont fontWithName:@".HiraKakuInterface-W1" size:41];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    self.layout = [[ATTicketLayout alloc] initWithTicket:self.ticket cellWidth:self.bounds.size.width];
    
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    [self drawTextWithContext:context Rect:[self.layout channelRect] attributedString:[self.layout channelAttrString]];
    [self drawTextWithContext:context Rect:[self.layout startAtRect] attributedString:[self.layout startAtAttrString]];
    [self drawTextWithContext:context Rect:[self.layout titleRect] attributedString:[self.layout titleAttrString]];
    [self drawTextWithContext:context Rect:[self.layout subTitleRect] attributedString:[self.layout subTitleAttrString]];
    
    CGContextRestoreGState(context);
    
    //[self drawRoundedRect:[self.layout startAtRect] withContext:context];
}

- (void)drawTextWithContext:(CGContextRef)context Rect:(CGRect)rect attributedString:(NSAttributedString*)attrString
{
    rect.size.height = self.bounds.size.height;
    CGPathRef path = CGPathCreateWithRect(rect, &CGAffineTransformIdentity);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                                                CFRangeMake(0, 0),
                                                path,
                                                NULL);
    CTFrameDraw(frame, context);
    
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}


- (void)drawRoundedRect:(CGRect)rect withContext:(CGContextRef)context
{
    
    CGFloat radius = 4.0f;
    
    rect.origin.y *= -1;
    //rect.origin.x += 0.75;
    //rect.origin.y += 0.75;
    //rect.size.width -= 1.5f;
    //rect.size.height -= 1.5f;
    
    CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor); //塗りつぶし色の指定
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor); //縁取り色の指定
    
    CGFloat leftX = CGRectGetMinX(rect);
    CGFloat centerX = CGRectGetMidX(rect);
    CGFloat rightX = CGRectGetMaxX(rect);
    CGFloat bottomY = CGRectGetMinY(rect);
    CGFloat centerY = CGRectGetMidY(rect);
    CGFloat topY = CGRectGetMaxY(rect);
    
    CGContextMoveToPoint(context, leftX, centerY); //パス描画開始座標
    CGContextAddArcToPoint(context, leftX, bottomY, centerX, bottomY, radius); //左下の角
    CGContextAddArcToPoint(context, rightX, bottomY, rightX, centerY, radius); //右下の角
    CGContextAddArcToPoint(context, rightX, topY, centerX, topY, radius); //右上の角
    CGContextAddArcToPoint(context, leftX, topY, leftX, centerY, radius); //左上の角
    CGContextClosePath(context);
    //CGContextDrawPath(context, kCGPathFillStroke);
    CGContextDrawPath(context, kCGPathStroke);
}

@end
