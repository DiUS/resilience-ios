#import "IssueMapViewController.h"
#import "WaypointAnnotation.h"
#import "ParseClient.h"
#import "Incident.h"
#import "IncidentCategory+Waypoint.h"
#import "Open311Client.h"

@interface IssueMapViewController () <MKMapViewDelegate>

@property (nonatomic, retain) MKMapView *mapView;

@property (nonatomic, strong) UIView *errorView;
@property (nonatomic, strong) UILabel *errorLabel;

@end

@implementation IssueMapViewController

#pragma mark - view lifecycle

- (void)viewWillAppear:(BOOL)animated {
  // Display the incident markers
  [self.errorView removeFromSuperview];
//  [[ParseClient sharedClient] fetchIncidents:^(NSArray *incidents) {
  [[Open311Client sharedClient] fetchIncidents:^(NSArray *incidents) {

    for (Incident * incident in incidents) {
      CLLocationCoordinate2D pointCoordinate = incident.location.coordinate;
      WaypointAnnotation *pointAnnotation = [WaypointAnnotation annotationWithCoordinate:pointCoordinate];
      pointAnnotation.title = incident.name;
      pointAnnotation.subtitle = [incident createdDateAsString];
      pointAnnotation.ID = incident.id;
      pointAnnotation.category = incident.category;
      [self.mapView addAnnotation:pointAnnotation];
    }
  } failure:^(NSError *error) {
    [self showErrorView:@"Error loading issues"];
  }];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  // Set up the map view
  self.mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
  [self.view addSubview:self.mapView];
  self.mapView.delegate = self;

  self.errorView = [[UIView alloc] initWithFrame:CGRectMake(
          0,
          0,
          self.view.frame.size.width,
          30)];
  UIColor *black = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
  self.errorView.backgroundColor = black;
  self.errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.errorView.frame.size.width - 40, self.errorView.frame.size.height)];
  self.errorLabel.text = @"Error loading issues...";
  self.errorLabel.textColor = [UIColor whiteColor];
  self.errorLabel.backgroundColor = [UIColor clearColor];
  [self.errorView addSubview:self.errorLabel];
  self.mapView.showsUserLocation = YES;
//  self.mapView.userTrackingMode = YES;
  self.mapView.delegate = self;
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  self.mapView.frame = self.view.frame;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)showErrorView:(NSString *)error {
  self.errorLabel.text = error;
  [self.view addSubview:self.errorView];
  self.errorView.alpha = 0.0f;
  [UIView animateWithDuration:0.9
                   animations:^{
                     self.errorView.alpha = 1.0f;
                   }
                   completion:nil];
}

#pragma mark - Map delegate

- (MKAnnotationView *)mapView:(MKMapView *)theMapView
            viewForAnnotation:(id <MKAnnotation>)annotation {
  MKPinAnnotationView *view = nil;
  if ([annotation isKindOfClass:[WaypointAnnotation class]]) {
    WaypointAnnotation *waypoint = (WaypointAnnotation *)annotation;
    view = (MKPinAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:@"identifier"];
    if (nil == view) {
      view = [[MKPinAnnotationView alloc]
              initWithAnnotation:annotation reuseIdentifier:@"identifier"];
      view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    view.image = [waypoint.category annotationImage];
    [view setCanShowCallout:YES];
    [view setAnimatesDrop:YES];
  }
  return view;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
  WaypointAnnotation *annotation = view.annotation;
  NSLog(@"calloutAccessoryControlTapped: %@, %@", annotation.title, annotation.ID);
//  [self.navigationController pushViewController:self.detailsThemes animated:YES];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
  MKCoordinateRegion region;
  MKCoordinateSpan span;
  span.latitudeDelta = 0.5;
  span.longitudeDelta = 0.5;
  CLLocationCoordinate2D location;
  location.latitude = userLocation.coordinate.latitude;
  location.longitude = userLocation.coordinate.longitude;
  region.span = span;
  region.center = location;
  [mapView setRegion:region animated:YES];
}


@end
