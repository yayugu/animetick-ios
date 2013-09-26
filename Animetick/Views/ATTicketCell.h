@class ATTicket;

@interface ATTicketCell : UITableViewCell

@property (strong, nonatomic) ATTicket *ticket;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UILabel *channel;
@property (weak, nonatomic) IBOutlet UILabel *startAt;
@property (weak, nonatomic) IBOutlet UILabel *watchedLabel;
@property (weak, nonatomic) IBOutlet UILabel *nearDateLabel;

@end
