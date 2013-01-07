#import <CoreLocation/CoreLocation.h>
#import "Open311Client.h"
#import "AFNetworking.h"
#import "ServiceRequest.h"
#import "ISO8601DateFormatter.h"


@implementation Open311Client

+ (NSURL *)serverURL {
  return [NSURL URLWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"Open311ServerURL"]];
}

+ (ISO8601DateFormatter *)dateFormatter {
  static ISO8601DateFormatter *formatter = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    formatter = [[ISO8601DateFormatter alloc] init];
  });
  return formatter;
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

- (void)fetchServiceRequests:(ServiceRequestSuccessBlock)success failure:(Open311FailureBlock)failure {
//  NSDictionary *parameters = @{ @"start_date" : nil, @"end_date" : nil, @"status": @"open" };
  [self getPath:@"requests" parameters:nil success:^(AFHTTPRequestOperation *operation, id jsonResponse) {

    NSLog(@"Service Requests: %@", jsonResponse);
    NSMutableArray *serviceRequests = [[NSMutableArray alloc] init];
    for (NSDictionary * rawRequest in jsonResponse) {
      ServiceRequest *serviceRequest = [[ServiceRequest alloc] init];
      serviceRequest.location = [[CLLocation alloc] initWithLatitude:[[rawRequest valueForKey:@"lat"] doubleValue] longitude:[[rawRequest valueForKey:@"long"] doubleValue]];
      serviceRequest.addressString = [rawRequest valueForKey:@"address_string"];
      serviceRequest.addressId = [rawRequest valueForKey:@"address_id"];
      serviceRequest.email = [rawRequest valueForKey:@"email"];
      serviceRequest.deviceId = [rawRequest valueForKey:@"device_id"];
      serviceRequest.accountId = [rawRequest valueForKey:@"account_id"];
      serviceRequest.firstName = [rawRequest valueForKey:@"first_name"];
      serviceRequest.lastName = [rawRequest valueForKey:@"last_name"];
      serviceRequest.phone = [rawRequest valueForKey:@"phone"];
      serviceRequest.requestDescription = [rawRequest valueForKey:@"description"];
      serviceRequest.mediaUrl = [NSURL URLWithString:[rawRequest valueForKey:@"media_url"]];
      serviceRequest.requestedDate = [self dateFromString:[rawRequest valueForKey:@"requested_datetime"]];
      serviceRequest.updatedDate = [self dateFromString:[rawRequest valueForKey:@"updated_datetime"]];
      serviceRequest.expectedDate = [self dateFromString:[rawRequest valueForKey:@"expected_datetime"]];
      [serviceRequests addObject:serviceRequest];
    }

    success(serviceRequests);

  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

- (NSDate *)dateFromString:(NSString *)date {
  if(date)
    return [[Open311Client dateFormatter] dateFromString:date];
  else
    return nil;
}

@end