
#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "Incident.h"
#import "Client.h"


@interface Open311Client : AFHTTPClient
+ (Open311Client *)sharedClient;


typedef void (^Open311FailureBlock)(NSError *error);

- (void)fetchIncidentsForLocation:(CLLocation *)location success:(IncidentSuccessBlock)success failure:(Open311FailureBlock)failure;

- (void)fetchIncidentsAtCurrentLocation:(IncidentSuccessBlock)success failure:(Open311FailureBlock)failure;

- (void)fetchServiceRequests:(CLLocation *)location success:(ServiceRequestSuccessBlock)success failure:(Open311FailureBlock)failure;

- (void)fetchCategories:(CategoriesSuccessBlock)success failure:(Open311FailureBlock)failure;

- (void)createIncident:(Incident *)incident success:(IncidentCreateSuccessBlock)success failure:(Open311FailureBlock)failure;

- (void)sendFeedback:(NSString *)feedback success:(FeedbackSuccessBlock)success failure:(FailureBlock)failure;

- (void)resolveIncident:(Incident *)incident success:(FeedbackSuccessBlock)success failure:(FailureBlock)failure;
@end