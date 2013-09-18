#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@interface LocationManager : NSObject

typedef void (^LocationSuccessBlock)(CLLocation *location);
typedef void (^LocationFailureBlock)(NSString *error);

@property (strong, nonatomic) NSString *purpose;

- (void)findLocation:(LocationSuccessBlock)success failure:(LocationFailureBlock)failure;

- (void)findLocationWithHighAccuracy:(LocationSuccessBlock)success failure:(LocationFailureBlock)failure;
@end