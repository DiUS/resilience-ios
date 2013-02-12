#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "Client.h"

@class Incident;

@interface ParseClient : AFHTTPClient
+ (ParseClient *)sharedClient;

typedef void (^ParseClientFailureBlock)(NSError *error);

- (void)fetchIncidents:(IncidentSuccessBlock)success failure:(ParseClientFailureBlock)failure;

- (void)updloadImage:(UIImage *)image andIncident:(Incident *)incident;

@end