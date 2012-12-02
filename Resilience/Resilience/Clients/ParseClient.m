#import <CoreLocation/CoreLocation.h>
#import "ParseClient.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"
//#import "NSDictionary+BlocksKit.h"
#import "Incident.h"
//#import "NSArray+BlocksKit.h"

@implementation ParseClient

+ (NSURL *)serverURL {
  return [NSURL URLWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"ServerURL"]];
}

+ (ParseClient *)sharedClient {
  static ParseClient *_sharedClient = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedClient = [[ParseClient alloc] initWithBaseURL:[ParseClient serverURL]];
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
  [self setAPIHeaders:self];

  return self;
}

- (void)setAPIHeaders:(AFHTTPClient *) client{
  [client setDefaultHeader:@"X-Parse-Application-Id" value:@"8NMa9Rsekvkh8k1DNI0g1ehyVLkiTFDV7Mnn2a6i"];
  [client setDefaultHeader:@"X-Parse-REST-API-Key" value:@"eOBxve3CJq7QBms7BRwKPK3g1hwBH4ccfqpKgvVt"];
}

- (void)fetchIncidents:(IncidentSuccessBlock)success failure:(ClientFailureBlock)failure
{
  [self getPath:@"1/classes/incident" parameters:@{@"order" : @"-createdAt"} success:^(AFHTTPRequestOperation *operation, id JSON) {

    NSLog(@"Incidents: %@", JSON);
    NSArray *incidentsRaw = [[NSArray alloc] initWithArray:[JSON objectForKey:@"results"]];
//    NSArray *incidents = [incidentsRaw map:^id(id obj) {
//      return [[Incident alloc] initWithName:[obj objectForKey:@"name"]];
//    }];
    NSMutableArray *incidents = [[NSMutableArray alloc] init];
    for (NSDictionary * incident in incidentsRaw) {
      NSDictionary *locationDictionary = [incident objectForKey:@"location"];
      CLLocation *location = [[CLLocation alloc] initWithLatitude:[[locationDictionary valueForKey:@"latitude"] doubleValue] longitude:[[locationDictionary valueForKey:@"longitude"] doubleValue]];
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"];
      NSDate *date = [dateFormatter dateFromString:[incident objectForKey:@"updatedAt"]];
      Incident *newIncident = [[Incident alloc] initWithName:[incident objectForKey:@"name"] andLocation:location andCategory:[incident objectForKey:@"category"] andDate:date andID:[incident objectForKey:@"objectId"]];
      newIncident.imageUrl = incident[@"photo"][@"url"];
      [incidents addObject:newIncident];
    }

    success(incidents);

  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}

- (void)updloadImage:(UIImage *)image andIncident:(Incident *)incident {
  // TODO specify compression
  NSData *jpegData = UIImageJPEGRepresentation(image, 0.75);

  // TODO - inline client for uploading
  AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:[ParseClient serverURL]];
  [client setDefaultHeader:@"Accept" value:@"application/json"];
  [self setAPIHeaders:client];

  NSMutableURLRequest *urlRequest = [client multipartFormRequestWithMethod:@"POST" path:@"1/files/parseincident.jpeg" parameters:nil constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
    [formData appendPartWithFileData:jpegData name:@"parseincident" fileName:@"parseincident.jpeg" mimeType:@"image/jpeg"];
  }];

  AFJSONRequestOperation *requestOperation =
          [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest
                                                          success:^(NSURLRequest *request1, NSHTTPURLResponse *response, id JSON) {
    NSDictionary *parameters = @{
            @"name": incident.name,
            @"note": @"iOS - default note",
            @"impact": @"LOW",
            @"location": @{ @"__type": @"GeoPoint",
                            @"latitude": [NSNumber numberWithDouble:incident.location.coordinate.latitude],
                            @"longitude": [NSNumber numberWithDouble:incident.location.coordinate.longitude]},
            @"category": incident.category,
            @"photo": @{@"url" : JSON[@"url"],
                        @"name": JSON[@"name"],
                        @"__type": @"File"} };

    [self postPath:@"1/classes/incident" parameters:parameters success:^(AFHTTPRequestOperation *op2, id responseObject2) {
      NSLog(@"Upload incident: %@", responseObject2);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      NSLog(@"error: %@", [error localizedDescription]);
    }];
  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    NSLog(@"error: %@", [error localizedDescription]);
  }];
  [requestOperation start];
}

@end