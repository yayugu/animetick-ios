#import "ATTicket.h"

@protocol ATTicketListDelegate

- (void)ticketListDidLoad;
- (void)ticketListMoreDidLoad;
- (void)ticketListLoadDidFailed;

@end

@interface ATTicketList : NSObject

@property (nonatomic) BOOL lastFlag;

- (id)initWithWatched:(BOOL)watched delegate:(id<ATTicketListDelegate>)delegate;
- (NSInteger)numberOfSections;
- (NSInteger)numberOfTicketsInSection:(NSInteger)section;
- (ATTicket*)ticketAtIndexPath:(NSIndexPath*)path;
- (void)removeTicketAtIndexPath:(NSIndexPath*)path;
- (NSString*)titleForSection:(NSInteger)section;
- (void)loadMore;
- (void)reload;

@end



