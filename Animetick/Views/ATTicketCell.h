#import "ATSwipableTableViewCell.h"

@class ATTicket, ATTicketContentView;

@interface ATTicketCell : ATSwipableTableViewCell

@property (strong, nonatomic) ATTicket *ticket;
@property (strong, nonatomic) ATTicketContentView *frontView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView watched:(BOOL)watched;

@end
