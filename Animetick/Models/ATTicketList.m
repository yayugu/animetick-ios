#import "ATTicketList.h"
#import "ATAPI.h"

@interface ATTicketList()

@property (nonatomic, strong) NSMutableArray *tickets;
@property (nonatomic, weak) id<ATTicketListDelegate> delegate;
@property (nonatomic) BOOL watched;

@end

@implementation ATTicketList

- (id)initWithWatched:(BOOL)watched delegate:(id<ATTicketListDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.tickets = [NSMutableArray array];
        self.watched = watched;
        self.delegate = delegate;
        [self requestWithOffset:0];
    }
    return self;
}

- (ATTicket*)ticketAtIndex:(int)index
{
    return self.tickets[index];
}

- (void)removeTicketAtIndex:(int)index
{
    [self.tickets removeObjectAtIndex:index];
}

- (int)count
{
    return self.tickets.count;
}

- (void)loadMore
{
    [self requestWithOffset:self.tickets.count];
}

- (void)reload
{
    [self requestWithOffset:0];
}

- (void)requestWithOffset:(int)offset
{
    [ATAPI
     getTicketListWithOffset:offset
     watched:self.watched
     completion:^(NSDictionary *dic, NSError *error) {
         if (error) {
             [self.delegate ticketListLoadDidFailed];
         } else {
             NSArray *tickets = dic[@"list"];
             if (offset == 0) {
                 self.tickets = [NSMutableArray array];
             }
             for (NSMutableDictionary *ticket in tickets) {
                 ticket[@"watched"] = [NSNumber numberWithBool:self.watched];
                 ATTicket *ticketObj = [[ATTicket alloc] initWithDictionary:ticket];
                 [self.tickets addObject:ticketObj];
             }
             
             self.lastFlag = [(NSNumber*)NSNullToNil(dic[@"last_flag"]) boolValue];
             
             if (offset == 0) {
                 [self.delegate ticketListDidLoad];
             } else {
                 [self.delegate ticketListMoreDidLoad];
             }
         }
     }];
}

@end
