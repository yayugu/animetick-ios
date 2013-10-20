#import "ATSwipableTableViewCell.h"

@class ATTicket, ATTicketContentView;

@interface ATTicketCell : ATSwipableTableViewCell

@property (strong, nonatomic) ATTicket *ticket;
@property (strong, nonatomic) ATTicketContentView *frontView;

@end
