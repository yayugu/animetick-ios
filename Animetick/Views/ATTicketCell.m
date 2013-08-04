//
//  ATTicketCell.m
//  Animetick
//
//  Created by yayugu on 2013/08/04.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "ATTicketCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ATTicketCell

- (void)awakeFromNib
{
    [self.icon layer].borderColor = [[UIColor lightGrayColor] CGColor];
    [self.icon layer].borderWidth = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
