#import "IncidentViewController.h"
#import "UIColor+Resilience.h"
#import "WaypointAnnotation.h"
#import "UIImageView+AFNetworking.h"
#import "IncidentDetails.h"
#import "UIImage+Tileable.h"
#import "Open311Client.h"
#import <QuartzCore/QuartzCore.h>
#import <NoticeView/WBErrorNoticeView.h>
#import <CoreGraphics/CoreGraphics.h>

static const float IMAGE_HEIGHT = 175.f;


@interface SwitchView : UIView

@end

@implementation SwitchView

- (CGSize)intrinsicContentSize {
  return CGSizeMake(200, 20);
}

@end

@interface IncidentViewController ()<UIAlertViewDelegate>
@property(nonatomic, strong) UIImageView *warnImage;
@property(nonatomic, strong) UIView *imageViewSurround;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) MKMapView *incidentMap;
@property(nonatomic, strong) IncidentDetails *footerView;
@property(nonatomic, strong) UIButton *mapButton;
@property(nonatomic, strong) UIButton *pictureButton;
@property(nonatomic, strong) UIView *switchButtons;
@end

@implementation IncidentViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self data];
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)loadView {
  [self components];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - delegate methods
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
  MKAnnotationView *annotationView = [views objectAtIndex:0];
  MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotationView.annotation.coordinate, 5000, 5000);
  [mapView setRegion:region];
}


#pragma mark - Private Methods

- (void)data {
  if (self.incident.imageUrl) {
    [self.imageView setImageWithURL:[self.incident imageUrlForSize:CGSizeMake(self.view.bounds.size.width, IMAGE_HEIGHT)]];
  }

  [self.footerView populateWithIncident:self.incident];

  WaypointAnnotation *annotation = [WaypointAnnotation annotationWithCoordinate:self.incident.location.coordinate];
  annotation.title = self.incident.name;
  annotation.subtitle = [self.incident createdDateAsString];
  annotation.ID = self.incident.id;
  [self.incidentMap addAnnotation:annotation];
}

- (void)components {
  self.view = [[UIView alloc] initWithFrame:CGRectZero];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissView:)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Resolve" style:UIBarButtonItemStyleDone target:self action:@selector(promptToResolveIncident:)];
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Assets/BackgroundTexture"]];

  UIImage *warningImage = [UIImage imageNamed:@"Assets/IncidentDetailsBackground"];
  UIImage *resizableWarningImage = [warningImage stretchableImageWithLeftCapWidth:1 topCapHeight:1];
  self.warnImage = [[UIImageView alloc] initWithImage:resizableWarningImage];
  [self.view addSubview:self.warnImage];

  self.switchButtons = [[SwitchView alloc] initWithFrame:CGRectZero];
  [self.view addSubview:self.switchButtons];

  self.mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
  self.mapButton.frame = CGRectMake(0., 0., 88, 29);
  [self.mapButton setBackgroundImage:[UIImage imageNamed:@"Assets/LeftControlDeselected"] forState:UIControlStateNormal];
  [self.mapButton setBackgroundImage:[UIImage imageNamed:@"Assets/LeftControlSelected"] forState:UIControlStateSelected];
  [self.mapButton addTarget:self action:@selector(selectMapView) forControlEvents:UIControlEventTouchUpInside];
  [self.mapButton setTitle:@"Map" forState:UIControlStateNormal];
  [self.mapButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
  [self.mapButton setTitleColor:[UIColor titleTextColor] forState:UIControlStateNormal];
  [self.switchButtons addSubview:self.mapButton];

  self.pictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
  self.pictureButton.frame = CGRectMake(89., 0., 89, 29);
  [self.pictureButton setBackgroundImage:[UIImage imageNamed:@"Assets/RightControlDeselected"] forState:UIControlStateNormal];
  [self.pictureButton setBackgroundImage:[UIImage imageNamed:@"Assets/RightControlSelected"] forState:UIControlStateSelected];
  [self.pictureButton setTitle:@"Picture" forState:UIControlStateNormal];
  [self.pictureButton addTarget:self action:@selector(selectPictureView) forControlEvents:UIControlEventTouchUpInside];
  [self.pictureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
  [self.pictureButton setTitleColor:[UIColor titleTextColor] forState:UIControlStateNormal];
  self.pictureButton.selected = YES;
  [self.switchButtons addSubview:self.pictureButton];

  self.imageView = [[UIImageView alloc] initWithImage:nil];
  self.imageView.contentMode = UIViewContentModeScaleAspectFill;
  self.imageView.clipsToBounds = YES;
  [self.imageViewSurround addSubview:self.imageView];
  [self.view addSubview:self.imageView];

  self.footerView = [[IncidentDetails alloc] initWithFrame:CGRectZero];
  [self.view addSubview:self.footerView];

  self.navigationItem.title = @"Incident Details";
  
  self.incidentMap = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 350, 200)];
  self.incidentMap.delegate = self;
  self.incidentMap.scrollEnabled = NO;
  
  self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
  self.incidentMap.translatesAutoresizingMaskIntoConstraints = NO;
  self.footerView.translatesAutoresizingMaskIntoConstraints = NO;
  self.warnImage.translatesAutoresizingMaskIntoConstraints = NO;
  self.imageViewSurround.translatesAutoresizingMaskIntoConstraints = NO;
  self.switchButtons.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)selectPictureView {
  [self.incidentMap removeFromSuperview];
  [self.view addSubview:self.imageView];
  self.pictureButton.selected = YES;
  self.mapButton.selected = NO;
  [self.view setNeedsUpdateConstraints];
}

