#import "DataStore.h"

#define kDataStoreKey @"database"
#define kDataFile @"Resilience.plist"

@implementation DataStore

+ (id)loadObjectForKey:(NSString *)key {
  NSString *dataPath = [[DataStore getPrivateDocsDir] stringByAppendingPathComponent:kDataFile];
  NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
  if (codedData == nil) return nil;

  NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
  NSDictionary *dataStore = [unarchiver decodeObjectForKey:kDataStoreKey];
  [unarchiver finishDecoding];
  return dataStore[key];
}

+ (void)saveObject:(id)object forKey:(NSString *)key {
  NSString *dataPath = [[DataStore getPrivateDocsDir] stringByAppendingPathComponent:kDataFile];

  // load existing data
  NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
  NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
  NSDictionary *database = [unarchiver decodeObjectForKey:kDataStoreKey];
  NSMutableDictionary *mutableDatabase = database ? [database mutableCopy] : [[NSMutableDictionary alloc] init];

  // add / replace existing data
  [mutableDatabase setObject:object forKey:key];
  NSMutableData *updatedData = [[NSMutableData alloc] init];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:updatedData];
  [archiver encodeObject:mutableDatabase forKey:kDataStoreKey];
  [archiver finishEncoding];
  [updatedData writeToFile:dataPath atomically:YES];
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