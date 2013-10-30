//
//  ATTicketSegmentViewController.m
//  Animetick
//
//  Created by yayugu on 2013/10/30.
//  Copyright (c) 2013年 yayugu. All rights reserved.
//

#import "ATTicketSegmentViewController.h"
#import "ATTicketViewController.h"

@interface ATTicketSegmentViewController ()

@property (nonatomic, strong) ATTicketViewController *unwatchedTicketViewContoller;
@property (nonatomic, strong) ATTicketViewController *watchedTicketViewContoller;

@end

@implementation ATTicketSegmentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (ATTicketViewController*)addTicketViewControllerWithWatched:(BOOL)watched
{
    ATTicketViewController *ticketViewController = [[ATTicketViewController alloc] initWithWatched:watched];
    [self addChildViewController:ticketViewController];
    [self didMoveToParentViewController:self];
    return ticketViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.unwatchedTicketViewContoller = [self addTicketViewControllerWithWatched:NO];
    self.watchedTicketViewContoller = [self addTicketViewControllerWithWatched:YES];

    [self.view addSubview:self.unwatchedTicketViewContoller.view];
}

- (IBAction)segmentValueChanged:(id)sender
{
    UISegmentedControl *control = (UISegmentedControl*)sender;
    switch (control.selectedSegmentIndex) {
        case 0:
            [self transitionFromViewController:self.watchedTicketViewContoller
                              toViewController:self.unwatchedTicketViewContoller
                                      duration:0
                                       options:UIViewAnimationOptionTransitionNone
                                    animations:nil
                                    completion:nil];
            break;
        case 1:
            [self transitionFromViewController:self.unwatchedTicketViewContoller
                              toViewController:self.watchedTicketViewContoller
                                      duration:0
                                       options:UIViewAnimationOptionTransitionNone
                                    animations:nil
                                    completion:nil];
            break;
        default:
            break;
    }
}

@end
