//
//  ATTicketLayout.h
//  Animetick
//
//  Created by Yuya Yaguchi on 11/22/13.
//  Copyright (c) 2013 yayugu. All rights reserved.
//

@class ATTicket;

static const CGFloat ATTicketLayoutTopPadding = 10;
static const CGFloat ATTicketLayoutBottomPadding = 5;
static const CGFloat ATTicketLayoutRightPadding = 65;
static const CGFloat ATTicketLayoutLeftPadding = 5;

@interface ATTicketLayout : NSObject

- (instancetype)initWithTicket:(ATTicket*)ticket;
- (CGFloat)heigthWithCellWidth:(CGFloat)cellWidth;

@end
