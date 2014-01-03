//
//  ATTicketSection.h
//  Animetick
//
//  Created by yayugu on 2014/01/03.
//  Copyright (c) 2014年 yayugu. All rights reserved.
//

@interface ATTicketSection : NSObject <NSCopying>

@property (nonatomic, strong) NSArray *tickets;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) NSUInteger hashCode;

@end
