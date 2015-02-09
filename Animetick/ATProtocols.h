@protocol ATDataSource <UITableViewDataSource>

@required

/**
 @param tableView the \c UITableView.
 @return the number of sections in the current data.
 */
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView; /**< promote to be a required method */

/**
 @param tableView the \c UITableView.
 @param section the section of the current data.
 @return the \c NSObject representation of the current data's section queried.
 */
- (NSObject*) tableView:(UITableView*)tableView objectForSection:(NSInteger)section;
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

@end
