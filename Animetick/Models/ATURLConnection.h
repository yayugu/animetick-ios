//
//  ATURLConnection.h
//  Animetick
//
//  Created by yayugu on 2013/07/28.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATURLConnection : NSURLConnection

+ (void)sendRequestWithSubURL:(NSString*)subURL
                   completion:(void (^)(NSURLResponse *response, NSData *data, NSError *error))completion;

@end
