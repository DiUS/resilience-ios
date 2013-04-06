#import "ResilientUploader.h"
#import "Client.h"
#import "Open311Client.h"
#import "AFHTTPClient.h"


@interface ResilientUploader()

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation ResilientUploader

- (id)initWithClient:(AFHTTPClient *)client {
  if (self = [super init]) {
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;

    BOOL reachable = client.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable;
    [self.operationQueue setSuspended:reachable];

    __weak typeof(self) weakSelf = self;
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

- (void)uploadWithBlock:(void (^)())operation {
  [self.operationQueue addOperationWithBlock:operation];
}

@end