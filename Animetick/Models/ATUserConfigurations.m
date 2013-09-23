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
