//
//  ATURLConnection.h
//  Animetick
//
//  Created by yayugu on 2013/07/28.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

typedef void (^ATRequestCompletion)(NSURLResponse *response, NSData *data, NSError *error);
typedef void (^ATJSONRequestCompletion)(NSDictionary *dictionary, NSError *error);
typedef NS_ENUM(NSUInteger, ATRequestMethod) {
    GET,
    POST
};

@interface ATNetworking : NSObject

+ (void)sendRequestWithSubURL:(NSString*)subURL
                       method:(ATRequestMethod)method
                   completion:(ATRequestCompletion)completion;
+ (void)sendJSONRequestWithSubURL:(NSString *)subURL
                           method:(ATRequestMethod)method
                       completion:(ATJSONRequestCompletion)completion;

@end