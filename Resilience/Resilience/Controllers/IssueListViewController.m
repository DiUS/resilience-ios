
#import "IssueListViewController.h"
#import "Incident.h"
#import "ParseClient.h"

@interface IssueListViewController ()

@property (nonatomic, strong) NSArray *incidents;

@end

@implementation IssueListViewController

- (id)init {
  if (self = [super initWithStyle:UITableViewStylePlain]) {
    self.incidents = [[NSArray alloc] init];
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
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if(!cell)
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

  cell.detailTextLabel.text = incident.name;
  cell.backgroundColor = [UIColor whiteColor];
  [cell.detailTextLabel sizeToFit];
  return cell;
}

@end
