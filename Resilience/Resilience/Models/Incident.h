#import <CoreLocation/CoreLocation.h>

@interface Incident : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *subCategory;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) CLLocation *location;

- (id)initWithName:(NSString *)name andLocation:(CLLocation *)location andCategory:(NSString *)category andDate:(NSDate *)updatedDate andID:(NSString *)id;
- (NSString *)updatedDateAsString;

//        private Impact scale;
//        private Point point;

@end