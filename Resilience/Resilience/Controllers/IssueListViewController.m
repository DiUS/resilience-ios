
#import "IssueListViewController.h"
#import "Incident.h"

@interface IssueListViewController ()

@property (nonatomic, strong) NSArray *issues;

@end

@implementation IssueListViewController

- (id)init
{
  if(self = [super initWithStyle:UITableViewStylePlain]) {
    self.issues = @[[[Incident alloc] initWithName:@"mike needs an aws key"], [[Incident alloc] initWithName:@"Zerobot fail"]];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return (NSInteger)self.issues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  Incident *incident = [self.issues objectAtIndex:(NSUInteger)indexPath.row];

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
