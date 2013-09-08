#import "NSDate+Formatting.h"

@implementation NSDateFormatter (Formatting)

+ (NSDateFormatter *)defaultDateFormatter {
  static NSDateFormatter *dateFormatter;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDoesRelativeDateFormatting:YES];
  });

  return dateFormatter;
}

@end

@implementation NSDate (Formatting)

- (NSString *)resilienceCreateDateAsString {
  return [[NSDateFormatter defaultDateFormatter] stringFromDate:self];
}

@end