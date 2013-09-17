
#import "UploadIncident.h"
#import "Incident.h"
#import "DataStore.h"

static NSString *const kArchiveKey = @"upload";

@implementation UploadIncident

- (id)initWithIncident:(Incident *)incident {
  if (self = [super init]) {
    self.incidentToUpload = incident;
    self.fileId = [[NSUUID UUID] UUIDString];
  }
  return self;
}

- (void)saveIncidentToDisk {
  NSString *dataPath = [UploadIncident filenameForId:self.fileId];
  NSMutableData *newIncident = [[NSMutableData alloc] init];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:newIncident];

  [archiver encodeObject:self forKey:kArchiveKey];
  [archiver finishEncoding];
  [newIncident writeToFile:dataPath atomically:YES];
}

- (void)removeIncident {
  NSError *deleteError;
  NSLog(@"Removing %@ document path: %@", self.incidentToUpload.name, [UploadIncident filenameForId:self.fileId]);
  BOOL success = [[NSFileManager defaultManager] removeItemAtPath:[UploadIncident filenameForId:self.fileId] error:&deleteError];
  if (!success) {
    NSLog(@"Error removing document path: %@", deleteError.localizedDescription);
  }
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
          @"incident" : @"incident",
          @"fileId" : @"fileId"
  };
}

+ (NSString *)uploadDir {
  NSError *error;
  NSString *uploadDir = [[DataStore getPrivateDocsDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"upload"]];
  [[NSFileManager defaultManager] createDirectoryAtPath:uploadDir withIntermediateDirectories:YES attributes:nil error:&error];
  return uploadDir;
}

+ (NSString *)filenameForId:(NSString *)id {
  return [[self uploadDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", id]];
}

+ (NSArray *)loadUnsavedIncidents {
  NSString *uploadDir = [self uploadDir];
  NSError *error;
  NSArray *uploads = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:uploadDir error:&error];
  NSMutableArray *incidentsToUpload = [[NSMutableArray alloc] init];

  for (NSString *fileName in uploads) {
    if ([fileName hasSuffix:@".plist"]) {
      NSData *codedData = [[NSData alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [self uploadDir], fileName]];
      NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
      [incidentsToUpload addObject: [unarchiver decodeObjectForKey:kArchiveKey]];
    }
  }
  return incidentsToUpload;
}

@end