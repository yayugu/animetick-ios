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

- (void)setSessionId:(NSString *)sessionId
{
    _sessionId = sessionId;
    [self savePlist];
}

- (void)savePlist
{
    NSDictionary *dic = @{@"sessionId": self.sessionId};
    [dic writeToFile:[self plistPath] atomically:YES];
}

- (void)loadPlist
{
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:[self plistPath]];
    if (dic) {
        _sessionId = dic[@"sessionId"];
    } else {
        _sessionId = nil;
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
