
#import "AddIncidentViewController.h"
#import "ParseClient.h"
#import "Incident.h"
#import "UITextField+Resilience.h"
#import "UIColor+Resilience.h"
#import "DetailSelectionController.h"
#import "IncidentCategory.h"
#import "Open311Client.h"

@interface AddIncidentViewController() <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIImagePickerController *imgPicker;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) DetailSelectionController *detailSelectionController;
@property (nonatomic, strong) IncidentCategory *category;
@property (nonatomic, strong) UIBarButtonItem *nextButton;
@property (nonatomic, strong) UIBarButtonItem *saveButton;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImageView *cameraImageView;
@property (nonatomic, strong) UILabel *addPhotoLabel;

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

  self.cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
  self.cameraImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Assets/uploadPhoto"]];
  self.cameraImageView.translatesAutoresizingMaskIntoConstraints = NO;
  self.addPhotoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.addPhotoLabel.text = @"Add photo";
  self.addPhotoLabel.font = [UIFont boldSystemFontOfSize:20.];
  self.addPhotoLabel.textColor = [UIColor lightGreyTextColor];
  self.addPhotoLabel.backgroundColor = [UIColor clearColor];
  self.addPhotoLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [self.cameraButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
  self.cameraButton.translatesAutoresizingMaskIntoConstraints = NO;

  [self.view addSubview:self.cameraButton];
  [self.cameraButton addSubview:self.cameraImageView];
  [self.cameraButton addSubview:self.addPhotoLabel];

  self.detailSelectionController = [[DetailSelectionController alloc] init];
  self.detailSelectionController.delegate = self;

  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
  self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; // 100 m
}

- (void)progressToIssueDetails {
  self.navigationItem.rightBarButtonItem = self.saveButton;
  [self.navigationController pushViewController:self.detailSelectionController animated:YES];

}

- (void)saveIssueAndDismiss {
  Incident *incident = [[Incident alloc] initWithName:self.name
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
  self.addPhotoLabel.hidden = YES;
  self.cameraImageView.hidden = YES;
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
  NSDictionary *views = NSDictionaryOfVariableBindings(_cameraButton);
  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"|-[_cameraButton]-|"
                              options:0
                              metrics:nil
                                views:views]];
  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|-[_cameraButton]-|"
                              options:NSLayoutFormatAlignAllLeft
                              metrics:nil
                                views:views]];

  NSDictionary *cameraViews = NSDictionaryOfVariableBindings(_addPhotoLabel, _cameraImageView);
  [self.cameraButton addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|-[_cameraImageView(==128)]-[_addPhotoLabel(==30)]"
                              options:NSLayoutFormatAlignAllCenterX
                              metrics:nil
                                views:cameraViews]];
  [self.cameraButton addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"|[_cameraImageView(==200)]|"
                              options:0
                              metrics:nil
                                views:cameraViews]];
  [self.cameraButton addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"[_addPhotoLabel]"
                              options:0
                              metrics:nil
                                views:cameraViews]];

}

#pragma mark - CategorySelectionDelegate methods
- (void) detailSelectionController:(DetailSelectionController *)controller didSelectName:(NSString *)name andCategory:(IncidentCategory *)category {
  self.category = category;
  self.name = name;
  [self saveIssueAndDismiss];
}

@end