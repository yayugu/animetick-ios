//
//  ATDataSourceDiffPatch.h
//  Animetick
//
//  Created by yayugu on 2015/02/08.
//  Copyright (c) 2015年 yayugu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATProtocols.h"

@interface ATDataSourceDiffPatch : NSObject

@property(nonatomic, strong) UITableView *tableView;

+ (void)updateTableView:(UITableView*)tableview from:(id<ATDataSource>)d1 to:(id<ATDataSource>)d2;

@end
