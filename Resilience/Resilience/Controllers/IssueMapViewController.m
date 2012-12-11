#import "IssueMapViewController.h"
#import "WaypointAnnotation.h"
#import "ZSPinAnnotation.h"
#import "ParseClient.h"
#import "Incident.h"
#import "IncidentCategory.h"
#import "IncidentCategory+Waypoint.h"
#import <CoreLocation/CoreLocation.h>

@interface IssueMapViewController ()

@property (nonatomic, strong) NSArray *incidents;
@property (nonatomic, retain) MKMapView *mapView;

- (void)zoomToFitMapAnnotations:(MKMapView *)mapView;

@end

@implementation IssueMapViewController

#pragma mark - view lifecycle

- (void)viewWillAppear:(BOOL)animated {
  // Display the incident markers
  [[ParseClient sharedClient] fetchIncidents:^(NSArray *incidents) {
    self.incidents = incidents;
    for (unsigned int i=0; i<[self.incidents count]; i++) {
      Incident *incident = [self.incidents objectAtIndex:i];
      CLLocationCoordinate2D pointCoordinate = incident.location.coordinate;
      WaypointAnnotation *pointAnnotation = [WaypointAnnotation annotationWithCoordinate:pointCoordinate];
      pointAnnotation.title = incident.name;
      pointAnnotation.subtitle = [incident updatedDateAsString];
      pointAnnotation.ID = incident.id;
      pointAnnotation.category = incident.category;
      [self.mapView addAnnotation:pointAnnotation];
    }
    // Zoom to fit everything we found
    [self zoomToFitMapAnnotations:self.mapView];
  } failure:^(NSError *error) {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Whoa...!"
                                                      message:[error localizedDescription]
                                                     delegate:nil cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
  }];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  // Set up the map view
  self.mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
  [self.view addSubview:self.mapView];
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
    [view setAnimatesDrop:NO];
  }
  return view;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
  WaypointAnnotation *annotation = view.annotation;
  NSLog(@"calloutAccessoryControlTapped: %@, %@", annotation.title, annotation.ID);
//  [self.navigationController pushViewController:self.detailsThemes animated:YES];
}

- (void)zoomToFitMapAnnotations:(MKMapView *)mapView {
  if ([mapView.annotations count] == 0) return;
  
  CLLocationCoordinate2D topLeftCoord;
  topLeftCoord.latitude = -90;
  topLeftCoord.longitude = 180;
  
  CLLocationCoordinate2D bottomRightCoord;
  bottomRightCoord.latitude = 90;
  bottomRightCoord.longitude = -180;
  
  for(id<MKAnnotation> annotation in mapView.annotations) {
    topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
    topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
    bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
    bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
  }
  
  MKCoordinateRegion region;
  region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
  region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
  region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
  
  // Add a little extra space on the sides
  region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
  
  region = [mapView regionThatFits:region];
  [mapView setRegion:region animated:YES];
}


@end
