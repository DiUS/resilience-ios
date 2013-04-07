
#import "IncidentCategory+Waypoint.h"
#import "WaypointAnnotation.h"
#import "ZSPinAnnotation.h"


@implementation IncidentCategory (Waypoint)

- (UIImage *)annotationImage {
  return [ZSPinAnnotation pinAnnotationWithColor:[UIColor greenColor]];
}

@end