- (void)selectMapView {
  [self.imageView removeFromSuperview];
//  self.issueMap s
  [self.view addSubview:self.incidentMap];
  self.pictureButton.selected = NO;
  self.mapButton.selected = YES;
  [self.view setNeedsUpdateConstraints];
}


- (void)updateViewConstraints {
  [super updateViewConstraints];

  UIView *displayView = nil;
  if (self.mapButton.selected) {
    displayView = self.incidentMap;
  } else {
    displayView = self.imageView;
  }
  NSDictionary *views = NSDictionaryOfVariableBindings(displayView, _footerView, _warnImage, _switchButtons);

  NSString *verticalConstraints = [NSString stringWithFormat:@"V:|-8-[displayView(==%f)]-[_switchButtons(30@1000)]-[_footerView]|", IMAGE_HEIGHT];
  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:verticalConstraints
                              options:0
                              metrics:nil views:views]];

  NSLayoutConstraint* cn = [NSLayoutConstraint constraintWithItem:self.switchButtons
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.0
                                                         constant:0];
  [self.view addConstraint:cn];

  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|[_footerView]|"
                              options:0
                             metrics:nil views:views]];

  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|-8-[displayView]-8-|"
                              options:0
                              metrics:nil views:views]];

  [self.view addConstraints:[NSLayoutConstraint
                             constraintsWithVisualFormat:@"H:|-8-[_warnImage]-3-|"
                             options:0
                             metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint
                             constraintsWithVisualFormat:@"V:|-8-[_warnImage]-3-|"
                             options:0
                             metrics:nil views:views]];

  [self.imageView setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];

}

- (void)dismissView:(id)dismissView {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)promptToResolveIncident:(id)incidentView {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Resolve incident" message:@"Are you sure you want to mark this incident as resolved?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
  [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
  if(buttonIndex == 1) {
    [self resolveIncident];
  }
}

- (void)resolveIncident {
  [[Open311Client sharedClient] resolveIncident:self.incident success:^{
    [self.delegate detailViewControllerDidResolveIncidentAndClose:self];
    [self dismissViewControllerAnimated:YES completion:nil];
  } failure:^(NSError *error) {
    WBErrorNoticeView *errorView = [[WBErrorNoticeView alloc] initWithView:self.view title:@"Error resolving incident."];
    errorView.message = error.localizedDescription;
    errorView.alpha = 0.9;
    errorView.floating = YES;
    [errorView show];
  }];
}

@end
