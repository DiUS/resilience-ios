
#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

@interface LocationManager : NSObject

+ (LocationManager*) sharedManager;

@property (strong, nonatomic) NSString *purpose;

@property (readonly, nonatomic) RACSignal *currentLocationSignal;


@end