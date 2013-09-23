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
