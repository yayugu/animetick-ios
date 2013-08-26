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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveUnauthorizedError:)
                                                 name:ATDidReceiveUnauthorizedError
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([ATServiceLocator sharedLocator].auth.sessionId == nil) {
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
}

- (void)didReceiveUnauthorizedError:(NSNotification*)notification
{
    [[ATServiceLocator sharedLocator].auth clear];
    ATLoginViewController *loginViewController = [[ATLoginViewController alloc] init];
    [self presentViewController:loginViewController animated:YES completion:nil];
}

@end
