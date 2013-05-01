#import "ResilientUploader.h"
#import "Open311Client.h"
#import "UploadIncident.h"
#import "UploadOperation.h"


@interface ResilientUploader ()

@property(nonatomic, strong) NSOperationQueue *operationQueue;

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
  UploadIncident *incidentToUpload = [[UploadIncident alloc] initWithIncident:incident];
  [incidentToUpload saveIncident];
  [self enqueIncidentForUpload:incidentToUpload];
}

- (void)enqueIncidentForUpload:(UploadIncident *)uploadIncident {
  UploadOperation *operation = [[UploadOperation alloc] initWithIncident:uploadIncident];
  [self.operationQueue addOperation:operation];
}

- (void)uploadQueuedIncident {
  NSArray *queuedIncidents = [UploadIncident loadUnsavedIssues];

  for(UploadIncident *incident in queuedIncidents) {
    [self enqueIncidentForUpload:incident];
  }
}

@end