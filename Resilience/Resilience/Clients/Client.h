
#import <Foundation/Foundation.h>

@class Incident;

typedef void (^IncidentSuccessBlock)(NSArray *notifications);
typedef void (^ServiceRequestSuccessBlock)(NSArray *serviceRequests);
typedef void (^ServicesSuccessBlock)(NSArray *services);
typedef void (^CategoriesSuccessBlock)(NSArray *categories);
typedef void (^IncidentCreateSuccessBlock)(Incident *incident);
typedef void (^FeedbackSuccessBlock)();
typedef void (^FailureBlock)(NSError *error);

@interface Client : NSObject
@end