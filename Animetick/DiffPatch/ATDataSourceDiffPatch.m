//
//  ATDataSourceDiffPatch.m
//  Animetick
//
//  Created by yayugu on 2015/02/08.
//  Copyright (c) 2015年 yayugu. All rights reserved.
//

#import "ATDataSourceDiffPatch.h"

#import "ATTableViewUpdates.h"


// TODO: diffの構造
// insert or delete or update
// section or column
typedef NS_ENUM(NSUInteger, ATPatchType) {
    ATPatchTypeInsertSection,
    ATPatchTypeUpdateSection,
    ATPatchTypeDeleteSection,
    ATPatchTypeInsertRow,
    ATPatchTypeUpdateRow,
    ATPatchTypeDeleteRow,
};

@interface ATPatch : NSObject
@end

// TODO: cell & sectionのid
// TODO: sectionのtitleなど色々見ないと

@implementation ATDataSourceDiffPatch

+ (void)updateTableView:(UITableView*)tableview from:(id<ATDataSource>)d1 to:(id<ATDataSource>)d2;
{
    ATDataSourceDiffPatch *diffPatch = [[ATDataSourceDiffPatch alloc] init];
    [diffPatch update:tableview from:d1 to:d2];
}

- (void)update:(UITableView*)tableview from:(id<ATDataSource>)d1 to:(id<ATDataSource>)d2
{
    _tableView = tableview;
    
    ATTableViewUpdates* patch = [[ATTableViewUpdates alloc] init];
    BOOL reload = [self diffFrom:d1 to:d2 patch:patch];
    [self applyPatch:patch reloadFlag:reload];
}

- (BOOL)diffFrom:(id<ATDataSource>)d1 to:(id<ATDataSource>)d2 patch:(ATTableViewUpdates*)patch;
{
    NSInteger oldSectionCount = [d1 numberOfSections];
    NSMutableDictionary* oldSectionMap = [[NSMutableDictionary alloc] initWithCapacity:oldSectionCount];
    for (NSInteger i = 0; i < oldSectionCount; i++)
    {
        NSUInteger hash = [d1 hashForSection:i];
        oldSectionMap[@(hash)] = @(i);
    }
    
    NSInteger newSectionCount = [d2 numberOfSections];
    NSMutableDictionary* newSectionMap = [[NSMutableDictionary alloc] initWithCapacity:newSectionCount];
    for (NSInteger i = 0; i < newSectionCount; i++)
    {
        NSUInteger hash = [d2 hashForSection:i];
        newSectionMap[@(hash)] = @(i);
    }
    
    
    return [self _detectSectionUpdates:patch from:d1 to:d2 oldSectionMap:oldSectionMap newSectionMap:newSectionMap];
}


- (BOOL) _detectSectionUpdates:(ATTableViewUpdates*)updates
                          from:(id<ATDataSource>)d1
                            to:(id<ATDataSource>)d2
                 oldSectionMap:(NSDictionary*)oldSectionMap
                 newSectionMap:(NSDictionary*)newSectionMap
{
    NSUInteger oldSectionCount = oldSectionMap.count;
    NSUInteger newSectionCount = newSectionMap.count;
    NSInteger oldIndex = 0;
    NSInteger newIndex = 0;
    NSUInteger oldHash, newHash;

    // Optimize redundant object retrieval
    BOOL repeatOld = NO;
    BOOL repeatNew = NO;
    
    while (true)
    {
        if (!repeatOld)
            oldHash = 0;
        if (!repeatNew)
            newHash = 0;
        if (!oldHash && oldIndex < oldSectionCount)
            oldHash = [d1 hashForSection:oldIndex];
        if (!newHash && newIndex < newSectionCount)
            newHash = [d2 hashForSection:newIndex];
        
        repeatOld = repeatNew = NO;
        
        if (!oldHash && !newHash)
            break;
        
        if (oldHash)
        {
            NSNumber *newIndexToMatchNewId = [newSectionMap objectForKey:@(oldHash)];
            if (!newIndexToMatchNewId)
            {
                [updates.deleteSections addIndex:oldIndex];
                oldIndex++;
                repeatNew = YES;
                continue;
            }
        }
        
        if (newHash)
        {
            NSNumber *oldIndexToMatchNewId = [oldSectionMap objectForKey:@(oldHash)];
            if (!oldIndexToMatchNewId)
            {
                [updates.insertSections addIndex:newIndex];
                newIndex++;
                repeatOld = YES;
                continue;
            }
        }
        
        if (newHash && oldHash)
        {
            BOOL didChange = (oldHash != newHash);
            if (didChange)
            {
                [updates.reloadSections addIndex:oldIndex];
            }
            else
            {
                // check row changes
                if ([self _detectRowUpdates:updates
                                       from:d1
                                         to:d2
                         forPreviousSection:oldIndex
                                    section:newIndex])
                {
                    [updates.reloadSections addIndex:oldIndex];
                }
            }
        }
        
        oldIndex++;
        newIndex++;
    }
    return NO;
}



