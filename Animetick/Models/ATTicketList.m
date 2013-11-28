#import "ATTicketList.h"
#import "ATAPI.h"

@interface ATTicketList()

@property (nonatomic, strong) NSMutableArray *tickets;
@property (nonatomic, strong) NSMutableArray *sectionedTickets;
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

- (NSInteger)numberOfSections
{
    return [self.sectionedTickets count];
}

- (NSInteger)numberOfTicketsInSection:(NSInteger)section
{
    return [self.sectionedTickets[section][@"tickets"] count];
}

- (ATTicket*)ticketAtIndexPath:(NSIndexPath*)path
{
    NSUInteger index = [self.sectionedTickets[path.section][@"tickets"][path.row] unsignedIntegerValue];
    return self.tickets[index];
}

- (void)removeTicketAtIndexPath:(NSIndexPath*)path
{
    NSUInteger index = [self.sectionedTickets[path.section][@"tickets"][path.row] unsignedIntegerValue];
    [self.tickets removeObjectAtIndex:index];
    self.sectionedTickets = [self generateSectionedTickets];
}

- (NSString*)titleInSection:(NSInteger)section
{
    return self.sectionedTickets[section][@"title"];
}

- (void)loadMore
{
    [self requestWithOffset:self.tickets.count];
}

- (void)reload
{
    [self requestWithOffset:0];
}

#pragma mark - Internal methods

- (NSMutableArray*)generateSectionedTickets
{
    NSMutableArray *sections = [NSMutableArray array];
    NSUInteger i = 0;
    int lastSectionIndex = -1;
    for (ATTicket *ticket in self.tickets) {
        if (lastSectionIndex != -1 && [ticket.nearDateText isEqualToString:sections[lastSectionIndex][@"title"]]) {
            [sections[lastSectionIndex][@"tickets"] addObject:[NSNumber numberWithUnsignedInteger:i]];
        } else {
            [sections addObject:@{@"title": ticket.nearDateText,
                                  @"tickets": [NSMutableArray arrayWithObject:[NSNumber numberWithUnsignedInteger:i]]}];
            lastSectionIndex++;
        }
        i++;
    }
    return sections;
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
             self.sectionedTickets = [self generateSectionedTickets];
             
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
