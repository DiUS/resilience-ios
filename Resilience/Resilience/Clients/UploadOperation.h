@class UploadIncident;
@class UploadOperation;

@protocol UploadOperationProtocol <NSObject>
- (void)uploadSuccessful:(UploadOperation *)operation incident:(UploadIncident *)incident;
- (void)uploadFailed:(UploadOperation *)operation incident:(UploadIncident *)incident;
@end

@interface UploadOperation : NSOperation

@property (nonatomic, strong) UploadIncident *incident;
@property (nonatomic, weak) id<UploadOperationProtocol> delegate;

- (id)initWithIncident:(UploadIncident *)incident;
@end