//
//  ATAuth.h
//  Animetick
//
//  Created by yayugu on 2013/07/27.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

@interface ATAuth : NSObject

@property (nonatomic, strong, readonly) NSString* sessionId;
@property (nonatomic, strong, readonly) NSString* csrfToken;
- (void)setSessionId:(NSString*)sessionId csrfToken:(NSString*)csrfToken;

@end
