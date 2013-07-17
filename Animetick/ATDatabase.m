//
//  ATDatabase.m
//  Animetick
//
//  Created by Kazuki Akamine on 2013/07/17.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "ATDatabase.h"
#import "FMDatabase.h"
#define DBFILE @"animetick.db"

@interface ATDatabase()
- (id) initDatabase;
@end

@implementation ATDatabase

- (id) initDatabase
{
    if (self = [super init])
    {
        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docdir = [pathArray objectAtIndex:0];
        NSString *dbpath = [docdir stringByAppendingPathComponent:DBFILE];
        db = [FMDatabase databaseWithPath:dbpath];
        if (![db open]) {
            NSLog(@"open err: %@", dbpath);
            return NULL;
        }
    }
    return self;
}

+ (ATDatabase *) instance
{
    static ATDatabase *_default = NULL;
    if (_default != NULL)
    {
        return _default;
    }
    static dispatch_once_t safer;
    dispatch_once(&safer, ^(void)
    {
        _default = [[ATDatabase alloc] initDatabase];
    });
    return _default;
}

- (FMDatabase *) getDatabase
{
    return db;
}
@end
