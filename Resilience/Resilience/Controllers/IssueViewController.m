#import "IncidentHeader.h"
#import "IssueViewController.h"
#import "UIColor+Resilience.h"
#import "WaypointAnnotation.h"
#import "UIImageView+AFNetworking.h"
#import "IncidentFooter.h"

@interface IssueViewController ()
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) MKMapView *issueMap;
@property(nonatomic, strong) IncidentHeader *headerView;
@property(nonatomic, strong) IncidentFooter *footerView;
@end

@implementation IssueViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self style];
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

- (void)style {
  self.view.backgroundColor = [UIColor defaultBackgroundColor];
}

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

  self.imageView = [[UIImageView alloc] initWithImage:nil];
  self.imageView.contentMode = UIViewContentModeScaleAspectFit;
  [self.view addSubview:self.imageView];

  self.headerView = [[IncidentHeader alloc] initWithFrame:CGRectZero];
  [self.view addSubview:self.headerView];
  self.footerView = [[IncidentFooter alloc] initWithFrame:CGRectZero];
  [self.view addSubview:self.footerView];

  self.navigationItem.title = @"Issue Details";

  self.issueMap = [[MKMapView alloc] initWithFrame:CGRectZero];
  self.issueMap.delegate = self;
  self.issueMap.scrollEnabled = NO;
  [self.view addSubview:self.issueMap];

  self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
  self.issueMap.translatesAutoresizingMaskIntoConstraints = NO;
  self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
  self.footerView.translatesAutoresizingMaskIntoConstraints = NO;

}


- (void)updateViewConstraints {
  [super updateViewConstraints];
  NSDictionary *views = NSDictionaryOfVariableBindings(_imageView, _issueMap, _headerView, _footerView);
  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|[_headerView]-[_imageView(>=185)]-[_footerView]|"
                              options:0
                              metrics:nil views:views]];

  [self.view addConstraints:[NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|[_headerView]-[_issueMap(>=185)]-[_footerView]|"
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
          constraintsWithVisualFormat:@"H:|-[_imageView]-20-[_issueMap(==_imageView)]-|"
                              options:0
                              metrics:nil views:views]];

}

@end
