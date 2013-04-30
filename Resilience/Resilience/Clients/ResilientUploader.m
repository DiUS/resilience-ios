#import "ResilientUploader.h"
#import "Client.h"
#import "Open311Client.h"
#import "AFHTTPClient.h"
#import "DataStore.h"
#import "Incident.h"


static NSString *const kFileId = @"fileId";
static NSString *const kArchiveKey = @"upload";

@interface ResilientUploader ()

@property(nonatomic, strong) NSOperationQueue *operationQueue;
@property(nonatomic, strong) Open311Client *client;

@end

@implementation ResilientUploader

+ (ResilientUploader *)sharedUploader {
  static ResilientUploader *_sharedClient = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedClient = [[ResilientUploader alloc] initWithClient:[Open311Client sharedClient]];
  });

  return _sharedClient;
}

- (id)initWithClient:(Open311Client *)client {
  if (self = [super init]) {
    self.client = client;
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;

    BOOL reachable = client.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable;
    [self.operationQueue setSuspended:reachable];

    __weak typeof (self) weakSelf = self;
    [client setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
      if (status == AFNetworkReachabilityStatusNotReachable) {
        [weakSelf.operationQueue setSuspended:YES];
      } else {
        [weakSelf.operationQueue setSuspended:NO];
      }
    }];
  }
  return self;
}

- (void)saveIncident:(Incident *)incident {
  NSString *GUID = [[NSUUID UUID] UUIDString];
  NSString *dataPath = [self filenameForId:GUID];
  NSMutableData *newIncident = [[NSMutableData alloc] init];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:newIncident];

  NSDictionary *uploadIncident = @{@"incident" : incident, kFileId : GUID};
  [archiver encodeObject:uploadIncident forKey:kArchiveKey];
  [archiver finishEncoding];
  [newIncident writeToFile:dataPath atomically:YES];

  [self enqueIncidentForUpload:uploadIncident];
}

- (void)enqueIncidentForUpload:(NSDictionary *)uploadIncident {


  NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(uploadIncident:) object:uploadIncident];
  [self.operationQueue addOperation:operation];

//  [self.operationQueue addOperationWithBlock:^{
//    [self uploadIncident:incident fileId:fileId];
//  }];
}

- (void)uploadIncident:(NSDictionary *)uploadIncident {
  Incident *incident = [uploadIncident valueForKey:@"incident"];
  NSString *fileId = [uploadIncident valueForKey:kFileId];

  NSLog(@"Uploading incident %@ id: %@", incident.name, fileId);

  [self.client createIncident:incident success:^(Incident *uploadedIncident) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"incidentUploaded" object:self userInfo:@{@"incident" : uploadedIncident}];
    NSError *deleteError;
    NSString *path = [self filenameForId:fileId];
    NSLog(@"Removing %@ document path: %@", uploadedIncident.name, path);
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:&deleteError];
    if (!success) {
      NSLog(@"Error removing document path: %@", deleteError.localizedDescription);
    }
  }                   failure:^(NSError *error) {

  }];
}

- (NSString *)uploadDir {
  NSError *error;
  NSString *uploadDir = [[DataStore getPrivateDocsDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"upload"]];
  [[NSFileManager defaultManager] createDirectoryAtPath:uploadDir withIntermediateDirectories:YES attributes:nil error:&error];
  return uploadDir;
}

- (NSString *)filenameForId:(NSString *)id {
  return [[self uploadDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", id]];
}

- (void)uploadUnsavedIssues {
  NSString *uploadDir = [self uploadDir];
  NSError *error;
  NSArray *uploads = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:uploadDir error:&error];

  for (NSString *fileName in uploads) {
    if ([fileName hasSuffix:@".plist"]) {
      NSData *codedData = [[NSData alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [self uploadDir], fileName]];

      NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
      NSDictionary *uploadIncident = [unarchiver decodeObjectForKey:kArchiveKey];

      [self enqueIncidentForUpload:uploadIncident];
    }
  }
}

@end