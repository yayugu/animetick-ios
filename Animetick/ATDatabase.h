//
//  ATDatabase.h
//  Animetick
//
//  Created by Kazuki Akamine on 2013/07/17.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface ATDatabase : NSObject
{
    FMDatabase *db;
}
+ (ATDatabase *) instance;
- (FMDatabase *) getDatabase;
@end
