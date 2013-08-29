//
//  ATCheckbox.h
//  Animetick
//
//  Created by yayugu on 2013/08/06.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//


// UIControlEventApplicationReservedのrangeに入る値
static const NSUInteger ATTicketWatchButtonEventLongPress = 0x01000000;

@interface ATTicketWatchButton : UIControl

@property (nonatomic) BOOL checked;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;

- (void)setChecked:(BOOL)checked animated:(BOOL)animated;

@end
