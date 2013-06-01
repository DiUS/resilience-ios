#import <CoreLocation/CoreLocation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <ReactiveCocoa.h>
#import "IssueListViewController.h"
#import "Incident.h"
#import "ParseClient.h"
#import "IncidentCell.h"
#import "AFNetworking.h"
#import "IssueViewController.h"
#import "Open311Client.h"
#import "WBErrorNoticeView.h"
#import "WBStickyNoticeView.h"
#import "LocationManager.h"
#import "UIView+WSLoading.h"

@interface IssueListViewController ()<IssueViewControllerDelegate>

@property (nonatomic, strong) NSArray *incidents;
@property (nonatomic, strong) RACDisposable *currentLocationDisposable;;

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

- (void)viewDidAppear:(BOOL)animated {
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

- (void)viewDidDisappear:(BOOL)animated {
  [self.currentLocationDisposable dispose];
}

- (void)loadIssues {
  [self.view showLoading];
  self.currentLocationDisposable = [[[[[[[LocationManager sharedManager]
          currentLocationSignal]
    takeUntil:[RACSignal interval:1]]
    takeLast:1]
    doNext:^(id location) {
      NSLog(@"location %@", location);
      NSLog(@"received location: %@", location);
      [self loadIssues:location];
    }] doError:^(NSError *error) {
      NSLog(@"Error getting location: %@", error);
      [self loadIssues:nil];
  }]
    subscribeCompleted:^{
    }
  ];
}

- (void)loadIssues:(CLLocation *)location {
  [[Open311Client sharedClient] fetchIncidents:location success:^(NSArray *incidents) {
    self.incidents = incidents;
    [self.tableView reloadData];
    [self.view hideLoading];
    if(incidents.count == 0) {
      WBStickyNoticeView *noticeView = [[WBStickyNoticeView alloc] initWithView:self.view title:@"No issues have been reported in your area."];
      noticeView.alpha = 0.9;
      noticeView.floating = YES;
      [noticeView show];
    }
  } failure:^(NSError *error) {
    [self.view hideLoading];
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
  issueVC.delegate = self;
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:issueVC];
  issueVC.incident = incident;
  [self presentViewController:navController animated:YES completion:nil];
}

- (void)detailViewControllerDidResolveIssueAndClose:(IssueViewController *)detailViewController {
  [self loadIssues];
}

@end
