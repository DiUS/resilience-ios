#import "MTLModel.h"
#import "IncidentCategoryAdapter.h"
#import "Service.h"


@interface IncidentCategoryAdapter()
@end

@implementation IncidentCategoryAdapter

- (id)initWithService:(Service *)service {
  self = [super init];
  if (self) {
    self.name = service.name;
    self.code = service.code;
  }
  return self;
}

@end