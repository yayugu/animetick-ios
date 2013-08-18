//
//  ATTicket.h
//  Animetick
//
//  Created by yayugu on 2013/07/28.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

@interface ATTicket : NSObject

@property (nonatomic) int titleId;
@property (nonatomic) int count;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *iconPath;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSDate *startAt;
@property (nonatomic, strong) NSArray *flags;
@property (nonatomic, strong) NSString *chName;
@property (nonatomic) int chNumber;
@property (nonatomic) BOOL watched;

- (id)initWithDictionary:(NSDictionary*)dictionary;
- (NSURL*)iconURL;
- (NSString*)channelText;
- (NSString*)startAtText;
- (void)watch;
- (void)unwatch;

@end