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

- (void)animate
{
    self.animationView.frame = (CGRect){
        .origin = {
            .x = self.frame.origin.x - 100,
            .y = self.frame.origin.y - 100
        },
        .size = {
            .width = self.frame.size.width + 200,
            .height = self.frame.size.height + 200
        }
    };
    [UIView
     animateWithDuration:0.2
     delay:0
     options:UIViewAnimationOptionCurveEaseOut
     animations:^{
         self.animationView.frame = self.frame;
     }
     completion:^(BOOL finished) {
         [self removeFromSuperview];
     }];
}

@end
