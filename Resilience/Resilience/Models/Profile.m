#import <Mantle/MTLModel+NSCoding.h>
#import "Profile.h"
#import "DataStore.h"

#define kDataStoreKey @"database"
#define kDataFile @"Resilience.plist"

@implementation Profile

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
          kProfileFirstNameKey : kProfileFirstNameKey,
          kProfileLastNameKey : kProfileLastNameKey,
          kProfilePhoneNameKey : kProfilePhoneNameKey,
          kProfileEmailKey : kProfileEmailKey
  };
}

+ (Profile *)loadProfile {
  Profile *profile = [DataStore loadObjectForKey:@"profile"];
  if(!profile) {
    return [[Profile alloc] init];
  }
  return profile;
}

- (void)save {
  [DataStore saveObject:self forKey:@"profile"];
}

@end