//
//  ATTicketViewController.m
//  Animetick
//
//  Created by yayugu on 2013/07/28.
//  Copyright (c) 2013年 Kazuki Akamine. All rights reserved.
//

#import "ATTicketViewController.h"
#import "ATTicketList.h"
#import "ATTicketCell.h"
#import "ATTicketWatchButton.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ATTicketViewController () <ATTicketListDelegate>

@property (nonatomic, strong) ATTicketList *ticketList;

@end

@implementation ATTicketViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.ticketList = [[ATTicketList alloc] initWithDelegate:self];
    [self.tableView registerNib:[UINib nibWithNibName:@"ATTicketCell" bundle:nil] forCellReuseIdentifier:@"ATTicketCell"];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(pullToRefresh)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.ticketList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ATTicketCell";
    ATTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ATTicketCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ATTicketCell"];
    }
    [self assignCell:cell ValuesWithIndexPath:indexPath];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Ticket list delegate

- (void)ticketListDidUpdated
{
    NSLog(@"%d", self.ticketList.count);
    
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

#pragma mark - Refresh controll

- (void)pullToRefresh
{
    if (!self.refreshControl.refreshing) return;
    [self.ticketList reload];
}

#pragma mark - Watch button

- (void)onTicketWatchButtonLongPress:(ATTicketWatchButton*)button
{
    ATTicket *ticket = [self.ticketList ticketAtIndex:button.tag];
    if (button.checked) {
        [ticket unwatch];
    } else {
        [ticket watch];
    }
    button.checked = !button.checked;
    NSLog(@"watch button tapped: %d", button.tag);
}

#pragma mark - Internals

- (void)assignCell:(ATTicketCell*)cell ValuesWithIndexPath:(NSIndexPath*)indexPath
{
    int index = indexPath.row;
    ATTicket *ticket = [self.ticketList ticketAtIndex:index];
    [cell.icon setImageWithURL:ticket.iconURL];
    cell.title.text = ticket.title;
    cell.subTitle.text = ticket.subTitle;
    cell.startAt.text = ticket.startAtText;
    cell.channel.text = ticket.channelText;
    
    ((ATTicketWatchButton*)cell.watchButton).checked = ticket.watched;
    cell.watchButton.tag = index;
    
    if (cell.watchButton.allTargets.count == 0) {
        [cell.watchButton addTarget:self
                             action:@selector(onTicketWatchButtonLongPress:)
                   forControlEvents:ATTicketWatchButtonEventLongPress];
    }
}

@end
