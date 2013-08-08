//
//  ATURLConnection.h
//  Animetick
//
//  Created by yayugu on 2013/07/28.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

@interface ATNetworking

+ (void)sendRequestWithSubURL:(NSString*)subURL
                   completion:(void (^)(NSURLResponse *response, NSData *data, NSError *error))completion;

@end
