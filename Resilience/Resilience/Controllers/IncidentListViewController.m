#import <CoreLocation/CoreLocation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "IncidentListViewController.h"
#import "Incident.h"
#import "ParseClient.h"
#import "IncidentCell.h"
#import "AFNetworking.h"
#import "IncidentViewController.h"
#import "Open311Client.h"
#import "WBErrorNoticeView.h"
#import "WBStickyNoticeView.h"
#import "UIView+WSLoading.h"

@interface IncidentListViewController ()<IncidentViewControllerDelegate>

@property (nonatomic, strong) NSArray *incidents;

@end

@implementation IncidentListViewController

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
  [self loadIncidents];
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)refreshView:(UIRefreshControl *)refresh {
  refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
  [self loadIncidents];

  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"MMM d, h:mm a"];
  NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
  refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
  [refresh endRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

- (void)loadIncidents {
  [self.view showLoading];
  [[Open311Client sharedClient] fetchIncidentsAtCurrentLocation:^(NSArray *incidents) {
    self.incidents = incidents;
    [self.tableView reloadData];
    [self.view hideLoading];
    if(incidents.count == 0) {
      WBStickyNoticeView *noticeView = [[WBStickyNoticeView alloc] initWithView:self.view title:@"No incidents have been reported in your area."];
      noticeView.alpha = 0.9;
      noticeView.floating = YES;
      [noticeView show];
    }
  } failure:^(NSError *error) {
    [self.view hideLoading];
    WBErrorNoticeView *errorView = [[WBErrorNoticeView alloc] initWithView:self.view title:@"Error loading incidents."];
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

  static NSString *CellIdentifier = @"IncidentCell";
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
  IncidentViewController *incidentVC = [[IncidentViewController alloc] init];
  incidentVC.delegate = self;
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:incidentVC];
  incidentVC.incident = incident;
  [self presentViewController:navController animated:YES completion:nil];
}

- (void)detailViewControllerDidResolveIncidentAndClose:(IncidentViewController *)detailViewController {
  [self loadIncidents];
}

@end
