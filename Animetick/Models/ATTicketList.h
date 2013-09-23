#import "ATTicket.h"

@protocol ATTicketListDelegate

- (void)ticketListDidLoad;
- (void)ticketListMoreDidLoad;

@end

@interface ATTicketList : NSObject

@property (nonatomic) BOOL lastFlag;

- (id)initWithDelegate:(id<ATTicketListDelegate>)delegate;
- (ATTicket*)ticketAtIndex:(int)index;
- (int)count;
- (void)loadMore;
- (void)reload;

@end



