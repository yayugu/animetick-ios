#import "ATSettingViewController.h"
#import "ATAuth.h"
#import "ATUserConfigurations.h"
#import "NSHTTPCookieStorage+ATAdditions.h"

@interface ATSettingViewController ()

- (IBAction)tweetOnWatchSwitchToggled:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *tweetOnWatchSwitch;

@end

@implementation ATSettingViewController

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
    
    self.tweetOnWatchSwitch.on = [ATServiceLocator sharedLocator].userConfigurations.tweetOnWatch;

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"tweet"]) {
        
        // do nothing
        
    } else if ([cell.reuseIdentifier isEqualToString:@"website"]) {
        
        NSURL *url = [NSURL URLWithString:ATAnimetickURLString];
        [[UIApplication sharedApplication] openURL:url];
        
    } else if ([cell.reuseIdentifier isEqualToString:@"logout"]) {
        
        [[ATServiceLocator sharedLocator].auth clear];
        [NSHTTPCookieStorage.sharedHTTPCookieStorage deleteAllCookie];
        [[NSNotificationCenter defaultCenter] postNotificationName:ATDidReceiveReauthorizeRequired object:nil];
        
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)tweetOnWatchSwitchToggled:(id)sender
{
    [ATServiceLocator sharedLocator].userConfigurations.tweetOnWatch = self.tweetOnWatchSwitch.on;
}

@end
