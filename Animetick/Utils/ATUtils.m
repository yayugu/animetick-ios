#import "ATUtils.h"

id NSNullToNil(id value)
{
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}