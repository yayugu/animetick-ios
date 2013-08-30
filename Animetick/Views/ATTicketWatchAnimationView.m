//
//  ATTicketWatchAnimationView.m
//  Animetick
//
//  Created by yayugu on 2013/08/30.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "ATTicketWatchAnimationView.h"

@interface ATTicketWatchAnimationView ()

@property (nonatomic, retain) UIView *animationView;

@end


@implementation ATTicketWatchAnimationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.animationView = [[UIView alloc] initWithFrame:frame];
        self.animationView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.animationView];
    }
    return self;
}

- (void)animateTo:(UIView*)view
{
    UIView *rootView = [UIApplication sharedApplication].delegate.window.rootViewController.view;
    [rootView addSubview:self];
    
    CGPoint origin = [self originFromRootViewToView:view];
    [UIView
     animateWithDuration:0.2
     delay:0
     options:UIViewAnimationOptionCurveEaseOut
     animations:^{
         CGRect frame = {
             .origin = origin,
             .size = view.bounds.size
         };
         self.animationView.frame = frame;
     }
     completion:^(BOOL finished) {
         [self removeFromSuperview];
     }];
}

- (CGPoint)originFromRootViewToView:(UIView*)view
{
    UIView *rootView = [UIApplication sharedApplication].delegate.window.rootViewController.view;
    CGFloat originX = 0;
    CGFloat originY = 0;

    // status barの分下にずらす。もう少しマシなやり方がないものか
    originY += [UIApplication sharedApplication].statusBarFrame.size.height;
    
    while (true) {
        if (view == rootView) {
            return CGPointMake(originX, originY);
        }
        if (!view) {
            return CGPointZero;
        }
        originX += view.frame.origin.x;
        originY += view.frame.origin.y;
        view = view.superview;
    }
}

@end
