#import "ATTicketViewController.h"
#import "ATTicketList.h"
#import "ATTicketCell.h"
#import "UIColor+ATAdditions.h"
#import "ATTicketLayout.h"
#import "ATPaddingIndicator.h"
#import "ATTicketSection.h"
#import "ATDataSourceDiffPatch.h"

@interface ATTicketViewController () <ATTicketListDelegate, SWTableViewCellDelegate>

@property (nonatomic, strong) ATTicketList *ticketList;
@property (nonatomic, strong) ATTicketList *previousTicketList;
@property (nonatomic, strong) ATDataSourceDiffPatch* diffPatch;
@property (nonatomic, strong) ATPaddingIndicator *indicator;
@property (nonatomic) BOOL watched;
@property (nonatomic) BOOL firstTimeLayout;
@property (nonatomic) CFAbsoluteTime loadMoreStartTime;

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
    
    UITableViewStyle style = self.watched ? UITableViewStylePlain : UITableViewStyleGrouped;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:style];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.estimatedRowHeight = 70;
    self.tableView.rowHeight = UITableViewAutomaticDimension; // value for zero rows
    
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
    
    self.tableView.separatorInset = (UIEdgeInsets) {
        .top = 0,
        .bottom = 0,
        .left = 69,
        .right = 0,
    };
    
    self.diffPatch = [[ATDataSourceDiffPatch alloc] init];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.ticketList.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.ticketList numberOfTicketsInSection:section];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.ticketList titleForSection:section];
}

#pragma mark - Table view delegate

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
    if (self.ticketList.numberOfSections <= 0
        || self.ticketList.lastFlag
        || !leachToBottom
        || [self.indicator.indicator isAnimating]) {
        return;
    }
    [self.ticketList loadMore];
    [self startIndicator];
    self.loadMoreStartTime = CFAbsoluteTimeGetCurrent();
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
    if ([self.ticketList numberOfTicketsInSection:indexPath.section] > 1) {
        [self.ticketList removeTicketAtIndexPath:indexPath];
    } else {
        [self.ticketList removeTicketAtIndexPath:indexPath];
    }
    [self update];
}


#pragma mark - Ticket list delegate

- (void)ticketListDidLoad
{
    [self update];
}

- (void)ticketListMoreDidLoad
{
    // load時間が短すぎると不自然なので、一定時間は待つようにしてloadしてる感を出す
    static const NSTimeInterval loadTimeMin = 0.5;
    NSTimeInterval interval = CFAbsoluteTimeGetCurrent() - self.loadMoreStartTime;
    if (interval < loadTimeMin) {
        [self performSelector:@selector(ticketListMoreDidLoad) withObject:nil afterDelay:(loadTimeMin - interval)];
        return;
    }
    [self update];
}

- (void)ticketListLoadDidFailed
{
    [self endLoading];
}

#pragma mark - Internals

- (void)update
{
    if (self.previousTicketList) {
        [ATDataSourceDiffPatch updateTableView:self.tableView from:self.previousTicketList to:self.ticketList];
    } else {
        [self.tableView reloadData];
    }
    self.previousTicketList = [self.ticketList copy];
    [self endLoading];
}

- (void)endLoading
{
    [self.refreshControl endRefreshing];
    [self endIndicator];
}

- (void)assignCell:(ATTicketCell*)cell ValuesWithIndexPath:(NSIndexPath*)indexPath
{
    ATTicket *ticket = [self.ticketList ticketAtIndexPath:indexPath];
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
