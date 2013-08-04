//
//  ATURLConnection.m
//  Animetick
//
//  Created by yayugu on 2013/07/28.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "ATURLConnection.h"
#import "ATAuth.h"

@implementation ATURLConnection

+ (void)sendRequestWithSubURL:(NSString*)subURL
                   completion:(void (^)(NSURLResponse *response, NSData *data, NSError *error))completion
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self URLfromSubURL:subURL]];
    [request setAllHTTPHeaderFields:[self header]];
    
    [self sendAsynchronousRequest:request
                            queue:[NSOperationQueue mainQueue]
                completionHandler:completion];
}

+ (NSURL*)URLfromSubURL:(NSString*)subURL
{
    NSString *fullPath = [kAnimetickURLString stringByAppendingString:subURL];
    return [NSURL URLWithString:fullPath];
}

+ (NSDictionary*)header
{
    //NSString *sessionId = @"N0tPUGM0RUZIYWUxOWlZVkZpY00rZ2x1bVA1U3NuNTQ0bGUrTFoxVk1MKytyK01xalRNRUFRSVNqb2NLRDhjOVlrVGVQZlN0UVpsK1F4NjdiWTRKV24zdHlSazVwN1NEVjhkS3FuQ2xMNGQzTnVpekN1WVIyWjBOaVJiaFBnK2dXRVNBaTAxOVJ3dEFDbnh1WThML2tLbC9SSGEyZ3p3bld3ZURvUE16S1VXdEYydzVqU3QwL2lNMHhrK2xSZVhSaGJmTU5NT09OV2Q1dGlOc01FckNpTzhLMWZNNFpZQ0hCY3dFSlcyalRSejN2QUlRNGoxcDFaVHo1azdnRmhvYUZkYkdMQVVhLzRwWjhSd1ZVeHBTMlFzL0I3RWFBMVhQUjRmL1pvUjVPYllkQ09KZi9pajhmWHJiRmIwdmsrWEVFWktDUzJsVDFZUzh3c2tDMGpYVTcxM05IUmtzWk0xaWFYbGMyc095MHdEeDZXdjNBd2NOcnBhZ3d5Sm8zTzMzQkpzZTNIWFM1SHdtYjlxRlBhdTNnYXFHZklIaU5SM1RGSWwxTFZlZVFuUi9EOUVJN0JDWTB6bXJrb0ZlaUZMeDBoZmJ3NDB4NDl0cGdOL293YjlaVDZhMkpPZU5kcEdzUmcyRGNFNHlaVUtTV3pudDFtZXJtOCtpeUNJc3IxdEJrTk5uZytQUERLa1ZxN3JkeVh1QkszaytjNXFScHlQYk5GQmEwRFJYQ3NNPS0tTkVGamlDbFpPbndrV0ZFeHppcGxjZz09--bc8c4aaa5928f3d708fc1f8636b9a7fe3c32caf3";
    
    
    // NSHTTPCookieを作成し、それを配列形式として、
    // requestHeaderFieldsWithCookiesを使って、HTTPヘッダへ設定する
    NSString *sessionId = APPDELEGATE.auth.sessionId;
    NSDictionary *cookieProperties = @{NSHTTPCookieName: @"_animetick_session",
                                       NSHTTPCookieValue: sessionId,
                                       NSHTTPCookieDomain: @"dev.animetick.net",
                                       NSHTTPCookiePath: @"\\",
                                       NSHTTPCookieExpires: @0};
    NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:cookieProperties];
    NSDictionary *header = [NSHTTPCookie requestHeaderFieldsWithCookies:@[cookie]];
    return header;
}

@end
