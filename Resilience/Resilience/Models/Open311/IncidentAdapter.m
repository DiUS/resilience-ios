
#import "IncidentAdapter.h"
#import "ServiceRequest.h"
#import "Service.h"
#import "IncidentCategory.h"
#import "CloudinaryClient.h"

@implementation IncidentAdapter

- (id) initWithServiceRequest:(ServiceRequest *)serviceReqest {
  self = [super init];
  if (self) {
    self.serviceRequest = serviceReqest;
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

- (NSURL *)imageUrlForSize:(CGSize)size {
  return [[CloudinaryClient sharedClient] imageURLForResource:self.serviceRequest.mediaUrl.absoluteString size:size];
}

- (CLLocation *)location {
  return self.serviceRequest.location;
}

- (NSString *)address {
  return self.serviceRequest.address;
}

- (NSString *)description {
  return self.serviceRequest.description;
}

@end