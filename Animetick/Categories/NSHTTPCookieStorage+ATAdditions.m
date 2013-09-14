//
//  NSHTTPCookieStorage+ATAdditions.m
//  Animetick
//
//  Created by yayugu on 2013/09/14.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "NSHTTPCookieStorage+ATAdditions.h"

@implementation NSHTTPCookieStorage (ATAdditions)

- (void)deleteAllCookie
{
    NSHTTPCookieStorage *cookieStrage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	for (NSHTTPCookie *cookie in [cookieStrage cookies]) {
		[cookieStrage deleteCookie:cookie];
	}
}

@end
