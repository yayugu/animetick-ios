//
//  ATAlertView.m
//  Animetick
//
//  Created by yayugu on 2013/09/18.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "ATAlertView.h"

@interface ATAlertView () <UIAlertViewDelegate>

@property (nonatomic, strong) ATAlertViewShowCompletion completion;

@end

@implementation ATAlertView

- (id)initWithTitle:(NSString*)title
            message:(NSString*)message
  cancelButtonTitle:(NSString*)cancelButtonTitle
  otherButtonTitles:(NSString*)otherButtonTitles, ...
{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    if (self) {
        if (otherButtonTitles) {
            va_list argumentList;
            NSString *eachText;
            
            va_start(argumentList, otherButtonTitles);
            while ((eachText = va_arg(argumentList, NSString *))) {
                [self addButtonWithTitle:title];
            }
            va_end(argumentList);
        }
    }
    return self;
}

- (void)showWithCompletion:(ATAlertViewShowCompletion)completion
{
    _completion = completion;
    [self show];
}

#pragma mark - alert view delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    _completion(buttonIndex);
    _completion = nil;
}

@end
