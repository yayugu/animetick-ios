//
//  ATTicketList.m
//  Animetick
//
//  Created by yayugu on 2013/07/28.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "ATTicketList.h"
#import "ATAPI.h"

@interface ATTicketList()

@property (nonatomic, strong) NSMutableArray *tickets;
@property (nonatomic, weak) id<ATTicketListDelegate> delegate;

@end

@implementation ATTicketList

- (id)initWithDelegate:(id<ATTicketListDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.tickets = [NSMutableArray array];
        self.delegate = delegate;
        [self requestPageIndex:0];
    }
    return self;
}

- (ATTicket*)ticketAtIndex:(int)index
{
    return self.tickets[index];
}

- (int)count
{
    return self.tickets.count;
}

- (void)loadMore
{
    
}

- (void)reload
{
    [self requestPageIndex:0];
}

- (void)requestPageIndex:(int)index
{
    [ATAPI
     getTicketListWithPage:index
     completion:^(NSDictionary *dic, NSError *error) {
         if (error) {
             // do something
             NSLog(@"%@", error);
         } else {
             NSArray *tickets = dic[@"list"];
             for (NSDictionary *ticket in tickets) {
                 ATTicket *ticketObj = [[ATTicket alloc] initWithDictionary:ticket];
                 [self.tickets addObject:ticketObj];
             }
             [self.delegate ticketListDidUpdated];
         }
     }];
}

@end
