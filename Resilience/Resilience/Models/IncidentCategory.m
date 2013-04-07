#import "MTLModel.h"
#import "IncidentCategory.h"
#import "DataStore.h"


@implementation IncidentCategory

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
          @"name": @"name",
          @"code": @"code"
  };
}

+ (NSArray *)loadCategories {
  return [DataStore loadObjectForKey:@"categories"];
}

+ (void)saveCategories:(NSArray *)categories {
  [DataStore saveObject:categories forKey:@"categories"];
}

@end