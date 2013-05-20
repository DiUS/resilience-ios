
#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationManager()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) RACSubject *locationSubject;
@property (readwrite, nonatomic) int numberOfLocationSubscribers;

@end

@implementation LocationManager

+ (LocationManager*) sharedManager {
  static LocationManager *_locationManager;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _locationManager = [[LocationManager alloc] init];
  });

  return _locationManager;
}

- (id)init {
  self = [super init];
  if(!self) return nil;

  self.locationSubject = [RACReplaySubject replaySubjectWithCapacity:1];
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
  self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; // 100 m

  return self;
}

- (RACSignal *)currentLocationSignal {
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    @synchronized(self) {
      if(self.numberOfLocationSubscribers == 0) {
        [self.locationManager startUpdatingLocation];
      }
      ++self.numberOfLocationSubscribers;
    }

    [self.locationSubject subscribe:subscriber];

    return [RACDisposable disposableWithBlock:^{
      @synchronized(self) {
        --self.numberOfLocationSubscribers;
        if(self.numberOfLocationSubscribers == 0) {
          [self.locationManager stopUpdatingLocation];
        }
      }
    }];
  }];
}

# pragma mark - CLLocationManagerDelegate 

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
  NSLog(@"location update received");
  [self.locationSubject sendNext:locations[0]];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  [self.locationSubject sendError:error];
}

@end