//
//  ATRootViewController.m
//  Animetick
//
//  Created by yayugu on 2013/07/28.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "ATRootViewController.h"

#import "ATLoginViewController.h"
#import "ATAuth.h"

@interface ATRootViewController ()

@property ATAuth *auth;

@end

@implementation ATRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.auth = [[ATAuth alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.auth.sessionId == nil) {
        NSLog(@"session_id: not found.");
        ATLoginViewController *loginViewController = [[ATLoginViewController alloc] init];
        loginViewController.auth = self.auth;
        
        [self.navigationController presentViewController:loginViewController animated:YES completion:nil];
    } else {
        NSLog(@"session_id: %@", self.auth.sessionId);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
