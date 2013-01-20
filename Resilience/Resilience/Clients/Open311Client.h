
#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface Open311Client : AFHTTPClient
+ (Open311Client *)sharedClient;

typedef void (^ServiceRequestSuccessBlock)(NSArray *serviceRequests);
typedef void (^IncidentAdapterSuccessBlock)(NSArray *notifications);
typedef void (^Open311FailureBlock)(NSError *error);

- (void)fetchIncidents:(IncidentAdapterSuccessBlock)success failure:(Open311FailureBlock)failure;

- (void)fetchServiceRequests:(ServiceRequestSuccessBlock)success failure:(Open311FailureBlock)failure;
@end