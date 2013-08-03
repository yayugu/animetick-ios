//
//  ATRootTabController.m
//  Animetick
//
//  Created by Yuya Yaguchi on 8/1/13.
//  Copyright (c) 2013 Kazuki Akamine. All rights reserved.
//

#import "ATRootTabController.h"
#import "ATTicketViewController.h"
#import "ATLoginViewController.h"
#import "ATAuth.h"

@interface ATRootTabController ()

@end

@implementation ATRootTabController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (APPDELEGATE.auth.sessionId == nil) {
        NSLog(@"session_id: not found.");
        ATLoginViewController *loginViewController = [[ATLoginViewController alloc] init];
        
        [self presentViewController:loginViewController animated:YES completion:^{
            [self presentTabs];
        }];
    } else {
        [self presentTabs];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentTabs
{
    ATTicketViewController *ticketViewController = [[ATTicketViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:ticketViewController];
    NSArray *tabs = @[navigationController];
    [self setViewControllers:tabs animated:NO];
    
    NSLog(@"session_id: %@", APPDELEGATE.auth.sessionId);
}

@end
