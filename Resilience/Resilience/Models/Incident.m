
#import "Incident.h"

@implementation Incident

- (id) initWithName:(NSString *)name {
  self = [super init];
  if (self) {
    self.name = name;
  }
  return self;
}

@end
