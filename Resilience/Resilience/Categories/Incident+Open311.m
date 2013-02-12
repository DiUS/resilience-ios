#import <CoreLocation/CoreLocation.h>
#import "Incident+Open311.h"
#import "IncidentCategory.h"

@implementation Incident (Open311)

-(NSDictionary *)asDictionary {

  return @{ @"service_code": self.category.code,
     @"lat": [NSNumber numberWithDouble:self.location.coordinate.latitude],
     @"long": [NSNumber numberWithDouble:self.location.coordinate.longitude],
//     @"device_id": ,
//     @"first_name": profile.firstName,
//     @"last_name": profile.lastName,
//     @"phone": profile.phone,
     @"description": self.name,
     @"media_url": [[NSURL URLWithString:@"http://www.imagesummit.com/WMD/image_summit_photographic_fine_art_gallery/Earth/product%20images/broken_fence.jpg" relativeToURL:nil] absoluteString]
//     @"attribute[WHISPAWN]": @"anything"
  };
}

@end