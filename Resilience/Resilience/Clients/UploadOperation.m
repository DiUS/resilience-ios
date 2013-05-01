#import "UploadOperation.h"
#import "Incident.h"
#import "Open311Client.h"
#import "UploadIncident.h"
#import "AppNotifications.h"


@implementation UploadOperation

- (id)initWithIncident:(UploadIncident *)incident {
  if (self = [super init]) {
    self.incident = incident;
  }
  return self;
}

#pragma mark - Main
- (void)main {
  NSLog(@"Uploading incident %@ id: %@", self.incident.incidentToUpload.name, self.incident.fileId);

  [[Open311Client sharedClient] createIncident:self.incident.incidentToUpload
          success:^(Incident *uploadedIncident) {
            [self.incident removeIncident];
            [self.delegate uploadSuccessful:self incident:self.incident];
          } failure:^(NSError *error) {
    [self.delegate uploadFailed:self incident:self.incident];
  }];
}

@end