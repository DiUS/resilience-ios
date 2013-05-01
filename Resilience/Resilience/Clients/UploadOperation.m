#import "UploadOperation.h"
#import "Incident.h"
#import "Open311Client.h"
#import "UploadIncident.h"


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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"incidentUploaded" object:self userInfo:@{@"incident" : uploadedIncident}];
            [self.incident removeIncident];
          } failure:^(NSError *error) {

  }];
}

@end