//
//  ATTicketList.m
//  Animetick
//
//  Created by yayugu on 2013/07/28.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "ATTicketList.h"
#import "ATURLConnection.h"

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
    NSString *subUrl = [NSString stringWithFormat:@"/ticket/list/%d.json", index];
    [ATURLConnection
     sendRequestWithSubURL:subUrl
     completion:^(NSURLResponse *response, NSData *data, NSError *error) {
         NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingAllowFragments
                                                                  error:nil];
         if (error) {
             // do something
         } else {
             NSArray *tickets = result[@"list"];
             for (NSDictionary *ticket in tickets) {
                 ATTicket *ticketObj = [[ATTicket alloc] initWithDictionary:ticket];
                 [self.tickets addObject:ticketObj];
             }
             [self.delegate ticketListDidUpdated];
         }
     }];
}

@end
