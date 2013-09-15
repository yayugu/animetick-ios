//
//  ATTicketCell.m
//  Animetick
//
//  Created by yayugu on 2013/08/04.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "ATTicketCell.h"
#import "UIColor+ATAdditions.h"
#import "ATTicket.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ATTicketCell

- (void)awakeFromNib
{
    [self.icon layer].borderColor = [[UIColor lightGrayColor] CGColor];
    [self.icon layer].borderWidth = 1.0;
    
    UIView *selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = [UIColor atTintColor];
    self.selectedBackgroundView = selectedBackgroundView;
}

- (void)setTicket:(ATTicket *)ticket
{
    _ticket = ticket;
    [self.icon setImageWithURL:ticket.iconURL];
    self.title.text = ticket.title;
    self.subTitle.text = ticket.episondeNumberWithSubTitle;
    self.startAt.text = ticket.startAtText;
    self.channel.text = ticket.channelText;
    self.watched = ticket.watched;
}

- (void)setWatched:(BOOL)watched
{
    if (watched) {
        self.watchedLabel.hidden = NO;
    } else {
        self.watchedLabel.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
