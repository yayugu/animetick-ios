#import "ATServiceLocator.h"

@implementation ATServiceLocator

+ (id)sharedLocator
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
