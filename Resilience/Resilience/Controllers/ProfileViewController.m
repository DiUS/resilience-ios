#import <GoogleAnalytics-iOS-SDK/GAIFields.h>
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>
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
@property (nonatomic, weak) UITextField *currentTextField;
@property (nonatomic, strong) Profile *profile;
@property (nonatomic, strong) id tracker;

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
  self.tableView.backgroundColor = [UIColor defaultBackgroundColor];
  self.tracker = [[GAI sharedInstance] defaultTracker];
  [self.tracker set:kGAIScreenName value:@"Profile"];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.firstNameTextField.text = self.profile.firstName;
  self.lastNameTextField.text = self.profile.lastName;
  self.emailTextField.text = self.profile.email;
  self.phoneNumberTextField.text = self.profile.phone;
  [self.tracker send:[[GAIDictionaryBuilder createAppView] build]];
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
  UITableViewCell *cell;
  switch (indexPath.row) {
    case 0:
      cell = [UITableViewCell cellWithName:@"Name" andField:self.firstNameTextField];
      break;
    case 1:
      cell = [UITableViewCell cellWithName:@"Last Name" andField:self.lastNameTextField];
      break;
    case 2:
      cell = [UITableViewCell cellWithName:@"Phone" andField:self.phoneNumberTextField];
      break;
    case 3:
      cell = [UITableViewCell cellWithName:@"Email" andField:self.emailTextField];
      break;
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.row) {
    case 0:
      [self.firstNameTextField becomeFirstResponder];
      break;
    case 1:
      [self.lastNameTextField becomeFirstResponder];
      break;
    case 2:
      [self.phoneNumberTextField becomeFirstResponder];
      break;
    case 3:
      [self.emailTextField becomeFirstResponder];
      break;
  }
}

@end