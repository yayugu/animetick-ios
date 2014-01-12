//
//  ATTableViewUpdates.h
//  Animetick
//
//  Created by yayugu on 2014/01/12.
//  Copyright (c) 2014年 yayugu. All rights reserved.
//

@interface ATTableViewUpdates : NSObject

@property (nonatomic, readonly) NSMutableIndexSet* deleteSections;
@property (nonatomic, readonly) NSMutableIndexSet* reloadSections;
@property (nonatomic, readonly) NSMutableIndexSet* insertSections;
@property (nonatomic, readonly) NSMutableArray* deleteRows;
@property (nonatomic, readonly) NSMutableArray* reloadRows;
@property (nonatomic, readonly) NSMutableArray* insertRows;

@end