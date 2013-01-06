
#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface Open311Client : AFHTTPClient
+ (Open311Client *)sharedClient;

typedef void (^ServiceRequestSuccessBlock)(NSArray *serviceRequests);
typedef void (^Open311FailureBlock)(NSError *error);

- (void)fetchServiceRequests:(ServiceRequestSuccessBlock)success failure:(Open311FailureBlock)failure;
@end