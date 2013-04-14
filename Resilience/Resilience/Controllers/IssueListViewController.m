#import <CoreLocation/CoreLocation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "IssueListViewController.h"
#import "Incident.h"
#import "ParseClient.h"
#import "IncidentCell.h"
#import "AFNetworking.h"
#import "IssueViewController.h"
#import "Open311Client.h"

@interface IssueListViewController ()

@property (nonatomic, strong) NSArray *incidents;
@property (nonatomic, strong) UIView *errorView;
@property (nonatomic, strong) UILabel *errorLabel;

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

- (void)viewWillAppear:(BOOL)animated {
  [self loadIssues];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
  refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
  [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
  self.refreshControl = refresh;

  self.errorView = [[UIView alloc] initWithFrame:CGRectMake(
          0,
          0,
          self.view.frame.size.width,
          30)];
  UIColor *black = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
  self.errorView.backgroundColor = black;
  self.errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.errorView.frame.size.width - 40, self.errorView.frame.size.height)];
  self.errorLabel.text = @"Error loading issues...";
  self.errorLabel.textColor = [UIColor whiteColor];
  self.errorLabel.backgroundColor = [UIColor clearColor];
  [self.errorView addSubview:self.errorLabel];
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
      [self showErrorView:@"No issues in your area!"];
    }
  } failure:^(NSError *error) {
    [self showErrorView:@"Error loading issues..."];
  }];
}

- (void)showErrorView:(NSString *)error {
  self.errorLabel.text = error;
  [self.view addSubview:self.errorView];
  self.errorView.alpha = 0.0f;
  [UIView animateWithDuration:0.9
                     animations:^{
                       self.errorView.alpha = 1.0f;
                     }
                     completion:nil];
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
  issueVC.incident = incident;
  [self.navigationController pushViewController:issueVC animated:YES];

}

@end
