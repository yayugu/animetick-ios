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

- (void)update:(UITableView*)tableview from:(id<ATDataSource>)d1 to:(id<ATDataSource>)d2
{
    
}

- (void)diffFrom:(id<ATDataSource>)d1 to:(id<ATDataSource>)d2
{
    NSInteger oldSectionCount = [_updatingDataSource numberOfPreviousSectionsInTableView:self];
    NSMutableDictionary* oldSectionMap = [[NSMutableDictionary alloc] initWithCapacity:oldSectionCount];
    
    for (NSInteger i = 0; i < oldSectionCount; i++)
    {
        NSObject *obj = [_updatingDataSource tableView:self objectForPreviousSection:i];
        NSObject<NSCopying> *key = [_updatingDataSource tableView:self keyForSectionObject:obj];
        oldSectionMap[key] = @(i);
    }
    
    NSInteger newSectionCount = [_updatingDataSource numberOfSectionsInTableView:self];
    NSMutableDictionary* newSectionMap = [[NSMutableDictionary alloc] initWithCapacity:newSectionCount];
    
    for (NSInteger i = 0; i < newSectionCount; i++)
    {
        NSObject *obj = [_updatingDataSource tableView:self objectForSection:i];
        NSObject<NSCopying> *key = [_updatingDataSource tableView:self keyForSectionObject:obj];
        newSectionMap[key] = @(i);
    }
    
    ATTableViewUpdates* updates = [[ATTableViewUpdates alloc] init];
    
    BOOL reload = [self _detectSectionUpdates:updates
                       withUpdatingDataSource:_updatingDataSource
                                oldSectionMap:oldSectionMap
                                newSectionMap:newSectionMap];
}

- (void)updateData
{
    @autoreleasepool
    {
        [self willUpdate];
        
        if (!self.window) {
            [self reloadData];
            [self didUpdate];
            return;
        }
        

        
        // diff
        
        if (reload) {
            NSLog(@"something wrong: detectSectionUpdates");
            [self reloadData];
            [self didUpdate];
            return;
        }
        
        @try
        {
            // NSLog(@"%@", updates);
            [self _applyUpdates:updates];
        }
        @catch (NSException *exception)
        {
            NSLog(@"Exception: %@", exception);
            
            [self reloadData];
            [self didUpdate];
            return;
        }
        
        [self didUpdate];
    }
}

