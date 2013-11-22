//
//  ATTicketLayout.h
//  Animetick
//
//  Created by Yuya Yaguchi on 11/22/13.
//  Copyright (c) 2013 yayugu. All rights reserved.
//

@class ATTicket;

@interface ATTicketLayout : NSObject

- (instancetype)initWithTicket:(ATTicket*)ticket cellWidth:(CGFloat)cellWidth;
- (CGFloat)height;

- (CGRect)titleRect;
- (CGRect)subTitleRect;
- (NSAttributedString*)titleAttrString;
- (NSAttributedString*)subTitleAttrString;

@end
