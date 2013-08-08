//
//  ATAuth.m
//  Animetick
//
//  Created by yayugu on 2013/07/27.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "ATAuth.h"

@implementation ATAuth

- (id)init
{
    self = [super init];
    if (self) {
        [self loadPlist];
    }
    return self;
}

- (void)setSessionId:(NSString*)sessionId csrfToken:(NSString*)csrfToken
{
    NSDictionary *dic = @{@"sessionId": sessionId,
                          @"csrfToken": csrfToken};
    [dic writeToFile:[self plistPath] atomically:YES];
    [self loadPlist];
}

- (void)loadPlist
{
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:[self plistPath]];
    if (dic) {
        _sessionId = dic[@"sessionId"];
        _csrfToken = dic[@"csrfToken"];
    } else {
        _sessionId = nil;
        _csrfToken = nil;
    }
}

- (NSString*)plistPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    NSString *filePath = [directory stringByAppendingPathComponent:@"at_auth.plist"];
    return filePath;
}

@end
