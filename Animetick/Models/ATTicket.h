@interface ATTicket : NSObject

@property (nonatomic) int titleId;
@property (nonatomic) int count;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *iconPath;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSDate *startAt;
@property (nonatomic, strong) NSDate *endAt;
@property (nonatomic, strong) NSArray *flags;
@property (nonatomic, strong) NSString *chName;
@property (nonatomic) int chNumber;
@property (nonatomic) BOOL watched; // Key-Value Observable

- (id)initWithDictionary:(NSDictionary*)dictionary;
- (NSURL*)iconURL;
- (NSString*)titleWithEpisodeNumberText;
- (NSString*)subTitleText;
- (NSString*)channelText;
- (NSString*)startAtText;
- (NSString*)nearDateLabelText;
- (void)watch;
- (void)unwatch;

@end
