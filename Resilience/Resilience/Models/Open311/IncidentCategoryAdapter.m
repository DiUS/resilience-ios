
#import "IncidentCategoryAdapter.h"
#import "Service.h"


@interface IncidentCategoryAdapter()
@property (nonatomic, strong) Service *service;
@end

@implementation IncidentCategoryAdapter

- (id)initWithService:(Service *)service {
  self = [super init];
  if (self) {
    self.service = service;
    self.name = service.name;
    self.code = service.code;
  }
  return self;
}

@end