- (BOOL) _detectRowUpdates:(ATTableViewUpdates*)updates
                      from:(id<ATDataSource>)d1
                        to:(id<ATDataSource>)d2
        forPreviousSection:(NSInteger)oldSection
                   section:(NSInteger)newSection
{
    NSInteger deletes = 0;
    NSInteger reloads = 0;
    NSInteger inserts = 0;
    @autoreleasepool
    {
        NSInteger oldRowCount = [d1 numberOfRowsInSection:oldSection];
        NSMutableDictionary* oldRowMap = [[NSMutableDictionary alloc] initWithCapacity:oldRowCount];
        for (NSInteger i = 0; i < oldRowCount; i++)
        {
            NSUInteger hash = [d1 hashAtIndexPath:[NSIndexPath indexPathForRow:i inSection:oldSection]];
            oldRowMap[@(hash)] = @(i);
        }
        
        NSInteger newRowCount = [d2 numberOfRowsInSection:newSection];
        NSMutableDictionary* newRowMap = [[NSMutableDictionary alloc] initWithCapacity:newRowCount];
        for (NSInteger i = 0; i < newRowCount; i++)
        {
            NSUInteger hash = [d2 hashAtIndexPath:[NSIndexPath indexPathForRow:i inSection:newSection]];
            newRowMap[@(hash)] = @(i);
        }
        
        if (oldRowCount != oldRowMap.count || newRowCount != newRowMap.count) {
            [self rowReloadWithUpdates:updates deletes:deletes inserts:inserts reloads:reloads];
            return YES;
        }
        
        NSInteger oldIndex = 0;
        NSInteger newIndex = 0;
        NSUInteger oldHash, newHash;
        
        // Optimize redundant object retrieval
        BOOL repeatOld = NO;
        BOOL repeatNew = NO;
        
        while (true)
        {
            NSIndexPath* oldPath = [NSIndexPath indexPathForRow:oldIndex inSection:oldSection];
            NSIndexPath* newPath = [NSIndexPath indexPathForRow:newIndex inSection:newSection];
            if (!repeatOld)
                oldHash = 0;
            if (!repeatNew)
                newHash = 0;
            if (!oldHash && oldIndex < oldRowCount)
                oldHash = [d1 hashAtIndexPath:oldPath];
            if (!newHash && newIndex < newRowCount)
                newHash = [d2 hashAtIndexPath:newPath];
            
            repeatOld = repeatNew = NO;
            
            if (!oldHash && !newHash)
                break;
            
            if (oldHash)
            {
                NSNumber* newIndexToMatchOldId = newRowMap[@(oldHash)];
                if (!newIndexToMatchOldId)
                {
                    [updates.deleteRows addObject:oldPath];
                    oldIndex++;
                    deletes++;
                    repeatNew = YES;
                    continue;
                }
            }
            
            if (newHash)
            {
                NSNumber* oldIndexToMatchNewId = oldRowMap[@(newHash)];
                if (!oldIndexToMatchNewId)
                {
                    [updates.insertRows addObject:newPath];
                    newIndex++;
                    inserts++;
                    repeatOld = YES;
                    continue;
                }
            }
            
            if (newHash && oldHash)
            {
                BOOL didChange = (oldHash != newHash);
                if (didChange)
                {
                    [updates.reloadRows addObject:oldPath];
                    reloads++;
                }
            }
            
            oldIndex++;
            newIndex++;
        }
    }
    return NO;
}

- (void) _applyUpdates:(ATTableViewUpdates*)updates
{
    [_tableView beginUpdates];
    if (updates.deleteSections.count > 0)
    {
        [_tableView deleteSections:updates.deleteSections
            withRowAnimation:UITableViewRowAnimationLeft];
    }
    if (updates.deleteRows.count > 0)
    {
        [_tableView deleteRowsAtIndexPaths:updates.deleteRows
                    withRowAnimation:UITableViewRowAnimationLeft];
    }
    if (updates.reloadSections.count > 0)
    {
        [_tableView reloadSections:updates.reloadSections
            withRowAnimation:UITableViewRowAnimationLeft];
    }
    if (updates.reloadRows.count > 0)
    {
        [_tableView reloadRowsAtIndexPaths:updates.reloadRows
                    withRowAnimation:UITableViewRowAnimationLeft];
    }
    if (updates.insertSections.count > 0)
    {
        [_tableView insertSections:updates.insertSections
            withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if (updates.insertRows.count > 0)
    {
        [_tableView insertRowsAtIndexPaths:updates.insertRows
                    withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [_tableView endUpdates];
}

- (void)rowReloadWithUpdates:(ATTableViewUpdates*)updates
                     deletes:(NSInteger)deletes
                     inserts:(NSInteger)inserts
                     reloads:(NSInteger)reloads
{
    // Cleanup our modified lists of changes
    if (deletes)
    {
        [updates.deleteRows removeObjectsInRange:NSMakeRange(updates.deleteRows.count - deletes, deletes)];
    }
    if (inserts)
    {
        [updates.insertRows removeObjectsInRange:NSMakeRange(updates.insertRows.count - inserts, inserts)];
    }
    if (reloads)
    {
        [updates.reloadRows removeObjectsInRange:NSMakeRange(updates.reloadRows.count - reloads, reloads)];
    }
}

- (void)willUpdate
{
    /*
    if ([_updatingDataSource respondsToSelector:@selector(tableViewWillUpdate::)])
    {
        [_updatingDataSource tableViewWillUpdate:self];
    }
     */
}

- (void)didUpdate
{
    /*
    if ([_updatingDataSource respondsToSelector:@selector(tableViewDidUpate:)])
    {
        [_updatingDataSource tableViewDidUpate:self];
    }*/
}

- (void)applyPatch:(ATTableViewUpdates*)patch reloadFlag:(BOOL)reload
{
    @autoreleasepool
    {
        [self willUpdate];
        
        if (!_tableView.window) {
            [_tableView reloadData];
            [self didUpdate];
            return;
        }
        
        if (reload) {
            NSLog(@"something wrong: detectSectionUpdates");
            [_tableView reloadData];
            [self didUpdate];
            return;
        }
        
        @try
        {
            // NSLog(@"%@", updates);
            [self _applyUpdates:patch];
        }
        @catch (NSException *exception)
        {
            NSLog(@"Exception: %@", exception);
            
            [_tableView reloadData];
            [self didUpdate];
            return;
        }
        
        [self didUpdate];
    }
}



@end
