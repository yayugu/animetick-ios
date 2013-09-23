#import "ATAuth.h"

@implementation ATAuth

- (id)init
{
    self = [super init];
    if (self) {
        [self loadPlist];
    }
    return self;
}

- (void)setSessionId:(NSString*)sessionId csrfToken:(NSString*)csrfToken
{
    NSDictionary *dic = @{@"sessionId": sessionId,
                          @"csrfToken": csrfToken};
    [dic writeToFile:[self plistPath] atomically:YES];
    [self loadPlist];
}

- (void)clear
{
    _sessionId = nil;
    _csrfToken = nil;
    NSFileManager *manager = [[NSFileManager alloc] init];
    [manager removeItemAtPath:[self plistPath] error:nil];
}

- (void)loadPlist
{
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:[self plistPath]];
    if (dic) {
        _sessionId = dic[@"sessionId"];
        _csrfToken = dic[@"csrfToken"];
    } else {
        _sessionId = nil;
        _csrfToken = nil;
    }
}

- (NSString*)plistPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"at_auth_%d.plist", AT_SERVER_NUMBER];
    NSString *filePath = [directory stringByAppendingPathComponent:fileName];
    return filePath;
}

@end
