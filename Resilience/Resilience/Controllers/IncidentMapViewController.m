#import <NoticeView/WBErrorNoticeView.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "IncidentMapViewController.h"
#import "WaypointAnnotation.h"
#import "ParseClient.h"
#import "Incident.h"
#import "IncidentCategory+Waypoint.h"
#import "Open311Client.h"
#import "IncidentViewController.h"

@interface IncidentMapViewController () <MKMapViewDelegate, IncidentViewControllerDelegate>

@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) NSMutableArray *annotations;
@end

@implementation IncidentMapViewController

#pragma mark - view lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  // Set up the map view
  self.mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
  self.view = self.mapView;
  self.mapView.delegate = self;
  self.mapView.showsUserLocation = YES;
  self.annotations = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)updateAnnotations:(CLLocation *)location {
  [[Open311Client sharedClient] fetchIncidentsForLocation:location success:^(NSArray *incidents) {
    [self.mapView removeAnnotations:self.annotations];
    [self.annotations removeAllObjects];
    for (Incident * incident in incidents) {
      CLLocationCoordinate2D pointCoordinate = incident.location.coordinate;
      WaypointAnnotation *pointAnnotation = [WaypointAnnotation annotationWithCoordinate:pointCoordinate];
      pointAnnotation.title = incident.name;
      pointAnnotation.subtitle = [incident createdDateAsString];
      pointAnnotation.ID = incident.id;
      pointAnnotation.category = incident.category;
      pointAnnotation.incident = incident;
      [self.annotations addObject:pointAnnotation];
    }
    [self.mapView addAnnotations:self.annotations];
  } failure:^(NSError *error) {
    WBErrorNoticeView *errorView = [[WBErrorNoticeView alloc] initWithView:self.view title:@"Error loading incidents."];
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
  WaypointAnnotation *annotation = view.annotation;
  IncidentViewController *incidentVC = [[IncidentViewController alloc] init];
  incidentVC.delegate = self;
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:incidentVC];
  incidentVC.incident = annotation.incident;
  [self presentViewController:navController animated:YES completion:nil];
}

- (void)detailViewControllerDidResolveIncidentAndClose:(IncidentViewController *)detailViewController {
  [self updateAnnotations:[self getLocation:self.mapView]];
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

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
  [self updateAnnotations:[self getLocation:mapView]];
}

- (CLLocation *)getLocation:(MKMapView *)mapView {
  CLLocation *location = [[CLLocation alloc] initWithLatitude:mapView.region.center.latitude longitude:mapView.region.center.longitude];
  return location;
}

@end
