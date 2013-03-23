#import <CoreLocation/CoreLocation.h>
#import "Incident+Open311.h"
#import "IncidentCategory.h"
#import "Profile.h"

@implementation Incident (Open311)

-(NSDictionary *)asDictionary:(Profile *)profile {

  return @{ @"service_code": self.category.code,
     @"lat": [NSNumber numberWithDouble:self.location.coordinate.latitude],
     @"long": [NSNumber numberWithDouble:self.location.coordinate.longitude],
     @"device_id": [UIDevice currentDevice].identifierForVendor.UUIDString,
     @"first_name": profile.firstName ?: @"",
     @"last_name": profile.lastName ?: @"",
     @"phone": profile.phone ?: @"",
     @"email": profile.email ?: @"",
     @"description": self.name,
     @"media_url": [[NSURL URLWithString:self.imageUrl relativeToURL:nil] absoluteString]
//     @"attribute[WHISPAWN]": @"anything"
  };
}

@end