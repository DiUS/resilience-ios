
#import "Incident.h"
#import "IncidentCategory.h"

@implementation Incident

- (id) initWithName:(NSString *)name andLocation:(CLLocation *)location andCategory:(NSString *)category andDate:(NSDate *)updatedDate andID:(NSString *)id {
  self = [super init];
  if (self) {
    self.name = name;
    self.location = location;
    self.category = [IncidentCategory categoryFromString:category];
    self.updatedDate = updatedDate;
    self.id = id;
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
