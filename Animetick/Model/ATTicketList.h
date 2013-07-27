//
//  ATTicketList.h
//  Animetick
//
//  Created by yayugu on 2013/07/28.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATTicket.h"

@interface ATTicketList : NSObject

- (ATTicket*)ticketAtIndex:(int)index;
- (int)count;
- (void)loadMore;

@end