- (BOOL) _detectSectionUpdates:(ATTableViewUpdates*)updates
        withUpdatingDataSource:(id<ATTableViewUpdatingDataSource>)updatingDataSource
                 oldSectionMap:(NSDictionary*)oldSectionMap
                 newSectionMap:(NSDictionary*)newSectionMap
{
    NSUInteger oldSectionCount = oldSectionMap.count;
    NSUInteger newSectionCount = newSectionMap.count;
    NSInteger oldIndex = 0;
    NSInteger newIndex = 0;
    NSObject* oldObj, *newObj;
    NSObject<NSCopying>* oldKey, *newKey;
    
    // Optimize redundant object retrieval
    BOOL repeatOld = NO;
    BOOL repeatNew = NO;
    
    while (true)
    {
        if (!repeatOld)
            oldObj = oldKey = nil;
        if (!repeatNew)
            newObj = newKey = nil;
        if (!oldObj && oldIndex < oldSectionCount)
            oldObj = [_updatingDataSource tableView:self objectForPreviousSection:oldIndex];
        if (!newObj && newIndex < newSectionCount)
            newObj = [_updatingDataSource tableView:self objectForSection:newIndex];
        if (!oldKey && oldObj)
            oldKey = [_updatingDataSource tableView:self keyForSectionObject:oldObj];
        if (!newKey && newObj)
            newKey = [_updatingDataSource tableView:self keyForSectionObject:newObj];
        
        repeatOld = repeatNew = NO;
        
        if (!oldKey && !newKey)
            break;
        
        if (oldKey)
        {
            NSNumber *newIndexToMatchNewId = [newSectionMap objectForKey:oldKey];
            if (!newIndexToMatchNewId)
            {
                [updates.deleteSections addIndex:oldIndex];
                oldIndex++;
                repeatNew = YES;
                continue;
            }
        }
        
        if (newKey)
        {
            NSNumber *oldIndexToMatchNewId = [oldSectionMap objectForKey:newKey];
            if (!oldIndexToMatchNewId)
            {
                [updates.insertSections addIndex:newIndex];
                newIndex++;
                repeatOld = YES;
                continue;
            }
        }
        
        if (newKey && oldKey)
        {
            // The order of items was manipulated beyond just additions and removals
            // Bail
            if (![oldKey isEqual:newKey])
            {
                NSLog(@"something wrong: section key equality broken");
                return YES;
            }
            
            BOOL didChange = NO;
            if ([_updatingDataSource respondsToSelector:@selector(tableView:isPreviousSectionObject:equalToSectionObject:)]) {
                didChange = ![_updatingDataSource tableView:self isPreviousSectionObject:oldObj equalToSectionObject:newObj];
            } else {
                didChange = ![oldObj isEqual:newObj];
            }
            
            if (didChange)
            {
                [updates.reloadSections addIndex:oldIndex];
            }
            else
            {
                // check row changes
                if ([self _detectRowUpdates:updates
                             withDataSource:updatingDataSource
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

- (void) _applyUpdates:(ATTableViewUpdates*)updates
{
    [self beginUpdates];
    if (updates.deleteSections.count > 0)
    {
        [self deleteSections:updates.deleteSections
            withRowAnimation:UITableViewRowAnimationLeft];
    }
    if (updates.deleteRows.count > 0)
    {
        [self deleteRowsAtIndexPaths:updates.deleteRows
                    withRowAnimation:UITableViewRowAnimationLeft];
    }
    if (updates.reloadSections.count > 0)
    {
        [self reloadSections:updates.reloadSections
            withRowAnimation:UITableViewRowAnimationLeft];
    }
    if (updates.reloadRows.count > 0)
    {
        [self reloadRowsAtIndexPaths:updates.reloadRows
                    withRowAnimation:UITableViewRowAnimationLeft];
    }
    if (updates.insertSections.count > 0)
    {
        [self insertSections:updates.insertSections
            withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if (updates.insertRows.count > 0)
    {
        [self insertRowsAtIndexPaths:updates.insertRows
                    withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self endUpdates];
}

- (BOOL) _detectRowUpdates:(ATTableViewUpdates*)updates
            withDataSource:(id<ATTableViewUpdatingDataSource>)updatingDataSource
        forPreviousSection:(NSInteger)oldSection
                   section:(NSInteger)newSection
{
    NSInteger deletes = 0;
    NSInteger reloads = 0;
    NSInteger inserts = 0;
    @autoreleasepool
    {
        NSInteger oldRowCount = [updatingDataSource tableView:self numberOfRowsInPreviousSection:oldSection];
        NSMutableDictionary* oldRowMap = [[NSMutableDictionary alloc] initWithCapacity:oldRowCount];
        for (NSInteger i = 0; i < oldRowCount; i++)
        {
            NSObject *obj = [_updatingDataSource tableView:self objectAtPreviousIndexPath:[NSIndexPath indexPathForRow:i inSection:oldSection]];
            NSObject<NSCopying> *key = [_updatingDataSource tableView:self keyForRowObject:obj];
            oldRowMap[key] = @(i);
        }
        
        NSInteger newRowCount = [updatingDataSource tableView:self numberOfRowsInSection:newSection];
        NSMutableDictionary* newRowMap = [[NSMutableDictionary alloc] initWithCapacity:newRowCount];
        for (NSInteger i = 0; i < newRowCount; i++)
        {
            NSObject *obj = [_updatingDataSource tableView:self objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:newSection]];
            NSObject<NSCopying> *key = [_updatingDataSource tableView:self keyForRowObject:obj];
            newRowMap[key] = @(i);
        }
        
        if (oldRowCount != oldRowMap.count || newRowCount != newRowMap.count) {
            [self rowReloadWithUpdates:updates deletes:deletes inserts:inserts reloads:reloads];
            return YES;
        }
        
        NSInteger oldIndex = 0;
        NSInteger newIndex = 0;
        NSObject* oldObj, *newObj;
        NSObject<NSCopying>* oldKey, *newKey;
        
        // Optimize redundant object retrieval
        BOOL repeatOld = NO;
        BOOL repeatNew = NO;
        
        while (true)
        {
            NSIndexPath* oldPath = [NSIndexPath indexPathForRow:oldIndex inSection:oldSection];
            NSIndexPath* newPath = [NSIndexPath indexPathForRow:newIndex inSection:newSection];
            if (!repeatOld)
                oldObj = oldKey = nil;
            if (!repeatNew)
                newObj = newKey = nil;
            if (!oldObj && oldIndex < oldRowCount)
                oldObj = [_updatingDataSource tableView:self objectAtPreviousIndexPath:oldPath];
            if (!newObj && newIndex < newRowCount)
                newObj = [_updatingDataSource tableView:self objectAtIndexPath:newPath];
            if (!oldKey && oldObj)
                oldKey = [_updatingDataSource tableView:self keyForRowObject:oldObj];
            if (!newKey && newObj)
                newKey = [_updatingDataSource tableView:self keyForRowObject:newObj];
            
            repeatOld = repeatNew = NO;
            
            if (!oldKey && !newKey)
                break;
            
            if (oldKey)
            {
                NSNumber* newIndexToMatchOldId = newRowMap[oldKey];
                if (!newIndexToMatchOldId)
                {
                    [updates.deleteRows addObject:oldPath];
                    oldIndex++;
                    deletes++;
                    repeatNew = YES;
                    continue;
                }
            }
            
            if (newKey)
            {
                NSNumber* oldIndexToMatchNewId = oldRowMap[newKey];
                if (!oldIndexToMatchNewId)
                {
                    [updates.insertRows addObject:newPath];
                    newIndex++;
                    inserts++;
                    repeatOld = YES;
                    continue;
                }
            }
            
            if (newKey && oldKey)
            {
                // The order of items was manipulated beyond just additions and removals
                // Bail
                if (![oldKey isEqual:newKey])
                {
                    NSLog(@"something wrong: row key equality");
                    [self rowReloadWithUpdates:updates deletes:deletes inserts:inserts reloads:reloads];
                    return YES;
                }
                
                BOOL didChange = NO;
                if ([_updatingDataSource respondsToSelector:@selector(tableView:isPreviousRowObject:equalToRowObject:)]) {
                    didChange = ![_updatingDataSource tableView:self isPreviousRowObject:oldObj equalToRowObject:newObj];
                } else {
                    didChange = ![oldObj isEqual:newObj];
                }
                
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
    if ([_updatingDataSource respondsToSelector:@selector(tableViewWillUpdate::)])
    {
        [_updatingDataSource tableViewWillUpdate:self];
    }
}

- (void)didUpdate
{
    if ([_updatingDataSource respondsToSelector:@selector(tableViewDidUpate:)])
    {
        [_updatingDataSource tableViewDidUpate:self];
    }
}


@end
