//
//  UIImage+ATAdditions.m
//  Animetick
//
//  Created by Yuya Yaguchi on 11/27/13.
//  Copyright (c) 2013 yayugu. All rights reserved.
//

#import "UIImage+ATAdditions.h"

@implementation UIImage (ATAdditions)

- (UIImage *)roundedImageWithCornerRadius:(CGFloat)cornerRadius
{
    // Negative radius means no rounded borders
    if (cornerRadius <= 0) {
        return self;
    }
    
    // Make sure the rounded corner fits in the image
    const CGFloat maxCornerSize = MIN(self.size.width, self.size.height) * 0.5;
    cornerRadius *= self.scale;
    if (cornerRadius > maxCornerSize) {
        cornerRadius = maxCornerSize;
    }
    
    // Get the closest posible alpha info for our context
    CGImageRef image = self.CGImage;
    const CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(image);
    CGImageAlphaInfo alphaInfo = (bitmapInfo & kCGBitmapAlphaInfoMask);
    switch (alphaInfo) {
        case kCGImageAlphaNone:
        case kCGImageAlphaNoneSkipFirst: alphaInfo = kCGImageAlphaPremultipliedFirst; break;
        case kCGImageAlphaNoneSkipLast: alphaInfo = kCGImageAlphaPremultipliedLast; break;
        default: break;
    }
    
    // Make a transparent (with Alpha) context that resembles the most to original image.
    const CGFloat h = self.size.height * self.scale;
    const CGFloat w = self.size.width * self.scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h,
                                                 CGImageGetBitsPerComponent(image),
                                                 CGImageGetBitsPerComponent(image) * 4 * w,
                                                 colorSpace,
                                                 (bitmapInfo & ~kCGBitmapAlphaInfoMask) | alphaInfo);
    CGColorSpaceRelease(colorSpace);
    
    // Create a clipping path with rounded corners
    const CGFloat r = cornerRadius;
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, r);
    CGContextAddArcToPoint(context, 0, h, r, h, r);
    CGContextAddArcToPoint(context, w, h, w, h-r, r);
    CGContextAddArcToPoint(context, w, 0, w-r, 0, r);
    CGContextAddArcToPoint(context, 0, 0, 0, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    
    // Draw the image to the context; everything outside the clipping path will become transparent
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), image);
    
    // Create a CGImage from the context and an UIImage from it.
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *roundedImage = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);
    return roundedImage;
}

@end
