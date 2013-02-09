
#import "AddIncidentViewController.h"
#import "ParseClient.h"
#import "Incident.h"
#import "UITextField+Resilience.h"
#import "UIColor+Resilience.h"
#import "CategorySelectionController.h"
#import "IncidentCategory.h"
#import "Open311Client.h"

@interface AddIncidentViewController() <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIImagePickerController *imgPicker;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UITableView *detailsTableView;
@property (nonatomic, strong) CategorySelectionController *categorySelectionController;
@property (nonatomic, strong) IncidentCategory *category;
@property (nonatomic, strong) UIBarButtonItem *nextButton;
@property (nonatomic, strong) UIBarButtonItem *saveButton;

@end

@implementation AddIncidentViewController

- (id)init {
  if (self = [super init]) {
    self.view.backgroundColor = [UIColor defaultBackgroundColor];
  }
  return self;
}

- (void)viewDidLoad {
  [self.locationManager startUpdatingLocation];
}

- (void)loadView {
  self.view = [[UIView alloc] initWithFrame:CGRectZero];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(dismissAddIssue)];
  self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(progressToIssueDetails)];
  self.saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveIssueAndDismiss)];
  self.navigationItem.rightBarButtonItem = self.nextButton;
  self.navigationItem.rightBarButtonItem.enabled = NO;

  self.cameraButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.cameraButton setTitle:@"Add photo" forState:UIControlStateNormal];
  [self.cameraButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
  self.cameraButton.translatesAutoresizingMaskIntoConstraints = NO;

  self.detailsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
  self.detailsTableView.translatesAutoresizingMaskIntoConstraints = NO;
  self.detailsTableView.dataSource = self;
  self.detailsTableView.delegate = self;
  self.detailsTableView.backgroundView = nil;

  self.nameTextField = [UITextField styledTextField];
  self.nameTextField.placeholder = @"Incident description";
  self.nameTextField.borderStyle = UITextBorderStyleNone;
  self.nameTextField.textColor = [UIColor blackColor];
  self.nameTextField.font = [UIFont systemFontOfSize:14.0];
  self.nameTextField.backgroundColor = [UIColor clearColor];
  self.nameTextField.keyboardType = UIKeyboardTypeDefault;   // use the default type input method (entire keyboard)
  self.nameTextField.returnKeyType = UIReturnKeyDone;
  self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;  // has a clear 'x' button to the right
  [self.nameTextField addTarget:self action:@selector(enableDoneButton) forControlEvents:UIControlEventEditingChanged];
  self.nameTextField.translatesAutoresizingMaskIntoConstraints = NO;

  [self.view addSubview:self.cameraButton];
//  [self.view addSubview:self.nameTextField];
  [self.view addSubview:self.detailsTableView];
//  self.view.translatesAutoresizingMaskIntoConstraints = NO;


  self.categorySelectionController = [[CategorySelectionController alloc] init];
  self.categorySelectionController.delegate = self;

  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
  self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; // 100 m
}

- (void)progressToIssueDetails {
  [self.navigationController pushViewController:self.categorySelectionController animated:YES];
  self.navigationItem.rightBarButtonItem = self.nextButton;

}

- (void)saveIssueAndDismiss {
  Incident *incident = [[Incident alloc] initWithName:self.nameTextField.text
                                          andLocation:self.locationManager.location
                                          andCategory:self.category andDate:[NSDate date] andID:nil];
  [[Open311Client sharedClient] createIncident:incident success:^(Incident *updatedIncident) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"BAM!" message:@"Incident reported" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alertView show];
    [self dismissViewControllerAnimated:YES completion:nil];
  } failure:^(NSError *error) {

  }];

}

- (void)dismissAddIssue {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)takePhoto {
  UIActionSheet *cameraActionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Take Photo", nil),NSLocalizedString(@"Choose photo", nil), nil];
  [cameraActionSheet showInView:self.view];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  self.photo = [info objectForKey:UIImagePickerControllerOriginalImage];
  [self.cameraButton setImage:self.photo forState:UIControlStateNormal];
  [self.imgPicker dismissViewControllerAnimated:YES completion:nil];
  [self enableDoneButton];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  self.imgPicker = [[UIImagePickerController alloc] init];
  self.imgPicker.delegate = self;

  switch (buttonIndex) {
    case 0:
      self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
      break;
    case 1:
      self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
      break;
  }
  if (buttonIndex < 2) {
    [self presentViewController:self.imgPicker animated:YES completion:nil];
  }
}

- (void)enableDoneButton {
  if ([self isValid]) {
    self.navigationItem.rightBarButtonItem.enabled = YES;
  } else{
    self.navigationItem.rightBarButtonItem.enabled = NO;
  }
}

- (BOOL)isValid {
  if (self.photo != nil) {
    return YES;
  }
  return NO;
}

- (void)updateViewConstraints {
  [super updateViewConstraints];
  NSDictionary *views = NSDictionaryOfVariableBindings(_cameraButton, _detailsTableView);
  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"|-[_cameraButton(==100)]"
                              options:0
                              metrics:nil
                                views:views]];
  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"|-[_detailsTableView]-|"
                              options:0
                              metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|-[_cameraButton(==75)]-[_detailsTableView]-|"
                              options:NSLayoutFormatAlignAllLeft
                              metrics:nil
                                views:views]];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];

  switch(indexPath.row) {
    case  0: {
      tableViewCell.textLabel.text = @"Name";
      self.nameTextField.frame = CGRectMake(100,15,150,20);
      [tableViewCell.contentView addSubview:self.nameTextField];
      break;
    }
    case 1: {
      tableViewCell.textLabel.text = @"Category";
      tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      tableViewCell.detailTextLabel.text = self.category ? self.category.name : @"Select category";
      break;
    }
  }

  return tableViewCell;
}

#pragma mark - UITableViewDelegate Methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if(indexPath.row == 1) {
    [self.navigationController pushViewController:self.categorySelectionController animated:YES];
  }
}

#pragma mark - CategorySelectionDelegate methods
- (void)categorySelectionController:(CategorySelectionController *)controller didSelectCategory:(IncidentCategory *)category {
  self.category = category;
  [self.detailsTableView reloadData];
  [self.navigationController popViewControllerAnimated:YES];
}

@end