
#import <Foundation/Foundation.h>

@class CLLocation;

@interface ServiceRequest : NSObject

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *addressString;
@property (nonatomic, strong) NSString *addressId;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *requestDescription;
@property (nonatomic, strong) NSDate *requestedDate;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic, strong) NSDate *expectedDate;
@property (nonatomic, strong) NSURL *mediaUrl;

@end