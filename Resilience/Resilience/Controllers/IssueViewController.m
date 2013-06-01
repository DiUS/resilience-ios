#import "IncidentHeader.h"
#import "IssueViewController.h"
#import "UIColor+Resilience.h"
#import "WaypointAnnotation.h"
#import "UIImageView+AFNetworking.h"
#import "IncidentFooter.h"
#import "UIImage+Tileable.h"
#import "Open311Client.h"
#import <QuartzCore/QuartzCore.h>
#import <NoticeView/WBErrorNoticeView.h>

@interface IssueViewController ()<UIAlertViewDelegate>
@property(nonatomic, strong) UIImageView *warnImage;
@property(nonatomic, strong) UIView *imageViewSurround;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIView *issueMapSurround; 
@property(nonatomic, strong) MKMapView *issueMap;
@property(nonatomic, strong) IncidentHeader *headerView;
@property(nonatomic, strong) IncidentFooter *footerView;
@end

@implementation IssueViewController

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
  MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotationView.annotation.coordinate, 250, 250);
  [mapView setRegion:region];
}


#pragma mark - Private Methods

- (void)data {
  if (self.incident.imageUrl) {
    [self.imageView setImageWithURL:[self.incident imageUrlForSize:CGSizeMake(120.f, 185.f)]];
  }

  [self.headerView populateWithIncident:self.incident];
  [self.footerView populateWithIncident:self.incident];

  WaypointAnnotation *annotation = [WaypointAnnotation annotationWithCoordinate:self.incident.location.coordinate];
  annotation.title = self.incident.name;
  annotation.subtitle = [self.incident createdDateAsString];
  annotation.ID = self.incident.id;
  [self.issueMap addAnnotation:annotation];

}

- (void)components {
  self.view = [[UIView alloc] initWithFrame:CGRectZero];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissView:)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Resolve" style:UIBarButtonItemStylePlain target:self action:@selector(promptToResolveIncident:)];
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Assets/BackgroundTexture"]];

  UIImage *warningImage = [UIImage imageNamed:@"Assets/IncidentDetailsBackground"];
  UIImage *resizableWarningImage = [warningImage stretchableImageWithLeftCapWidth:1 topCapHeight:1];
  self.warnImage = [[UIImageView alloc] initWithImage:resizableWarningImage];
  [self.view addSubview:self.warnImage];

  self.imageViewSurround = [[UIView alloc] initWithFrame:CGRectZero];
  self.imageViewSurround.backgroundColor = [UIColor whiteColor];
  self.imageViewSurround.layer.shadowColor = [UIColor darkGrayColor].CGColor;
  self.imageViewSurround.layer.shadowOffset = CGSizeMake(2.0, 2.0);
  self.imageViewSurround.layer.shadowRadius = 3.0;
  self.imageViewSurround.layer.shadowOpacity = 1.0; 

  self.imageView = [[UIImageView alloc] initWithImage:nil];
  self.imageView.contentMode = UIViewContentModeScaleAspectFill;
  self.imageView.clipsToBounds = YES;
  [self.imageViewSurround addSubview:self.imageView];
  [self.view addSubview:self.imageViewSurround];

  self.headerView = [[IncidentHeader alloc] initWithFrame:CGRectZero];
  [self.view addSubview:self.headerView];
  self.footerView = [[IncidentFooter alloc] initWithFrame:CGRectZero];
  [self.view addSubview:self.footerView];

  self.navigationItem.title = @"Issue Details";

  self.issueMapSurround = [[UIView alloc] initWithFrame:CGRectZero];
  self.issueMapSurround.backgroundColor = [UIColor whiteColor];
  self.issueMapSurround.layer.shadowColor = [UIColor darkGrayColor].CGColor;
  self.issueMapSurround.layer.shadowRadius = 3.0;
  self.issueMapSurround.layer.shadowOpacity = 1.0;
  self.issueMapSurround.layer.shadowOffset = CGSizeMake(2.0, 2.0);
  
  self.issueMap = [[MKMapView alloc] initWithFrame:CGRectZero];
  self.issueMap.delegate = self;
  self.issueMap.scrollEnabled = NO;
  
  [self.issueMapSurround addSubview:self.issueMap];
  [self.view addSubview:self.issueMapSurround];

  self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
  self.issueMap.translatesAutoresizingMaskIntoConstraints = NO;
  self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
  self.footerView.translatesAutoresizingMaskIntoConstraints = NO;
  self.warnImage.translatesAutoresizingMaskIntoConstraints = NO;
  self.imageViewSurround.translatesAutoresizingMaskIntoConstraints = NO;
  self.issueMapSurround.translatesAutoresizingMaskIntoConstraints = NO; 
}


- (void)updateViewConstraints {
  [super updateViewConstraints];
  NSDictionary *views = NSDictionaryOfVariableBindings(_imageViewSurround, _imageView, _issueMapSurround, _issueMap, _headerView, _footerView, _warnImage);
  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|[_headerView]-[_imageViewSurround(==100)]-[_footerView]"
                              options:0
                              metrics:nil views:views]];

  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"V:[_headerView]-[_issueMapSurround(==100)]"
                              options:0
                              metrics:nil views:views]];

  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|[_headerView]|"
                              options:0
                              metrics:nil views:views]];

  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|[_footerView]|"
                              options:0
                             metrics:nil views:views]];

  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|-[_imageViewSurround]-20-[_issueMapSurround(==_imageViewSurround)]-|"
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

  [self.imageViewSurround addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-3-[_imageView]-3-|"
                                                                                 options:0 metrics:0 views:views]];
  [self.imageViewSurround addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[_imageView]-3-|"
                                                                                 options:0 metrics:0 views:views]];
  [self.imageView setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];

  [self.issueMapSurround addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-3-[_issueMap]-3-|"
                                                                                 options:0 metrics:0 views:views]];
  [self.issueMapSurround addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[_issueMap]-3-|"
                                                                                 options:0 metrics:0 views:views]];
}

- (void)dismissView:(id)dismissView {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)promptToResolveIncident:(id)incidentView {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Resolve issue" message:@"Are you sure you want to mark this issue as resolved?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
  [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
  if(buttonIndex == 1) {
    [self resolveIncident];
  }
}

- (void)resolveIncident {
  [[Open311Client sharedClient] resolveIncident:self.incident success:^{
    [self.delegate detailViewControllerDidResolveIssueAndClose:self];
    [self dismissViewControllerAnimated:YES completion:nil];
  } failure:^(NSError *error) {
    WBErrorNoticeView *errorView = [[WBErrorNoticeView alloc] initWithView:self.view title:@"Error resolving issue."];
    errorView.message = error.localizedDescription;
    errorView.alpha = 0.9;
    errorView.floating = YES;
    [errorView show];
  }];
}



@end
