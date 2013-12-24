#import "ATTicket.h"

@protocol ATTicketListDelegate

- (void)ticketListDidLoad;
- (void)ticketListMoreDidLoad;
- (void)ticketListLoadDidFailed;

@end

@interface ATTicketList : NSEnumerator

@property (nonatomic, strong) NSMutableArray *tickets;
@property (nonatomic) BOOL lastFlag;
@property (nonatomic, strong) NSMutableArray *sectionedTickets;

- (id)initWithWatched:(BOOL)watched delegate:(id<ATTicketListDelegate>)delegate;
- (NSInteger)numberOfSections;
- (NSInteger)numberOfTicketsInSection:(NSInteger)section;
- (ATTicket*)ticketAtIndexPath:(NSIndexPath*)path;
- (void)removeTicketAtIndexPath:(NSIndexPath*)path;
- (NSString*)titleForSection:(NSInteger)section;
- (void)loadMore;
- (void)reload;

@end



