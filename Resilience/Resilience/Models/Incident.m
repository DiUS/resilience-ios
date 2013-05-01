
#import "Incident.h"
#import "IncidentCategory.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

@implementation Incident

- (id)initWithName:(NSString *)name andLocation:(CLLocation *)location andCategory:(IncidentCategory *)category andDate:(NSDate *)updatedDate andID:(NSString *)id andImage:(UIImage *)image{
  if (self = [super init]) {
    self.name = name;
    self.location = location;
    self.category = category;
    self.updatedDate = updatedDate;
    self.image = image;
    self.id = id;
  }
  return self;
}

- (NSString *)createdDateAsString {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"H:mm d-MMM-yyyy"];
  NSString *startTime = [dateFormatter stringFromDate:self.createdDate];
  return startTime;
}

- (NSURL *)imageUrlForSize:(CGSize)size {
  return self.imageUrl;
}

+ (NSValueTransformer *)imageUrlJSONTransformer {
  return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
          @"name" : @"name",
          @"location" : @"location",
          @"updatedDate" : @"updatedDate",
          @"imageUrl" : @"imageUrl",
          @"id" : @"id"
  };
}

@end
