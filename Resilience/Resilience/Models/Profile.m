#import "Profile.h"
#import "NSDictionary+TypedAccess.h"

#define kProfileKey @"Profile"
#define kProfileFile @"Resilience.plist"

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
          kProfileFirstNameKey : [decoder decodeObjectForKey:kProfileFirstNameKey] ? : @"",
          kProfileLastNameKey : [decoder decodeObjectForKey:kProfileLastNameKey] ? : @"",
          kProfilePhoneNameKey : [decoder decodeObjectForKey:kProfilePhoneNameKey] ? : @"",
          kProfileEmailKey : [decoder decodeObjectForKey:kProfileEmailKey] ? : @""
  }];
}


+ (Profile *)loadProfile {
  NSString *dataPath = [[Profile getPrivateDocsDir] stringByAppendingPathComponent:kProfileFile];
  NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
  if (codedData == nil) return [[Profile alloc] init];

  NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
  Profile *profile = [unarchiver decodeObjectForKey:kProfileKey];
  [unarchiver finishDecoding];
  return profile;

}

- (void)save {
  NSString *dataPath = [[Profile getPrivateDocsDir] stringByAppendingPathComponent:kProfileFile];
  NSMutableData *data = [[NSMutableData alloc] init];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
  [archiver encodeObject:self forKey:kProfileKey];
  [archiver finishEncoding];
  [data writeToFile:dataPath atomically:YES];
}

+ (NSString *)getPrivateDocsDir {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];

  NSError *error;
  [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];

  return documentsDirectory;
}

@end