//
//  ATTicketSection.m
//  Animetick
//
//  Created by yayugu on 2014/01/03.
//  Copyright (c) 2014年 yayugu. All rights reserved.
//

#import "ATTicketSection.h"

@implementation ATTicketSection

- (instancetype)copyWithZone:(NSZone *)zone
{
    ATTicketSection *clone = [[[self class] alloc] init];
    clone.title = self.title;
    clone.tickets = [self.tickets copy];
    clone.hashCode = self.hashCode;
    return clone;
}

- (NSUInteger)hash
{
    return _hashCode;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[ATTicketSection class]]) {
        return NO;
    }
    return [self hash] == [object hash];
}

@end