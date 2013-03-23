#import "ProfileViewController.h"
#import "UITextField+Form.h"
#import "UIColor+Resilience.h"
#import "UITableViewCell+Form.h"
#import "Profile.h"

@interface ProfileViewController()

@property (nonatomic, strong) UITextField *firstNameTextField;
@property (nonatomic, strong) UITextField *lastNameTextField;
@property (nonatomic, strong) UITextField *phoneNumberTextField;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) Profile *profile;

@end

@implementation ProfileViewController

- (id)init {
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
    self.title = @"Profile";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem.title = @"Save";
  }
  return self;
}

- (void)loadView {
  [super loadView];
  self.firstNameTextField = [UITextField formTextField:@"First Name"];
  self.lastNameTextField = [UITextField formTextField:@"Last Name"];
  self.phoneNumberTextField = [UITextField numberFormTextField:@"Phone"];
  self.emailTextField = [UITextField emailFormTextField:@"Email"];

  self.profile = [Profile loadProfile];
  self.tableView.backgroundView = nil;
  self.view.backgroundColor = [UIColor defaultBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated {
  self.firstNameTextField.text = self.profile.firstName;
  self.lastNameTextField.text = self.profile.lastName;
  self.emailTextField.text = self.profile.email;
  self.phoneNumberTextField.text = self.profile.phone;
}

- (void)save:(id)save {
  self.profile.firstName = self.firstNameTextField.text;
  self.profile.lastName = self.lastNameTextField.text;
  self.profile.email = self.emailTextField.text;
  self.profile.phone = self.phoneNumberTextField.text;
  [self.profile save];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.row) {
    case 0:
      return [UITableViewCell cellWithName:@"Name" andField:self.firstNameTextField];
    case 1:
      return [UITableViewCell cellWithName:@"Last Name" andField:self.lastNameTextField];
    case 2:
      return [UITableViewCell cellWithName:@"Phone" andField:self.phoneNumberTextField];
    case 3:
      return [UITableViewCell cellWithName:@"Email" andField:self.emailTextField];
  }
  return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 4;
}

@end