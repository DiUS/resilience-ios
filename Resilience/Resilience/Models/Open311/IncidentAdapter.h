#import <Foundation/Foundation.h>
#import "Incident.h"

@class ServiceRequest;
@class Service;

@interface IncidentAdapter : Incident

@property (nonatomic, strong) ServiceRequest *serviceRequest;

- (id)initWithServiceRequest:(ServiceRequest *)serviceRequest;

@end