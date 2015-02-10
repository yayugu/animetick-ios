#import "ATTicket.h"
#import "ATProtocols.h"

@class ATTicketSection;

@protocol ATTicketListDelegate

- (void)ticketListDidLoad;
- (void)ticketListMoreDidLoad;
- (void)ticketListLoadDidFailed;

@end

@interface ATTicketList : NSEnumerator <NSCopying, ATDataSource>

@property (nonatomic) BOOL lastFlag;

- (id)initWithWatched:(BOOL)watched delegate:(id<ATTicketListDelegate>)delegate;
- (NSInteger)numberOfSections;
- (NSInteger)numberOfTicketsInSection:(NSInteger)section;
- (ATTicketSection*)sectionAtIndex:(NSInteger)index;
- (ATTicket*)ticketAtIndexPath:(NSIndexPath*)path;
- (void)removeTicketAtIndexPath:(NSIndexPath*)path;
- (NSString*)titleForSection:(NSInteger)section;
- (void)loadMore;
- (void)reload;

@end



