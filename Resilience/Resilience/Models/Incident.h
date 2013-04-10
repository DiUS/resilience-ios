#import <CoreLocation/CoreLocation.h>

@class IncidentCategory;

@interface Incident : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) IncidentCategory *category;
@property (nonatomic, strong) NSString *subCategory;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) CLLocation *location;

- (id)initWithName:(NSString *)name andLocation:(CLLocation *)location andCategory:(IncidentCategory *)category andDate:(NSDate *)updatedDate andID:(NSString *)id1 andImage:(UIImage *)image;

- (NSString *)createdDateAsString;

- (NSURL *)imageUrlForSize:(CGSize)size;

@end