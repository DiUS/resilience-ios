#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@class Incident;

@interface ParseClient : AFHTTPClient
+ (ParseClient *)sharedClient;

typedef void (^IncidentSuccessBlock)(NSArray *notifications);
typedef void (^ClientFailureBlock)(NSError *error);

- (void)fetchIncidents:(IncidentSuccessBlock)success failure:(ClientFailureBlock)failure;

- (void)updloadImage:(UIImage *)image andIncident:(Incident *)incident;

@end