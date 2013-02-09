
#import "CategorySelectionController.h"
#import "Open311Client.h"
#import "IncidentCategory.h"

@interface CategorySelectionController()

@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSIndexPath *selectedIndex;

@end

@implementation CategorySelectionController

- (id)init {
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
    self.title = @"Category";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(categorySelected:)];
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[Open311Client sharedClient] fetchCategories:^(NSArray *categories) {
    self.categories = categories;
    [self.tableView reloadData];
  } failure:^(NSError *error) {
    NSLog(@"error getting categories");
  }];
}

-(void)categorySelected:(id)sender {
  [self.delegate categorySelectionController:self didSelectCategory:self.categories[(NSUInteger)self.selectedIndex.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"CategoryCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if(!cell)
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

  cell.accessoryType = UITableViewCellAccessoryNone;
  IncidentCategory *category = self.categories[(NSUInteger)indexPath.row];
  cell.detailTextLabel.text = category.name;
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return (NSInteger)[self.categories count];
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.selectedIndex) {
    UITableViewCell *previousCell = [tableView cellForRowAtIndexPath:self.selectedIndex];
    previousCell.accessoryType = UITableViewCellAccessoryNone;
  }

  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  cell.accessoryType = UITableViewCellAccessoryCheckmark;
  self.selectedIndex = indexPath;
}

@end