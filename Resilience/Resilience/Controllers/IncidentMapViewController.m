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
#import "UIColor+Resilience.h"
#import "View+MASAdditions.h"
#import "UIDevice+iOS7.h"

@interface IncidentMapViewController () <MKMapViewDelegate, IncidentViewControllerDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, assign) BOOL hasLocation;
@property (nonatomic, strong) UIButton *refreshButton;

@end

@implementation IncidentMapViewController

#pragma mark - view lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  // Set up the map view
  self.mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
//  self.view = self.mapView;
  self.mapView.delegate = self;
  self.mapView.showsUserLocation = YES;
  self.mapView.userTrackingMode = MKUserTrackingModeNone;
  self.annotations = [[NSMutableArray alloc] init];
  self.hasLocation = NO;
  self.refreshButton = [UIButton buttonWithType:UIButtonTypeSystem];
  if (![UIDevice iOS7]) {
    self.refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.refreshButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
  }
  [self.refreshButton setTitle:@"Search this location" forState:UIControlStateNormal];
  [self.refreshButton setBackgroundColor:[UIColor colorWithRed:250. green:250. blue:250. alpha:1.]];
  [self.refreshButton addTarget:self action:@selector(updateAnnotations) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.mapView];
  [self.view addSubview:self.refreshButton];
  self.screenName = @"Incident map";

  [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view.mas_left).with.offset(70);
    make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
    make.right.equalTo(self.view.mas_right).with.offset(-70);
  }];
}

- (void)viewDidAppear:(BOOL)animated {
  [self updateAnnotations];
  self.mapView.frame = CGRectMake(0., 0., self.view.frame.size.width, self.view.frame.size.height);
}

- (void)updateAnnotations {
  CLLocation *location = [[CLLocation alloc] initWithLatitude:self.mapView.region.center.latitude longitude:self.mapView.region.center.longitude];
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
  [self updateAnnotations];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
  if(!self.hasLocation) {
    MKCoordinateRegion region;
    region.span = MKCoordinateSpanMake(0.5, 0.5);;
    region.center =  userLocation.coordinate;
    self.hasLocation = YES;
    [mapView setRegion:region animated:YES];
  }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
//  [self updateAnnotations:[self getLocation:mapView]];
}

- (CLLocation *)getLocation:(MKMapView *)mapView {
  CLLocation *location = [[CLLocation alloc] initWithLatitude:mapView.region.center.latitude longitude:mapView.region.center.longitude];
  return location;
}

@end
