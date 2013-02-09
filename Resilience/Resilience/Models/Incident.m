
#import "Incident.h"
#import "IncidentCategory.h"

@implementation Incident

- (id) initWithName:(NSString *)name andLocation:(CLLocation *)location andCategory:(IncidentCategory *)category andDate:(NSDate *)updatedDate andID:(NSString *)id {
  self = [super init];
  if (self) {
    self.name = name;
    self.location = location;
    self.category = category;
    self.updatedDate = updatedDate;
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

@end
