#import "IncidentCategory.h"

static NSString *const WIND = @"Wind";
static NSString *const AIR = @"Air";
static NSString *const FIRE = @"Fire";
static NSString *const WATER = @"Water";



@implementation IncidentCategory

+ (IncidentCategory *)categoryFromString:(NSString*)category {

  if([category isEqualToString:WIND]) {
    return [[Wind alloc] init];
  } else if([category isEqualToString:FIRE]) {
    return [[Fire alloc] init];
  } else if([category isEqualToString:WATER]) {
    return [[Water alloc] init];
  } else if([category isEqualToString:AIR]) {
    return [[Air alloc] init];
  }
  return nil;
}

- (NSString *)categoryName {
  return @"";
}

@end

@implementation Wind

- (NSString *)categoryName {
  return WIND;
}

@end

@implementation Fire

- (NSString *)categoryName {
  return FIRE;
}

@end

@implementation Water

- (NSString *)categoryName {
  return WATER;
}

@end

@implementation Air

- (NSString *)categoryName {
  return AIR;
}

@end