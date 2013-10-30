#import "ATTicket.h"

@protocol ATTicketListDelegate

- (void)ticketListDidLoad;
- (void)ticketListMoreDidLoad;
- (void)ticketListLoadDidFailed;

@end

@interface ATTicketList : NSObject

@property (nonatomic) BOOL lastFlag;

- (id)initWithWatched:(BOOL)watched delegate:(id<ATTicketListDelegate>)delegate;
- (ATTicket*)ticketAtIndex:(int)index;
- (int)count;
- (void)loadMore;
- (void)reload;

@end



