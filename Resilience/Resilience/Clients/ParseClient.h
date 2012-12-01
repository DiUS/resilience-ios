#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface ParseClient : AFHTTPClient
+ (ParseClient *)sharedClient;

typedef void (^IncidentSuccessBlock)(NSArray *notifications);
typedef void (^ClientFailureBlock)(NSError *error);

- (void)fetchIncidents:(IncidentSuccessBlock)success failure:(ClientFailureBlock)failure;
@end