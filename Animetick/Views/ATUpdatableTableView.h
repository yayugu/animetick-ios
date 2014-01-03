//
//  ATUpdatableTableView.h
//  Animetick
//
//  Created by yayugu on 2014/01/03.
//  Copyright (c) 2014年 yayugu. All rights reserved.
//

@protocol UITableViewUpdatingDataSource;

@interface ATUpdatableTableView : UITableView
- (void) updateData;
@property (nonatomic, weak) id<UITableViewUpdatingDataSource>updatingDataSource;
@end


@protocol UITableViewUpdatingDataSource <UITableViewDataSource>

@required

/**
 @param tableView the \c UITableView.
 @return the number of sections in the previous data.
 */
- (NSInteger) numberOfPreviousSectionsInTableView:(UITableView*)tableView;
/**
 @param tableView the \c UITableView.
 @return the number of sections in the current data.
 */
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView; /**< promote to be a required method */

/**
 @param tableView the \c UITableView.
 @param section the section of previous data whose row count is to be determined.
 @return the row count of the provided \a section in the previous data.
 */
- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInPreviousSection:(NSInteger)section;
/**
 @param tableView the \c UITableView.
 @param section the section of current data whose row count is to be determined.
 @return the row count of the provided \a section in the current data.
 */
- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section;

/**
 @param tableView the \c UITableView.
 @param section the section of the previous data.
 @return the \c NSObject representation of the previous data's section queried.
 */
- (NSObject*) tableView:(UITableView*)tableView objectForPreviousSection:(NSInteger)section;
/**
 @param tableView the \c UITableView.
 @param section the section of the current data.
 @return the \c NSObject representation of the current data's section queried.
 */
- (NSObject*) tableView:(UITableView*)tableView objectForSection:(NSInteger)section;

/**
 @param tableView the \c UITableView.
 @param indexPath the \c NSIndexPath to the row of the previous data.
 @return the \c NSObject representation of the previous data's row queried using \a indexPath.
 */
- (NSObject*) tableView:(UITableView*)tableView objectAtPreviousIndexPath:(NSIndexPath*)indexPath;
/**
 @param tableView the \c UITableView.
 @param indexPath the \c NSIndexPath to the row of the current data.
 @return the \c NSObject representation of the current data's row queried using \a indexPath.
 */
- (NSObject*) tableView:(UITableView*)tableView objectAtIndexPath:(NSIndexPath*)indexPath;

/**
 Called to determine the unique identification key of a table view data's object.
 @param tableView the \c UITableView.
 @param object the \c NSObject to identify.
 @return the key used for identifying the section object.
 */
- (NSObject<NSCopying>*) tableView:(UITableView*)tableView keyForSectionObject:(NSObject*)object;

/**
 Called to determine the unique identification key of a table view data's object.
 @param tableView the \c UITableView.
 @param object the \c NSObject to identify.
 @return the key used for identifying the row object.
 */
- (NSObject<NSCopying>*) tableView:(UITableView*)tableView keyForRowObject:(NSObject*)object;

@optional
/**
 Called to determine if there was a modification to an object.  If not implemented in the implementing class, \a isEqual: will be used instead.
 If a modification is found, the modified section is reloaded.
 @param tableView the \c UITableView.
 @param previousObject an \c NSObject of the previous data's section.
 @param object an \c NSObject of the current data's section.
 @return \c YES if the objects are equal, \c NO otherwise.
 */
- (BOOL) tableView:(UITableView *)tableView isPreviousSectionObject:(NSObject*)previousObject equalToSectionObject:(NSObject*)object;

/**
 Called to determine if there was a modification to an object.  If not implemented in the implementing class, \a isEqual: will be used instead.
 If a modification is found, the modified row is reloaded.
 @param tableView the \c UITableView.
 @param previousObject an \c NSObject of the previous data's row.
 @param object an \c NSObject of the current data's row.
 @return \c YES if the objects are equal, \c NO otherwise.
 */
- (BOOL) tableView:(UITableView *)tableView isPreviousRowObject:(NSObject*)previousObject equalToRowObject:(NSObject*)object;

/**
 Called as \a updateData starts.  Once this callback is completed, the previous table data MUST be available for all previous data query calls.
 @param tableView the \c UITableView that will update.
 @see tableViewDidUpdate:
 */
- (void) tableViewWillUpdate:(UITableView*)tableView;
/**
 Called when \a updateData is completing.  This is a good spot to unload any memory allocated to maintaining the previous table data.
 @param tableView the \c UITableView that did update.
 @see tableViewWillUpdate:
 */
- (void) tableViewDidUpate:(UITableView*)tableView;

@end

