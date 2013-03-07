#import <CoreLocation/CoreLocation.h>
#import "Open311Client.h"
#import "AFNetworking.h"
#import "ServiceRequest.h"
#import "IncidentAdapter.h"
#import "Service.h"
#import "NSDictionary+TypedAccess.h"
#import "IncidentCategoryAdapter.h"
#import "Incident.h"
#import "Incident+Open311.h"
#import "CLUploader.h"

@interface Open311Client() <CLUploaderDelegate>

@property (nonatomic, strong) Incident *incidentToUpload;
@property (nonatomic, copy) IncidentCreateSuccessBlock uploadSuccessBlock;
@property (nonatomic, copy) Open311FailureBlock uploadFailureBlock;

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
  self = [super initWithBaseURL:url];
  if (!self) {
    return nil;
  }

  [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
  self.parameterEncoding = AFFormURLParameterEncoding;
  [self setDefaultHeader:@"Accept" value:@"application/json"];
  [self setDefaultHeader:@"Content-Type" value:@"application/json"];
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

- (void)fetchCategories:(CategoriesSuccessBlock)success failure:(Open311FailureBlock)failure {
  [self fetchServices:^(NSArray *services) {
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    // TODO: reactive cocoa for getting requests and services together?
    for (Service *service in services) {
      [categories addObject:[[IncidentCategoryAdapter alloc] initWithService:service]];
    }
    success(categories);
  } failure:failure];
}

- (void)fetchServices:(ServicesSuccessBlock)success failure:(Open311FailureBlock)failure {
  [self getPath:@"services.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id jsonResponse) {
    NSLog(@"Services: %@", jsonResponse);
    NSMutableArray *services = [[NSMutableArray alloc] init];
    for (NSDictionary * rawService in jsonResponse) {
      Service *serviceRequest = [[Service alloc] init];
      serviceRequest.code = [rawService stringValueForKeyPath:@"service_code"];
      serviceRequest.name = [rawService valueForKey:@"service_name"];
      serviceRequest.serviceDescription = [rawService valueForKey:@"description"];
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

- (void)createIncident:(Incident *)incident success:(IncidentCreateSuccessBlock)success failure:(Open311FailureBlock)failure {
  // TODO: pull this wackiness into a different object.

  CLCloudinary *cloudinary = [[CLCloudinary alloc] init];
  [cloudinary.config setValue:@"resilience" forKey:@"cloud_name"];
  [cloudinary.config setValue:@"345754584192129" forKey:@"api_key"];
  [cloudinary.config setValue:@"EOqrfFTaj1vNv_3BTTUAWCQgGUc" forKey:@"api_secret"];

  CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
  [uploader upload:UIImageJPEGRepresentation(incident.image, 0.75f) options:@{}];
  self.incidentToUpload = incident;
  self.uploadSuccessBlock = success;
  self.uploadFailureBlock = failure;
}

#pragma mark - CLUploaderDelegate
- (void) uploaderSuccess:(NSDictionary*)result context:(id)context {
  NSString* publicId = [result valueForKey:@"public_id"];
  NSLog(@"Upload success. Public ID=%@, Full result=%@", publicId, result);
  self.incidentToUpload.imageUrl = [result valueForKey:@"url"];
  [self postPath:@"requests.json" parameters:[self.incidentToUpload asDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"Incident created successfully %@", responseObject);
    self.incidentToUpload.id = responseObject[0][@"service_request_id"];
    self.uploadSuccessBlock(self.incidentToUpload);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error creating a service request");
    self.uploadFailureBlock(error);
  }];
}

- (void) uploaderError:(NSString*)result code:(int) code context:(id)context {
  NSLog(@"Upload error: %@, %d", result, code);
  self.uploadFailureBlock([NSError errorWithDomain:@"upload" code:code userInfo:nil]);
}

- (void) uploaderProgress:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite context:(id)context {
  NSLog(@"Upload progress: %d/%d (+%d)", totalBytesWritten, totalBytesExpectedToWrite, bytesWritten);
}

@end