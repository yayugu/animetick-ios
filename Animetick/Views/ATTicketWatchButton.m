//
//  ATCheckbox.m
//  Animetick
//
//  Created by yayugu on 2013/08/06.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "ATTicketWatchButton.h"
#import "ATTicketWatchAnimationView.h"
#import "UIColor+ATAdditions.h"
#import <CoreGraphics/CoreGraphics.h>

@interface ATTicketWatchButton ()

@property (nonatomic, strong) UILabel *checkLabel;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;

@end

@implementation ATTicketWatchButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor grayColor];
        
        CGRect frame = {
            .origin.x = 0,
            .origin.y = 0,
            .size = self.frame.size
        };
        self.checkLabel = [[UILabel alloc] initWithFrame:frame];
        self.checkLabel.backgroundColor = [UIColor clearColor];
        self.checkLabel.textColor = [UIColor whiteColor];
        self.checkLabel.textAlignment = NSTextAlignmentCenter;
        self.checkLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:19];
        
        // 90度
        self.checkLabel.transform = CGAffineTransformMakeRotation(M_PI / 2);
        CGRect bounds = {
            .origin.x = 0,
            .origin.y = 0,
            .size.width = self.frame.size.height,
            .size.height = self.frame.size.width
        };
        self.checkLabel.bounds = bounds;
        [self addSubview:self.checkLabel];
        
        self.longPressGestureRecognizer =
          [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                        action:@selector(onLongPressGesture:)];
        self.longPressGestureRecognizer.minimumPressDuration = 0.2;
        [self addGestureRecognizer:self.longPressGestureRecognizer];
    }
    return self;
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    
    if (checked) {
        self.checkLabel.text = @"Watched";
        self.backgroundColor = [UIColor atTintColor];
    } else {
        self.backgroundColor = [UIColor grayColor];
        self.checkLabel.text = @"Watch";
    }
}

- (void)setChecked:(BOOL)checked animated:(BOOL)animated
{
    [self setChecked:checked];
    
    ATTicketWatchAnimationView *animationView = [[ATTicketWatchAnimationView alloc] initWithFrame:self.bounds];
    [self addSubview:animationView];
    [animationView animate];
}

- (void)onLongPressGesture:(UILongPressGestureRecognizer*)recognizer
{
    switch (recognizer.state) {
        // 長押し認識
        case UIGestureRecognizerStateBegan:
            [self sendActionsForControlEvents:ATTicketWatchButtonEventLongPress];
            break;
        default:
            break;
    }
}

@end
