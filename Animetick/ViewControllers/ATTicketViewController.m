#import "ATTicketViewController.h"
#import "ATTicketList.h"
#import "ATTicketCell.h"
#import "UIColor+ATAdditions.h"
#import "ATTicketLayout.h"
#import "ATPaddingIndicator.h"


@interface ATTicketViewController () <ATTicketListDelegate, SWTableViewCellDelegate>

@property (nonatomic, strong) ATTicketList *ticketList;
@property (nonatomic, strong) ATPaddingIndicator *indicator;
@property (nonatomic) BOOL watched;
@property (nonatomic) BOOL firstTimeLayout;

@end

@implementation ATTicketViewController

- (instancetype)initWithWatched:(BOOL)watched
{
    self = [super init];
    if (self) {
        self.watched = watched;
        self.firstTimeLayout = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.ticketList = [[ATTicketList alloc] initWithWatched:self.watched delegate:self];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(pullToRefresh)
                  forControlEvents:UIControlEventValueChanged];
    
    
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"ATPaddingIndicator"
                                                    owner:self
                                                  options:nil];
    self.indicator = bundle[0];
    [self.indicator.indicator setHidesWhenStopped:YES];
    [self.indicator.indicator stopAnimating];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (self.firstTimeLayout) {
        CGFloat topInsets = 20 + self.navigationController.navigationBar.frame.size.height; // status bar height + navigation bar height
        CGFloat bottomInsets = self.tabBarController.tabBar.frame.size.height; // tab bar height
        if (self.tableView.contentOffset.y == 0) {
            self.tableView.contentOffset = (CGPoint) {
                .x = 0,
                .y = - topInsets,
            };
        }
        UIEdgeInsets contentInsets = (UIEdgeInsets){
            .top = topInsets,
            .bottom = bottomInsets,
            .left = 0,
            .right = 0,
        };
        self.tableView.contentInset = contentInsets;
        self.tableView.scrollIndicatorInsets = contentInsets;
        
        self.firstTimeLayout = NO;
    }
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
        cell = [[ATTicketCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:@"ATTicketCell"
                               containingTableView:self.tableView
                                           watched:self.watched];
        cell.delegate = self;
    }
    [self assignCell:cell ValuesWithIndexPath:indexPath];
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ATTicket *ticket = [self.ticketList ticketAtIndex:indexPath.row];
    return [[[ATTicketLayout alloc] initWithTicket:ticket cellWidth:self.view.bounds.size.width] height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ATTicketCell *cell = (ATTicketCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell showRightUtilityButtonsAnimated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetWidthWindow = self.tableView.contentOffset.y + self.tableView.bounds.size.height;
    BOOL leachToBottom = contentOffsetWidthWindow >= self.tableView.contentSize.height;
    if (self.ticketList.count <= 0
        || self.ticketList.lastFlag
        || !leachToBottom
        || [self.indicator.indicator isAnimating]) {
        return;
    }
    [self.ticketList loadMore];
    [self startIndicator];
}

#pragma mark - Refresh control

- (void)pullToRefresh
{
    if (!self.refreshControl.refreshing) return;
    [self.ticketList reload];
}

#pragma mark - Swipable table view cell delegate

- (void)swippableTableViewCell:(ATTicketCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    ATTicket *ticket = cell.ticket;
    if (ticket.watched) {
        [ticket unwatch];
    } else {
        [ticket watch];
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.ticketList removeTicketAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}


#pragma mark - Ticket list delegate

- (void)ticketListDidLoad
{
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    [self endIndicator];
}

- (void)ticketListMoreDidLoad
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    int i = [self.tableView numberOfRowsInSection:0];
    for (; i < self.ticketList.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPaths addObject:indexPath];
    }
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.refreshControl endRefreshing];
    [self endIndicator];
}

- (void)ticketListLoadDidFailed
{
    [self.refreshControl endRefreshing];
    [self endIndicator];
}

#pragma mark - Internals

- (void)assignCell:(ATTicketCell*)cell ValuesWithIndexPath:(NSIndexPath*)indexPath
{
    int index = indexPath.row;
    ATTicket *ticket = [self.ticketList ticketAtIndex:index];
    cell.ticket = ticket;
}

- (void)startIndicator
{
    self.indicator.frame = (CGRect) {
        .origin = {0, 0},
        .size.width = self.view.bounds.size.width,
        .size.height = 40,
    };
    [self.indicator.indicator startAnimating];
    [self.tableView setTableFooterView:self.indicator];
}

- (void)endIndicator
{
    [self.indicator.indicator stopAnimating];
    [self.indicator removeFromSuperview];
    [self.tableView setTableFooterView:nil];
}

@end
