#import "ATTicketList.h"
#import "ATTicketSection.h"
#import "ATAPI.h"

@interface ATTicketList()

@property (nonatomic, weak) id<ATTicketListDelegate> delegate;
@property (nonatomic) BOOL watched;
@property (nonatomic) BOOL requesting;
@property (nonatomic, strong) NSMutableArray *tickets;
@property (nonatomic, strong) NSMutableArray *ticketSections;

@end

@implementation ATTicketList

- (id)initWithWatched:(BOOL)watched delegate:(id<ATTicketListDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.tickets = [NSMutableArray array];
        self.watched = watched;
        self.delegate = delegate;
        self.requesting = NO;
        [self requestWithOffset:0];
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    ATTicketList *clone = [[[self class] alloc] init];
    clone.tickets = [self.tickets mutableCopy];
    clone.ticketSections = [self.ticketSections mutableCopy];
    clone.lastFlag = self.lastFlag;
    clone.delegate = self.delegate;
    clone.watched = self.watched;
    clone.requesting = self.requesting;
    return clone;
}

- (NSInteger)numberOfSections
{
    return [self.ticketSections count];
}

- (NSInteger)numberOfTicketsInSection:(NSInteger)section
{
    return [[self.ticketSections[section] tickets] count];
}

- (ATTicketSection*)sectionAtIndex:(NSInteger)index
{
    return self.ticketSections[index];
}

- (ATTicket*)ticketAtIndexPath:(NSIndexPath*)path
{
    NSUInteger index = [((NSArray*)[self.ticketSections[path.section] tickets])[path.row] unsignedIntegerValue];
    return self.tickets[index];
}

- (void)removeTicketAtIndexPath:(NSIndexPath*)path
{
    NSUInteger index = [((NSArray*)[self.ticketSections[path.section] tickets])[path.row] unsignedIntegerValue];
    [self.tickets removeObjectAtIndex:index];
    self.ticketSections = [self generateSectionedTicketsWithTickets:self.tickets];
}

- (NSString*)titleForSection:(NSInteger)section
{
    return [self.ticketSections[section] title];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return [[self.ticketSections[section] tickets] count];
}

- (NSUInteger)hashForSection:(NSInteger)section
{
    return [self.ticketSections[section] hash];
}

- (NSUInteger)hashAtIndexPath:(NSIndexPath*)path
{
    NSUInteger index = [((NSArray*)[self.ticketSections[path.section] tickets])[path.row] unsignedIntegerValue];
    return [self.tickets[index] hash];
}

- (void)loadMore
{
    [self requestWithOffset:(int)self.tickets.count];
}

- (void)reload
{
    [self requestWithOffset:0];
}

#pragma mark - Internal methods

- (NSMutableArray*)newTicketsWithRawTickets:(NSArray*)rawTickets offset:(int)offset
{
    NSMutableArray *tickets;
    if (offset == 0) {
        tickets = [NSMutableArray array];
    } else {
        tickets = [self.tickets mutableCopy];
    }
    for (NSMutableDictionary *rawTicket in rawTickets) {
        rawTicket[@"watched"] = [NSNumber numberWithBool:self.watched];
        ATTicket *ticketObj = [[ATTicket alloc] initWithDictionary:rawTicket];
        [tickets addObject:ticketObj];
    }
    return tickets;
}

- (NSMutableArray*)generateSectionedTicketsWithTickets:(NSArray*)tickets
{
    return self.watched
        ? [self generateSectionedTicketsWatchedWithTickets:tickets]
        : [self generateSectionedTicketsUnwatchedWithTickets:tickets];
}

- (NSMutableArray*)generateSectionedTicketsWatchedWithTickets:(NSArray*)tickets
{
    NSMutableArray *sections = [NSMutableArray array];
    ATTicketSection *section = [[ATTicketSection alloc] init];
    section.title = @"";
    section.hashCode = 0;
    section.tickets = [NSMutableArray array];
    [sections addObject:section];
    NSUInteger i = 0;
    for (__unused ATTicket *ticket in tickets) {
        [[sections[0] tickets] addObject:[NSNumber numberWithUnsignedInteger:i]];
        i++;
    }
    return sections;
}

- (NSMutableArray*)generateSectionedTicketsUnwatchedWithTickets:(NSArray*)tickets
{
    NSMutableArray *sections = [NSMutableArray array];
    NSUInteger i = 0;
    int lastSectionIndex = -1;
    for (ATTicket *ticket in tickets) {
        if (lastSectionIndex != -1 && [ticket.nearDateText isEqualToString:[sections[lastSectionIndex] title]]) {
            [[sections[lastSectionIndex] tickets] addObject:[NSNumber numberWithUnsignedInteger:i]];
        } else {
            ATTicketSection *section = [[ATTicketSection alloc] init];
            section.title = ticket.nearDateText;
            section.hashCode = ticket.sectionHash;
            section.tickets = [NSMutableArray arrayWithObject:@(i)];
            [sections addObject:section];
            lastSectionIndex++;
        }
        i++;
    }
    return sections;
}

- (void)requestWithOffset:(int)offset
{
    @synchronized(self) {
        if (self.requesting) return;
        self.requesting = YES;
    }
    [ATAPI
     getTicketListWithOffset:offset
     watched:self.watched
     completion:^(NSDictionary *dic, NSError *error) {
         if (error) {
             [self.delegate ticketListLoadDidFailed];
             self.requesting = NO;
         } else {
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                 NSMutableArray *tmpTickets = [self newTicketsWithRawTickets:dic[@"list"] offset:offset];
                 NSMutableArray *tmpSectionedTickets = [self generateSectionedTicketsWithTickets:tmpTickets];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     self.tickets = tmpTickets;
                     self.ticketSections = tmpSectionedTickets;
                     self.lastFlag = [(NSNumber*)NSNullToNil(dic[@"last_flag"]) boolValue];
                     
                     if (offset == 0) {
                         [self.delegate ticketListDidLoad];
                     } else {
                         [self.delegate ticketListMoreDidLoad];
                     }
                     self.requesting = NO;
                 });
             });
         }
     }];
}

@end
