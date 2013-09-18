
#import "DetailSelectionController.h"
#import "Open311Client.h"
#import "IncidentCategory.h"
#import "UITextField+Resilience.h"
#import "UIColor+Resilience.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface DetailSelectionController ()

@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSIndexPath *selectedIndex;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) id tracker;

@end

@implementation DetailSelectionController

- (id)init {
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
    self.title = @"Details";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(categorySelected:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
  }
  return self;
}

- (void)loadView {
  [super loadView];
  self.nameTextField = [UITextField styledTextField];
  self.nameTextField.placeholder = @"Incident description";
  self.nameTextField.borderStyle = UITextBorderStyleNone;
  self.nameTextField.textColor = [UIColor darkGreyTextColor];
  self.nameTextField.font = [UIFont systemFontOfSize:16.0];
  self.nameTextField.backgroundColor = [UIColor clearColor];
  self.nameTextField.keyboardType = UIKeyboardTypeDefault;   // use the default type input method (entire keyboard)
  self.nameTextField.returnKeyType = UIReturnKeyDone;
  self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;  // has a clear 'x' button to the right
  self.nameTextField.textAlignment = NSTextAlignmentLeft;
  [self.nameTextField addTarget:self
                     action:@selector(textFieldFinished:)
           forControlEvents:UIControlEventEditingDidEndOnExit];

  self.tableView.backgroundView = nil;
  self.view.backgroundColor = [UIColor defaultBackgroundColor];
  self.tracker = [[GAI sharedInstance] defaultTracker];
  [self.tracker set:kGAIScreenName value:@"Add Incident Detail"];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.tracker send:[[GAIDictionaryBuilder createAppView] build]];
  [[Open311Client sharedClient] fetchCategories:^(NSArray *categories) {
    self.categories = categories;
    [self.tableView reloadData];
  } failure:^(NSError *error) {
    NSLog(@"error getting categories");
  }];
}

-(void)categorySelected:(id)sender {
  [self.delegate detailSelectionController:self didSelectName:self.nameTextField.text andCategory:self.categories[(NSUInteger)self.selectedIndex.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    UITableViewCell *tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    tableViewCell.textLabel.text = @"Name";
    self.nameTextField.frame = CGRectMake(100,12,190,30);
    self.nameTextField.textColor = [UIColor darkGreyTextColor];
    [tableViewCell.contentView addSubview:self.nameTextField];
    return tableViewCell;
  }

  static NSString *CellIdentifier = @"CategoryCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if(!cell)
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

  cell.accessoryType = UITableViewCellAccessoryNone;
  IncidentCategory *category = self.categories[(NSUInteger)indexPath.row];
  cell.detailTextLabel.text = category.name;
  return cell;
}

- (void)enableDoneButton {
  if ([self isValid]) {
    self.navigationItem.rightBarButtonItem.enabled = YES;
  } else{
    self.navigationItem.rightBarButtonItem.enabled = NO;
  }
}

- (BOOL)isValid {
  if ((self.nameTextField.text && ![self.nameTextField.text isEqualToString:@""]) && self.selectedIndex ) {
    return YES;
  }
  return NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 1;
  }
  return (NSInteger)[self.categories count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 1) {
    return @"Category";
  }
  return nil;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if(indexPath.section == 0) {
    [self.nameTextField becomeFirstResponder];
  }
  if (indexPath.section == 1) {
    if (self.selectedIndex) {
      UITableViewCell *previousCell = [tableView cellForRowAtIndexPath:self.selectedIndex];
      previousCell.accessoryType = UITableViewCellAccessoryNone;
    }

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.selectedIndex = indexPath;
    [self.nameTextField resignFirstResponder];
  }
  [self enableDoneButton];
}

- (void)textFieldFinished:(id)sender {
  [self enableDoneButton];
  [sender resignFirstResponder];
}

@end