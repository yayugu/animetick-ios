#import "ATTicketCell.h"
#import "UIColor+ATAdditions.h"
#import "ATTicket.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ATTicketCell

# pragma mark - Object Lifecycle

- (void)awakeFromNib
{
    [self.icon layer].borderColor = [[UIColor lightGrayColor] CGColor];
    [self.icon layer].borderWidth = 1.0;
    
    UIView *selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = [UIColor atTintColor];
    self.selectedBackgroundView = selectedBackgroundView;
}

- (void)dealloc
{
    [_ticket removeObserver:self forKeyPath:@"watched"];
}

# pragma mark - Key-Value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"watched"]) {
        [self updateBackgroundLabels];
    }
}

# pragma mark -

- (void)setTicket:(ATTicket *)ticket
{
    [_ticket removeObserver:self forKeyPath:@"watched"];
    [ticket addObserver:self forKeyPath:@"watched" options:0 context:nil];
    
    _ticket = ticket;
    [self.icon setImageWithURL:ticket.iconURL];
    self.title.text = ticket.title;
    self.subTitle.text = ticket.episondeNumberWithSubTitle;
    self.startAt.text = ticket.startAtText;
    self.channel.text = ticket.channelText;
    [self updateBackgroundLabels];
}

# pragma mark - Internals

- (void)updateBackgroundLabels
{
    if (self.ticket.watched) {
        self.watchedLabel.hidden = NO;
        self.nearDateLabel.text = @"";
    } else {
        self.watchedLabel.hidden = YES;
        self.nearDateLabel.text = self.ticket.nearDateLabelText;
    }
}

@end
