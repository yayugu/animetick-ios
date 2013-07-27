//
//  ATTicketList.m
//  Animetick
//
//  Created by yayugu on 2013/07/28.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "ATTicketList.h"

@interface ATTicketList()

@property (nonatomic, strong) NSMutableArray *tickets;

@end

@implementation ATTicketList

- (id)init
{
    self = [super init];
    if (self) {
        
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

@end
