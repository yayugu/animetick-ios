//
//  ATTableViewUpdates.m
//  Animetick
//
//  Created by yayugu on 2014/01/12.
//  Copyright (c) 2014年 yayugu. All rights reserved.
//

#import "ATTableViewUpdates.h"

@implementation ATTableViewUpdates

- (instancetype)init
{
    if (self = [super init])
    {
        _deleteSections = [[NSMutableIndexSet alloc] init];
        _reloadSections = [[NSMutableIndexSet alloc] init];
        _insertSections = [[NSMutableIndexSet alloc] init];
        _deleteRows = [[NSMutableArray alloc] init];
        _reloadRows = [[NSMutableArray alloc] init];
        _insertRows = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
