//
//  ATURLConnection.m
//  Animetick
//
//  Created by yayugu on 2013/07/28.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "ATNetworking.h"
#import "ATAuth.h"

@implementation ATNetworking

+ (void)sendRequestWithSubURL:(NSString*)subURL
                   completion:(ATRequestCompletion)completion
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self URLfromSubURL:subURL]];
    [request setAllHTTPHeaderFields:[self header]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:completion];
}

+ (void)sendJSONRequestWithSubURL:(NSString *)subURL
                       completion:(ATJSONRequestCompletion)completion
{
    ATRequestCompletion wrapCompletion = ^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingAllowFragments
                                                              error:&error];
        if (error) {
            completion(nil, error);
            return;
        }
        completion(dic, error);
    };
    [self sendRequestWithSubURL:subURL completion:wrapCompletion];
}

+ (NSURL*)URLfromSubURL:(NSString*)subURL
{
    NSString *fullPath = [ATAnimetickURLString stringByAppendingString:subURL];
    return [NSURL URLWithString:fullPath];
}

+ (NSDictionary*)header
{
    NSString *sessionId = [ATServiceLocator sharedLocator].auth.sessionId;
    NSString *csrfToken = [ATServiceLocator sharedLocator].auth.csrfToken;
    NSDictionary *cookieProperties = @{NSHTTPCookieName: @"_animetick_session",
                                       NSHTTPCookieValue: sessionId,
                                       NSHTTPCookieDomain: @"dev.animetick.net",
                                       NSHTTPCookiePath: @"\\",
                                       NSHTTPCookieExpires: @0};
    NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:cookieProperties];
    NSDictionary *cookieHeader = [NSHTTPCookie requestHeaderFieldsWithCookies:@[cookie]];
    
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    [header addEntriesFromDictionary:cookieHeader];
    header[@"X-CSRF-Token"] = csrfToken;
    
    return header;
}

@end