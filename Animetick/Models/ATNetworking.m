#import "ATNetworking.h"
#import "ATAuth.h"

@implementation ATNetworking

+ (void)sendRequestWithSubURL:(NSString*)subURL
                       method:(ATRequestMethod)method
                   completion:(ATRequestCompletion)completion
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self URLfromSubURL:subURL]];
    [request setAllHTTPHeaderFields:[self header]];
    [request setHTTPMethod:(method == POST ? @"POST" : @"GET")];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:completion];
}

+ (void)sendJSONRequestWithSubURL:(NSString *)subURL
                           method:(ATRequestMethod)method
                       completion:(ATJSONRequestCompletion)completion
{
    ATRequestCompletion wrapCompletion = ^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSInteger statusCode = ((NSHTTPURLResponse*)response).statusCode;
            if (statusCode == 401) {
                // Unauthorized
                [[NSNotificationCenter defaultCenter] postNotificationName:ATDidReceiveReauthorizeRequired
                                                                    object:nil];
            }
            completion(nil, error);
            return;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                                                              error:&error];
        if (error) {
            completion(dic, error);
            return;
        }
        completion(dic, error);
    };
    [self sendRequestWithSubURL:subURL method:method completion:wrapCompletion];
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
                                       NSHTTPCookieDomain: ATAnimetickDomain,
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
