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
    
    int index = indexPath.row;
    ATTicket *ticket = [self.ticketList ticketAtIndex:index];
    [cell.icon setImageWithURL:ticket.iconURL];
    cell.title.text = ticket.title;
    cell.subTitle.text = ticket.subTitle;
    
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

@end
