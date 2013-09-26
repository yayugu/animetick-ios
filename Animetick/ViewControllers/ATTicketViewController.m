#import "ATTicketViewController.h"
#import "ATTicketList.h"
#import "ATTicketCell.h"

@interface ATTicketViewController () <ATTicketListDelegate>

@property (nonatomic, strong) ATTicketList *ticketList;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

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
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.indicator setColor:[UIColor darkGrayColor]];
    [self.indicator setHidesWhenStopped:YES];
    [self.indicator stopAnimating];
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
    ATTicket *ticket = [self.ticketList ticketAtIndex:indexPath.row];
    if (ticket.watched) {
        [ticket unwatch];
    } else {
        [ticket watch];
    }

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
        || [self.indicator isAnimating]) {
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
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
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
    [self.indicator startAnimating];
    CGRect footerFrame = self.tableView.tableFooterView.frame;
    footerFrame.size.height += 10.0f;
    [self.indicator setFrame:footerFrame];
    [self.tableView setTableFooterView:self.indicator];
}

- (void)endIndicator
{
    [self.indicator stopAnimating];
    [self.indicator removeFromSuperview];
    [self.tableView setTableFooterView:nil];
}

@end
