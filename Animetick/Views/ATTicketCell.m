//
//  ATTicketCell.m
//  Animetick
//
//  Created by yayugu on 2013/08/04.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "ATTicketCell.h"
#import "UIColor+ATAdditions.h"
#import <QuartzCore/QuartzCore.h>

@implementation ATTicketCell

- (void)awakeFromNib
{
    [self.icon layer].borderColor = [[UIColor lightGrayColor] CGColor];
    [self.icon layer].borderWidth = 1.0;
    
    UIView *selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = [UIColor atTintColor];
    self.selectedBackgroundView = selectedBackgroundView;
}

- (void)setWatched:(BOOL)watched
{
    if (watched) {
        self.backgroundColor = [UIColor atWatchedCellColor];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
