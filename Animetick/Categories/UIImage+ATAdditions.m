//
//  UIImage+ATAdditions.m
//  Animetick
//
//  Created by Yuya Yaguchi on 11/27/13.
//  Copyright (c) 2013 yayugu. All rights reserved.
//

#import "UIImage+ATAdditions.h"

@implementation UIImage (ATAdditions)

- (UIImage*)processedImageForAnimeIcon
{
    // Make sure the rounded corner fits in the image
    CGFloat cornerRadius = 6.0;
    cornerRadius *= self.scale;
    const CGFloat maxCornerSize = MIN(self.size.width, self.size.height) * 0.5;
    if (cornerRadius > maxCornerSize) {
        cornerRadius = maxCornerSize;
    }

    // Make a transparent (with Alpha) context that resembles the most to original image.
    const CGFloat h = self.size.height * self.scale;
    const CGFloat w = self.size.width * self.scale;
    CGImageRef image = self.CGImage;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h,
                                                 CGImageGetBitsPerComponent(image),
                                                 CGImageGetBitsPerComponent(image) * 4 * w,
                                                 colorSpace,
                                                 kCGBitmapAlphaInfoMask & kCGImageAlphaNoneSkipLast);
    CGColorSpaceRelease(colorSpace);
    
    // Fill background with white color
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(context, CGRectMake(0, 0, w, h));
    
    // Create a clipping path with rounded corners
    const CGFloat r = cornerRadius;
    [self addRoundedCornerPathWithContext:context width:w height:h cornerRadius:r];
    CGContextClip(context);

    // Draw the image to the context; everything outside the clipping path will become transparent
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), image);
    
    // Draw border with gray color
    [self addRoundedCornerPathWithContext:context width:w height:h cornerRadius:r];
    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1.0);
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokePath(context);
    
    // Create a CGImage from the context and an UIImage from it.
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *roundedImage = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);
    return roundedImage;
}

- (void)addRoundedCornerPathWithContext:(CGContextRef)context width:(CGFloat)w height:(CGFloat)h cornerRadius:(CGFloat)r
{
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, r);
    CGContextAddArcToPoint(context, 0, h, r, h, r);
    CGContextAddArcToPoint(context, w, h, w, h-r, r);
    CGContextAddArcToPoint(context, w, 0, w-r, 0, r);
    CGContextAddArcToPoint(context, 0, 0, 0, r, r);
    CGContextClosePath(context);
}

@end
