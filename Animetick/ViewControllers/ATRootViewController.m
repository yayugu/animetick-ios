//
//  ATRootViewController.m
//  Animetick
//
//  Created by yayugu on 2013/07/28.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "ATRootViewController.h"

#import "ATLoginViewController.h"
#import "ATTicketViewController.h"
#import "ATAuth.h"

@interface ATRootViewController ()

@end

@implementation ATRootViewController

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
    
    if (APPDELEGATE.auth.sessionId == nil) {
        NSLog(@"session_id: not found.");
        ATLoginViewController *loginViewController = [[ATLoginViewController alloc] init];
        
        [self.navigationController presentViewController:loginViewController animated:YES completion:nil];
    } else {
        ATTicketViewController *ticketViewController = [[ATTicketViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:ticketViewController animated:NO];
        NSLog(@"session_id: %@", APPDELEGATE.auth.sessionId);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
