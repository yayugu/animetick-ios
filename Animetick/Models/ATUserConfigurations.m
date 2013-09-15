//
//  ATUserConfigurations.m
//  Animetick
//
//  Created by yayugu on 2013/09/15.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "ATUserConfigurations.h"

@implementation ATUserConfigurations

- (void)setTweetOnWatch:(BOOL)tweetOnWatch
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:tweetOnWatch forKey:@"ATTweetOnWatch"];
    [userDefaults synchronize];
}

- (BOOL)tweetOnWatch
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:@{@"ATTweetOnWatch": @NO}];
    return [userDefaults boolForKey:@"ATTweetOnWatch"];
}

@end
