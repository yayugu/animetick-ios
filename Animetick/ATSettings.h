//
//  ATSettings.h
//  Animetick
//
//  Created by yayugu on 2013/08/04.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#define AT_SERVER 1

#if AT_SERVER == 0
static NSString *const ATAnimetickURLString = @"http://animetick.net";
static NSString *const ATAnimetickDomain = @"http://animetick.net";
#endif

#if AT_SERVER == 1
static NSString *const ATAnimetickURLString = @"http://kazz187:h8xelpr1@dev.animetick.net";
static NSString *const ATAnimetickDomain = @"http://dev.animetick.net";
#endif

#if AT_SERVER == 2
static NSString *const ATAnimetickURLString = @"http://localhost:3000";
static NSString *const ATAnimetickDomain = @"http://localhost";
#endif

static NSString *const ATDidReceiveUnauthorizedError = @"ATDidReceiveUnauthorizedError";