//
//  ATTicket.m
//  Animetick
//
//  Created by yayugu on 2013/07/28.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "ATTicket.h"

@implementation ATTicket

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        [self assignValuesWithDictionary:dictionary];
    }
    return self;
}

- (void)assignValuesWithDictionary:(NSDictionary*)dic
{
    self.titleId = [(NSNumber*)dic[@"title_id"] intValue];
    self.count = [(NSNumber*)dic[@"count"] intValue];
    self.title = dic[@"title"];
    self.iconPath = dic[@"icon_path"];
    self.subTitle = dic[@"sub_title"];
    //self.startAt =
    self.chName = dic[@"ch_name"];
    self.chNumber = [(NSNumber*)dic[@"chNumber"] intValue];
}

@end
