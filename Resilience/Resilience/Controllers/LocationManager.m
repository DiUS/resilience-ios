#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationManager () <CLLocationManagerDelegate>

@property(strong, nonatomic) CLLocationManager *locationManager;
@property(nonatomic, copy) LocationSuccessBlock successBlock;
@property(nonatomic, copy) LocationFailureBlock failureBlock;

@end

@implementation LocationManager

- (id)init {
  self = [super init];
  if (!self) return nil;

  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
  self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; // 100 m

  return self;
}

- (void)findLocation:(LocationSuccessBlock)success failure:(LocationFailureBlock)failure {
  [self findLocation:YES success:success failure:failure];
}

- (void)findLocationWithHighAccuracy:(LocationSuccessBlock)success failure:(LocationFailureBlock)failure {
  [self findLocation:NO success:success failure:failure];
}

- (void)findLocation:(BOOL)useCachedValue success:(LocationSuccessBlock)success failure:(LocationFailureBlock)failure {
  if ([CLLocationManager locationServicesEnabled]) {
    self.successBlock = success;
    self.failureBlock = failure;
    if (useCachedValue) {
      [self requestLastLocationReceived];
    } else {
      [self requestUpdatedLocation];
    }
  } else {
    failure(@"Location services disabled");
  }
}

- (void)requestLastLocationReceived {
  if (self.locationManager.location) { // TODO: Check timestamp?
    self.successBlock(self.locationManager.location);
  } else {
    [self requestUpdatedLocation];
  }
}

- (void)requestUpdatedLocation {
  [self.locationManager startUpdatingLocation];
}

# pragma mark - CLLocationManagerDelegate 

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
  [self.locationManager stopUpdatingLocation];
  self.successBlock(locations[0]);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  self.failureBlock(error.localizedDescription);
}

@end