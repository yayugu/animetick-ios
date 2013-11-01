#define AT_SERVER_NUMBER 0

#if AT_SERVER_NUMBER == 0
static NSString *const ATAnimetickURLString = @"http://animetick.net";
static NSString *const ATAnimetickDomain = @"http://animetick.net";
#endif

#if AT_SERVER_NUMBER == 1
static NSString *const ATAnimetickURLString = @"http://localhost:3000";
static NSString *const ATAnimetickDomain = @"http://localhost";
#endif

static NSString *const ATDidReceiveReauthorizeRequired = @"ATDidReceiveReauthorizeRequired";
static NSString *const ATTicketWatchDidFailed = @"ATTicketWatchDidFailed";
