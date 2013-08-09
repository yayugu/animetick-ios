//
//  ATAPI.h
//  Animetick
//
//  Created by yayugu on 2013/08/09.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "ATNetworking.h"

@interface ATAPI : NSObject

+ (void)getTicketListWithPage:(int)page completion:(ATJSONRequestCompletion)completion;
+ (void)postTicketWatchWithTitleId:(int)titleId
                      episodeCount:(int)episodeCount
                        completion:(ATJSONRequestCompletion)completion;

@end
