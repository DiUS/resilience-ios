#import "IssueMapViewController.h"
#import "WaypointAnnotation.h"
#import "ZSPinAnnotation.h"

@interface IssueMapViewController ()

@end

@implementation IssueMapViewController


#pragma mark - view lifecycle

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
