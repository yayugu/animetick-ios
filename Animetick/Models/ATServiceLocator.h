@class ATAuth, ATUserConfigurations;

@interface ATServiceLocator : NSObject

@property (nonatomic, retain) ATAuth *auth;
@property (nonatomic, retain) ATUserConfigurations *userConfigurations;

+ (ATServiceLocator*)sharedLocator;

@end
