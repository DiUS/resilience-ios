
#import <Foundation/Foundation.h>

@class CLLocation;

@interface ServiceRequest : NSObject

@property (nonatomic, strong) NSString *servicRequestId;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *statusNotes;
@property (nonatomic, strong) NSString *serviceName;
@property (nonatomic, strong) NSString *serviceCode;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *agencyResponsible;
@property (nonatomic, strong) NSString *serviceNotice;
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