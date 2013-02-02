#import <CoreLocation/CoreLocation.h>
#import "Open311Client.h"
#import "AFNetworking.h"
#import "ServiceRequest.h"
#import "IncidentAdapter.h"
#import "Service.h"
#import "NSDictionary+TypedAccess.h"


@implementation Open311Client

+ (NSURL *)serverURL {
  return [NSURL URLWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Open311ServerURL"]];
}

+ (Open311Client *)sharedClient {
  static Open311Client *_sharedClient = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedClient = [[Open311Client alloc] initWithBaseURL:[Open311Client serverURL]];
  });

  return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
  self = [super initWithBaseURL:url];
  if (!self) {
    return nil;
  }

  [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
  self.parameterEncoding = AFJSONParameterEncoding;
  [self setDefaultHeader:@"Accept" value:@"application/json"];
  [self setDefaultHeader:@"Content-Type" value:@"application/json"];
  return self;
}

- (void)fetchIncidents:(IncidentAdapterSuccessBlock)success failure:(Open311FailureBlock)failure
{
  [self fetchServices:^(NSArray *services) {

  } failure:failure];

  [self fetchServiceRequests:^(NSArray *serviceRequests) {
    NSMutableArray *incidents = [[NSMutableArray alloc] init];
    // TODO: reactive cocoa for getting requests and services together?
    for (ServiceRequest *request in serviceRequests) {
      [incidents addObject:[[IncidentAdapter alloc] initWithServiceRequest:request andService:nil]];
    }

    success(incidents);
  } failure:failure];
}

- (void)fetchServiceRequests:(ServiceRequestSuccessBlock)success failure:(Open311FailureBlock)failure {
//  NSDictionary *parameters = @{ @"start_date" : nil, @"end_date" : nil, @"status": @"open" };
  [self getPath:@"requests.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id jsonResponse) {
    NSLog(@"Service Requests: %@", jsonResponse);
    NSMutableArray *serviceRequests = [[NSMutableArray alloc] init];
    for (NSDictionary * rawRequest in jsonResponse) {
      ServiceRequest *serviceRequest = [[ServiceRequest alloc] init];
      serviceRequest.servicRequestId = [rawRequest stringValueForKeyPath:@"service_request_id"];
      serviceRequest.status = [rawRequest stringValueForKeyPath:@"status"];;
      serviceRequest.statusNotes = [rawRequest stringValueForKeyPath:@"status_notes"];;
      serviceRequest.serviceName = [rawRequest stringValueForKeyPath:@"service_name"];;
      serviceRequest.serviceCode = [rawRequest stringValueForKeyPath:@"service_code"];;
      serviceRequest.description = [rawRequest stringValueForKeyPath:@"description"];;
      serviceRequest.agencyResponsible = [rawRequest stringValueForKeyPath:@"agency_responsible"];
      serviceRequest.serviceNotice = [rawRequest stringValueForKeyPath:@"service_notice"];
      serviceRequest.location = [[CLLocation alloc] initWithLatitude:[rawRequest doubleValueForKeyPath:@"lat"] longitude:[rawRequest doubleValueForKeyPath:@"long"]];
      serviceRequest.addressString = [rawRequest stringValueForKeyPath:@"address_string"];
      serviceRequest.addressId = [rawRequest stringValueForKeyPath:@"address_id"];
      serviceRequest.email = [rawRequest stringValueForKeyPath:@"email"];
      serviceRequest.deviceId = [rawRequest stringValueForKeyPath:@"device_id"];
      serviceRequest.accountId = [rawRequest stringValueForKeyPath:@"account_id"];
      serviceRequest.firstName = [rawRequest stringValueForKeyPath:@"first_name"];
      serviceRequest.lastName = [rawRequest stringValueForKeyPath:@"last_name"];
      serviceRequest.phone = [rawRequest stringValueForKeyPath:@"phone"];
      serviceRequest.requestDescription = [rawRequest stringValueForKeyPath:@"description"];
      serviceRequest.mediaUrl = [rawRequest urlValueForKeyPath:@"media_url"];
      serviceRequest.requestedDate = [rawRequest dateValueForISO8601StringKeyPath:@"requested_datetime"];
      serviceRequest.updatedDate = [rawRequest dateValueForISO8601StringKeyPath:@"updated_datetime"];
      serviceRequest.expectedDate = [rawRequest dateValueForISO8601StringKeyPath:@"expected_datetime"];
      [serviceRequests addObject:serviceRequest];
    }

    success(serviceRequests);

  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

- (void)fetchServices:(ServicesSuccessBlock)success failure:(Open311FailureBlock)failure {
  [self getPath:@"services.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id jsonResponse) {
    NSLog(@"Services: %@", jsonResponse);
    NSMutableArray *services = [[NSMutableArray alloc] init];
    for (NSDictionary * rawService in jsonResponse) {
      Service *serviceRequest = [[Service alloc] init];
      serviceRequest.code = [rawService stringValueForKeyPath:@"code"];
      serviceRequest.name = [rawService valueForKey:@"name"];
      serviceRequest.serviceDescription = [rawService valueForKey:@"service_description"];
      serviceRequest.metadata = [rawService boolValueForKeyPath:@"metadata"];
      serviceRequest.type = [rawService valueForKey:@"type"];
      serviceRequest.keywords = [rawService valueForKey:@"keywords"];
      serviceRequest.group = [rawService valueForKey:@"group"];
      [services addObject:serviceRequest];
    }
    success(services);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

@end