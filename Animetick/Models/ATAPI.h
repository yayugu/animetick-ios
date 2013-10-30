#import "ATNetworking.h"

@interface ATAPI : NSObject

+ (void)getTicketListWithOffset:(int)offset
                        watched:(BOOL)watched
                     completion:(ATJSONRequestCompletion)completion;
+ (void)postTicketWatchWithTitleId:(int)titleId
                      episodeCount:(int)episodeCount
                        completion:(ATJSONRequestCompletion)completion;
+ (void)postTicketUnwatchWithTitleId:(int)titleId
                        episodeCount:(int)episodeCount
                          completion:(ATJSONRequestCompletion)completion;

@end
