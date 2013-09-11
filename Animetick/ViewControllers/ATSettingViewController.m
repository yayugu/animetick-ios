//
//  ATSettingViewController.m
//  Animetick
//
//  Created by yayugu on 2013/09/09.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "ATSettingViewController.h"

@interface ATSettingViewController ()

- (IBAction)tweetOnWatchSwitchToggled:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *tweetOnWatchSwitch;

@end

@implementation ATSettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tweetOnWatchSwitch.on = NO;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

- (IBAction)tweetOnWatchSwitchToggled:(id)sender {
}

@end
