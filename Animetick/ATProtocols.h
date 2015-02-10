@protocol ATDataSource

@required

/**
 @return the number of sections in the current data.
 */
- (NSInteger)numberOfSections; /**< promote to be a required method */


- (NSInteger)numberOfRowsInSection:(NSInteger)section;

/**
 @param section the section of the current data.
 @return the \c NSObject representation of the current data's section queried.
 */
- (NSUInteger)hashForSection:(NSInteger)section;

/**
 @param indexPath the \c NSIndexPath to the row of the current data.
 @return the \c NSObject representation of the current data's row queried using \a indexPath.
 */
- (NSUInteger)hashAtIndexPath:(NSIndexPath*)indexPath;

@end
