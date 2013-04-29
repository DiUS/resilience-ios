#import "Profile.h"
#import "NSDictionary+TypedAccess.h"
#import "DataStore.h"

#define kDataStoreKey @"database"
#define kDataFile @"Resilience.plist"

@implementation Profile

- (id)initWithDictionary:(NSDictionary *)values {
  if (self = [super init]) {
    self.firstName = [values stringValueForKeyPath:kProfileFirstNameKey];
    self.lastName = [values stringValueForKeyPath:kProfileLastNameKey];
    self.phone = [values stringValueForKeyPath:kProfilePhoneNameKey];
    self.email = [values stringValueForKeyPath:kProfileEmailKey];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeObject:self.firstName forKey:kProfileFirstNameKey];
  [encoder encodeObject:self.lastName forKey:kProfileLastNameKey];
  [encoder encodeObject:self.email forKey:kProfileEmailKey];
  [encoder encodeObject:self.phone forKey:kProfilePhoneNameKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
  return [self initWithDictionary:@{
          kProfileFirstNameKey : [decoder decodeObjectForKey:kProfileFirstNameKey] ?: @"",
          kProfileLastNameKey : [decoder decodeObjectForKey:kProfileLastNameKey] ?: @"",
          kProfilePhoneNameKey : [decoder decodeObjectForKey:kProfilePhoneNameKey] ?: @"",
          kProfileEmailKey : [decoder decodeObjectForKey:kProfileEmailKey] ?: @""
  }];
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