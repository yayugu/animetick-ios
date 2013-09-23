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
@property (nonatomic) int loadedPageIndex;

@end

@implementation ATTicketList

- (id)initWithDelegate:(id<ATTicketListDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.tickets = [NSMutableArray array];
        self.delegate = delegate;
        self.loadedPageIndex = -1;
        [self requestPage];
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
    [self requestPage];
}

- (void)reload
{
    self.loadedPageIndex = -1;
    [self requestPage];
}

- (void)requestPage
{
    [ATAPI
     getTicketListWithPage:self.loadedPageIndex + 1
     completion:^(NSDictionary *dic, NSError *error) {
         if (error) {
             // do something
             NSLog(@"%@", error);
         } else {
             self.loadedPageIndex++;
             
             NSArray *tickets = dic[@"list"];
             if (self.loadedPageIndex == 0) {
                 self.tickets = [NSMutableArray array];
             }
             for (NSDictionary *ticket in tickets) {
                 ATTicket *ticketObj = [[ATTicket alloc] initWithDictionary:ticket];
                 [self.tickets addObject:ticketObj];
             }
             
             self.lastFlag = [(NSNumber*)NSNullToNil(dic[@"last_flag"]) boolValue];
             
             if (self.loadedPageIndex == 0) {
                 [self.delegate ticketListDidLoad];
             } else {
                 [self.delegate ticketListMoreDidLoad];
             }
         }
     }];
}

@end
