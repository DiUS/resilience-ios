#import <CoreLocation/CoreLocation.h>
#import "IssueListViewController.h"
#import "Incident.h"
#import "ParseClient.h"
#import "IncidentCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "IssueViewController.h"

@interface IssueListViewController ()

@property (nonatomic, strong) NSArray *incidents;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;

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
  [[ParseClient sharedClient] fetchIncidents:^(NSArray *incidents) {
    self.incidents = incidents;
    [self.tableView reloadData];
  } failure:^(NSError *error) {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Whoa...!"
                                                      message:[error localizedDescription]
                                                     delegate:nil cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
  }];
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return (NSInteger)self.incidents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  Incident *incident = [self.incidents objectAtIndex:(NSUInteger) indexPath.row];

  static NSString *CellIdentifier = @"IssueCell";
  IncidentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if(!cell)
    cell = [[IncidentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

  cell.nameLabel.text = incident.name;
  cell.locationLabel.text = [NSString stringWithFormat:@"near: %f, %f", incident.location.coordinate.longitude, incident.location.coordinate.latitude];

  cell.timeLabel.text = [NSString stringWithFormat:@"Reported on %@", [self.dateFormatter stringFromDate:incident.updatedDate]];
  cell.photoImageView.image = [self imageForCategory:incident];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 70.;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Incident *incident = [self.incidents objectAtIndex:(NSUInteger) indexPath.row];
    IssueViewController *issueVC = [[IssueViewController alloc] init];
    issueVC.incident = incident;
    [self.navigationController pushViewController:issueVC animated:YES];

}

- (UIImage *)imageForCategory:(Incident *)incident {
  if ([incident.category isEqualToString:@"Fire"]) {
    return [UIImage imageNamed:@"fire"];
  } else if ([incident.category isEqualToString:@"Water"]) {
    return [UIImage imageNamed:@"water"];
  } else if ([incident.category isEqualToString:@"Wind"]) {
    return [UIImage imageNamed:@"air"];
  }
  return nil;
}

-(NSDateFormatter*)dateFormatter
{
    if (_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"HH:mm, dd MMM yyyy"];

    }
    return _dateFormatter;
}
@end
