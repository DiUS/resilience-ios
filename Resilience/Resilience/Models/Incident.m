
#import "Incident.h"

@implementation Incident

- (id) initWithName:(NSString *)name andLocation:(CLLocation *)location andCategory:(NSString *)category andDate:(NSDate *)updatedDate {
  self = [super init];
  if (self) {
    self.name = name;
    self.location = location;
    self.category = category;
    self.updatedDate = updatedDate;
  }
  return self;
}

- (NSString *)updatedDateAsString {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"H:mm d-MMM-yyyy"];
  NSString *startTime = [dateFormatter stringFromDate:self.updatedDate];
  return startTime;
}

@end
