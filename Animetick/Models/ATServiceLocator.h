//
//  ATServiceLocator.h
//  Animetick
//
//  Created by Yuya Yaguchi on 8/8/13.
//  Copyright (c) 2013 Kazuki Akamine. All rights reserved.
//

@class ATAuth, ATUserConfigurations;

@interface ATServiceLocator : NSObject

@property (nonatomic, retain) ATAuth *auth;
@property (nonatomic, retain) ATUserConfigurations *userConfigurations;

+ (ATServiceLocator*)sharedLocator;

@end
