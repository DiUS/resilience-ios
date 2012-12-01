
#import "Incident.h"

@implementation Incident

- (id) initWithName:(NSString *)name andLocation:(CLLocation *)location {
  self = [super init];
  if (self) {
    self.name = name;
    self.location = location;
  }
  return self;
}

@end
