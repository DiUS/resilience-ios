#import "IssueMapViewController.h"
#import "WaypointAnnotation.h"
#import "ZSPinAnnotation.h"
#import "ParseClient.h"
#import "Incident.h"
#import <CoreLocation/CoreLocation.h>

@interface IssueMapViewController ()

@property (nonatomic, strong) NSArray *incidents;

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
      pointAnnotation.markerType = kFireMarker;
      pointAnnotation.title = incident.name;
//      [mapView addAnnotation:pointAnnotation];
    }
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

  self.view.backgroundColor = [UIColor blueColor];
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
    view = (MKPinAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:@"identifier"];
    if (nil == view) {
      view = [[MKPinAnnotationView alloc]
              initWithAnnotation:annotation reuseIdentifier:@"identifier"];
      //            view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    WaypointAnnotation *marker = annotation;
    switch (marker.markerType) {
      case kFireMarker:
        view.image = [ZSPinAnnotation pinAnnotationWithColor:[UIColor greenColor]];
        break;
      case kWindMarker:
        view.image = [ZSPinAnnotation pinAnnotationWithColor:[UIColor redColor]];
        break;
      case kWaterMarker:
        view.image = [ZSPinAnnotation pinAnnotationWithColor:[UIColor orangeColor]];
        break;
    }
    [view setCanShowCallout:YES];
    [view setAnimatesDrop:NO];
  }
  return view;
}


@end
