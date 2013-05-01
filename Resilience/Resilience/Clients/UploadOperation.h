@class UploadIncident;

@interface UploadOperation : NSOperation

@property (nonatomic, strong) UploadIncident *incident;

- (id)initWithIncident:(UploadIncident *)incident;
@end