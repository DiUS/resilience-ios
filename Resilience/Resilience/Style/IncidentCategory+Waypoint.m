
#import "IncidentCategory+Waypoint.h"
#import "WaypointAnnotation.h"
#import "ZSPinAnnotation.h"


@implementation IncidentCategory (Waypoint)

- (UIImage *)annotationImage {
  return [ZSPinAnnotation pinAnnotationWithColor:[UIColor greenColor]];
}

@end

@implementation Wind (Waypoint)

- (UIImage *)annotationImage {
  return [ZSPinAnnotation pinAnnotationWithColor:[UIColor greenColor]];
}

@end

@implementation Fire (Waypoint)

- (UIImage *)annotationImage {
  return [ZSPinAnnotation pinAnnotationWithColor:[UIColor redColor]];
}

@end

@implementation Water (Waypoint)

- (UIImage *)annotationImage {
  return [ZSPinAnnotation pinAnnotationWithColor:[UIColor blueColor]];
}

@end

@implementation Air (Waypoint)

- (UIImage *)annotationImage {
  return [ZSPinAnnotation pinAnnotationWithColor:[UIColor blackColor]];
}

@end