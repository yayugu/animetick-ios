#import "ATTicketCell.h"
#import "UIColor+ATAdditions.h"
#import "ATTicket.h"
#import "ATTicketContentView.h"
#import "ATTicketLayout.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ATTicketCell

# pragma mark - Object Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView watched:(BOOL)watched
{
    UIButton *watchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    watchButton.backgroundColor = [UIColor atTintColor];
    NSString *watchButtonTitle = watched ? @"Unwatch" : @"Watch";
    [watchButton setTitle:watchButtonTitle forState:UIControlStateNormal];
    [watchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NSArray *rightUtilityButtons = @[watchButton];
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier containingTableView:containingTableView rightUtilityButtons:rightUtilityButtons];
    if (self) {
        NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"ATTicketContentView"
                                                        owner:self
                                                      options:nil];
        self.frontView = bundle[0];
        [self.frontView.icon layer].borderColor = [[UIColor lightGrayColor] CGColor];
        [self.frontView.icon layer].borderWidth = 1.0;
        self.frontView.nearDateLabel.font = [UIFont fontWithName:@".HiraKakuInterface-W1" size:41];
        [self.scrollViewContentView addSubview:self.frontView];
        
        UIView *selectedBackgroundView = [[UIView alloc] init];
        selectedBackgroundView.backgroundColor = [UIColor atTintColor];
        self.selectedBackgroundView = selectedBackgroundView;
    }
    return self;
}

# pragma mark -

- (void)setTicket:(ATTicket *)ticket
{
    _ticket = ticket;
    [self.frontView.icon setImageWithURL:ticket.iconURL];
    self.frontView.ticket = ticket;
    
    self.frontView.title.text = @"";
    self.frontView.subTitle.text = @"";
    self.frontView.startAt.text = @"";
    self.frontView.channel.text = @"";
    self.frontView.nearDateLabel.text = @"";
    
    CGRect frame = self.frame;
    frame.size.height = [[[ATTicketLayout alloc] initWithTicket:ticket cellWidth:self.bounds.size.width] height];
    self.frame = frame;
    
    [self setNeedsLayout];
    [self.frontView setNeedsLayout];
    [self.frontView setNeedsDisplay];
    //self.frontView.title.text = ticket.title;
    //self.frontView.subTitle.text = ticket.episondeNumberWithSubTitle;
    //self.frontView.startAt.text = ticket.startAtText;
    //self.frontView.channel.text = ticket.channelText;
    //self.frontView.nearDateLabel.text = self.ticket.nearDateLabelText;
}

@end
