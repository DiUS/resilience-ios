#import <NoticeView/WBErrorNoticeView.h>
#import "IssueMapViewController.h"
#import "WaypointAnnotation.h"
#import "ParseClient.h"
#import "Incident.h"
#import "IncidentCategory+Waypoint.h"
#import "Open311Client.h"

@interface IssueMapViewController () <MKMapViewDelegate>

@property (nonatomic, retain) MKMapView *mapView;

@end

@implementation IssueMapViewController

#pragma mark - view lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  // Set up the map view
  self.mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
  self.view = self.mapView;
  self.mapView.delegate = self;

  self.mapView.showsUserLocation = YES;
  self.mapView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
  // Display the incident markers
  [[Open311Client sharedClient] fetchIncidents:nil success:^(NSArray *incidents) {
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
    WBErrorNoticeView *errorView = [[WBErrorNoticeView alloc] initWithView:self.view title:@"Error loading issues."];
    errorView.message = error.localizedDescription;
    errorView.alpha = 0.9;
    [errorView show];
  }];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
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
//  WaypointAnnotation *annotation = view.annotation;
//  NSLog(@"calloutAccessoryControlTapped: %@, %@", annotation.title, annotation.ID);
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
