
#import "IncidentAdapter.h"
#import "ServiceRequest.h"
#import "Service.h"
#import "IncidentCategory.h"

@implementation IncidentAdapter

- (id) initWithServiceRequest:(ServiceRequest *)serviceReqest andService:(Service *)service {
  self = [super init];
  if (self) {
    self.serviceRequest = serviceReqest;
    self.service = service;
  }
  return self;
}

- (NSString *)id {
  return self.serviceRequest.servicRequestId;
}

- (NSString *)name {
  return self.serviceRequest.serviceName;
}

- (NSDate *)createdDate {
  return self.serviceRequest.requestedDate;
}

- (NSDate *)updatedDate {
  return self.serviceRequest.updatedDate;
}

- (NSString *)note {
  return self.serviceRequest.description;
}

- (IncidentCategory *)category {
//  return [IncidentCategory categoryFromString:self.service.group];
  return nil;
}

- (NSString *)subCategory {
  return @"Not supported";
}

- (NSString *)imageUrl {
  return self.serviceRequest.mediaUrl.absoluteString;
}

- (CLLocation *)location {
  return self.serviceRequest.location;
}

@end