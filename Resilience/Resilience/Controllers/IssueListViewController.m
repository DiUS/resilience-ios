#import <CoreLocation/CoreLocation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "IssueListViewController.h"
#import "Incident.h"
#import "ParseClient.h"
#import "IncidentCell.h"
#import "AFNetworking.h"
#import "IssueViewController.h"
#import "Open311Client.h"
#import "WBErrorNoticeView.h"
#import "WBStickyNoticeView.h"

@interface IssueListViewController ()

@property (nonatomic, strong) NSArray *incidents;

@end

@implementation IssueListViewController

- (id)init {
  if (self = [super initWithStyle:UITableViewStylePlain]) {
    self.incidents = [[NSArray alloc] init];
    self.tableView.separatorColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
  refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
  [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
  self.refreshControl = refresh;
  [self loadIssues];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)refreshView:(UIRefreshControl *)refresh {
  refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
  [self loadIssues];

  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"MMM d, h:mm a"];
  NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
  refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
  [refresh endRefreshing];
}

- (void)loadIssues {
  [[Open311Client sharedClient] fetchIncidents:^(NSArray *incidents) {
    self.incidents = incidents;
    [self.tableView reloadData];
    if(incidents.count == 0) {
      WBStickyNoticeView *noticeView = [[WBStickyNoticeView alloc] initWithView:self.view title:@"No issues have been reported in your area."];
      noticeView.alpha = 0.9;
      [noticeView show];
    }
  } failure:^(NSError *error) {
    WBErrorNoticeView *errorView = [[WBErrorNoticeView alloc] initWithView:self.view title:@"Error loading issues."];
    errorView.message = error.localizedDescription;
    errorView.alpha = 0.9;
    errorView.floating = YES;
    [errorView show];
  }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return (NSInteger) self.incidents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  Incident *incident = [self.incidents objectAtIndex:(NSUInteger) indexPath.row];

  static NSString *CellIdentifier = @"IssueCell";
  IncidentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell)
    cell = [[IncidentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

  cell.nameLabel.text = incident.name;
  cell.descriptionLabel.text = [NSString stringWithFormat:@"%@", incident.description];

  cell.timeLabel.text = [NSString stringWithFormat:@"Reported on %@", [incident createdDateAsString]];
  [cell.photoImageView setImageWithURL:[incident imageUrlForSize:CGSizeMake(140.f, 140.f)]];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 70.;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  Incident *incident = [self.incidents objectAtIndex:(NSUInteger) indexPath.row];
  IssueViewController *issueVC = [[IssueViewController alloc] init];
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:issueVC];
  issueVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissDetailView:)];
  issueVC.incident = incident;
  [self presentViewController:navController animated:YES completion:nil];
}

- (void)dismissDetailView:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
