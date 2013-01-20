#import <Foundation/Foundation.h>
#import "Incident.h"

@class ServiceRequest;
@class Service;

@interface IncidentAdapter : Incident

@property (nonatomic, strong) ServiceRequest *serviceRequest;
@property (nonatomic, strong) Service *service;

- (id)initWithServiceRequest:(ServiceRequest *)serviceReqest andService:(Service *)service;


@end