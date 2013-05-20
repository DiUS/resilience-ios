
#import "MTLModel+NSCoding.h"
#import "MTLJSONAdapter.h"

@class Incident;

@interface UploadIncident : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) Incident *incidentToUpload;
@property (nonatomic, strong) NSString *fileId;

- (id)initWithIncident:(Incident *)incident;

- (void)saveIncidentToDisk;

- (void)removeIncident;

+ (NSArray *)loadUnsavedIssues;
@end