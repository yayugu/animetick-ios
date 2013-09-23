@interface ATAuth : NSObject

@property (nonatomic, strong, readonly) NSString* sessionId;
@property (nonatomic, strong, readonly) NSString* csrfToken;
- (void)setSessionId:(NSString*)sessionId csrfToken:(NSString*)csrfToken;
- (void)clear;

@end
