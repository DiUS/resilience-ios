
#import "ParseClient.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "NSDictionary+BlocksKit.h"
#import "Incident.h"
#import "NSArray+BlocksKit.h"

@implementation ParseClient

+ (ParseClient *)sharedClient {
  static ParseClient *_sharedClient = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedClient = [[ParseClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.parse.com"]];
  });

  return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
  self = [super initWithBaseURL:url];
  if (!self) {
    return nil;
  }

  [self registerHTTPOperationClass:[AFJSONRequestOperation class]];

  [self setDefaultHeader:@"Accept" value:@"application/json"];
  [self setDefaultHeader:@"Content-Type" value:@"application/json"];
  [self setDefaultHeader:@"X-Parse-Application-Id" value:@"8NMa9Rsekvkh8k1DNI0g1ehyVLkiTFDV7Mnn2a6i"];
  [self setDefaultHeader:@"X-Parse-REST-API-Key" value:@"eOBxve3CJq7QBms7BRwKPK3g1hwBH4ccfqpKgvVt"];

  return self;
}

- (void)fetchIncidents:(IncidentSuccessBlock)success failure:(ClientFailureBlock)failure
{
  [self getPath:@"1/classes/incident" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {

    NSLog(@"App.net Global Stream: %@", JSON);
    NSArray *incidentsRaw = [[NSArray alloc] initWithArray:[JSON objectForKey:@"results"]];
//    NSArray *incidents = [incidentsRaw map:^id(id obj) {
//      return [[Incident alloc] initWithName:[obj objectForKey:@"name"]];
//    }];
    NSMutableArray *incidents = [[NSMutableArray alloc] init];
    for (NSDictionary * incident in incidentsRaw) {
      [incidents addObject:[[Incident alloc] initWithName:[incident objectForKey:@"name"]]];
    }

    success(incidents);

  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  }];
}


@end