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
    [self updateBackgroundLabels];
}

- (void)setWatched:(BOOL)watched
{
    _watched = watched;
    [self updateBackgroundLabels];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

# pragma mark - Internals

- (void)updateBackgroundLabels
{
    if (_watched) {
        self.watchedLabel.hidden = NO;
        self.nearDateLabel.text = @"";
    } else {
        self.watchedLabel.hidden = YES;
        self.nearDateLabel.text = self.ticket.nearDateLabelText;
    }
}

@end
