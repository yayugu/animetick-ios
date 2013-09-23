#import "ATNetworking.h"

@interface ATAPI : NSObject

+ (void)getTicketListWithPage:(int)page completion:(ATJSONRequestCompletion)completion;
+ (void)postTicketWatchWithTitleId:(int)titleId
                      episodeCount:(int)episodeCount
                        completion:(ATJSONRequestCompletion)completion;
+ (void)postTicketUnwatchWithTitleId:(int)titleId
                        episodeCount:(int)episodeCount
                          completion:(ATJSONRequestCompletion)completion;

@end
