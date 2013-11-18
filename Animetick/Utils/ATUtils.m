#import "ATUtils.h"

id NSNullToNil(id value)
{
    return (value != [NSNull null]) ? value : nil;
}