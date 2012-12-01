
#import "AddIncidentViewController.h"
#import "ParseClient.h"
#import "Incident.h"

@interface AddIncidentViewController() <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIImagePickerController *imgPicker;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *categoryTextField;
@property (nonatomic, strong) UITextField *subcategoryTextField;
@property (nonatomic, strong) UITextField *notesTextField;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation AddIncidentViewController

- (id)init {
  if (self = [super init]) {
    self.view.backgroundColor = [UIColor colorWithRed:245. green:245. blue:245. alpha:1];
  }
  return self;
}

- (void)viewDidLoad {
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(dismissAddIssue)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveIssueAndDismiss)];
  self.navigationItem.rightBarButtonItem.enabled = NO;

  self.cameraButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.cameraButton setTitle:@"Add photo" forState:UIControlStateNormal];
  [self.cameraButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];

  self.cameraButton.frame = CGRectMake(10, 10, 100, 100);

  self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 30, 190, 44)];
  self.nameTextField.placeholder = @"Incident description";
  [self.nameTextField addTarget:self action:@selector(enableDoneButton) forControlEvents:UIControlEventEditingChanged];

  [self.view addSubview:self.cameraButton];
  [self.view addSubview:self.nameTextField];

  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
  self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; // 100 m
  [self.locationManager startUpdatingLocation];
}

- (void)saveIssueAndDismiss {
  [[ParseClient sharedClient] updloadImage:self.photo andIncident:[
          [Incident alloc] initWithName:self.nameTextField.text
                            andLocation:self.locationManager.location
                            andCategory:@"Water" andDate:[NSDate date] andID:nil]];

  [self dismissViewControllerAnimated:YES completion:nil];
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
  [self presentViewController:self.imgPicker animated:YES completion:nil];
}

- (void)enableDoneButton {
  if ([self isValid]) {
    self.navigationItem.rightBarButtonItem.enabled = YES;
  } else{
    self.navigationItem.rightBarButtonItem.enabled = NO;
  }
}

- (BOOL)isValid {
  if (self.photo != nil && self.nameTextField.text.length > 0) {
    return YES;
  }
  return NO;
}

@end