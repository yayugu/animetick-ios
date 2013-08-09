//
//  ATAPI.m
//  Animetick
//
//  Created by yayugu on 2013/08/09.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "ATAPI.h"

static NSString *const ATAPIFormatTicketList = @"/ticket/list/%d.json";
static NSString *const ATAPIFormatTicketWatch = @"/ticket/%d/%d/watch.json";

@implementation ATAPI

+ (void)getTicketListWithPage:(int)page completion:(ATJSONRequestCompletion)completion
{
    NSString *subURL = [NSString stringWithFormat:ATAPIFormatTicketList, page];
    [ATNetworking sendJSONRequestWithSubURL:subURL completion:completion];
}

+ (void)postTicketWatchWithTitleId:(int)titleId
                      episodeCount:(int)episodeCount
                        completion:(ATJSONRequestCompletion)completion
{
    NSString *subURL = [NSString stringWithFormat:ATAPIFormatTicketWatch, titleId, episodeCount];
    [ATNetworking sendJSONRequestWithSubURL:subURL completion:completion];
}

@end
