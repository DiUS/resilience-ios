#import <CoreLocation/CoreLocation.h>
#import "Open311Client.h"
#import "AFNetworking.h"
#import "ServiceRequest.h"
#import "IncidentAdapter.h"
#import "Service.h"
#import "NSDictionary+TypedAccess.h"
#import "IncidentCategoryAdapter.h"
#import "Incident+Open311.h"
#import "CLUploader.h"
#import "CloudinaryClient.h"
#import "Profile.h"
#import "ResilientUploader.h"

@interface Open311Client() <CLUploaderDelegate>

@property (nonatomic, strong) ResilientUploader *uploader;
@property (nonatomic, strong) CloudinaryClient *cloudinaryClient;

@end

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
  if (self = [super initWithBaseURL:url]) {
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    self.parameterEncoding = AFFormURLParameterEncoding;
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setDefaultHeader:@"Content-Type" value:@"application/json"];
    self.uploader = [[ResilientUploader alloc] initWithClient:self];
    self.cloudinaryClient = [[CloudinaryClient alloc] init];

  }
  return self;
}

- (void)fetchIncidents:(IncidentSuccessBlock)success failure:(Open311FailureBlock)failure {
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
      serviceRequest.address = [rawRequest stringValueForKeyPath:@"address"];
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

- (void)fetchCategories:(CategoriesSuccessBlock)success failure:(Open311FailureBlock)failure {
  [self fetchServices:^(NSArray *services) {
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    // TODO: reactive cocoa for getting requests and services together?
    for (Service *service in services) {
      [categories addObject:[[IncidentCategoryAdapter alloc] initWithService:service]];
    }
    [IncidentCategory saveCategories:categories]; // TODO: do this on another thread!
    success(categories);
  } failure:^(NSError *error) {
    NSArray *categories = [IncidentCategory loadCategories];
    if(categories) {
      NSLog(@"Could not get categories, falling back to persisted ones");
      success(categories);
    } else {
      failure(error);
    }
  }];
}

- (void)fetchServices:(ServicesSuccessBlock)success failure:(Open311FailureBlock)failure {
  [self getPath:@"services.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id jsonResponse) {
    NSLog(@"Services: %@", jsonResponse);
    NSMutableArray *services = [[NSMutableArray alloc] init];
    for (NSDictionary * rawService in jsonResponse) {
      Service *service = [[Service alloc] init];
      service.code = [rawService stringValueForKeyPath:@"service_code"];
      service.name = [rawService valueForKey:@"service_name"];
      service.serviceDescription = [rawService valueForKey:@"description"];
      service.metadata = [rawService boolValueForKeyPath:@"metadata"];
      service.type = [rawService valueForKey:@"type"];
      service.keywords = [rawService valueForKey:@"keywords"];
      service.group = [rawService valueForKey:@"group"];
      [services addObject:service];
    }
    success(services);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

- (void)createIncident:(Incident *)incident success:(IncidentCreateSuccessBlock)success failure:(FailureBlock)failure {
//  __weak Incident *blockIncident = incident;
  __weak id uploadClient = self.cloudinaryClient;
//  [self.uploader uploadWithBlock:^{
    [uploadClient updloadImage:incident.image success:^(NSString *uploadUrl) {
      incident.imageUrl = uploadUrl;
      [self postPath:@"requests.json" parameters:[incident asDictionary:[Profile loadProfile]] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Incident created successfully %@", responseObject);
        incident.id = responseObject[0][@"service_request_id"];
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
          success(incident);
//        }];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error creating a service request");
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
          failure(error);
//        }];
      }];
    } failure:failure];
//  }];
}

@end