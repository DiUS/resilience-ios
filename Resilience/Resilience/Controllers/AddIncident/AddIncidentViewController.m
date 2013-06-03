#import "AddIncidentViewController.h"
#import "ParseClient.h"
#import "Incident.h"
#import "UIColor+Resilience.h"
#import "IncidentCategory.h"
#import "UIImage+FixRotation.h"
#import "ResilientUploader.h"
#import "RACDisposable.h"
#import "LocationManager.h"

@interface AddIncidentViewController() <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) FDTakeController *takeController;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) DetailSelectionController *detailSelectionController;
@property (nonatomic, strong) RACDisposable *currentLocationDisposable;;
@property (nonatomic, strong) IncidentCategory *category;
@property (nonatomic, strong) UIBarButtonItem *nextButton;
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
}

- (void)loadView {
  self.view = [[UIView alloc] initWithFrame:CGRectZero];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissAddIssue)];
  self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(progressToIssueDetails)];
  self.navigationItem.rightBarButtonItem = self.nextButton;
  self.navigationItem.rightBarButtonItem.enabled = NO;

  self.cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
  self.cameraImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Assets/uploadPhoto"]];
  self.cameraImageView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.cameraImageView setContentMode: UIViewContentModeScaleAspectFit];
  self.addPhotoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.addPhotoLabel.text = @"Add photo";
  self.addPhotoLabel.font = [UIFont boldSystemFontOfSize:20.];
  self.addPhotoLabel.textColor = [UIColor darkGreyTextColor];
  self.addPhotoLabel.backgroundColor = [UIColor clearColor];
  self.addPhotoLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [self.cameraButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
  self.view.translatesAutoresizingMaskIntoConstraints = NO;

  [self.view addSubview:self.cameraButton];
  [self.cameraButton addSubview:self.cameraImageView];
  [self.cameraButton addSubview:self.addPhotoLabel];

  self.detailSelectionController = [[DetailSelectionController alloc] init];
  self.detailSelectionController.delegate = self;

}

- (void)viewWillAppear:(BOOL)animated {
  self.cameraButton.frame = self.view.frame;
}

- (void)progressToIssueDetails {
  [self.navigationController pushViewController:self.detailSelectionController animated:YES];
}

- (void)findLocationAndUploadIssue {
  self.currentLocationDisposable = [[[[[[[LocationManager sharedManager]
          currentLocationSignal]
          takeUntil:[RACSignal interval:3]]
          takeLast:1]
          doNext:^(id location) {
            NSLog(@"location %@", location);
            [self queueIncidentForUpload:location];
          }] doError:^(NSError *error) {
            NSLog(@"Error getting location: %@", error);
            [self queueIncidentForUpload:nil];
          }]
          subscribeCompleted:^{
          }
  ];

  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)queueIncidentForUpload:(id)location {
  Incident *incident = [[Incident alloc] initWithName:self.name
                                          andLocation:location
                                          andCategory:self.category
                                              andDate:[NSDate date]
                                                andID:nil andImage:self.photo];

  [[ResilientUploader sharedUploader] saveIncident:incident];
}

- (void)dismissAddIssue {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)takePhoto {
  self.takeController = [[FDTakeController alloc] init];
  self.takeController.viewControllerForPresentingImagePickerController = self;
  [self.takeController takePhotoOrChooseFromLibrary];
  self.takeController.delegate = self;
}

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info {
  self.photo = [photo fixOrientation];
  [self.view setNeedsUpdateConstraints];
  [self enableDoneButton];
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
  NSDictionary *cameraViews = NSDictionaryOfVariableBindings(_addPhotoLabel, _cameraImageView);
  [self.cameraButton addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|-(>=0)-[_cameraImageView]-[_addPhotoLabel]-(>=0)-|"
                              options:NSLayoutFormatAlignAllCenterX
                              metrics:nil
                                views:cameraViews]];

  [self.cameraButton addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"|[_cameraImageView(<=320)]|"
                              options:0
                              metrics:nil
                                views:cameraViews]];

  NSLayoutConstraint *centreXConstraint = [NSLayoutConstraint constraintWithItem:self.cameraImageView
                               attribute:NSLayoutAttributeCenterX
                               relatedBy:NSLayoutRelationEqual
                                  toItem:self.cameraButton
                               attribute:NSLayoutAttributeCenterX
                              multiplier:1.f constant:0.f];

  NSLayoutConstraint *centreYConstraint = [NSLayoutConstraint constraintWithItem:self.cameraImageView
                               attribute:NSLayoutAttributeCenterY
                               relatedBy:NSLayoutRelationEqual
                                  toItem:self.cameraButton
                               attribute:NSLayoutAttributeCenterY
                              multiplier:1.f constant:0.f];
  [self.cameraButton addConstraints:@[centreXConstraint, centreYConstraint]];
}

#pragma mark - CategorySelectionDelegate methods
- (void) detailSelectionController:(DetailSelectionController *)controller didSelectName:(NSString *)name andCategory:(IncidentCategory *)category {
  self.category = category;
  self.name = name;
  [self findLocationAndUploadIssue];
}

@end